# Create Placeholders

Ok so now we need to do something wild, we need to convert old endpoints from Legacy repos to the DIAS platform. The endpoints we need to convert is the ones from this list:

<insert list here>

The list was created using the map-endpoints.md template inside the legacy repo. Be sure to read that to understand the list content.

If the csv file contains columns dias_controller_path or conversion_status, please start by deleting them and all data related to them, before continuing.

Each converted endpoint will be SELF CONTAINED so it will not share services, models or any thing with anyone else. Technically they will be "Controller Modules" so in the DiasRestApi/dotnet_version/src/controllers each legacy repo will have a main subfolder (named after the repo it came from) and then in there one folder per endpoint key. 

## Example:
Imagine a repository called invoice_services that has to endpoints:
** GET /invoice/{invoice_number} **
** POST /invoices **

They will have these keys in the endpoint-list.csv file:
invoice_services_GET_!invoice!{invoice_number}
invoice_services_POST_!invoices

Then we should have these folders in the DiasRestApi:
/dotnet_version/src/controllers/invoice_services/get/invoice/{invoice_number}
/dotnet_version/src/controllers/invoice_services/post/invoices

## Folder Structure

Each controller module folder should have this complete structure:

```
/dotnet_version/src/controllers/{legacy-repo}/{method}/{path}/
├── notimplemented_handler_controller.cs  # Placeholder controller (501 NOT IMPLEMENTED)
├── services/                              # Empty folder for future services
├── models/                                # Empty folder for future models
├── tests/                                 # Empty folder for future tests
└── docs/                                  # Empty folder for future documentation
```

The notimplemented_handler_controller.cs should respond with HTTP 501 NOT IMPLEMENTED. In that controller file, you must add a comment section in the top that references the endpoint key, example:

/* 
    This endpoint was create from legacy endpoint key: invoice_services_GET_!invoice!{invoice_number}
*/

The endpoint which should be responded to is /legacy/<legacy repo name>/<legacy endpoint path>, example:

invoice_services_GET_!invoice!{invoice_number}
(from invoice_services)

Should respond to endpoint in the converted controller like this:

  @get('/legacy/invoice_services/invoice/{invoice_number}', {
    <code here>
  }

Please implement the placeholders for the endpoints in the list now, creating the complete folder structure (including empty services/, models/, tests/, and docs/ folders) for each endpoint. Then update the csv file with a new column called dias_controller_path (unless it already exists), that holds the exact relative path to the folder that the controller placeholder for the endpoint was placed in. After the dias_controller_path insert a column with name conversion_status, and set all endpoints to PLACEHOLDER_CREATED.

Also, copy the ENDPOINTS_SUMMARY.md from the same folder as the endpoints-list.csv, and the endpoints-list.csv file, to the root of the controller folder.
(/dotnet_version/src/controllers/invoice_services in the example above)

IMPORTANT! - Do not change any files outside of the controller module folder, and do not change any existing files

## Documentation Requirements

- When creating placeholder controllers, document the placeholder creation in the endpoint list CSV
- Update the conversion_status column to track progress
- The endpoint list CSV serves as living documentation and must be kept accurate
- When placeholders are later converted to full implementations, the conversion_status must be updated

**Documentation Checklist**:
- [ ] Endpoint list CSV updated with dias_controller_path column
- [ ] Endpoint list CSV updated with conversion_status column
- [ ] All endpoints marked as PLACEHOLDER_CREATED
- [ ] Placeholder controller files include comment headers with endpoint keys
