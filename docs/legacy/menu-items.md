# Legacy Menu Items — Full Tree

Extracted from `Legacy/DiasUI/src/app/theme/components/menu/menu.ts` (vertical menu).
Format: `Menu(id, title, route, href, icon, target, hasSubMenu, role, parentId)`

## Menu Tree

```
📊 Dashboard                                    (no role)
    └─ pages/dashboard

👥 AssignStudent                                 [AssignStudent]
    └─ pages/studentassigned/list

🎓 Students                                     [MenuStudent]
    ├─ pages/students/studentslist
    └─ Create → pages/students/studentCreate     [CreateStudent]

🏫 Schools                                      [MenuSchool]
    ├─ Schools
    │   ├─ pages/school/schoollist               [MenuSchool]
    │   └─ Create → pages/school/schooledit      [CreateSchool]
    └─ SchoolCalendar                            [MenuSchoolCalendar]
        ├─ pages/schoolcalendar/list
        └─ Create → pages/schoolcalendar/create  [SaveSchoolCalendar]

👤 Customers                                     [MenuCustomer]
    ├─ pages/customers/customerlist
    ├─ SellerRequests → pages/customers/salesrequest      [SalesAdmin]
    ├─ ChangeSalesperson → pages/customers/updatesalesperson [Administrators]
    ├─ MyRequests → pages/customers/mysalesrequest        [Salesman]
    └─ Create → pages/customers/customercreate            [CreateCustomer]

💻 Session                                       [MenuSession]
    ├─ pages/sessions/sessionslist
    ├─ Create → pages/sessions/sessionsEdit      [CreateSession]
    ├─ Skift AMU mål → pages/sessions/skiftamumaal [SkiftAmuMaal]
    └─ ProtocolLinking                           [MenuProtocolMerge]
        ├─ pages/protocol/protocollinkinglist
        └─ Create → pages/protocol/protocollinkingcreate [CreateProtocolMerge]

💰 Price                                         [MenuPrice]
    ├─ pages/prices/pricelist
    ├─ Create → pages/prices/priceedit           [CreatePrice]
    └─ Fee                                       [MenuFee]
        ├─ pages/prices/feelist
        └─ Create → pages/prices/feecreate       [CreateFee]

⚙️ Administration                                [MenuAdministration]
    ├─ Course                                    [MenuCourse]
    │   ├─ Course
    │   │   ├─ pages/course/courselist           [MenuCourse]
    │   │   └─ Create → pages/course/coursecreate [CreateCourse]
    │   └─ CourseInfo
    │       ├─ pages/course/courseinfolist        [MenuCourseInfo]
    │       └─ Create → pages/course/createcourseinfo [CreateCourseInfo]
    │
    ├─ Location                                  [MenuLocation]
    │   ├─ pages/location/locationlist
    │   └─ Create → pages/location/createlocation [EditLocations]
    │
    ├─ InvoiceType                               [MenuInvoiceType]
    │   ├─ pages/invoice/invoicetypelist
    │   └─ Create → pages/invoice/createinvoicetype [EditInvoiceType]
    │
    ├─ Assign                                    [MenuAssignObject]
    │   └─ pages/assignobject/list
    │
    ├─ Activity                                  [MenuActivity]
    │   ├─ pages/activity/activitylist
    │   └─ Create → pages/activity/create        [EditActivity]
    │
    ├─ Templates                                 [MenuTemplate]
    │   ├─ Template
    │   │   ├─ pages/template/templatelist        [MenuTemplate]
    │   │   └─ Create → pages/template/templateedit [MenuTemplate]
    │   ├─ KeyTemplate
    │   │   ├─ pages/template/keylist             [MenuTemplate]
    │   │   └─ Create → pages/template/keyedit    [MenuTemplate]
    │   └─ AdminText
    │       ├─ pages/template/admintextlist        [AdminText]
    │       └─ Create → pages/template/admintextcreate [AdminText]
    │
    ├─ Packages                                  [Packages]
    │   ├─ pages/packages/list
    │   └─ Create → pages/packages/create
    │
    ├─ Qualifications                            [Qualifications]
    │   ├─ pages/qualifications/list
    │   └─ Create → pages/qualifications/create
    │
    ├─ StudentTypes                              [menuStudentType]
    │   ├─ StudentTypes
    │   │   ├─ pages/studenttypes/list
    │   │   └─ Create → pages/studenttypes/create [EditStudentType]
    │   └─ RequisitionTypes
    │       ├─ pages/requisitiontypes/list
    │       └─ Create → pages/requisitiontypes/create [EditStudentType]
    │
    ├─ StatusTypes                               [StatusTypes]
    │   ├─ pages/statustypes/list
    │   └─ Create → pages/statustypes/create
    │
    ├─ Resources                                 [Resources]
    │   ├─ pages/resources/list
    │   └─ Create → pages/resources/create
    │
    ├─ UMO                                       [MenuUMO]
    │   └─ Delta                                 [MenuDelta]
    │       ├─ pages/delta/list
    │       └─ Settings → pages/delta/settings   [MenuSettingsDelta]
    │
    ├─ TypeOfTest                                [MenuTypeOfTest]
    │   ├─ pages/typeoftest/list
    │   └─ Create → pages/typeoftest/create      [EditTypeOfTest]
    │
    ├─ Area                                      [ViewArea]
    │   ├─ pages/area/list
    │   └─ Create → pages/area/create            [EditArea]
    │
    ├─ WebsiteCategories                         [ViewWebsiteKategorier]
    │   ├─ pages/websitecategories/list
    │   └─ Create → pages/websitecategories/create [EditWebsiteKategorier]
    │
    ├─ Documents                                 [MenuAdministration]
    │   ├─ DocumentCategory                      [MenuDocumentCategory]
    │   │   ├─ pages/document/documentcategorylist
    │   │   └─ Create → pages/document/documentcategorycreate [EditDocumentCategory]
    │   ├─ DocumentBinding                       [MenuDocumentBinding]
    │   │   ├─ pages/documentbinding/list
    │   │   └─ Create → pages/documentbinding/create [CreateDocumentBinding]
    │   └─ DocumentKeys                          [MenuDocumentBinding]
    │       ├─ pages/documentkeys/list
    │       └─ Create → pages/documentkeys/create [CreateDocumentBinding]
    │
    ├─ SchoolAMU                                 [ViewSkoleAMUramme]
    │   ├─ pages/schoolamu/list
    │   └─ Create → pages/schoolamu/create       [EditSkoleAMUramme]
    │
    ├─ Insurance                                 [ViewA_kasse]
    │   ├─ pages/insurance/list
    │   └─ Create → pages/insurance/create       [EditA_kasse]
    │
    ├─ CustomerInterest                          [ViewKundeInteresse]
    │   ├─ pages/customerinterest/list
    │   ├─ SyncVU → pages/customerinterest/sync
    │   ├─ Aktiver Holdsprog → pages/customerinterest/holdsprog
    │   └─ Create → pages/customerinterest/create [EditKundeInteresse]
    │
    └─ CancellationReasons                       [HoldaflysningsAarsag - Admin]
        ├─ pages/cancellationreason/list
        └─ Create → pages/cancellationreason/create

📊 Reports                                       [Reports]
    ├─ SearchInvoice → pages/invoice/searchinvoice           [ReportInvoice]
    ├─ MissingHours → pages/reports/signupmissinghours       [ReportMissingHours]
    ├─ ActivityPeriod → pages/reports/activityperiod          [ReportActivityPeriod]
    ├─ Offer → pages/reports/offer                            [ReportOffer]
    ├─ MissingDocuments → pages/reports/missingdocuments      [ReportMissingDocument]
    ├─ Signups → pages/reports/signupreport/{type}            [ReportSignup]
    ├─ SessionOutOfSync → pages/reports/vu                    [ReportSignup]
    ├─ UVM                                                    [ReportToUVM]
    │   ├─ Get → pages/reports/uvm/get
    │   ├─ Report → pages/reports/uvm/report
    │   └─ Reported → pages/reports/uvm/reported
    ├─ DWH                                                    [MenuReportDWH]
    │   ├─ Get → pages/reports/dwh/get
    │   ├─ Report → pages/reports/dwh/report
    │   └─ Reported → pages/reports/dwh/reported
    └─ CampaignContact → pages/reports/campaigncontact        [Campaign]

✉️ Messages                                      [Message]
    └─ pages/messages/messages

🤝 CustomerAgreement                              [MenuCustomerAgreement]
    └─ pages/customeragreement/list

🏅 Certificate                                    [MenuCertificate]
    ├─ pages/certificate/list
    └─ Arkiv → pages/certificate/arkiv

👥 UserManagement                                  [MenuUsers]
    ├─ Users → pages/users/userslist              [UserAdmin]
    ├─ Role → pages/role/list                     [Developer]
    │   └─ Create → pages/role/create
    └─ Groups → pages/groups/groupsList           [Groups]
        └─ Create → pages/groups/create           [EditGroups]

🔧 Developer                                      [Administrators]
    ├─ Logs → pages/developer/logs
    ├─ Notes → pages/developer/notes
    ├─ Config → pages/developer/configmanagement
    └─ Queue → pages/queue/list                   [MenuCertificate]
        └─ Create → pages/queue/create

📝 ChangeLog                                       [MenuDefault]
    └─ pages/changelog/list
```

