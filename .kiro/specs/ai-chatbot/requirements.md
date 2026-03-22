# Requirements Document

## Introduction

This document defines the requirements for an AI Chatbot feature integrated into the DIAS 4 platform. The chatbot provides a conversational interface embedded in the lower-right corner of the DiasUI frontend, enabling users to ask questions about how to use DIAS and to perform data actions (fetch, update) through natural language. The chatbot communicates through a new backend endpoint on the DiasDalApi, which orchestrates LLM interactions and translates user intents into DAL API operations, respecting the existing authentication and authorization model.

## Glossary

- **Chatbot_Widget**: The floating UI component rendered in the lower-right corner of the DiasUI frontend, providing the chat interface (input field, message list, toggle button).
- **Chat_Service**: The backend service within DiasDalApi responsible for receiving chat messages, interacting with the LLM_Provider, resolving user intents, executing data operations, and returning responses.
- **LLM_Provider**: The external large language model API (e.g., OpenAI, Azure OpenAI) used by the Chat_Service to interpret user messages and generate responses.
- **Conversation**: A sequence of messages between a user and the Chat_Service within a single session, maintaining context across turns.
- **User_Intent**: The classified purpose of a user message, such as asking a help question, requesting data retrieval, or requesting a data mutation.
- **Action_Confirmation**: A confirmation step presented to the user before the Chat_Service executes a data-mutating operation (create, update, delete).
- **DAL_API**: The existing DiasDalApi Express/MSSQL backend providing CRUD and stored procedure execution endpoints, authenticated via X-Api-Key headers.
- **BFF_Server**: The Express-based Backend-For-Frontend server (proxy server in DiasUI) that forwards frontend requests to backend APIs.
- **Auth**: The authentication system used by DiasUI for user session management.

## Requirements

### Requirement 1: Chatbot Widget Rendering

**User Story:** As a DIAS user, I want a chat icon in the lower-right corner of the screen, so that I can quickly access the AI assistant without leaving my current page.

#### Acceptance Criteria

1. WHEN a user is authenticated and on any page within DiasUI, THE Chatbot_Widget SHALL render a floating toggle button in the lower-right corner of the viewport.
2. WHEN the user clicks the toggle button, THE Chatbot_Widget SHALL open a chat panel displaying the Conversation message history and a text input field.
3. WHEN the user clicks the toggle button while the chat panel is open, THE Chatbot_Widget SHALL close the chat panel.
4. WHILE the chat panel is open, THE Chatbot_Widget SHALL remain visible and accessible regardless of page navigation within DiasUI.
5. THE Chatbot_Widget SHALL use the existing Tailwind CSS theme and shadcn/ui component patterns from the DiasUI design system.
6. THE Chatbot_Widget SHALL render above all other page content using a z-index that does not conflict with existing modal or toast components.

### Requirement 2: Message Sending and Display

**User Story:** As a DIAS user, I want to type messages and see responses in the chat panel, so that I can have a conversation with the AI assistant.

#### Acceptance Criteria

1. WHEN the user submits a message via the text input field, THE Chatbot_Widget SHALL display the user message in the Conversation view immediately.
2. WHEN the user submits a message, THE Chatbot_Widget SHALL send the message to the Chat_Service through the BFF_Server relay endpoint.
3. WHILE the Chat_Service is processing a message, THE Chatbot_Widget SHALL display a loading indicator in the Conversation view.
4. WHEN the Chat_Service returns a response, THE Chatbot_Widget SHALL display the assistant response in the Conversation view.
5. IF the Chat_Service returns an error, THEN THE Chatbot_Widget SHALL display an error message in the Conversation view indicating the request failed.
6. THE Chatbot_Widget SHALL auto-scroll the Conversation view to the most recent message when a new message is added.
7. WHEN the user submits an empty or whitespace-only message, THE Chatbot_Widget SHALL prevent submission and keep focus on the input field.

### Requirement 3: Conversation Context Management

**User Story:** As a DIAS user, I want the chatbot to remember what we discussed earlier in the conversation, so that I do not have to repeat context.

#### Acceptance Criteria

1. THE Chatbot_Widget SHALL maintain the Conversation message history in client-side state for the duration of the browser session.
2. WHEN the user sends a message, THE Chatbot_Widget SHALL include the recent Conversation history in the request to the Chat_Service to provide context.
3. WHEN the user closes and reopens the chat panel within the same browser session, THE Chatbot_Widget SHALL preserve and display the existing Conversation history.
4. WHEN the user logs out or the browser session ends, THE Chatbot_Widget SHALL clear the Conversation history.

### Requirement 4: Help and Guidance Responses

**User Story:** As a DIAS user, I want to ask the chatbot how to use DIAS features, so that I can get help without consulting external documentation.

#### Acceptance Criteria

1. WHEN the user asks a question about DIAS usage, THE Chat_Service SHALL respond with relevant guidance based on the system prompt and DIAS domain knowledge.
2. THE Chat_Service SHALL include a system prompt that describes DIAS platform capabilities, navigation structure, and common workflows.
3. WHEN the Chat_Service cannot provide a confident answer to a help question, THE Chat_Service SHALL respond indicating the limitation and suggest the user contact support.

### Requirement 5: Data Retrieval Actions

**User Story:** As a DIAS user, I want to ask the chatbot to fetch data from DIAS, so that I can quickly look up information without navigating through multiple pages.

