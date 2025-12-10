# Lab 9.5: Final Review & Self-Check

## Objective

Complete the capstone project by reviewing all requirements, verifying theme support, and conducting a final self-assessment.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Labs 9.1-9.4
- All components built and integrated
- Team page working

## Setup

### Quick Setup

```bash
./setup.sh
```

This will display the final checklist and review criteria.

### Manual Setup

No files to create - this is a review and reflection lab.

## Exercises

### Exercise 1: Functional Requirements Check

Test each feature and check off:

**View & Display:**
- [ ] Members display with avatar, name, email
- [ ] Role badge shows for each member
- [ ] Pending status shows for invited members
- [ ] Owner cannot be removed

**Search & Filter:**
- [ ] Search filters by name
- [ ] Search filters by email
- [ ] "All" shows all members
- [ ] Role filters work correctly
- [ ] Empty state shows when no matches

**Invite Flow:**
- [ ] "Invite Member" button opens modal
- [ ] Email validation works
- [ ] Role selection works
- [ ] Submit shows loading state
- [ ] Modal closes on success
- [ ] Form resets after close

**Theme Support:**
- [ ] Theme toggle changes header
- [ ] Theme toggle changes background
- [ ] Theme toggle changes text colors
- [ ] Theme toggle changes borders
- [ ] Modal respects theme
- [ ] All inputs respect theme

### Exercise 2: Technical Requirements Check

**Component Architecture:**
- [ ] UI components in packages/ui/
- [ ] App components in apps/web/components/team/
- [ ] Page in apps/web/app/team/
- [ ] Types in apps/web/types/

**Tokenization:**
- [ ] No hardcoded colors (search for `#` in components)
- [ ] All colors use `var(--color-*)`
- [ ] Background uses `var(--color-bg)`
- [ ] Text uses `var(--color-text)`
- [ ] Borders use `var(--color-border)`

**Type Safety:**
- [ ] TeamMember interface defined
- [ ] TeamInvite interface defined
- [ ] Props interfaces for all components
- [ ] No `any` types

### Exercise 3: Storybook Review

Verify components have stories:

**UI Components (packages/ui/):**
- [ ] Modal.stories.tsx exists
- [ ] Select.stories.tsx exists
- [ ] Modal stories show default, form, confirmation variants
- [ ] Select stories show label, error, disabled states

**Run Storybook:**
```bash
cd packages/ui
npm run storybook
```

Verify:
- [ ] Theme toggle works in Storybook
- [ ] All variants display correctly
- [ ] Controls work for adjustable props

### Exercise 4: Code Quality Review

**Check each file for:**

```
packages/ui/src/components/Modal.tsx
├── Uses CSS variables ✓
├── Has accessibility attributes ✓
├── Handles escape key ✓
└── Locks body scroll ✓

packages/ui/src/components/Select.tsx
├── Uses CSS variables ✓
├── Has label support ✓
├── Has error state ✓
└── Uses forwardRef ✓

apps/web/components/team/TeamMemberRow.tsx
├── Uses UI primitives ✓
├── Contains business logic ✓
├── Handles owner case ✓
└── Uses CSS variables ✓

apps/web/components/team/InviteMemberModal.tsx
├── Validates email ✓
├── Shows loading state ✓
├── Resets form on close ✓
└── Uses CSS variables ✓

apps/web/components/team/TeamMemberList.tsx
├── Manages filter state ✓
├── Handles empty state ✓
├── Integrates sub-components ✓
└── Uses CSS variables ✓
```

### Exercise 5: Architecture Verification

Verify the 5-layer architecture:

