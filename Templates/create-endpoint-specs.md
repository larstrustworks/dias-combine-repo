# Create Endpoint Specifications (Batch)

This template is used to create ENDPOINT_SPEC.md files for all endpoints in a legacy repository that have been scaffolded with placeholders. This is Phase 2.5 of the migration workflow - after placeholders are created but before full conversion begins.

## Context

You are working with a legacy repository that has been:
1. **Phase 1 (Discovery)**: Mapped using `Templates/map-endpoints.md` - created `endpoints-list.csv`
2. **Phase 2 (Scaffolding)**: Placeholders created using `Templates/create-placeholders.md` - created folder structure with empty docs/ folders

Now we need to create ENDPOINT_SPEC.md files for each endpoint so they can be reviewed before starting the full conversion process.

## Input Required

Please provide:
- **Legacy repo path**: Path to the legacy repository (e.g., `Legacy/integration/invoice_services`)
- **Endpoints CSV path**: Path to the endpoints-list.csv file (should be in the legacy repo's /map folder)

## Task

For each endpoint in the endpoints-list.csv file where conversion_status is "PLACEHOLDER_CREATED":

1. **Read the legacy code** for that endpoint thoroughly
2. **Analyze the business logic** - understand what it does, not just how
3. **Create ENDPOINT_SPEC.md** in the docs/ folder of the controller module

The ENDPOINT_SPEC.md file should be placed at:
```
{dias_controller_path}/docs/ENDPOINT_SPEC.md
```

## ENDPOINT_SPEC.md Structure

Each ENDPOINT_SPEC.md file must include:

### 1. Endpoint Overview
- **Endpoint Key**: The technical identifier from endpoints-list.csv
- **Legacy Path**: Original endpoint path from legacy repo
- **Converted Path**: New path in DiasRestApi (`/legacy/{repo}/{path}`)
- **HTTP Method**: GET, POST, PUT, DELETE, etc.
- **Purpose**: One-sentence description of what this endpoint does

### 2. Business Logic
- **Primary Function**: What business problem does this solve?
- **Business Rules**: Any validation, authorization, or business constraints
- **Data Flow**: High-level flow of data through the endpoint
- **Side Effects**: Does it create, update, or delete data? Send notifications? Call external services?

### 3. Request Specification
- **Path Parameters**: Document each parameter with type and description
- **Query Parameters**: Document each parameter with type, description, and whether optional
- **Request Headers**: Required headers (authentication, content-type, etc.)
- **Request Body**: Structure and validation rules (if applicable)
- **Example Request**: Concrete example with sample data

### 4. Response Specification
- **Success Response**: HTTP status code and body structure
- **Error Responses**: All possible error codes and their meanings
- **Response Headers**: Any special headers returned
- **Example Responses**: Concrete examples for success and common errors

### 5. Dependencies
- **Database Operations**: What tables/entities are accessed? Read or write?
- **External Services**: What external APIs or services are called?
- **Internal Services**: What other services within the legacy repo are used?
- **Authentication/Authorization**: What permissions are required?

### 6. Data Models
- **Input Models**: Data structures expected in request
- **Output Models**: Data structures returned in response
- **Database Models**: Entities that will need JSON DTOs for DalService
- **Transformation Logic**: Any data mapping or transformation

### 7. Edge Cases and Error Handling
- **Validation Errors**: What input validation is performed?
- **Not Found Scenarios**: When does it return 404?
- **Permission Errors**: When does it return 403?
- **Business Logic Errors**: What business rule violations can occur?
- **External Service Failures**: How are external failures handled?

### 8. Testing Considerations
- **Test Scenarios**: Key scenarios that must be tested
- **Test Data Requirements**: What data is needed for testing?
- **Comparison Testing**: How to verify 1-to-1 match with legacy endpoint
- **Edge Cases to Test**: Specific edge cases identified in the code

### 9. Conversion Notes
- **Complexity Assessment**: Simple, Medium, or Complex conversion?
- **Potential Challenges**: Any tricky parts identified in the legacy code?
- **External Service Calls**: Will need external_services.service.ts?
- **Shared Code**: Any shared utilities or helpers that need to be copied?
- **Special Considerations**: Anything unusual about this endpoint?

## Process

For each endpoint:

1. **Locate the legacy controller** using the controller column from endpoints-list.csv
2. **Read the entire code path** - follow all method calls, understand all logic
3. **Identify all dependencies** - database, external services, internal services
4. **Document the business logic** - what it does, not just how
5. **Create comprehensive ENDPOINT_SPEC.md** following the structure above
6. **Update conversion_status** in endpoints-list.csv to "SPEC_CREATED"

## Important Notes

### Deep Analysis Required
- Don't just document the obvious - dig deep into the code
- Follow all method calls to understand the complete flow
- Identify hidden dependencies and edge cases
- Document WHY things are done, not just WHAT is done

### Focus on Business Logic
- The spec should help someone understand the endpoint without reading legacy code
- Explain business rules and constraints clearly
- Document the purpose and value of the endpoint
- Include context about when and why this endpoint is used

### Prepare for Conversion
- The ENDPOINT_SPEC.md will be used during Phase 3 (Conversion)
- It should contain enough detail to guide the SDD process
- Identify potential challenges early
- Note any decisions that need to be made during conversion

### Batch Processing
- This template processes ALL endpoints in the CSV file
- Each endpoint gets its own ENDPOINT_SPEC.md file
- Update the CSV file after each spec is created
- If an endpoint is too complex, flag it in the spec and continue

## Example ENDPOINT_SPEC.md Template

```markdown
# Endpoint Specification: {Endpoint Name}

## Endpoint Overview
- **Endpoint Key**: `{key from CSV}`
- **Legacy Path**: `{original path}`
- **Converted Path**: `/legacy/{repo}/{path}`
- **HTTP Method**: `{method}`
- **Purpose**: {one-sentence description}

## Business Logic
{Detailed explanation of what this endpoint does and why}

## Request Specification
### Path Parameters
- `{param}`: {type} - {description}

### Query Parameters
- `{param}`: {type} - {description} (optional/required)

### Request Headers
- `Authorization`: Bearer token required
- `Content-Type`: application/json

### Request Body
```json
{
  "example": "request body"
}
```

## Response Specification
### Success Response (200 OK)
```json
{
  "example": "response body"
}
```

### Error Responses
- **404 Not Found**: {when this occurs}
- **400 Bad Request**: {when this occurs}
- **403 Forbidden**: {when this occurs}

## Dependencies
### Database Operations
- **Table**: {table name} - {read/write} - {purpose}

### External Services
- **Service**: {service name} - {endpoint} - {purpose}

### Authentication/Authorization
- Requires: {role/permission}

## Data Models
### Input Model
{description of input structure}

### Output Model
{description of output structure}

### Database Models (JSON DTOs)
{entities that need DalService operations}

## Edge Cases and Error Handling
- {edge case 1}
- {edge case 2}

## Testing Considerations
### Test Scenarios
1. {scenario 1}
2. {scenario 2}

### Test Data Requirements
- {data requirement 1}

## Conversion Notes
- **Complexity**: {Simple/Medium/Complex}
- **Challenges**: {any identified challenges}
- **External Services**: {yes/no - details}
- **Special Considerations**: {any special notes}
```

## Completion Criteria

This phase is complete when:
- [ ] All endpoints in CSV have ENDPOINT_SPEC.md files created
- [ ] All specs follow the required structure
- [ ] All specs contain comprehensive business logic documentation
- [ ] All conversion_status values updated to "SPEC_CREATED"
- [ ] All specs are ready for review before Phase 3 conversion

## Next Steps

After all ENDPOINT_SPEC.md files are created and reviewed:
1. Review the specs to understand the endpoints
2. Prioritize which endpoints to convert first
3. Use `Templates/convert-single-endpoint.md` for Phase 3 conversion
4. The ENDPOINT_SPEC.md will guide the SDD process during conversion
