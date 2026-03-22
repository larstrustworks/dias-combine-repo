# Legacy Page Inventory — Complete Conversion Checklist

All pages from `Legacy/DiasUI/src/app/pages/pages.routing.ts` and `menu.ts`.
Use `docs/DIASUI-PAGE-CONVERSION-PROMPT.md` for each conversion.

## Status Legend
- ⬜ Not started
- 🔄 In progress
- ✅ Converted
- ➖ Not needed (utility/shared, or merged into another page)

---

## Pages To Convert (46 pages)

| # | Page | Legacy Folder | Legacy Route | New Route | View Role | Create/Edit Role | Services | Status |
|---|------|--------------|-------------|-----------|-----------|-----------------|----------|--------|
| 1 | **Students** | `student/` | `students` | `/students` | `MenuStudent` | `CreateStudent` | StudentService | ✅ |
| 2 | **Student Create/Edit** | `student/` | `students/studentCreate` | `/students/create`, `/students/:id` | `MenuStudent` | `CreateStudent` | StudentService, CprService | ✅ |
| 3 | **Student Assigned** | `student/StudentAssigned/` | `studentassigned` | `/student-assigned` | `AssignStudent` | `AssignStudent` | StudentAssignedService | ✅ |
| 4 | **Student Types** | `student/StudentType/` | `studenttypes` | `/student-types` | `menuStudentType` | `EditStudentType` | StudentService | ✅ |
| 5 | **Requisition Types** | `student/RequisitionTypes/` | `requisitiontypes` | `/requisition-types` | `menuStudentType` | `EditStudentType` | StudentService | ✅ |
| 6 | **Schools** | `Schools/` | `school` | `/schools` | `MenuSchool` | `CreateSchool` | SchoolService | ✅ |
| 7 | **School Edit** | `Schools/Edit/` | `school/schooledit/:id` | `/schools/:id` | `MenuSchool` | `CreateSchool` | SchoolService, OmraadeService | ✅ |
| 8 | **School Efteruddannelse** | `Schools/EfterUddannelse/` | _(sub-page)_ | `/schools/:id/efteruddannelse` | `MenuSchool` | — | SchoolService | ✅ |
| 9 | **School Settings** | `Schools/SchoolSettings/` | _(sub-page)_ | `/schools/:id/settings` | `MenuSchool` | — | SchoolService | ✅ |
| 10 | **School Calendar** | `SchoolCalendar/` | `schoolcalendar` | `/school-calendar` | `MenuSchoolCalendar` | `SaveSchoolCalendar` | SchoolService | ✅ |
| 11 | **Customers** | `Customers/` | `customers` | `/customers` | `MenuCustomer` | `CreateCustomer` | CustomerService | ✅ |
| 12 | **Customer Contact Persons** | `Customers/CustomerContactPersons/` | `customers` | `/customers/:id/contacts` | `MenuCustomer` | — | ContactPersonService | ✅ |
| 13 | **Sessions** | `session/` | `sessions` | `/sessions` | `MenuSession` | `CreateSession` | SessionService | ✅ |
| 14 | **Signup** | `signup/` | `signup` | _(part of sessions)_ | `MenuSession` | — | SignupService | ✅ |
| 15 | **Protocol** | `Protocol/` | `protocol` | `/protocol` | `MenuProtocolMerge` | `CreateProtocolMerge` | ProtocolService | ✅ |
| 16 | **Prices** | `Prices/` | `prices` | `/prices` | `MenuPrice` | `CreatePrice` | PriceService | ✅ |
| 17 | **Fees** | `Prices/` (fee routes) | `prices/feelist` | `/fees` | `MenuFee` | `CreateFee` | PriceService | ✅ |
| 18 | **Courses** | `Course/` | `course` | `/courses` | `MenuCourse` | `CreateCourse` | CourseService | ✅ |
| 19 | **Course Info** | `Course/` (courseinfo routes) | `course/courseinfolist` | `/course-info` | `MenuCourseInfo` | `CreateCourseInfo` | CourseCatalogService | ✅ |
| 20 | **Locations** | `Locations/` | `location` | `/locations` | `MenuLocation` | `EditLocations` | LocationService, OmraadeService | ✅ |
| 21 | **Location Document** | `Locations/Document/` | `location/locationdocument/:id` | `/locations/:id/documents` | `MenuLocation` | — | LocationService | ✅ |
| 22 | **Invoice Types** | `Invoice/` | `invoice` | `/invoice-types` | `MenuInvoiceType` | `EditInvoiceType` | BillingService | ✅ |
| 23 | **Assign Objects** | `AssignObject/` | `assignobject` | `/assign-objects` | `MenuAssignObject` | — | AssignObjectService, SystemAssignObjectService | ✅ |
| 24 | **Activities** | `Activity/` | `activity` | `/activities` | `MenuActivity` | `EditActivity` | ActivityService | ✅ |
| 25 | **Templates** | `Template/` | `template` | `/templates` | `MenuTemplate` | `MenuTemplate` | TemplateService | ✅ |
| 26 | **Key Templates** | `Template/` (key routes) | `template/keylist` | `/key-templates` | `MenuTemplate` | `MenuTemplate` | KeyTemplateService, KeyWordService | ✅ |
| 27 | **Admin Text** | `Template/` (admintext routes) | `template/admintextlist` | `/admin-text` | `AdminText` | `AdminText` | AdminTextService | ✅ |
| 28 | **Packages** | `Packages/` | `packages` | `/packages` | `Packages` | `Packages` | PackagesService | ✅ |
| 29 | **Qualifications** | `Qualifications/` | `qualifications` | `/qualifications` | `Qualifications` | `Qualifications` | — | ✅ |
| 30 | **Status Types** | `StatusTypes/` | `statustypes` | `/status-types` | `StatusTypes` | `StatusTypes` | StatusTypeService | ✅ |
| 31 | **Resources** | `Resources/` | `resources` | `/resources` | `Resources` | `Resources` | — | ✅ |
| 32 | **Delta (UMO)** | `UMO/Delta/` | `delta` | `/delta` | `MenuDelta` | `MenuSettingsDelta` | UMOLogService, DomainVaerdierService | ✅ |
| 33 | **Type of Test** | `TypeOfTest/` | `typeoftest` | `/type-of-test` | `MenuTypeOfTest` | `EditTypeOfTest` | TestCourseService | ✅ |
| 34 | **Areas** | `area/` | `area` | `/areas` | `ViewArea` | `EditArea` | OmraadeService | ✅ |
| 35 | **Website Categories** | `websitecategories/` | `websitecategories` | `/website-categories` | `ViewWebsiteKategorier` | `EditWebsiteKategorier` | WebsiteCategoriesService | ✅ |
| 36 | **Document Categories** | `Administration/Document/DocumentCategory/` | `document` | `/document-categories` | `MenuDocumentCategory` | `EditDocumentCategory` | — | ✅ |
| 37 | **Document Bindings** | `Administration/Document/DocumentBinding/` | `documentbinding` | `/document-bindings` | `MenuDocumentBinding` | `CreateDocumentBinding` | — | ✅ |
| 38 | **Document Keys** | `Administration/Document/DocumentKeys/` | `documentkeys` | `/document-keys` | `MenuDocumentBinding` | `CreateDocumentBinding` | — | ✅ |
| 39 | **School AMU** | `SchoolAmu/` | `schoolamu` | `/school-amu` | `ViewSkoleAMUramme` | `EditSkoleAMUramme` | SchoolAmuService | ✅ |
| 40 | **Insurance** | `Insurance/` | `insurance` | `/insurance` | `ViewA_kasse` | `EditA_kasse` | InsuranceService | ✅ |
| 41 | **Customer Interest** | `customerinterest/` | `customerinterest` | `/customer-interest` | `ViewKundeInteresse` | `EditKundeInteresse` | CustomerInterestService | ✅ |
| 42 | **Cancellation Reasons** | `CancellationReason/` | `cancellationreason` | `/cancellation-reasons` | `HoldaflysningsAarsag - Admin` | `HoldaflysningsAarsag - Admin` | HoldAflysningsAarsagService | ✅ |
| 43 | **Messages** | `Messages/` | `messages` | `/messages` | `Message` | `Message` | — | ✅ |
| 44 | **Customer Agreements** | `CustomerAgreement/` | `customeragreement` | `/customer-agreements` | `MenuCustomerAgreement` | — | — | ✅ |
| 45 | **Certificates** | `Certificate/` | `certificate` | `/certificates` | `MenuCertificate` | — | CertificateService | ✅ |
| 46 | **Website Signups** | `WebSiteSignups/` | `websitesignups` | `/website-signups` | — | — | WebSiteSignupService | ✅ |

