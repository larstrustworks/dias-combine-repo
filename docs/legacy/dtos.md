# Legacy DTOs Reference

All DTOs are in `Legacy/DiasUI/src/app/pages/dtos/gen/`. There are **180+ DTO files**.
This document covers the most important shared DTOs and the key domain DTOs.

## Core Shared DTOs

### FilterDTO (`FilterDTO.ts`)
Used by virtually every list endpoint for server-side pagination, sorting, and filtering.

```typescript
class FilterDTO {
  PageIndex: number;      // 0-based page index
  PageSize: number;       // rows per page
  Orders: Order[];        // sort columns
  Query: Query[];         // filter conditions
  CountRequired: boolean; // whether to return total count
  TableCountRequired: boolean; // whether to return unfiltered table count
}
```

### Order (`Order.ts`)
```typescript
class Order {
  By: string;             // column name to sort by
  Direction: OrderDirection; // ASC or DESC
}
```

### Query (`Query.ts`)
```typescript
class Query {
  searchProp: string;        // column to filter on
  searchValue: string;       // value to search for
  SearchOptions: number;     // 0=Contains, 1=Equals, 2=StartsWith
  selectedOperator: number;  // 0=And, 1=Or
}
```

### FilterResult (generic wrapper, defined inline)
```typescript
interface FilterResult<T> {
  list: T[];
  QueryCount: number;    // count matching the filter
  TableCount: number;    // total count (unfiltered)
}
```

### Enums (`Models/Enum/globals.ts`)
```typescript
enum OrderDirection { ASC = 0, DESC = 1 }
enum TextSearchOptions { Contains = 0, Equals = 1, StartsWith = 2 }
enum Operator { And = 0, Or = 1 }
enum ObjectType { Student = 1, Session = 2, Location = 3, ... }
enum TypeOfCategoryEnum { Student = 1, Session = 2, Location = 3, School = 4, ... }
```

---

## Key Domain DTOs

### Student (`Student.ts`, `StudentInfoListDTO.ts`)
```typescript
interface Student {
  KursistID: number;
  Personnummer: string;    // CPR number
  Fornavn: string;         // First name
  Efternavn: string;       // Last name
  Adresse: string;
  Postnr: string;
  By: string;
  Telefon: string;
  Mobil: string;
  Email: string;
  WorkEmail: string;
  // ... many more fields
}
```

### School (`School.ts`)
```typescript
interface School {
  SkoleKode: string;       // School code (PK)
  Navn: string;            // Name
  Adresse: string;
  Postnr: string;
  By: string;
  Telefon: string;
  CVR: string;
  Shortname: string;
  // ... more fields
}
```

### Location (`Location.ts`)
```typescript
interface Location {
  LokationsID: number;
  Adresse: string;
  Postnr: string;
  By: string;
  Land: string;
  Beskrivelse: string;     // Description
  IdentifikationTekst: string;
  Telefon: string;
  Email: string;
  Web: string;
  Konto: string;
  OmraadeID: number;
  SchoolCode: string;       // Comma-separated school codes
  StateCode: string;
  Inactiv: boolean;
  FinanceLocationID: number;
  SafeDriving: boolean;
  TeachingExternalLocation: boolean;
  IsDucasLokation: boolean;
  Laengdegrad: number;      // Longitude
  Breddegrad: number;       // Latitude
  Area: Area;               // Nested area object
  // ... audit fields
}
```

### Session (`Session.ts`)
```typescript
interface Session {
  HoldID: number;
  HoldNr: string;
  KursusID: number;
  SkoleKode: string;
  LokationsID: number;
  Status: number;
  MaxAntal: number;
  // ... many more fields
}
```

### Course (`Course.ts`)
```typescript
interface Course {
  KursusID: number;
  KursusNavn: string;
  KursusType: string;
  Varighed: number;
  // ... more fields
}
```

### Customer (`Customer.ts`)
```typescript
interface Customer {
  KundeID: number;
  Firmanavn: string;
  Adresse: string;
  Postnr: string;
  By: string;
  CVR: string;
  Telefon: string;
  Email: string;
  // ... more fields
}
```

