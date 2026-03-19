# Shared Components Usage Guide

All shared components are in `DiasUI/src/components/shared/` and exported from `index.ts`.

```typescript
import { DataTable, PageHeader, SearchInput, FormModal, ConfirmDialog, StatusBadge, LoadingState, EmptyState } from '@/components/shared';
```

---

## DataTable

Server-side paginated, sortable table built on `@tanstack/react-table`.

```tsx
import { DataTable } from '@/components/shared';
import { ColumnDef } from '@tanstack/react-table';

const columns: ColumnDef<Student>[] = [
  { accessorKey: 'KursistID', header: () => t('students.columns.id') },
  { accessorKey: 'Fornavn', header: () => t('students.columns.firstName') },
  { accessorKey: 'Efternavn', header: () => t('students.columns.lastName') },
];

<DataTable
  columns={columns}
  data={students}
  totalCount={totalCount}
  pageSize={pageSize}
  pageIndex={pageIndex}
  sorting={sorting}
  loading={isLoading}
  onPaginationChange={({ pageIndex, pageSize }) => { ... }}
  onSortingChange={(sorting) => { ... }}
  onRowClick={(row) => navigate(`/students/${row.KursistID}`)}
/>
```

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| `columns` | `ColumnDef<T>[]` | ✅ | TanStack column definitions |
| `data` | `T[]` | ✅ | Row data array |
| `totalCount` | `number` | ✅ | Total matching records (for pagination) |
| `pageSize` | `number` | — | Rows per page (default: 10) |
| `pageIndex` | `number` | — | Current page (0-based) |
| `sorting` | `SortingState` | — | Current sort state |
| `loading` | `boolean` | — | Show loading overlay |
| `onPaginationChange` | `(pagination) => void` | — | Page change handler |
| `onSortingChange` | `(sorting) => void` | — | Sort change handler |
| `onRowClick` | `(row: T) => void` | — | Row click handler |

---

## PageHeader

Page title with optional create button or custom actions.

```tsx
<PageHeader
  titleKey="nav.students"
  createLabel={t('common.create')}
  createPath="/students/create"
  actions={<Button onClick={...}>Export</Button>}
/>
```

**Props:**
| Prop | Type | Description |
|------|------|-------------|
| `titleKey` | `string` | i18n key for page title |
| `createPath` | `string` | Navigate to this path on "Create" click |
| `createLabel` | `string` | Label for create button |
| `actions` | `ReactNode` | Custom action buttons (right side) |

**Tip:** Conditionally render create button based on role:
```tsx
<PageHeader
  titleKey="nav.students"
  createPath={hasRole('CreateStudent') ? '/students/create' : undefined}
  createLabel={t('common.create')}
/>
```

---

## SearchInput

Debounced search field.

```tsx
<SearchInput
  value={search}
  placeholder={t('common.search')}
  debounceMs={500}
  onSearch={(value) => setSearch(value)}
/>
```

**Props:**
| Prop | Type | Description |
|------|------|-------------|
| `value` | `string` | Current search value |
| `placeholder` | `string` | Placeholder text |
| `debounceMs` | `number` | Debounce delay (default: 300) |
| `onSearch` | `(value: string) => void` | Callback after debounce |

---

## FormModal

Modal dialog for create/edit forms.

```tsx
<FormModal
  open={isOpen}
  title={t('students.createTitle')}
  loading={isPending}
  submitLabel={t('common.save')}
  onSubmit={handleSubmit}
  onClose={() => setIsOpen(false)}
  wide
>
  <div className="grid grid-cols-2 gap-4">
    <input ... />
    <input ... />
  </div>
</FormModal>
```

**Props:**
| Prop | Type | Description |
|------|------|-------------|
| `open` | `boolean` | Whether modal is visible |
| `title` | `string` | Modal title |
| `children` | `ReactNode` | Form content |
| `loading` | `boolean` | Disable submit button, show spinner |
| `submitLabel` | `string` | Submit button text (default: "Submit") |
| `onSubmit` | `() => void` | Submit handler |
| `onClose` | `() => void` | Close handler |
| `wide` | `boolean` | Use wider modal (for complex forms) |

---

## ConfirmDialog

Confirmation modal for destructive actions. **Always use instead of `window.confirm()`.**

```tsx
<ConfirmDialog
  open={showDelete}
  title={t('students.deleteTitle')}
  message={t('students.deleteMessage')}
  variant="danger"
  loading={isDeleting}
  onConfirm={handleDelete}
  onCancel={() => setShowDelete(false)}
/>
```

**Props:**
| Prop | Type | Description |
|------|------|-------------|
| `open` | `boolean` | Whether dialog is visible |
| `title` | `string` | Dialog title |
| `message` | `string` | Confirmation message |
| `variant` | `'danger' \| 'warning' \| 'info'` | Color scheme |
| `loading` | `boolean` | Disable confirm button |
| `onConfirm` | `() => void` | Confirm handler |
| `onCancel` | `() => void` | Cancel handler |

---

## StatusBadge

Colored badge for status display.

```tsx
<StatusBadge label={t('common.active')} variant="success" />
<StatusBadge label={t('common.inactive')} variant="danger" />
```

**Props:**
| Prop | Type | Description |
|------|------|-------------|
| `label` | `string` | Badge text |
| `variant` | `'success' \| 'danger' \| 'warning' \| 'info' \| 'default'` | Color |

---

## LoadingState

Centered spinner with message. Use while data is loading.

```tsx
{isLoading && <LoadingState message={t('common.loading')} />}
```

---

## EmptyState

Message when no data exists.

```tsx
{!isLoading && data.length === 0 && <EmptyState message={t('common.noData')} />}
```

---

## Typical Page Pattern

```tsx
export default function StudentsListPage() {
  const { t } = useTranslation();
  const { hasRole } = useAuthStore();
  const navigate = useNavigate();
  const [search, setSearch] = useState('');
  const [pageIndex, setPageIndex] = useState(0);
  const [sorting, setSorting] = useState<SortingState>([]);

  const { data, isLoading } = useStudentList({ search, pageIndex, pageSize: 10, sorting });

  return (
    <div>
      <PageHeader
        titleKey="nav.students"
        createPath={hasRole('CreateStudent') ? '/students/create' : undefined}
        createLabel={t('common.create')}
      />
      <SearchInput value={search} onSearch={setSearch} placeholder={t('common.search')} />
      {isLoading ? (
        <LoadingState />
      ) : data?.list.length === 0 ? (
        <EmptyState message={t('common.noData')} />
      ) : (
        <DataTable
          columns={columns}
          data={data?.list ?? []}
          totalCount={data?.QueryCount ?? 0}
          pageIndex={pageIndex}
          sorting={sorting}
          onPaginationChange={(p) => setPageIndex(p.pageIndex)}
          onSortingChange={setSorting}
          onRowClick={(row) => navigate(`/students/${row.KursistID}`)}
        />
      )}
    </div>
  );
}
```