## Legacy Route → New Route Mapping

| Legacy Route (pages.routing.ts) | Legacy Module | New DiasUI Route |
|---|---|---|
| `dashboard` | DashboardModule | `/dashboard` |
| `studentassigned` | StudentAssignedModule | `/student-assigned` |
| `students` | StudentModule | `/students` |
| `school` | SchoolModule | `/schools` |
| `schoolcalendar` | SchoolCalendarModule | `/school-calendar` |
| `customers` | CustomerModule | `/customers` |
| `sessions` | SessionModule | `/sessions` |
| `signup` | signupModule | _(part of sessions)_ |
| `protocol` | ProtocolModule | `/protocol` |
| `prices` | PriceModule | `/prices`, `/fees` |
| `course` | courseModule | `/courses`, `/course-info` |
| `location` | LocationModule | `/locations` |
| `invoice` | InvoiceModule | `/invoice-types`, `/reports/search-invoice` |
| `assignobject` | AssignObjectModule | `/assign-objects` |
| `activity` | ActivityModule | `/activities` |
| `template` | TemplateModule | `/templates`, `/key-templates`, `/admin-text` |
| `packages` | PackagesModule | `/packages` |
| `qualifications` | QualificationsModule | `/qualifications` |
| `studenttypes` | studentTypeModule | `/student-types` |
| `requisitiontypes` | RequisitionTypesModule | `/requisition-types` |
| `statustypes` | StatusTypesModule | `/status-types` |
| `resources` | ResourcesModule | `/resources` |
| `delta` | DeltaModule | `/delta` |
| `typeoftest` | TypeOfTestModule | `/type-of-test` |
| `area` | AreaModule | `/areas` |
| `websitecategories` | WebsitecategoriesModule | `/website-categories` |
| `document` | DocumentModule | `/document-categories` |
| `documentbinding` | DocumentBindingModule | `/document-bindings` |
| `documentkeys` | DocumentKeysModule | `/document-keys` |
| `reports` | ReportModule | `/reports/*` |
| `messages` | MessagesModule | `/messages` |
| `customeragreement` | CustomerAgreementModule | `/customer-agreements` |
| `certificate` | CertificateModule | `/certificates` |
| `schoolamu` | SchoolAmuModule | `/school-amu` |
| `insurance` | InsuranceModule | `/insurance` |
| `customerinterest` | CustomerinterestModule | `/customer-interest` |
| `queue` | QueueModule | `/queue` |
| `users` | UserManagmentModule | `/users` |
| `groups` | GroupManagmentModule | `/groups` |
| `role` | RolesModule | `/roles` |
| `developer` | DeveloperModule | `/developer/*` |
| `changelog` | ChangeLogModule | `/changelog` |
| `cancellationreason` | CancellationReasonModule | `/cancellation-reasons` |
| `catering` | CateringModule | _(not in new nav — assess need)_ |
| `reporterrors` | ReportErrorsModule | _(not in new nav — assess need)_ |
| `websitesignups` | WebSiteSignupModule | `/website-signups` |
| `offer` | OfferModule | `/reports/offer` |