### Signup (`Signup.ts`, `SignupDTO.ts`)
```typescript
interface Signup {
  TilmeldingsID: number;
  KursistID: number;
  HoldID: number;
  TilmeldingsDato: Date;
  Status: number;
  // ... more fields
}
```

### Area (`Area.ts`, `OmraadeDto.ts`)
```typescript
interface Area {
  OmraadeID: number;
  Navn: string;            // Name
  Beskrivelse: string;     // Description
}
```

### LocationRoles (`LocationRoles.ts`)
```typescript
interface LocationRoles {
  ID: number;
  LokationId: number;
  Role: string;
}
```

### FinanceLocationDTO (`FinanceLocationDTO.ts`)
```typescript
interface FinanceLocationDTO {
  FinanceLocationID: number;
  Name: string;
}
```

### AspNetRolesDTO (`AspNetRolesDTO.ts`)
```typescript
interface AspNetRolesDTO {
  Id: string;
  Name: string;
}
```

---

## Supporting DTOs

| DTO File | Used By | Description |
|----------|---------|-------------|
| `ActivityDTO.ts` | Activities | Activity definition |
| `AdminTextDTO.ts` | Admin Text | Template admin text |
| `BillingDTO.ts` | Billing | Invoice/billing data |
| `BillingTypesDTO.ts` | Billing | Billing type definitions |
| `CertificateService` | Certificates | Certificate data |
| `ChosenBillingTypesDTO.ts` | Sessions | Selected billing types for session |
| `ContactPerson.ts` | Customers | Customer contact persons |
| `CourseCategoryDTO.ts` | Courses | Course category hierarchy |
| `CourseInfo.ts` | CourseInfo | Detailed course information |
| `CRF_LineDTO.ts` | UMO/Delta | CRF line items |
| `CustomerInterest.ts` | Customer Interest | Interest definitions |
| `DWHDTO.ts` | DWH reports | Data warehouse reporting |
| `Fee.ts` | Fees/Prices | Fee definitions |
| `GetProtocolDTO.ts` | Protocol | Protocol data |
| `HoldAflysningsAarsagDTO.ts` | Cancellation Reasons | Session cancellation reasons |
| `HoldSprogDTO.ts` | Holdsprog | Session language settings |
| `InsuranceDTO (A_kasseDTO.ts)` | Insurance | Insurance/A-kasse data |
| `InvoiceDTO.ts` | Invoice | Invoice data |
| `InvoiceTypeDTO.ts` | Invoice Types | Invoice type definitions |
| `KeysTemplateDTO.ts` | Key Templates | Key template data |
| `KeyWordDTO.ts` | Keywords | Template keywords |
| `MessageTxt.ts` | Messages | Message content |
| `NoteStatusDTO.ts` | Notes | Note status definitions |
| `PackagesDTO.ts` | Packages | Package definitions |
| `Prices.ts` | Prices | Price definitions |
| `ProtocolDTO.ts` | Protocol | Protocol entries |
| `RegionDTO.ts` | Region lookup | ZIP → city/state lookup |
| `ReportingToUVMDTO.ts` | UVM Reports | UVM report data |
| `SchoolAmuDTO.ts` | School AMU | AMU framework data |
| `SessionList.ts` | Sessions | Session list view DTO |
| `SettingDTO.ts` | Settings/Config | Configuration settings |
| `SignupDTO.ts` | Signups | Signup data |
| `StatusTypesDTO.ts` | Status Types | Status type definitions |
| `StudentAssignedDTO.ts` | Student Assigned | Assigned student data |
| `StudentType.ts` | Student Types | Student type definitions |
| `SystemAssignObjectsDTO.ts` | Assign Objects | System assignment data |
| `TemplateDTO.ts` | Templates | Template definitions |
| `TestCourse.ts` | Type of Test | Test course data |
| `UserDTO.ts` | Users | User account data |
| `Website_Categori.ts` | Website Categories | Category definitions |
| `WebsiteTilmeldingDTO.ts` | Website Signups | Online signup data |

## Full DTO File List (180+ files)

Located at `Legacy/DiasUI/src/app/pages/dtos/gen/`. Run:
```powershell
Get-ChildItem "Legacy/DiasUI/src/app/pages/dtos/gen/*.ts" | Select-Object Name
```
