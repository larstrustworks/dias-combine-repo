# Requirements Document

## Introduction

This document defines the requirements for an AI-powered chatbot feature integrated into the DIAS 4 platform. The Chatbot provides a conversational interface embedded in the DiasAdminUi, allowing authenticated users to ask questions about DIAS usage and to perform data operations (fetch, update) through natural language. The Chatbot communicates through the existing BFF proxy layer to a new backend chat endpoint on the DiasRestApi, which orchestrates LLM interactions and translates user intents into API calls against the existing DAL and REST API infrastructure.

## Glossary

- **Chatbot_Widget**: The floating UI component rendered in the lower-right corner of the DiasAdminUi, providing the chat interface (message input, message list, toggle button).
- **Chat_BFF_Endpoint**: A new Express endpoint on the DiasAdminUi BFF server (`/api/chat`) that proxies chat requests to the DiasRestApi Chat_Service, attaching authentication and API key headers.
- **Chat_Service**: A new backend service within the DiasRestApi (.NET) that receives user messages, manages conversation context, interacts with the LLM_Provider, and orchestrates data actions via the DAL_API or existing REST API endpoints.
- **LLM_Provider**: The external large language model service (e.g., Azure OpenAI) used by the Chat_Service to generate responses and determine user intent.
- **DAL_API**: The existing DiasDalApi (Node.js/Express) providing CRUD access to MSSQL databases.
- **DiasRestApi**: The existing .NET 9 REST API that acts as the gateway, handling authentication, routing, and proxying to legacy and internal services.
- **Action_Request**: A structured object produced by the Chat_Service when the LLM determines the user wants to perform a data operation (fetch, update, create, delete).
- **Conversation_Context**: The session-scoped history of messages exchanged between the user and the Chatbot within a single chat session, used to maintain coherent multi-turn conversations.
- **Confirmation_Prompt**: A message displayed by the Chatbot_Widget asking the user to explicitly confirm a data-modifying action before execution.
- **Authenticated_User**: A user who has a valid JWT token stored in session storage, as managed by the existing AuthContext.

## Requirements

### Requirement 1: Chatbot Widget Rendering

**User Story:** As a DIAS user, I want a chat icon in the lower-right corner of the application, so that I can access the chatbot from any page without leaving my current workflow.

#### Acceptance Criteria

1. WHEN an Authenticated_User navigates to any protected page, THE Chatbot_Widget SHALL render a toggle button fixed to the lower-right corner of the viewport.
2. WHEN the Authenticated_User clicks the toggle button, THE Chatbot_Widget SHALL expand to display the chat panel with a message list and text input field.
3. WHEN the Authenticated_User clicks the toggle button while the chat panel is open, THE Chatbot_Widget SHALL collapse the chat panel and show only the toggle button.
4. THE Chatbot_Widget SHALL preserve the Conversation_Context and message history when the chat panel is collapsed and re-expanded within the same browser session.
5. THE Chatbot_Widget SHALL NOT render the toggle button on the login page or for unauthenticated users.

### Requirement 2: Message Sending and Display

**User Story:** As a DIAS user, I want to type messages and see responses in a chat-like interface, so that I can have a natural conversation with the AI assistant.

#### Acceptance Criteria

1. WHEN the Authenticated_User submits a message via the text input, THE Chatbot_Widget SHALL display the user message in the message list immediately.
2. WHEN the Authenticated_User submits a message, THE Chatbot_Widget SHALL display a loading indicator until the Chat_Service returns a response.
3. WHEN the Chat_Service returns a response, THE Chatbot_Widget SHALL display the assistant response in the message list.
4. THE Chatbot_Widget SHALL auto-scroll the message list to the most recent message when a new message is added.
5. WHEN the Authenticated_User submits an empty or whitespace-only message, THE Chatbot_Widget SHALL prevent submission and keep the input field focused.

### Requirement 3: BFF Chat Proxy Endpoint

**User Story:** As a developer, I want chat requests to be proxied through the BFF server, so that API keys and backend URLs are not exposed to the browser.

#### Acceptance Criteria

1. WHEN the Chatbot_Widget sends a chat request, THE Chat_BFF_Endpoint SHALL forward the request to the Chat_Service on the DiasRestApi with the configured API key header.
2. THE Chat_BFF_Endpoint SHALL forward the Authenticated_User JWT token from the request to the Chat_Service as an Authorization header.
3. IF the Chat_Service returns an error status code, THEN THE Chat_BFF_Endpoint SHALL forward the error status and message to the Chatbot_Widget.
4. IF the Chat_BFF_Endpoint cannot reach the Chat_Service, THEN THE Chat_BFF_Endpoint SHALL return a 502 status with a descriptive error message.

### Requirement 4: Chat Service — Informational Queries

**User Story:** As a DIAS user, I want to ask the chatbot how to use DIAS features, so that I can get help without leaving the application.

#### Acceptance Criteria

1. WHEN the Chat_Service receives a user message classified as an informational query, THE Chat_Service SHALL send the message and Conversation_Context to the LLM_Provider and return the generated response.
2. THE Chat_Service SHALL include a system prompt that provides the LLM_Provider with knowledge about DIAS platform features, navigation, and common workflows.
3. WHEN the LLM_Provider returns a response, THE Chat_Service SHALL return the response text to the caller within 10 seconds under normal operating conditions.
4. THE Chat_Service SHALL maintain Conversation_Context for the duration of the user session to support multi-turn conversations.

### Requirement 5: Chat Service — Data Action Execution

**User Story:** As a DIAS user, I want to ask the chatbot to fetch or update data for me, so that I can perform common tasks through natural language instead of navigating multiple screens.

