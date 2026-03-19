# MAP Api EndPoints

This prompt is related to the project located in 

<legacy project folder>

Please add a folder at the root of this project called map. In that folder place a csv file called endpoints-list.csv outlining all endpoints in this project. Only externally exposed endpoints that others can call. The CSV file should be constructed as:

key;endpoint;controller;logic

Where:

key -> is a technical way of identifying the endpoint as <repository name>_<endpoint http method>_<endpoint path where / is replaced by !>, example: OrderService_GET_!customer!{customer_id}!orders
endpoint -> is the actual endpoint that can be called when a client invokes this service, example: GET /customer/{customer_id}/orders
controller -> is the name of the controller handling the endpoint, example: CustomerOrderController
logic -> Is a brief one liner describing the business logic functionality of the endpoint, example: fetches all orders for a specific customer

The csv file should include the header.

It is extremely important that you navigate through the entire repo to identify all endpoints, we cannot miss any, so use all the tricks you can imagine to get it done.

In same folder as the endpoints-list.csv also create an ENDPOINTS_SUMMARY.md file with all relevant information regarding the tech stack, endpoint etc you encounter during your research as that would be useful for later conversion of the endpoints 

## Documentation Requirements

- The endpoints-list.csv file is living documentation and must be kept accurate
- When new endpoints are added to the codebase, the CSV must be updated
- When endpoints are modified or deprecated, the CSV must be updated
- When endpoints are removed, they should be marked as deprecated in the CSV with a deprecation date, not deleted
- The CSV serves as the source of truth for endpoint inventory and migration tracking

**Documentation Checklist**:
- [ ] All endpoints in the repository are documented in the CSV
- [ ] CSV includes accurate key, endpoint, controller, and logic columns
- [ ] CSV file is placed in the /map folder at repository root
- [ ] CSV follows the specified format with semicolon delimiters
- [ ] CSV includes header row
