# DiasUI — Page Conversion Prompt Template

> **Usage**: Copy the entire prompt below, fill in the `[PLACEHOLDERS]`, and paste into your AI coding assistant.
> This template converts one legacy Angular page (from `Legacy/DiasUI/`) into the new React DiasUI (`DiasUI/`).

---

## THE PROMPT

```
You are converting a legacy Angular page in the DIAS system to a new React page.
Read ALL the files listed below carefully before writing any code.

═══════════════════════════════════════════════════════════════
TASK: Convert the "[PAGE_NAME]" page from legacy Angular to new React DiasUI.
═══════════════════════════════════════════════════════════════

## 1. SOURCE FILES TO READ (Legacy Angular)

Read every file in the legacy page folder — components, templates, modules, and child pages:

- `Legacy/DiasUI/src/app/pages/[LEGACY_FOLDER]/` — ALL .ts, .html files recursively
- `Legacy/DiasUI/src/app/pages/services/gen/[SERVICE_FILE].ts` — API service(s) used
- `Legacy/DiasUI/src/app/pages/dtos/gen/[DTO_FILES].ts` — DTOs used by the page
- `Legacy/DiasUI/src/app/pages/Models/Enum/globals.ts` — Enums (FilterDTO, OrderDirection, etc.)

IMPORTANT: Read ALL sub-components, child routes, modals, and embedded views.
The legacy module file (*.module.ts) lists all components and routes — use it as your checklist.

## 2. TARGET ARCHITECTURE (New React DiasUI)

Read these files to understand the existing patterns and components:

### 2a. Documentation (read first for context)
- `docs/DIASUI-ARCHITECTURE.md` — Full architecture reference (BFF, auth, routing, API layer)
- `docs/shared-components.md` — Usage guide with code examples for all shared components
- `docs/roles-and-permissions.md` — Auth store, hasRole(), role reference
- `docs/legacy/api-endpoints.md` — All legacy API endpoints grouped by service
- `docs/legacy/dtos.md` — Key DTO interfaces (FilterDTO, FilterResult, etc.)
- `docs/legacy/roles.md` — All 50+ legacy roles with descriptions
- `docs/legacy/menu-items.md` — Legacy→new route mapping table
- `docs/legacy/external-services.md` — External service URLs and new prefix mapping
- `docs/legacy/page-inventory.md` — Conversion status tracker (UPDATE THIS WHEN DONE)

### 2b. Source code to read
- `DiasUI/src/components/shared/index.ts` — Available shared components
- `DiasUI/src/components/shared/DataTable.tsx` — Table component (TanStack, server-side pagination/sorting)
- `DiasUI/src/components/shared/FormModal.tsx` — Modal for create/edit forms
- `DiasUI/src/components/shared/ConfirmDialog.tsx` — Delete/action confirmation
- `DiasUI/src/components/shared/SearchInput.tsx` — Debounced search
- `DiasUI/src/components/shared/PageHeader.tsx` — Page title + actions
- `DiasUI/src/components/shared/StatusBadge.tsx` — Status indicators
- `DiasUI/src/components/shared/LoadingState.tsx` — Loading spinner
- `DiasUI/src/components/shared/EmptyState.tsx` — Empty state
- `DiasUI/src/lib/api.ts` — Axios instance (base URL: /api, withCredentials)
- `DiasUI/src/stores/auth.ts` — Auth store with hasRole()
- `DiasUI/src/config/navigation.ts` — Sidebar nav with role requirements
- `DiasUI/src/router.tsx` — Route definitions (currently stubs)
- `DiasUI/src/i18n/en.json` and `DiasUI/src/i18n/da.json` — Translation files

### 2c. Already-converted pages (read for established patterns)
If any pages have already been converted, read them to follow the same patterns:
- Check `DiasUI/src/types/` for existing type files
- Check `DiasUI/src/hooks/` for existing API hook files
- Check `DiasUI/src/pages/` for existing converted pages
Follow the same code style, naming conventions, and patterns as already-converted pages.

## 3. REQUEST FLOW — HOW API CALLS WORK

The new DiasUI NEVER calls legacy APIs directly. All requests go through the BFF:

```
Browser (React)
  → axios.post('/api/legacy/API/Api/Location/GetAllFilterDTO', filterDTO)
    → BFF (server/proxy.ts) strips /api prefix
      → DiasRestApi (port 9090) receives /legacy/API/Api/Location/GetAllFilterDTO
        → Route Switcher matches /legacy/API/* → proxies to IIS http://10.200.250.31:80
          → IIS DiasAPI handles /Api/Location/GetAllFilterDTO
```

**Key rules:**
- Frontend uses `api` axios instance from `src/lib/api.ts` (baseURL: `/api`)
- All legacy WebApi calls use prefix: `/api/legacy/API/Api/...`
- All legacy Gateway/DiasServices calls use prefix: `/api/legacy/Gateway/...`
- All legacy Efteruddannelse calls use prefix: `/api/legacy/Efteruddannelse/...`
- The BFF attaches X-API-KEY automatically — never send API keys from frontend
- Use `withCredentials: true` (already configured in api.ts)

**Legacy URL mapping:**
| Legacy BaseURL | New frontend prefix |
|---|---|
| `BaseAPIService.WebApiUrl + '/Api/...'` | `/api/legacy/API/Api/...` |
| `BaseAPIService.DiasServicesApiUrl + '...'` | `/api/legacy/Gateway/...` |
| `BaseAPIService.HenteOpsamledeDataApiUrl + '...'` | `/api/legacy/Efteruddannelse/...` |
| `BaseAPIService.UvmIndberetningUrl + '...'` | `/api/legacy/ReportingToUVM/...` |
| Business Central calls | `/api/bc/...` (BFF handles token) |

## 4. FILES TO CREATE

For each page conversion, create these files:

### 4a. Types — `src/types/[domain].ts`
- TypeScript interfaces matching the legacy DTOs exactly (same property names, same casing)
- Include ALL DTOs used by the page, including nested ones
- Include the FilterDTO/FilterResult interfaces if not already shared
- Export everything

### 4b. API hooks — `src/hooks/use[Domain].ts`
- Use React Query (`@tanstack/react-query`) for all data fetching
- Use the `api` axios instance from `@/lib/api.ts`
- Create separate hooks: `use[Domain]List`, `use[Domain]ById`, `use[Domain]Save`, `use[Domain]Delete`
- For list endpoints using FilterDTO: accept page, pageSize, sorting, filters as params
- Build the FilterDTO object inside the hook (not in the component)
- Return `{ data, isLoading, error, refetch }` from queries
- Return `{ mutate, isPending }` from mutations
- Use `queryClient.invalidateQueries` after mutations to refresh lists
- Handle error toast notifications inside mutation onError callbacks

### 4c. List page — `src/pages/[Domain]ListPage.tsx`
- Use `PageHeader` with correct i18n titleKey and create button
- Use `SearchInput` for text filtering (debounced)
- Use `DataTable` with proper column definitions, server-side pagination, sorting
- Column definitions: use TanStack `ColumnDef<T>[]` — translate headers with `t()`
- Row click navigates to detail/edit page
- Role-based create button: only show if `hasRole('[CreateRole]')`
- Handle loading and empty states
- Preserve ALL grid columns from the legacy component
- Preserve ALL filter options (checkboxes, dropdowns) from the legacy template
- If the legacy page has a "Show Inactive" toggle, include it

### 4d. Detail/Edit page — `src/pages/[Domain]DetailPage.tsx`
- Use `react-hook-form` with `zodResolver` for form validation
- Match ALL form fields from the legacy edit component template
- Match ALL validation rules from the legacy FormBuilder (required, minLength, maxLength, pattern, etc.)
- Include dropdowns for related entities (loaded via separate API hooks)
- Include multi-select for many-to-many relationships (e.g., SchoolCode, Roles)
- Save button calls the mutation hook
- Delete button uses `ConfirmDialog`
- Success → toast + navigate back to list
- Error → toast with error message
- If the legacy page has sub-pages (tabs, nested views), include them as tabs or sections
- Use `useParams()` to get the ID from the route
- Handle both create (id=0 or no id) and edit modes in the same component

### 4e. Child components (if any)
- If the legacy module has additional routes (e.g., Document, Settings), create separate page components
- If the legacy page has inline modals or popups, use `FormModal`
- If the legacy page has child grids (e.g., sub-tables inside edit), include them

### 4f. Update existing files
- `src/router.tsx` — Replace the `<Stub>` entry with lazy-loaded page component(s)
- `src/i18n/en.json` — Add ALL new translation keys (page title, column headers, form labels, messages, validation errors, button labels, toast messages)
- `src/i18n/da.json` — Add ALL Danish translations (use the legacy Angular translation files or the Danish field names from DTOs as reference)
- `src/config/navigation.ts` — Verify the nav entry exists with correct `requiredRole` (it should already be there)

## 5. MANDATORY REQUIREMENTS

### Roles & Permissions
- The `requiredRole` on the navigation item controls sidebar visibility
- Use `useAuthStore().hasRole('RoleName')` to conditionally show:
  - Create buttons (e.g., `hasRole('CreateStudent')`)
  - Edit/Delete actions (e.g., `hasRole('EditLocations')`)
  - Tab sections that require special roles
- Role names must match the legacy system EXACTLY (same casing, same spelling)
- The 50+ legacy roles: AssignStudent, MenuStudent, CreateStudent, MenuSchool, CreateSchool, MenuSchoolCalendar, SaveSchoolCalendar, MenuCustomer, SalesAdmin, Salesman, CreateCustomer, MenuSession, CreateSession, SkiftAmuMaal, MenuProtocolMerge, CreateProtocolMerge, MenuPrice, MenuFee, CreateFee, CreatePrice, MenuAdministration, MenuCourse, CreateCourse, MenuCourseInfo, CreateCourseInfo, MenuLocation, EditLocations, MenuInvoiceType, EditInvoiceType, MenuAssignObject, MenuActivity, EditActivity, MenuTemplate, Packages, Qualifications, menuStudentType, EditStudentType, StatusTypes, Resources, MenuUMO, MenuDelta, MenuSettingsDelta, MenuTypeOfTest, EditTypeOfTest, ViewArea, EditArea, ViewWebsiteKategorier, EditWebsiteKategorier, Reports, ReportInvoice, ReportMissingHours, ReportActivityPeriod, ReportOffer, ReportMissingDocument, ReportSignup, ReportToUVM, MenuReportDWH, Campaign, MenuDocumentCategory, EditDocumentCategory, MenuDocumentBinding, CreateDocumentBinding, Message, Administrators, Developer, MenuCustomerAgreement, MenuCertificate, ViewSkoleAMUramme, EditSkoleAMUramme, ViewA_kasse, EditA_kasse, ViewKundeInteresse, EditKundeInteresse, HoldaflysningsAarsag - Admin, MenuUsers, UserAdmin, Groups, EditGroups, MenuDefault, StudentSession

### Localization (i18n)
- ALL user-facing text MUST use `t('key')` from `react-i18next`
- Never hardcode display text in English or Danish
- Use namespaced keys: `[domain].fieldName`, `[domain].messages.saved`, `[domain].columns.name`
- Add entries to BOTH `en.json` and `da.json`
- Danish translations for common terms: Gem (Save), Slet (Delete), Opret (Create), Rediger (Edit), Søg (Search), Annuller (Cancel), Tilbage (Back), Handlinger (Actions), Ja (Yes), Nej (No)
- Use the legacy Angular translation keys as reference for Danish terms
- Column headers should match legacy field display names but be translated

### Shared Components — ALWAYS USE THEM
- **DataTable** — for ALL list/grid views (never build custom tables)
- **PageHeader** — at the top of every list page
- **SearchInput** — for text search/filter (debounced)
- **FormModal** — for quick-create or inline-edit modals
- **ConfirmDialog** — for ALL destructive actions (delete, deactivate)
- **StatusBadge** — for status columns (Active/Inactive, etc.)
- **LoadingState** — while data is loading
- **EmptyState** — when no results

### UX Best Practices
- Server-side pagination, sorting, filtering (not client-side) — the DataTable is already set up for this
- Toast notifications for save/delete success and errors (use a toast library like sonner or react-hot-toast)
- Loading spinners during API calls
- Disable submit buttons while saving (`isPending` from mutation)
- Inline form validation with error messages below fields
- Responsive layout: forms use grid with responsive columns
- Keyboard accessible: forms submit on Enter, modals close on Escape
- Breadcrumb-friendly page titles
- Navigate back to list after successful save/delete

### FilterDTO Pattern
The legacy API uses a standard FilterDTO for server-side filtering:

```typescript
interface FilterDTO {
  PageIndex: number;
  PageSize: number;
  Orders: { By: string; Direction: 'ASC' | 'DESC' }[];
  Query: {
    searchProp: string;
    searchValue: string;
    SearchOptions: number; // 0=Contains, 1=Equals, 2=StartsWith
    selectedOperator: number; // 0=And, 1=Or
  }[];
  CountRequired: boolean;
  TableCountRequired: boolean;
}

interface FilterResult<T> {
  list: T[];
  QueryCount: number;
  TableCount: number;
}
```

Build this in the API hook based on pagination/sorting/filter state from the component.

### Code Quality
- All files in TypeScript with strict types (no `any` unless absolutely necessary)
- Export page components as default exports (for lazy loading in router)
- Import shared components from `@/components/shared`
- Import api from `@/lib/api`
- Import auth store from `@/stores/auth`
- Use `@/` path alias for all imports
- Follow existing code style (check prettier/eslint config)
- No comments unless explaining complex business logic

## 6. COMPLETENESS CHECKLIST

Before finishing, verify:

### Functionality
- [ ] ALL legacy routes from the module file are covered (list, edit, create, child pages)
- [ ] ALL grid columns from the legacy list component are present in the DataTable
- [ ] ALL form fields from the legacy edit template are present in the form
- [ ] ALL form validations (required, minLength, maxLength, pattern, digits) are replicated with zod
- [ ] ALL API calls from the legacy service are available via hooks
- [ ] ALL role checks match the legacy system exactly
- [ ] ALL filter options (checkboxes, dropdowns, toggles) from the legacy template are included
- [ ] ALL child components (documents, settings, sub-grids) are converted
- [ ] ALL toast messages (success, error) are present with i18n keys

### Code & i18n
- [ ] ALL translations added to BOTH en.json AND da.json
- [ ] Router updated — stubs replaced with lazy-loaded components
- [ ] No hardcoded text — everything uses t()
- [ ] DataTable, PageHeader, SearchInput, FormModal, ConfirmDialog used where appropriate
- [ ] Create button only visible when user hasRole('[CreateRole]')
- [ ] Delete button only visible when user hasRole (if applicable)
- [ ] API calls use correct prefix (/api/legacy/API/Api/...)
- [ ] FilterDTO built correctly for server-side pagination/sorting/filtering
- [ ] Follows same patterns as already-converted pages (if any exist)

### Documentation Updates
- [ ] `docs/legacy/page-inventory.md` — Change status from ⬜ to ✅ for this page
- [ ] If new shared types were created (e.g., shared FilterDTO), update `docs/legacy/dtos.md`
- [ ] If new API patterns were discovered, note them for future conversions

## 7. PAGE-SPECIFIC DETAILS

**Page name**: [PAGE_NAME]
**Legacy folder**: `Legacy/DiasUI/src/app/pages/[LEGACY_FOLDER]/`
**Legacy services**: [LIST_SERVICE_FILES]
**Legacy DTOs**: [LIST_DTO_FILES]
**View role**: [VIEW_ROLE from navigation.ts requiredRole]
**Create role**: [CREATE_ROLE]
**Edit role**: [EDIT_ROLE]
**New route path(s)**: [ROUTE_PATHS from router.tsx]
**Nav titleKey**: [TITLE_KEY from navigation.ts]

Additional context or special requirements:
[ADD ANY PAGE-SPECIFIC NOTES HERE]
```

---

## PLACEHOLDER REFERENCE

| Placeholder | Description | Example |
|---|---|---|
| `[PAGE_NAME]` | Human-readable page name | `Locations` |
| `[LEGACY_FOLDER]` | Folder name in `Legacy/DiasUI/src/app/pages/` | `Locations` |
| `[SERVICE_FILE]` | Legacy service TS file(s) | `LocationService.ts` |
| `[DTO_FILES]` | Legacy DTO TS file(s) | `Location.ts, FinanceLocationDTO.ts` |
| `[VIEW_ROLE]` | Role needed to see in sidebar | `MenuLocation` |
| `[CREATE_ROLE]` | Role needed to create | `EditLocations` |
| `[EDIT_ROLE]` | Role needed to edit/delete | `EditLocations` |
| `[ROUTE_PATHS]` | Routes from `router.tsx` | `/locations, /locations/create, /locations/:id` |
| `[TITLE_KEY]` | i18n key from `navigation.ts` | `nav.locations` |

---

## EXAMPLE: Filled prompt for Locations page

```
[PAGE_NAME] = Locations
[LEGACY_FOLDER] = Locations
[SERVICE_FILE] = gen/LocationService.ts, gen/OmraadeService.ts
[DTO_FILES] = gen/Location.ts, gen/FinanceLocationDTO.ts, gen/Area.ts, gen/LocationRoles.ts, gen/SystemAssignObjectsDTO.ts
[VIEW_ROLE] = MenuLocation
[CREATE_ROLE] = EditLocations
[EDIT_ROLE] = EditLocations
[ROUTE_PATHS] = /locations, /locations/create, /locations/:id
[TITLE_KEY] = nav.locations

Legacy module routes (from Location.module.ts):
- locationlist → LocationComponent (List)
- editlocation/:id → LocationEditComponent (Edit)
- createlocation → LocationEditComponent (Create, id=0)
- locationdocument/:id → LocationDocumentComponent (Document management)

Special notes:
- LocationEditComponent handles both create and edit
- Form has reactive Address+ZIP → auto-lookup Region (GetRegion)
- Multi-select for SchoolCode (comma-separated in DTO)
- LocationRoles management (add/remove roles to locations)
- SystemAssignObjects shows warning icons for locations with errors
- "Show Inactive" toggle on list page filters out inactive locations
- FinanceLocation dropdown loaded from separate endpoint
- Area dropdown loaded from OmraadeService
```