#### Acceptance Criteria

1. WHEN the Chat_Service receives a user message classified as a data action request, THE Chat_Service SHALL construct an Action_Request containing the target endpoint, HTTP method, and parameters.
2. WHEN the Chat_Service constructs an Action_Request for a read operation (GET), THE Chat_Service SHALL execute the request against the DAL_API or DiasRestApi and return the results formatted as a human-readable response.
3. WHEN the Chat_Service constructs an Action_Request for a write operation (POST, PUT, PATCH, DELETE), THE Chat_Service SHALL return a Confirmation_Prompt to the user before executing the action.
4. WHEN the Authenticated_User confirms a write Action_Request, THE Chat_Service SHALL execute the action and return the result to the user.
5. WHEN the Authenticated_User declines a write Action_Request, THE Chat_Service SHALL cancel the action and inform the user that the operation was not performed.
6. THE Chat_Service SHALL execute Action_Requests using the Authenticated_User JWT token, ensuring data access respects the same authorization rules as direct API calls.

### Requirement 6: Action Scope and Safety

**User Story:** As a system administrator, I want the chatbot to only perform actions within a defined set of allowed operations, so that the system remains safe from unintended modifications.

#### Acceptance Criteria

1. THE Chat_Service SHALL maintain a configurable allowlist of API endpoints and operations that the Chatbot is permitted to execute.
2. IF the Chat_Service determines an Action_Request targets an endpoint not on the allowlist, THEN THE Chat_Service SHALL refuse the action and inform the user that the requested operation is not available through the Chatbot.
3. THE Chat_Service SHALL log every Action_Request (including refused ones) with the user identity, requested endpoint, method, and timestamp.
4. THE Chat_Service SHALL NOT execute raw SQL queries or direct database commands through the Chatbot interface.

### Requirement 7: Authentication and Authorization

**User Story:** As a security-conscious administrator, I want the chatbot to enforce the same authentication and authorization as the rest of DIAS, so that no unauthorized access occurs through the chat interface.

#### Acceptance Criteria

1. WHEN the Chatbot_Widget sends a request to the Chat_BFF_Endpoint, THE Chatbot_Widget SHALL include the JWT token from the AuthContext in the request headers.
2. IF the Chat_BFF_Endpoint receives a request without a valid JWT token, THEN THE Chat_BFF_Endpoint SHALL return a 401 status and the Chatbot_Widget SHALL display an authentication error message.
3. IF the Chat_Service receives a request with an expired or invalid JWT token, THEN THE Chat_Service SHALL return a 401 status.
4. THE Chat_Service SHALL pass the Authenticated_User JWT token when making Action_Requests to the DAL_API or DiasRestApi, ensuring role-based access control is enforced.

### Requirement 8: Error Handling

**User Story:** As a DIAS user, I want clear error messages when something goes wrong with the chatbot, so that I understand what happened and what I can do next.

#### Acceptance Criteria

1. IF the LLM_Provider is unreachable or returns an error, THEN THE Chat_Service SHALL return a user-friendly error message indicating the AI service is temporarily unavailable.
2. IF an Action_Request execution fails, THEN THE Chat_Service SHALL return an error message describing the failure without exposing internal system details.
3. IF the Chatbot_Widget loses network connectivity, THEN THE Chatbot_Widget SHALL display a connection error message and allow the user to retry the last message.
4. IF the Chat_Service receives a malformed or unparseable user message, THEN THE Chat_Service SHALL return a response asking the user to rephrase the request.

### Requirement 9: Conversation Management

**User Story:** As a DIAS user, I want to be able to start a new conversation, so that I can reset the context when switching topics.

#### Acceptance Criteria

1. THE Chatbot_Widget SHALL display a "New conversation" button in the chat panel header.
2. WHEN the Authenticated_User clicks the "New conversation" button, THE Chatbot_Widget SHALL clear the message list and reset the Conversation_Context.
3. WHEN the Authenticated_User logs out, THE Chatbot_Widget SHALL clear all message history and Conversation_Context.
4. THE Chat_Service SHALL limit the Conversation_Context to a configurable maximum number of messages to prevent excessive token usage with the LLM_Provider.

### Requirement 10: Streaming Responses

**User Story:** As a DIAS user, I want to see the chatbot response appear progressively, so that I do not have to wait for the full response before reading.

#### Acceptance Criteria

1. WHEN the Chat_Service receives a response stream from the LLM_Provider, THE Chat_BFF_Endpoint SHALL forward the response as a Server-Sent Events (SSE) stream to the Chatbot_Widget.
2. WHEN the Chatbot_Widget receives streamed response chunks, THE Chatbot_Widget SHALL render each chunk incrementally in the message list.
3. IF the SSE stream is interrupted, THEN THE Chatbot_Widget SHALL display the partial response received so far and show an error indicator.

### Requirement 11: Chat Service Deployment

**User Story:** As a DevOps engineer, I want the chatbot backend to integrate into the existing Docker Compose deployment, so that it follows the same deployment patterns as other DIAS services.

#### Acceptance Criteria

1. THE Chat_Service SHALL be deployable as part of the DiasRestApi container without requiring a separate service container.
2. THE Chat_Service SHALL read LLM_Provider connection configuration (API endpoint, API key, model name) from environment variables.
3. THE Chat_Service SHALL expose a health check endpoint that reports the availability of the LLM_Provider connection.
4. THE DiasAdminUi container SHALL include the Chat_BFF_Endpoint configuration via the existing `REST_API_URL` environment variable without additional configuration.
