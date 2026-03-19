# DiasUI — Test Users & Roles Reference

> **Location**: `dias/docs/DIASUI-TEST-USERS.md`
> **Last updated**: 2026-03-19
> **Source**: Queried from `DEKRAUsers` and `users` databases on SQL Server 10.200.250.41

---

## How Authentication Works

DiasUI uses **two user databases**:

| Database | Username Format | Has Roles? | Example |
|----------|----------------|------------|---------|
| `users` | `Firstname.Lastname` | ❌ No group/role assignments | `Merete.Breiner` |
| `DEKRAUsers` | Employee ID (`A######`) | ✅ Full group→role mappings | `A509279` |

The BFF's `resolveUser()` function queries via **RestApi → `AccountInternal/GetAllUsers`**. If the lookup fails or returns no results (common in dev since the RestApi may not be fully connected), the BFF uses **fallback dev roles** that grant full access.

### For Impersonation Testing

In the impersonation form, type any string as a username. If the RestApi lookup succeeds, you get real roles. If it fails, you get fallback dev roles (full admin access).

---

## Role Groups (from DEKRAUsers database)

There are **116 active groups** and **440 roles**. Groups bundle roles together. A user is assigned to groups, and each group grants a set of roles.

### Key Groups

| Group | Description | Access Level |
|-------|-------------|--------------|
| **Administrator** | Full system administrator | All menus, all CRUD, user management |
| **Super Users** | Power users | All menus, all CRUD, reports, settings |
| **Super users Plus** | Extended super user | Super Users + additional permissions |
| **Economy** | Financial operations | Invoices, fees, economic reports |
| **Economic Admin** | Financial administration | Economy + admin-level financial ops |
| **Education Boss** | Education department lead | Sessions, protocols, teacher management |
| **Teacher** | Instructor role | Sessions, signups, protocols, students |
| **TeoriTeacher** | Theory instructor | Theory-specific teaching access |
| **LogPlanTeacher** | Logbook/plan teacher | Logbook and planning access |
| **Customer Service** | Customer support | Customer management, signups, sessions |
| **Customer Center** | Call center | Customer center operations |
| **Sales Person** | Sales representative | Sales dashboard, customer management |
| **Sales Boss** | Sales team lead | Sales + team management |
| **UserManagement** | User admin | Create/edit/delete users and groups |

### Regional Groups

| Group | Scope |
|-------|-------|
| **All Regions** | Access to all regions |
| **all locations** | Access to all locations |
| **Region Sjælland** | Zealand region only |
| **Region Nord/midt Jylland** | North/Mid Jutland only |
| **Region Fyn/Syd** | Funen/South only |

---

## Test Users by Role Profile

### 🔴 Administrator

| Employee ID | Email | Groups |
|-------------|-------|--------|
| `A509279` | anton.kristensen@dekra.dk | Administrator, UserManagement, all locations, All Regions |

**Roles granted**: All menu access, all CRUD operations, user management, settings, reports — effectively unrestricted.

### 🟠 Super Users

| Employee ID | Email | Groups |
|-------------|-------|--------|
| `A170761` | selina.rosentraetter@dekra.dk | Super Users |
| `A135383` | Merete.breiner@dekra.dk | Super Users, Super users Plus |

**Roles granted** (141 roles including): `MenuStudent`, `MenuSchool`, `MenuCustomer`, `MenuSession`, `MenuPrice`, `MenuAdministration`, `MenuLocation`, `MenuCourse`, `Reports`, `MenuTemplate`, `MenuStatusTypes`, `EditStudent`, `EditSession`, `EditSchool`, `EditLocations`, etc.

### 🟡 Economy / Finance

| Employee ID | Email | Groups |
|-------------|-------|--------|
| `A509273` | *(economy user)* | all locations, All Regions, Economy special update, Economy, Super Users, Show full CPR, MessageEconomic, Economic Admin |

**Roles granted**: All Super Users roles + `EditInvoice`, `EditFee`, `Invoice`, `Fee`, economic reporting.

### 🟢 Education Boss

| Employee ID | Email | Groups |
|-------------|-------|--------|
| `A508805` | caya.klint@dekra.dk | LogPlanTeacher, Education Boss, Location vognmandsuddannelser, TeoriTeacher, Customer Service, Region Sjælland |
| `A510545` | *(education boss)* | LogPlanTeacher, all locations, All Regions, Education Boss, TeoriTeacher, Dashboard filled sessions, Customer Service, Edit old protocol, DeactiveSignupTheoryAndLogplan, Copy Signup |

**Roles granted**: Session management, protocol editing, teacher oversight, signup management.

### 🔵 Teacher

| Employee ID | Email | Groups |
|-------------|-------|--------|
| `A511141` | bo.rasmussen@dekra.dk | LogPlanTeacher, TeoriTeacher, Teacher, Region Sjælland |
| `A508872` | soeren.ledet@dekra.dk | LogPlanTeacher, TeoriTeacher, Teacher, Region Sjælland |
| `A510976` | peter.svolgaard@dekra.dk | LogPlanTeacher, TeoriTeacher, Region Nord/midt Jylland, Teacher |
| `A510382` | brian.frahm@dekra.dk | LogPlanTeacher, TeoriTeacher, Teacher, Region Fyn/Syd |

