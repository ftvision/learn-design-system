# Lecture Notes: Capstone Project (Part 1 - Project Kickoff)

**Duration:** 30-45 minutes
**Chapter:** 09 - Capstone Project

---

## Lecture Outline

1. Opening Reflection
2. The Project: Team Management Feature
3. Mapping to the 5-Layer Architecture
4. Component Inventory and Planning
5. The Build Strategy
6. Success Criteria and Evaluation
7. Key Takeaways

---

## 1. Opening Reflection (5 minutes)

> **Ask the class:** "We've covered 8 chapters. What have we learned, and how does it all connect?"

**Expected responses:** Tokens, components, monorepos, theming, Storybook, cross-platform...

### The Journey So Far

```
Chapter 1: Understanding      → The 5-layer mental model
Chapter 2: Design Tokens      → Layer 1 (the foundation)
Chapter 3: Primitives         → Layer 2 (building blocks)
Chapter 4: Monorepo           → Architecture (how it's organized)
Chapter 5: App Components     → Layer 4 (business logic)
Chapter 6: Theming            → Cross-cutting concern
Chapter 7: Documentation      → Storybook (making it usable)
Chapter 8: Cross-Platform     → Multi-platform tokens
```

> **Now:** We integrate everything into a real feature that demonstrates mastery.

---

## 2. The Project: Team Management Feature (7 minutes)

### What We're Building

A complete "Team Settings" page that allows users to:

```
┌─────────────────────────────────────────────────────────────────┐
│  Team Settings                                    [Light/Dark]  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Team Members (5)                            [+ Invite Member]  │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 🔍 Search by name or email...    [All][Admin][Member]   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ [Avatar] Jane Smith              Owner                  │   │
│  │          jane@company.com                               │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ [Avatar] John Doe                [Admin ▼]    [Remove]  │   │
│  │          john@company.com                               │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ [Avatar] Alice Johnson           [Member ▼]   [Remove]  │   │
│  │          alice@company.com       (Pending)              │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Feature Requirements

| Requirement | Description |
|-------------|-------------|
| **View members** | Display list with avatar, name, email, role |
| **Search** | Filter by name or email |
| **Filter by role** | Show only admins, members, or guests |
| **Invite member** | Modal with email, role selection |
| **Edit role** | Inline dropdown to change roles |
| **Remove member** | With confirmation dialog |
| **Theme toggle** | Light/dark mode throughout |

### Why This Project?

This feature exercises every layer of the design system:

| Layer | Component |
|-------|-----------|
| **Layer 1: Tokens** | Colors, spacing, typography in all components |
| **Layer 2: Primitives** | Button, Input, Avatar, Badge, Card, Modal, Select |
| **Layer 3: Patterns** | Modal with form, list with filters |
| **Layer 4: App Components** | TeamMemberRow, InviteMemberModal, TeamMemberList |
| **Layer 5: Page** | /team page orchestrating everything |

---

## 3. Mapping to the 5-Layer Architecture (8 minutes)

### Visual: The Feature Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    TEAM MANAGEMENT FEATURE                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Layer 5: Page                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ /team/page.tsx                                          │    │
│  │ - Orchestrates data                                     │    │
│  │ - Handles routing                                       │    │
│  │ - Contains mock data (or API calls)                     │    │
│  └────────────────────────────┬────────────────────────────┘    │
│                               │ renders                          │
│  Layer 4: App Components      ▼                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ TeamMemberList                                          │    │
│  │ ├── TeamMemberRow                                       │    │
│  │ ├── InviteMemberModal                                   │    │
│  │ └── ConfirmDeleteDialog                                 │    │
│  │                                                         │    │
│  │ - Know about TeamMember type                            │    │
│  │ - Contain business logic (filtering, validation)        │    │
│  └────────────────────────────┬────────────────────────────┘    │
│                               │ compose                          │
│  Layers 2-3: UI Components    ▼                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ packages/ui                                             │    │
│  │ - Button, Input, Card, Avatar, Badge                    │    │
│  │ - Modal, ModalHeader, ModalBody, ModalFooter           │    │
│  │ - Select                                                │    │
│  │                                                         │    │
│  │ - No business logic                                     │    │
│  │ - Generic and reusable                                  │    │
│  └────────────────────────────┬────────────────────────────┘    │
│                               │ consume                          │
│  Layer 1: Design Tokens       ▼                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ packages/tokens + theme.css                             │    │
│  │ - --color-bg, --color-text, --color-primary            │    │
│  │ - --color-border, --color-error                        │    │
│  │ - Light/dark theme variants                            │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### The Key Separation

**UI Components (packages/ui/)**
```tsx
// Modal doesn't know about "team members"
<Modal open={open} onClose={onClose}>
  {children}
</Modal>

