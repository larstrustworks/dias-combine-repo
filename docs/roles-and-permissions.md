# Roles & Permissions — New DiasUI

How role-based access control works in the new React DiasUI.

## Architecture

```
Legacy DB (DEKRAUsers)
  └─ ApplicationUserGroups → Groups → GroupRoles → Roles
       ↓
  resolveUser() in server/auth.ts
       ↓
  Session cookie (dias.sid) stores user { id, username, roles: string[] }
       ↓
  Frontend reads via useAuthStore().user.roles
```

## Auth Store (`src/stores/auth.ts`)

```typescript
import { useAuthStore } from '@/stores/auth';

// In any component:
const { user, isAuthenticated, hasRole } = useAuthStore();

// Check a single role
if (hasRole('MenuStudent')) { /* show students menu */ }
if (hasRole('CreateStudent')) { /* show create button */ }
```

## Where Roles Are Checked

### 1. Sidebar Navigation (`src/config/navigation.ts`)

Each `NavItem` has an optional `requiredRole`. The sidebar component hides items the user lacks the role for.

```typescript
{
  id: 3,
  titleKey: 'nav.students',
  path: '/students',
  icon: GraduationCap,
  requiredRole: 'MenuStudent',  // ← only visible if user has this role
}
```

### 2. Page-Level Actions

Inside page components, use `hasRole()` to conditionally render:

```tsx
// Show create button only for users with CreateStudent role
<PageHeader
  titleKey="nav.students"
  createPath={hasRole('CreateStudent') ? '/students/create' : undefined}
/>

// Show delete button only for users with appropriate role
{hasRole('CreateStudent') && (
  <Button variant="destructive" onClick={() => setShowDelete(true)}>
    {t('common.delete')}
  </Button>
)}
```

### 3. Route Guards (Phase 2D — pending)

`ProtectedRoute` component will check roles at the route level:

```tsx
<Route
  path="/students"
  element={
    <ProtectedRoute requiredRole="MenuStudent">
      <StudentsListPage />
    </ProtectedRoute>
  }
/>
```

If the user lacks the role, they are redirected to `/unauthorized`.

## Complete Role List

See `docs/legacy/roles.md` for the full list of 50+ roles with descriptions.

### Quick Reference — Most Common Roles

| Role | Purpose | Used On |
|------|---------|---------|
| `MenuStudent` | View students | Nav + route |
| `CreateStudent` | Create/edit students | Create button |
| `MenuSchool` | View schools | Nav + route |
| `CreateSchool` | Create/edit schools | Create button |
| `MenuLocation` | View locations | Nav + route |
| `EditLocations` | Create/edit locations | Create button |
| `MenuCustomer` | View customers | Nav + route |
| `CreateCustomer` | Create/edit customers | Create button |
| `MenuSession` | View sessions | Nav + route |
| `CreateSession` | Create/edit sessions | Create button |
| `MenuAdministration` | View admin section | Nav |
| `Administrators` | Full admin access | Dev tools |
| `Reports` | View reports section | Nav |
| `MenuUsers` | View user management | Nav |
| `UserAdmin` | Manage users | User list |
| `Developer` | Developer features | Role management |

## How Roles Come From Legacy System

1. User logs in (impersonation or Entra ID)
2. BFF calls `resolveUser(identifier)` in `server/auth.ts`
3. `resolveUser()` calls legacy API: `GET /legacy/API/Api/AccountInternal/GetAllUsers`
4. Finds user by username/email, extracts their `roles[]` array
5. Stores in session: `{ id, username, email, roles, source }`
6. Frontend calls `GET /auth/me` → gets the user object with roles

### Role Data Structure

```typescript
// In DEKRAUsers database:
// Users → ApplicationUserGroups → ApplicationGroups → ApplicationGroupRoles → Roles

// Example user session:
{
  id: "A509279",
  username: "A509279",
  email: "admin@dekra.dk",
  roles: [
    "Administrators",
    "MenuStudent",
    "CreateStudent",
    "MenuSchool",
    "CreateSchool",
    "MenuLocation",
    "EditLocations",
    "MenuCustomer",
    "CreateCustomer",
    "MenuSession",
    "CreateSession",
    "Reports",
    "ReportInvoice",
    // ... many more
  ],
  source: "impersonation"
}
```

## Important Notes

- Role names are **case-sensitive** — `MenuStudent` ≠ `menustudent`
- One role has a space: `HoldaflysningsAarsag - Admin`
- There are **116 groups** and **440 role assignments** in the DEKRAUsers database
- Groups bundle roles together — users get roles via group membership
- See `docs/DIASUI-TEST-USERS.md` for test users with different role profiles