**Roles granted**: `MenuSession`, `MenuSignup`, `Protocol`, `Student`, `Session`, `Signup`, `Teacher`, `AssignObject`, `Note`, `School`, `Customer`, `DashBoard_MySessions`.

### 🟣 Customer Service

| Employee ID | Email | Groups |
|-------------|-------|--------|
| `A510316` | trine.gaardsoee@dekra.dk | all locations, All Regions, Customer Service, Copy Signup, UpdateKTADateSession |
| `A244766` | anette.pedersen@dekra.dk | all locations, All Regions, Customer Service |
| `A244795` | beth.hamborg@dekra.dk | all locations, All Regions, Customer Service, Berammelse |

### ⚪ Customer Center

| Employee ID | Email | Groups |
|-------------|-------|--------|
| `A509627` | jakob.enevoldsen@dekra.dk | all locations, All Regions, Customer Center |
| `A511214` | zainab.nassar@dekra.dk | all locations, Send to Eboks, All Regions, Customer Center |

### 🟤 Sales

| Employee ID | Email | Groups |
|-------------|-------|--------|
| `A509275` | *(sales boss)* | Teamplan, all locations, All Regions, Delete Document, Dashboard filled sessions, teamplan plus, Sales Boss, Sales Person, Show full CPR |
| `A510224` | janni.tranholm@dekra.dk | Region Nord/midt Jylland, Customer Service, Sales Person, Report invoice, Region Sjælland, Region Fyn/Syd |
| `A511110` | bo.hemmingsen@dekra.dk | Dashboard filled sessions, Sales Person, Region Sjælland |

---

## Menu Roles Reference

These role names control which sidebar menu items a user can see in the legacy (and new) UI:

| Role | Menu Item |
|------|-----------|
| `MenuStudent` | Students |
| `menuStudentType` | Student Types |
| `MenuSchool` | Schools |
| `MenuSchoolCalendar` | School Calendar |
| `MenuCustomer` | Customers |
| `MenuSession` | Sessions |
| `MenuSignup` | Signup |
| `MenuPrice` | Prices |
| `MenuFee` | Fees |
| `MenuAdministration` | Administration section |
| `MenuCourse` | Courses |
| `MenuCourseInfo` | Course Info |
| `MenuLocation` | Locations |
| `MenuInvoiceType` | Invoice Types |
| `MenuTemplate` | Templates |
| `MenuStatusTypes` | Status Types |
| `MenuResources` | Resources |
| `MenuPackages` | Packages |
| `MenuQualifications` | Qualifications |
| `MenuTypeOfTest` | Type of Test |
| `MenuDelta` | UMO / Delta |
| `MenuDocumentCategory` | Document Categories |
| `MenuProtocolMerge` | Protocol Merge |
| `MenuRequisitiontypes` | Requisition Types |
| `MenuReportDWH` | DWH Reports |
| `MenuSchoolSettings` | School Settings |
| `MenuSettingsDelta` | Delta Settings |
| `MenuUMO` | UMO |
| `Reports` | Reports section |
| `Administrators` | Admin tools |
| `UserAdmin` | User administration |

---

## Database Schema Reference

### `users` Database

| Table | Purpose |
|-------|---------|
| `AspNetUsers` | 785 users, `Firstname.Lastname` format, no role assignments |
| `AspNetRoles` | Empty |
| `AspNetUserRoles` | Empty |
| `ApplicationGroups` | Empty |
| `ApplicationGroupRoles` | Empty |
| `ApplicationUserGroups` | Empty |

### `DEKRAUsers` Database

| Table | Purpose |
|-------|---------|
| `AspNetUsers` | Users with employee ID format (`A######`) |
| `AspNetRoles` | 440 roles (permission names) |
| `ApplicationGroups` | 116 groups (role bundles) |
| `ApplicationGroupRoles` | Group → Role mappings |
| `ApplicationUserGroups` | User → Group assignments |

### Key Columns in AspNetUsers

```
Id, UserName, Email, FullName, SchoolCode, Type,
FirstName, LastName, IsDeleted, DeletedDate,
LastLoginTime, RegistrationDate, Comment
```

---

## Quick Reference: Impersonation Testing

For quick testing in the impersonation form:

| Type any username | What happens |
|-------------------|-------------|
| `admin` | Falls back to dev roles (full access) if RestApi lookup fails |
| `teacher` | Falls back to dev roles (full access) if not found |
| `Anton.Kristensen` | Looked up in `users` DB via RestApi — may return real user |
| `Merete.Breiner` | Found in `users` DB — one of the few with DEKRAUsers match |

> **Note**: In development mode, if the RestApi lookup fails or returns no results, the BFF creates a session with **full admin dev roles**. This is intentional for development convenience. In production, failed lookups result in authentication rejection.

### Dev Fallback Roles

When the RestApi is unavailable, impersonation grants these roles:

```
MenuDefault, MenuStudent, MenuSchool, MenuCustomer,
MenuSession, MenuPrice, MenuAdministration, Reports,
MenuLocation, MenuCourse, MenuUsers, Administrators
```