// Select doesn't know about "roles"
<Select options={options} value={value} onChange={onChange} />
```

**App Components (apps/web/components/)**
```tsx
// TeamMemberRow KNOWS about TeamMember
function TeamMemberRow({ member }: { member: TeamMember }) {
  // Business logic: owners can't be removed
  const canRemove = member.role !== "owner";

  return (
    <Card>
      <Avatar src={member.avatarUrl} />  {/* UI primitive */}
      <Badge>{member.role}</Badge>        {/* UI primitive */}
      {canRemove && <Button>Remove</Button>}  {/* Business rule */}
    </Card>
  );
}
```

---

## 4. Component Inventory and Planning (8 minutes)

### UI Components to Build (or Verify)

| Component | Layer | New or Existing? | Key Features |
|-----------|-------|------------------|--------------|
| **Modal** | 2-3 | New | Backdrop, escape key, focus trap |
| **Select** | 2 | New | Options, label, error state |
| **Button** | 2 | Existing (Ch 3) | Variants, loading state |
| **Input** | 2 | Existing (Ch 3) | Label, error, hint |
| **Card** | 2 | Existing (Ch 3) | Padding variants |
| **Avatar** | 2 | Existing (Ch 3) | Fallback initials |
| **Badge** | 2 | Existing (Ch 3) | Color variants |

### App Components to Build

| Component | Purpose | Composes |
|-----------|---------|----------|
| **TeamMemberRow** | Single member display | Avatar, Badge, Select, Button |
| **TeamMemberList** | List with filters | Input, Button, Card, TeamMemberRow |
| **InviteMemberModal** | Invite form | Modal, Input, Select, Button |
| **ConfirmDeleteDialog** | Delete confirmation | Modal, Button |

### Data Types to Define

```typescript
// apps/web/types/team.ts

interface TeamMember {
  id: string;
  name: string;
  email: string;
  role: "owner" | "admin" | "member" | "guest";
  avatarUrl?: string;
  joinedAt: Date;
  status: "active" | "pending" | "inactive";
}

interface TeamInvite {
  email: string;
  role: "admin" | "member" | "guest";
  message?: string;
}
```

---

## 5. The Build Strategy (7 minutes)

### Recommended Order

```
Phase 1: UI Foundation (2-3 hours)
├── Build Modal component
├── Build Select component
├── Verify existing components use theme tokens
└── Write Storybook stories for new components

Phase 2: App Components (2-3 hours)
├── Define TeamMember types
├── Build TeamMemberRow
├── Build InviteMemberModal
├── Build TeamMemberList
└── Add ConfirmDeleteDialog (stretch)

Phase 3: Integration (1-2 hours)
├── Create /team page
├── Wire up mock data
├── Test all interactions
└── Verify theme works throughout

Phase 4: Polish (1 hour)
├── Add loading states
├── Test edge cases (empty list, errors)
├── Review Storybook documentation
└── Final theme testing
```

### Build Bottom-Up

Start with the smallest pieces and work up:

```
1. Modal (UI primitive)
      ↓
2. Select (UI primitive)
      ↓
3. TeamMemberRow (app component using primitives)
      ↓
4. InviteMemberModal (app component using Modal + primitives)
      ↓
5. TeamMemberList (orchestrates TeamMemberRow + InviteMemberModal)
      ↓