---

## Reports (10 report pages, all under `/reports/`)

| # | Report | Legacy Route | New Route | Role | Status |
|---|--------|-------------|-----------|------|--------|
| R1 | **Search Invoice** | `invoice/searchinvoice` | `/reports/search-invoice` | `ReportInvoice` | ✅ |
| R2 | **Missing Hours** | `reports/signupmissinghours` | `/reports/missing-hours` | `ReportMissingHours` | ✅ |
| R3 | **Activity Period** | `reports/activityperiod` | `/reports/activity-period` | `ReportActivityPeriod` | ✅ |
| R4 | **Offer** | `reports/offer` | `/reports/offer` | `ReportOffer` | ✅ |
| R5 | **Missing Documents** | `reports/missingdocuments` | `/reports/missing-documents` | `ReportMissingDocument` | ✅ |
| R6 | **Signups** | `reports/signupreport/{type}` | `/reports/signups` | `ReportSignup` | ✅ |
| R7 | **Session Out of Sync** | `reports/vu` | `/reports/session-out-of-sync` | `ReportSignup` | ✅ |
| R8 | **UVM** (Get/Report/Reported) | `reports/uvm/*` | `/reports/uvm/*` | `ReportToUVM` | ✅ |
| R9 | **DWH** (Get/Report/Reported) | `reports/dwh/*` | `/reports/dwh/*` | `MenuReportDWH` | ✅ |
| R10 | **Campaign Contact** | `reports/campaigncontact` | `/reports/campaign-contact` | `Campaign` | ✅ |

