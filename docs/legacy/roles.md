# Legacy Roles Reference

All roles extracted from `Legacy/DiasUI/src/app/theme/components/menu/menu.ts` (vertical menu).
These roles control sidebar menu visibility and action permissions.

## Menu Visibility Roles

These roles determine which menu items a user can see in the sidebar:

| Role | Controls Visibility Of | Menu ID |
|------|----------------------|---------|
| `AssignStudent` | Assign Student page | 100 |
| `MenuStudent` | Students section | 300 |
| `MenuSchool` | Schools section | 400 |
| `MenuSchoolCalendar` | School Calendar | 430 |
| `MenuCustomer` | Customers section | 500 |
| `MenuSession` | Sessions section | 600 |
| `MenuProtocolMerge` | Protocol Linking | 670 |
| `MenuPrice` | Prices section | 700 |
| `MenuFee` | Fee sub-section | 750 |
| `MenuAdministration` | Administration section | 800 |
| `MenuCourse` | Courses sub-section | 805, 810 |
| `MenuCourseInfo` | Course Info | 820 |
| `MenuLocation` | Locations | 850 |
| `MenuInvoiceType` | Invoice Types | 870 |
| `MenuAssignObject` | Assign Objects | 890 |
| `MenuActivity` | Activities | 1000 |
| `MenuTemplate` | Templates, Key Templates | 1100, 1102, 1110 |
| `MenuUMO` | UMO section | 8000 |
| `MenuDelta` | Delta | 8100 |
| `MenuTypeOfTest` | Type of Test | 9000 |
| `MenuDocumentCategory` | Document Category | 12100 |
| `MenuDocumentBinding` | Document Binding, Document Keys | 12200, 12300 |
| `MenuCustomerAgreement` | Customer/Framework Agreements | 26000 |
| `MenuCertificate` | Certificates, Archive, Queue | 27000, 27100, 27007 |
| `MenuUsers` | User Management section | 10000 |
| `MenuReportDWH` | DWH Reports | 920 |
| `MenuDefault` | Change Log | 27200 |
| `Reports` | Reports section | 900 |
| `Message` | Messages | 11000 |
| `Administrators` | Developer section (Logs, Notes, Config) | 25000 |

## View Roles

| Role | What It Shows |
|------|---------------|
| `ViewArea` | Area list page | 
| `ViewWebsiteKategorier` | Website Categories list |
| `ViewSkoleAMUramme` | School AMU list |
| `ViewA_kasse` | Insurance list |
| `ViewKundeInteresse` | Customer Interest list, SyncVU, Holdsprog |

## Action/Create Roles

| Role | Action | Domain |
|------|--------|--------|
| `CreateStudent` | Create student | Students |
| `CreateSchool` | Create school | Schools |
| `SaveSchoolCalendar` | Create school calendar entry | School Calendar |
| `CreateCustomer` | Create customer | Customers |
| `CreateSession` | Create session | Sessions |
| `CreateProtocolMerge` | Create protocol linking | Protocol |
| `CreateFee` | Create fee | Fees |
| `CreatePrice` | Create price | Prices |
| `CreateCourse` | Create course | Courses |
| `CreateCourseInfo` | Create course info | Course Info |
| `EditLocations` | Create/edit location | Locations |
| `EditInvoiceType` | Create/edit invoice type | Invoice Types |
| `EditActivity` | Create/edit activity | Activities |
| `EditTypeOfTest` | Create/edit type of test | Type of Test |
| `EditArea` | Create area | Areas |
| `EditWebsiteKategorier` | Create website category | Website Categories |
| `EditDocumentCategory` | Create document category | Documents |
| `CreateDocumentBinding` | Create document binding/keys | Documents |
| `EditSkoleAMUramme` | Create school AMU | School AMU |
| `EditA_kasse` | Create insurance | Insurance |
| `EditKundeInteresse` | Create customer interest | Customer Interest |
| `EditStudentType` | Create student/requisition types | Student Types |
| `EditGroups` | Create groups | Groups |

## Special Roles

| Role | Description |
|------|-------------|
| `SalesAdmin` | View seller requests (Customers) |
| `Salesman` | View own sales requests (Customers) |
| `SkiftAmuMaal` | Change AMU goals (Sessions) |
| `MenuSettingsDelta` | Delta settings access |
| `Packages` | Packages CRUD |
| `Qualifications` | Qualifications CRUD |
| `StatusTypes` | Status Types CRUD |
| `Resources` | Resources CRUD |
| `menuStudentType` | Student Types & Requisition Types visibility |
| `AdminText` | Admin Text CRUD |
| `UserAdmin` | Users list access |
| `Groups` | Groups list visibility |
| `Developer` | Role management |
| `Campaign` | Campaign Contact report |
| `HoldaflysningsAarsag - Admin` | Cancellation Reasons CRUD |
| `StudentSession` | (Referenced in code, exact usage varies) |

## Report Roles

| Role | Report |
|------|--------|
| `ReportInvoice` | Search Invoice |
| `ReportMissingHours` | Missing Hours |
| `ReportActivityPeriod` | Activity Period |
| `ReportOffer` | Offer |
| `ReportMissingDocument` | Missing Documents |
| `ReportSignup` | Signups, Session Out of Sync |
| `ReportToUVM` | UVM reports (Get, Report, Reported) |

## Notes

- Role names are **case-sensitive** and must match exactly
- The `menu.ts` file contains `new Menu(id, title, route, href, icon, target, hasSubMenu, role, parentId)`
- The 8th parameter is the `role` string — this is used by `MenuService` to filter menu items
- Some roles overlap: e.g., `MenuCourse` is used for both Course list visibility and Course sub-menu
- The new DiasUI `navigation.ts` must map these same roles to `requiredRole` on `NavItem`