6. Team Page (renders TeamMemberList with data)
```

### Testing Strategy

| Component | How to Test |
|-----------|-------------|
| UI Components | Storybook stories, visual inspection |
| App Components | Render in page, test interactions |
| Theme | Toggle theme, verify all components update |
| Full Feature | End-to-end flow: search, filter, invite, edit, remove |

---

## 6. Success Criteria and Evaluation (5 minutes)

### Functional Requirements Checklist

```
[ ] Members display with avatar, name, email, role
[ ] Search filters members by name or email
[ ] Role filter buttons work (All, Admin, Member, Guest)
[ ] "Invite Member" button opens modal
[ ] Invite modal has email validation
[ ] Invite modal submits and closes
[ ] Role dropdown allows changing roles (except owner)
[ ] Remove button appears for non-owners
[ ] Theme toggle switches all components
```

### Technical Requirements Checklist

```
[ ] All colors use CSS variables (var(--color-*))
[ ] No hardcoded hex values in components
[ ] UI components live in packages/ui/
[ ] App components live in apps/web/components/
[ ] TypeScript types for TeamMember, TeamInvite
[ ] Modal and Select have Storybook stories
[ ] Theme works in Storybook
```

### Evaluation Rubric

| Criteria | Excellent | Good | Needs Work |
|----------|-----------|------|------------|
| **Architecture** | Clear layer separation | Minor mixing | UI has business logic |
| **Tokens** | 100% tokenized | Some hardcoded values | Many hardcoded values |
| **Theming** | Works everywhere | Works mostly | Broken in places |
| **Documentation** | All components in Storybook | Most components | Missing stories |
| **Code Quality** | Clean, typed, organized | Some issues | Messy, untyped |

---

## 7. Key Takeaways (5 minutes)

### The Design System in Action

```
┌─────────────────────────────────────────────────────────────────┐
│                    WHAT YOU'VE LEARNED                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   MENTAL MODEL                                                   │
│   ─────────────────────────────────────────────────────────     │
│   The 5-layer architecture guides every decision:               │
│   "Where does this component belong? What layer is it?"         │
│                                                                  │
│   TOKENS                                                         │
│   ─────────────────────────────────────────────────────────     │
│   Every color, spacing, and typography value comes from         │
│   tokens. Change once, update everywhere.                       │
│                                                                  │
│   COMPONENT DESIGN                                               │
│   ─────────────────────────────────────────────────────────     │
│   Primitives are generic. App components add business logic.    │
│   Composition > configuration.                                  │
│                                                                  │
│   THEMING                                                        │
│   ─────────────────────────────────────────────────────────     │
│   Semantic tokens enable effortless theme switching.            │
│   One class on <html> changes everything.                       │
│                                                                  │
│   DOCUMENTATION                                                  │
│   ─────────────────────────────────────────────────────────     │
│   Stories ARE documentation. If it works in Storybook,          │
│   it's documented.                                              │
│                                                                  │
│   ARCHITECTURE                                                   │
│   ─────────────────────────────────────────────────────────     │
│   Monorepos enable instant updates. workspace:* dependencies    │
│   link packages without publishing.                             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Three Things to Demonstrate

Your capstone should prove you can:

1. **Architect a feature using the 5-layer model** — Tokens → Primitives → Patterns → App Components → Pages. Each layer has its place.

2. **Build accessible, theme-aware components** — Keyboard navigation, ARIA attributes, focus states, and colors that respond to theme changes.

3. **Document as you build** — Storybook stories for new components, showing variants and states. Living documentation.

### The Capstone Mindset

This isn't just about building a feature. It's about demonstrating:

```
"I understand how design systems work, and I can build
features that leverage the system correctly."
```

When you finish:
- Anyone can see your components in Storybook
- The theme toggle proves your tokenization works
- The code structure shows you understand architecture
- The feature works end-to-end

---

## Looking Ahead

### During the Lab

- Start with UI components (Modal, Select)
- Write stories as you build
- Test theming early and often
- Build up to the full feature

### After the Course

- Explore Cal.com and Supabase codebases
- Apply these patterns to your own projects
- Consider contributing to open-source design systems
- Keep the 5-layer model in mind for future work

---

## Discussion Questions for Class

1. You're building the Modal component. Should it handle form submission, or should that be the parent's job?

2. The TeamMemberRow needs to show "Pending" for invited members. Where does this logic belong—in the Badge variant or in the app component?

3. What happens if you skip writing Storybook stories? How does that affect future developers?

4. A teammate wants to add a "dark mode only" feature that changes component behavior (not just colors). Is this a good idea? Why or why not?

---

## Common Pitfalls to Avoid

### Pitfall 1: Business Logic in UI Components

```tsx
// BAD: Modal knows about team members
function Modal({ member }: { member: TeamMember }) {
  const canDelete = member.role !== "owner";  // Business logic!
}

// GOOD: Modal is generic
function Modal({ open, onClose, children }) { ... }
```

### Pitfall 2: Hardcoded Colors

```tsx
// BAD: Hardcoded color
<div className="bg-gray-900 text-white">

// GOOD: Theme token
<div className="bg-[var(--color-bg)] text-[var(--color-text)]">
```

### Pitfall 3: Skipping Stories

```tsx
// BAD: No stories, no documentation
// Modal.tsx exists but Modal.stories.tsx doesn't

// GOOD: Story for every component
export const Default: Story = {};
export const WithForm: Story = { ... };
```

### Pitfall 4: Monolithic App Components

```tsx
// BAD: One giant component does everything
function TeamPage() {
  // 500 lines of filtering, forms, lists, modals...
}

// GOOD: Composed from smaller pieces
function TeamPage() {
  return <TeamMemberList members={data} onInvite={...} />;
}
```

---

## Additional Resources

- **Example:** [Cal.com Team Settings](https://github.com/calcom/cal.com/tree/main/apps/web/components/team)
- **Example:** [Supabase Organization Members](https://github.com/supabase/supabase/tree/master/apps/studio/components/interfaces/Organization)
- **Accessibility:** [WAI-ARIA Modal Dialog Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/)

---

## Congratulations!

You've reached the capstone. This is where everything comes together.

Build with intention. Every color should be a token. Every component should have a layer. Every feature should be documented.

Good luck!
