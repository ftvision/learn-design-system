# Chapter 5: App Components

## Chapter Goal

By the end of this chapter, you will:
- Understand the difference between UI components and app components
- Know when to put a component in `packages/ui/` vs `apps/web/components/`
- Build app-specific components that compose UI primitives
- Handle business logic, data fetching, and form validation
- Create a clear separation between presentation and logic

## Prerequisites

- Completed Chapters 1-4
- Working monorepo from Chapter 4
- Understanding of React hooks and TypeScript

## Key Concepts

### The Two Types of Components

| UI Components (`packages/ui/`) | App Components (`apps/web/components/`) |
|-------------------------------|----------------------------------------|
| Generic, reusable | Product-specific |
| No business logic | Contains business logic |
| No data fetching | May fetch data |
| Works for any app | Works for THIS app |
| Example: `<Button>` | Example: `<SubmitOrderButton>` |
| Example: `<Card>` | Example: `<ProductCard>` |
| Example: `<Avatar>` | Example: `<UserProfileHeader>` |

### The Composition Pattern

App components **compose** UI components:

```tsx
// UI Component (generic)
<Card><Avatar /><Button /></Card>

// App Component (specific)
function UserCard({ user, onEdit }) {
  return (
    <Card>
      <Avatar src={user.avatar} alt={user.name} />
      <h3>{user.name}</h3>
      <Badge>{user.role}</Badge>
      <Button onClick={() => onEdit(user)}>Edit Profile</Button>
    </Card>
  );
}
```

### When to Create an App Component

Create an app component when you need:
- Business-specific props (e.g., `user`, `order`, `product`)
- Data fetching or mutations
- Form validation
- Navigation or routing
- State management
- Business rules

## What You'll Build

- UserCard: Displays user info with edit/delete actions
- ContactForm: Form with validation and submission
- DataTable: Table with business-specific columns
- Dashboard widgets: Metrics and charts

## Time Estimate

- Theory: 20 minutes
- Lab exercises: 2 hours
- Reflection: 20 minutes

## Success Criteria

- [ ] Built 3+ app components that compose UI primitives
- [ ] Implemented form validation in an app component
- [ ] Separated presentation (UI) from logic (app)
- [ ] Understood when to promote an app component to UI
- [ ] Compared with Cal.com's app components

## Next Chapter

Chapter 6 adds theming, allowing your components to adapt to light/dark mode and custom brand colors.
