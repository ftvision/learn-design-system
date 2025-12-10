# Chapter 9 Study Plan: Capstone Project

## Overview

This capstone project integrates everything from Chapters 1-8. You'll build a complete Team Management feature that demonstrates mastery of design systems.

---

## Part 1: Theory (20 minutes)

### 1.1 The 5-Layer Architecture in Action

This capstone exercises every layer:

```
┌─────────────────────────────────────────────────────────────────┐
│ LAYER 5: Page (/team/page.tsx)                                  │
│ - Fetches/provides data                                         │
│ - Orchestrates app components                                   │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 4: App Components                                         │
│ - TeamMemberList (filtering, search)                           │
│ - TeamMemberRow (member display)                               │
│ - InviteMemberModal (invite form)                              │
├─────────────────────────────────────────────────────────────────┤
│ LAYERS 2-3: UI Components (packages/ui/)                        │
│ - Modal, Select (new)                                          │
│ - Button, Input, Card, Avatar, Badge (existing)               │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 1: Design Tokens                                          │
│ - --color-bg, --color-text, --color-border                     │
│ - Theme switching with CSS variables                           │
└─────────────────────────────────────────────────────────────────┘
```

### 1.2 The Key Separation

**UI Components** (packages/ui/):
- Generic, reusable patterns
- No business logic
- Example: `Modal` doesn't know about "team members"

**App Components** (apps/web/components/):
- Domain-specific
- Contains business logic
- Example: `InviteMemberModal` knows about roles, validation

### 1.3 Component Inventory

**UI Components to Build:**

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| Modal | Dialog overlay | Escape key, backdrop click, body scroll lock |
| Select | Dropdown | Label, error state, options array |

**App Components to Build:**

| Component | Purpose | Composes |
|-----------|---------|----------|
| TeamMemberRow | Single member display | Avatar, Badge, Select, Button |
| InviteMemberModal | Invite form | Modal, Input, Select, Button |
| TeamMemberList | List with filters | Input, Button, Card, TeamMemberRow |

### 1.4 Data Model

```typescript
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

## Part 2: Labs

### Lab 9.1: Planning & Data Model (~30 minutes)

**Objective:** Define TypeScript types and create mock data for the team management feature.

**Topics:**
- TypeScript interface design
- Mock data creation
- Component inventory planning

**Key Concepts:**
- Type-driven development
- Data modeling for UI
- Planning before building

[→ Go to Lab 9.1](./labs/lab9.1/README.md)

---

### Lab 9.2: Build Modal & Select (~45 minutes)

**Objective:** Build the Modal and Select UI primitives that will be used by app components.

**Topics:**
- Modal with accessibility (escape key, backdrop)
- Select with label and error states
- Compound component pattern

**Key Concepts:**
- UI primitives are generic
- CSS variable usage for theming
- Storybook documentation

[→ Go to Lab 9.2](./labs/lab9.2/README.md)

---

### Lab 9.3: Build App Components (~45 minutes)

**Objective:** Build TeamMemberRow and InviteMemberModal app components.

**Topics:**
- Composing UI primitives
- Business logic in components
- Form validation patterns

**Key Concepts:**
- App components know about domain
- Separation of UI and business logic
- Form state management

[→ Go to Lab 9.3](./labs/lab9.3/README.md)

---

### Lab 9.4: Build TeamMemberList & Page (~45 minutes)

**Objective:** Build the TeamMemberList component and integrate everything into the team page.

**Topics:**
- State management for filters
- Component composition
- Page-level orchestration

**Key Concepts:**
- Lifting state up
- Callback props pattern
- Empty state handling

[→ Go to Lab 9.4](./labs/lab9.4/README.md)

---

### Lab 9.5: Final Review & Self-Check (~30 minutes)

**Objective:** Review all requirements, verify theme support, and complete self-assessment.

**Topics:**
- Functional requirements verification
- Technical requirements check
- Architecture review

**Key Concepts:**
- Quality checklist
- Self-assessment
- Course reflection

[→ Go to Lab 9.5](./labs/lab9.5/README.md)

---

## Part 3: Self-Check & Reflection

### Files You Should Have

```
apps/web/
├── types/
│   └── team.ts
├── data/
│   └── mockTeamMembers.ts
├── components/team/
│   ├── index.ts
│   ├── TeamMemberRow.tsx
│   ├── InviteMemberModal.tsx
│   └── TeamMemberList.tsx
└── app/team/
    └── page.tsx

packages/ui/src/components/
├── Modal.tsx
├── Modal.stories.tsx
├── Select.tsx
└── Select.stories.tsx
```

### Self-Check

Before completing the course, verify:

- [ ] Team page displays all members
- [ ] Search filters by name and email
- [ ] Role filter buttons work
- [ ] Invite modal opens, validates, and submits
- [ ] Role dropdown changes member roles
- [ ] Remove button appears for non-owners
- [ ] Theme toggle changes all colors
- [ ] No hardcoded colors in components
- [ ] Storybook stories exist for Modal and Select

### Written Reflection

1. **What was the most challenging part of the capstone?**
   ```


   ```

2. **How did the 5-layer architecture help organize your code?**
   ```


   ```

3. **What would you do differently in a real project?**
   ```


   ```

---

## Extension Exercises

### Exercise 9.1: Add Confirmation Dialog

Create a ConfirmDeleteDialog that appears before removing a member.

### Exercise 9.2: Add Loading Skeletons

Show skeleton placeholders while the member list loads.

### Exercise 9.3: Add Sorting

Allow sorting members by name, role, or join date.

### Exercise 9.4: Add Pagination

Support pagination for large team lists.

### Exercise 9.5: Add Keyboard Navigation

Support arrow keys to navigate the member list.

---

## Congratulations!

You've completed the Design System course. You now understand:

- ✅ The 5-layer architecture of design systems
- ✅ How to create and use design tokens
- ✅ Building accessible primitive components
- ✅ Monorepo architecture with Turborepo
- ✅ Separating UI from app components
- ✅ Implementing themes with CSS variables
- ✅ Documenting with Storybook
- ✅ Cross-platform token generation
- ✅ Integrating everything into a real feature

### Next Steps

1. **Explore real-world examples:**
   - [Cal.com](https://github.com/calcom/cal.com)
   - [Supabase](https://github.com/supabase/supabase)

2. **Apply to your own projects:**
   - Start with tokens
   - Build a primitive component library
   - Add theming support

Keep building and refer back to these patterns as you evolve your design system!