```
┌─────────────────────────────────────────────────────────────────┐
│ LAYER 5: Pages                                                   │
│ └── app/team/page.tsx                                           │
│     ├── Data fetching/mocking                                   │
│     ├── Mutation callbacks                                      │
│     └── Layout composition                                      │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 4: App Components                                         │
│ └── components/team/                                            │
│     ├── TeamMemberList.tsx (orchestration)                     │
│     ├── TeamMemberRow.tsx (member display)                     │
│     └── InviteMemberModal.tsx (invite form)                    │
├─────────────────────────────────────────────────────────────────┤
│ LAYERS 2-3: UI Components                                       │
│ └── packages/ui/src/components/                                 │
│     ├── Modal.tsx + sub-components                             │
│     ├── Select.tsx                                              │
│     └── Button, Input, Card, Avatar, Badge (existing)          │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 1: Design Tokens                                          │
│ └── packages/tokens/ + theme.css                               │
│     └── --color-bg, --color-text, --color-border, etc.        │
└─────────────────────────────────────────────────────────────────┘
```

### Exercise 6: Final Self-Assessment

Rate yourself (1-5) on each criterion:

| Criterion | 1 | 2 | 3 | 4 | 5 |
|-----------|---|---|---|---|---|
| Feature completeness | | | | | |
| Component architecture | | | | | |
| Design token usage | | | | | |
| Theme support | | | | | |
| Code quality | | | | | |
| Documentation (stories) | | | | | |

**Evaluation Guide:**
- 5: Excellent - Exceeds all requirements
- 4: Good - Meets all requirements
- 3: Satisfactory - Meets most requirements
- 2: Needs improvement - Missing some requirements
- 1: Incomplete - Missing many requirements

### Exercise 7: Written Reflection

Answer these questions:

1. **What was the most challenging part of building this feature?**
   ```


   ```

2. **How did the 5-layer architecture help organize your code?**
   ```


   ```

3. **What would you do differently next time?**
   ```


   ```

4. **How would you extend this feature (e.g., real API, more roles)?**
   ```


   ```

## Key Concepts Summary

### The Design System in Action

Through this capstone, you demonstrated:

1. **Token-Based Styling**
   - All colors from CSS variables
   - Theme changes affect entire UI
   - Single source of truth

2. **Component Architecture**
   - UI primitives are generic
   - App components add business logic
   - Clear separation of concerns

3. **Composition Over Configuration**
   - Modal composed with Header, Body, Footer
   - TeamMemberList composed with Row and Modal
   - Flexible, maintainable structure

4. **Type-Driven Development**
   - Define types first
   - Build components to match
   - Type safety throughout

### What You've Learned

```
Chapter 1: The 5-layer mental model
    ↓
Chapter 2: Design tokens as foundation
    ↓
Chapter 3: Building primitive components
    ↓
Chapter 4: Monorepo architecture
    ↓
Chapter 5: App components with business logic
    ↓
Chapter 6: Theming with CSS variables
    ↓
Chapter 7: Documentation with Storybook
    ↓
Chapter 8: Cross-platform tokens
    ↓
Chapter 9: Everything together in a real feature
```

## Stretch Goals (Optional)

If you have extra time:

### 1. Add Confirmation Dialog
Build a ConfirmDeleteDialog component for member removal.

### 2. Add Loading Skeletons
Show skeleton loading states while data loads.

### 3. Add Sorting
Sort members by name, role, or join date.

### 4. Add Keyboard Navigation
Support arrow keys to navigate the member list.

### 5. Add Storybook Stories for App Components
Document TeamMemberRow and TeamMemberList in Storybook.

## Checklist

Final verification before completing the course:

- [ ] All functional requirements pass
- [ ] All technical requirements pass
- [ ] Storybook stories exist for new UI components
- [ ] Theme toggle works everywhere
- [ ] No hardcoded colors
- [ ] Code follows layer separation
- [ ] Self-assessment completed
- [ ] Written reflection completed

## Congratulations!

You've completed the Design System course! You now understand:

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

3. **Keep learning:**
   - Explore Radix UI for accessible primitives
   - Learn about design system versioning
   - Study component testing strategies

Good luck on your design system journey!