#### Acceptance Criteria

1. WHEN the user requests data retrieval through natural language, THE Chat_Service SHALL interpret the User_Intent and execute the corresponding read operation against the DAL_API.
2. WHEN the Chat_Service successfully retrieves data, THE Chat_Service SHALL format the results into a human-readable response and return the response to the Chatbot_Widget.
3. IF the DAL_API returns an error during data retrieval, THEN THE Chat_Service SHALL return a descriptive error message to the Chatbot_Widget without exposing internal system details.
4. THE Chat_Service SHALL enforce the authenticated user's permissions when executing data retrieval operations.

### Requirement 6: Data Mutation Actions with Confirmation

**User Story:** As a DIAS user, I want the chatbot to update data in DIAS on my behalf, so that I can perform quick edits without navigating to the relevant form.

#### Acceptance Criteria

1. WHEN the user requests a data mutation (create, update, or delete) through natural language, THE Chat_Service SHALL interpret the User_Intent and describe the intended operation back to the user as an Action_Confirmation.
2. WHEN the user confirms the Action_Confirmation, THE Chat_Service SHALL execute the mutation against the DAL_API.
3. WHEN the user rejects the Action_Confirmation, THE Chat_Service SHALL cancel the operation and inform the user that no changes were made.
4. WHEN the Chat_Service successfully executes a mutation, THE Chat_Service SHALL return a confirmation message describing the completed change.
5. IF the DAL_API returns an error during a mutation, THEN THE Chat_Service SHALL return a descriptive error message to the Chatbot_Widget without exposing internal system details.
6. THE Chat_Service SHALL enforce the authenticated user's permissions when executing data mutation operations.

### Requirement 7: Chat Backend Endpoint

**User Story:** As a developer, I want a dedicated chat endpoint on the backend, so that the frontend can communicate with the AI service through the existing API infrastructure.

#### Acceptance Criteria

1. THE DAL_API SHALL expose a POST endpoint at `/api/v1/chat/message` that accepts a JSON body containing the user message and Conversation history.
2. THE Chat_Service SHALL authenticate requests using the existing X-Api-Key header mechanism used by the DAL_API.
3. THE Chat_Service SHALL forward the user message and Conversation context to the LLM_Provider and return the LLM_Provider response.
4. WHEN the LLM_Provider determines the user intent requires a data operation, THE Chat_Service SHALL execute the operation using existing DAL_API services (CrudService, DbObjectService) and include the result in the response.
5. IF the LLM_Provider is unreachable or returns an error, THEN THE Chat_Service SHALL return a structured error response with status code 502 and a user-friendly message.
6. THE Chat_Service SHALL limit the Conversation history sent to the LLM_Provider to a configurable maximum number of messages to control token usage.

### Requirement 8: BFF Relay Integration

**User Story:** As a developer, I want the chat requests to flow through the existing BFF relay pattern, so that API keys and backend URLs remain server-side only.

#### Acceptance Criteria

1. THE BFF_Server in DiasUI SHALL relay chat requests from the Chatbot_Widget to the DAL_API chat endpoint using the existing `/api` proxy pattern.
2. THE BFF_Server SHALL attach the configured `BACKEND_API_KEY` as the `X-Api-Key` header when forwarding chat requests to the DAL_API.
3. THE BFF_Server SHALL forward the Supabase_Auth JWT token from the client request to the DAL_API for user-level authorization.

### Requirement 9: LLM Provider Configuration

**User Story:** As a platform administrator, I want to configure the LLM provider connection through environment variables, so that I can switch providers or update API keys without code changes.

#### Acceptance Criteria

1. THE Chat_Service SHALL read the LLM_Provider API key from an environment variable (`LLM_API_KEY`).
2. THE Chat_Service SHALL read the LLM_Provider base URL from an environment variable (`LLM_BASE_URL`).
3. THE Chat_Service SHALL read the LLM model identifier from an environment variable (`LLM_MODEL`).
4. IF any required LLM configuration environment variable is missing at startup, THEN THE Chat_Service SHALL log a warning and disable the chat endpoint, returning status code 503 for chat requests.

### Requirement 10: Rate Limiting and Abuse Prevention

**User Story:** As a platform administrator, I want to limit chatbot usage per user, so that LLM costs remain predictable and the system is protected from abuse.

#### Acceptance Criteria

1. THE Chat_Service SHALL enforce a configurable maximum number of messages per user per hour (default: 60).
2. WHEN a user exceeds the rate limit, THE Chat_Service SHALL return status code 429 with a message indicating when the user can send messages again.
3. THE Chat_Service SHALL read the rate limit configuration from an environment variable (`CHAT_RATE_LIMIT_PER_HOUR`).

### Requirement 11: Accessibility

**User Story:** As a DIAS user with accessibility needs, I want the chatbot to be keyboard-navigable and screen-reader compatible, so that I can use the assistant regardless of how I interact with the interface.

#### Acceptance Criteria

1. THE Chatbot_Widget SHALL be operable using keyboard navigation, including opening/closing the panel and submitting messages.
2. THE Chatbot_Widget SHALL include appropriate ARIA labels and roles for the toggle button, chat panel, message list, and input field.
3. WHEN a new assistant message is displayed, THE Chatbot_Widget SHALL announce the message to screen readers using an ARIA live region.