---

## User Management (3 pages)

| # | Page | Legacy Route | New Route | Role | Status |
|---|------|-------------|-----------|------|--------|
| U1 | **Users** | `users/userslist` | `/users` | `UserAdmin` | ✅ |
| U2 | **Roles** | `role/list` | `/roles` | `Developer` | ✅ |
| U3 | **Groups** | `groups/groupsList` | `/groups` | `Groups` / `EditGroups` | ✅ |

---

## Developer Tools (4 pages)

| # | Page | Legacy Route | New Route | Role | Status |
|---|------|-------------|-----------|------|--------|
| D1 | **Logs** | `developer/logs` | `/developer/logs` | `Administrators` | ✅ |
| D2 | **Notes** | `developer/notes` | `/developer/notes` | `Administrators` | ✅ |
| D3 | **Config** | `developer/configmanagement` | `/developer/config` | `Administrators` | ✅ |
| D4 | **Queue** | `queue/list` | `/queue` | `MenuCertificate` | ✅ |

---

## Other Pages

| # | Page | Legacy Route | New Route | Status |
|---|------|-------------|-----------|--------|
| O1 | **Change Log** | `changelog/list` | `/changelog` | ✅ |
| O2 | **Dashboard** | `dashboard` | `/dashboard` | ✅ |

---

## Not Converted — Utility/Shared Folders

These legacy folders are **not pages** — they are shared utilities, models, or framework scaffolding:

| Folder | Reason |
|--------|--------|
| `dtos/` | DTO definitions — referenced by pages, not a page itself |
| `services/` | API service classes — referenced by pages |
| `Models/` | Enums and models |
| `shared/` | Shared Angular components (GlobalService, etc.) |
| `grid-view/` | Custom grid component framework |
| `Components/` | Shared UI building blocks |
| `form-elements/` | Form element demos |
| `blank/` | Empty page template |
| `charts/` | Chart demos (commented out in routing) |
| `maps/` | Map demos (commented out) |
| `search/` | Search component |
| `modal/` | Modal demo |
| `tools/` | Developer tools framework page |
| `calendar/` | Calendar component wrapper |
| `login/` | Login page (already converted to new DiasUI) |
| `register/` | Registration (not used) |
| `errors/` | Error pages |
| `dynamic-menu/` | Dynamic menu demo (not used) |
| `membership/` | Membership demo (not used) |
| `mailbox/` | Mailbox demo (not used) |
| `ui/` | UI component demos |
| `dashboard/` | Dashboard (basic, will be rebuilt) |
| `WebApiServices/` | ConfigModel definition |

---

## Assess Need — May Not Be Needed In New UI

| Folder | Legacy Route | Notes |
|--------|-------------|-------|
| `Catering/` | `catering` | Catering reports — not in new nav, assess if still needed |
| `ReportErrors/` | `reporterrors` | Error reporting — may be replaced by developer logs |
| `CopyObject/` | _(embedded)_ | Copy functionality — likely embedded in other pages |
| `AssignObjectFavorites/` | _(embedded)_ | Favorites for assign — sub-feature |
| `AssignTest/` | _(embedded)_ | Test assignment — sub-feature |
| `ChosenBillingTypes/` | _(embedded)_ | Billing type selection — used as sub-component |
| `ChosenTest/` | _(embedded)_ | Test selection — used as sub-component |
| `CRF_Line/` | _(embedded)_ | CRF line items — part of UMO/Delta |
| `Documentation/` | _(embedded)_ | Document viewer — embedded in other pages |
| `Holdsprog/` | _(embedded)_ | Session language — embedded in customer interest |
| `Notes/` | `note` | Notes — in dev tools nav |
| `Offer/` | `offer` | Offers — part of reports |
| `Planning/` | _(embedded)_ | Planning features — embedded |
| `Send/` | _(embedded)_ | Send/email functionality — embedded |
| `Settings/` | _(embedded)_ | Settings sub-page |

---

## Summary

| Category | Count |
|----------|-------|
| **Main pages** | 46 |
| **Reports** | 10 |
| **User Management** | 3 |
| **Developer Tools** | 4 |
| **Other** | 2 |
| **Total to convert** | **65** |
| **Utility/not needed** | ~22 |
| **Assess need** | ~15 |

## Recommended Conversion Order

1. **Students** (most complex, establishes pattern)
2. **Schools** (includes sub-pages)
3. **Locations** (includes roles management, documents)
4. **Customers** (includes contact persons, sales)
5. **Sessions** (includes signups, protocol)
6. **Courses + Course Info**
7. **Prices + Fees**
8. Simple CRUD pages: Activities, Templates, Packages, Qualifications, Student Types, Status Types, Resources, Areas, Website Categories, Insurance, School AMU, Customer Interest, Cancellation Reasons
9. Documents (Categories, Bindings, Keys)
10. Reports (10 report pages)
11. User Management (Users, Roles, Groups)
12. Developer Tools
13. Remaining: Messages, Certificates, Customer Agreements, Delta/UMO, Type of Test, School Calendar, Website Signups, Change Log
