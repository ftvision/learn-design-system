# Lecture Notes: Documentation with Storybook (Part 1 - Theory)

**Duration:** 30-45 minutes
**Chapter:** 07 - Documentation with Storybook

---

## Lecture Outline

1. Opening Question
2. Why Documentation Matters
3. What is Storybook?
4. The Anatomy of a Story
5. The Component Story Format (CSF)
6. Autodocs and Interactive Controls
7. Key Takeaways

---

## 1. Opening Question (3 minutes)

> **Ask the class:** "You join a new team that has a design system with 50 components. How do you learn which components exist, what props they accept, and how to use them?"

**Expected answers:** Read the code, ask teammates, trial and error, hope there's documentation...

**Instructor note:** This question surfaces the documentation problem. Without proper docs, design systems become "code archaeology"—digging through implementations to understand usage.

**Follow-up:** "What if there was a visual catalog where you could see every component, interact with its props, and copy example code?"

---

## 2. Why Documentation Matters (7 minutes)

### The Documentation Problem

Design systems fail when people don't know how to use them:

```
Developer: "I need a button with a loading state"
            ↓
Without docs: Search codebase → Find Button.tsx → Read implementation
              → Guess at props → Trial and error → 30 minutes later...

With docs:    Open Storybook → Click "Button" → See "Loading" story
              → Copy code → Done in 2 minutes
```

### What Good Documentation Provides

| Need | Solution |
|------|----------|
| "What components exist?" | Sidebar navigation |
| "What does it look like?" | Visual preview |
| "What props does it accept?" | Auto-generated API table |
| "How do variants differ?" | Individual stories for each state |
| "Can I try different props?" | Interactive controls |
| "What's the recommended usage?" | Usage guidelines in MDX |

### Living Documentation

The key insight: **documentation that lives with code stays accurate**.

```
Traditional docs (README, Wiki):
  Code changes → Docs unchanged → Docs become lies

Storybook:
  Code changes → Stories use actual component → Docs always accurate
```

> **Key insight:** A story IS the documentation. If the story works, the code works. If the code changes, the story reflects it.

---

## 3. What is Storybook? (8 minutes)

### The Definition

> **Storybook** is an open-source tool for building and documenting UI components in isolation.

Think of it as a **visual component catalog** and **development workbench**.

### What Storybook Provides

```
┌─────────────────────────────────────────────────────────────────┐
│                         STORYBOOK UI                             │
├─────────────┬───────────────────────────────────────────────────┤
│             │                                                   │
│  SIDEBAR    │                  CANVAS                           │
│             │                                                   │
│  Components │   ┌─────────────────────────────────────────┐    │
│  ├─ Button  │   │                                         │    │
│  │  ├─ Primary    │         [ Primary Button ]            │    │
│  │  ├─ Secondary  │                                       │    │
│  │  └─ Loading    │         Your component renders here   │    │
│  ├─ Input   │   │                                         │    │
│  │  └─ ...  │   └─────────────────────────────────────────┘    │
│  └─ Card    │                                                   │
│             │   ┌─────────────────────────────────────────┐    │
│             │   │            CONTROLS PANEL               │    │
│             │   │                                         │    │
│             │   │  variant: [primary ▼]                   │    │
│             │   │  size:    [md ▼]                        │    │
│             │   │  loading: [ ] (checkbox)                │    │
│             │   │  disabled: [ ]                          │    │
│             │   │                                         │    │
│             │   └─────────────────────────────────────────┘    │
└─────────────┴───────────────────────────────────────────────────┘
```

### Key Features

| Feature | What It Does |
|---------|--------------|
| **Stories** | Show components in specific states |
| **Controls** | Let you modify props interactively |
| **Autodocs** | Generate API documentation from TypeScript |
| **Actions** | Log events like onClick, onChange |
| **Viewports** | Test responsive behavior |
| **Backgrounds** | Test with different background colors |
| **Theme Switching** | Toggle light/dark mode |

### Where Storybook Lives in a Monorepo

```
my-product/
├── packages/
│   └── ui/
│       └── src/components/
│           ├── Button.tsx           # Component
│           └── Button.stories.tsx   # Stories live WITH component
└── apps/
    └── docs/                        # Storybook app
        ├── .storybook/
        │   ├── main.ts             # Configuration
        │   └── preview.ts          # Global settings
        └── stories/
            └── Introduction.mdx    # Welcome page
```

> **Best practice:** Stories live next to components. When you update `Button.tsx`, `Button.stories.tsx` is right there to update too.

---

## 4. The Anatomy of a Story (10 minutes)

### What IS a Story?

> A **story** captures a specific state of a component with specific props.

One component has MANY stories:

```
Button Component
    │
    ├── Story: Primary      (variant="primary")
    ├── Story: Secondary    (variant="secondary")
    ├── Story: Loading      (loading=true)
    ├── Story: Disabled     (disabled=true)
    ├── Story: Small        (size="sm")
    └── Story: All Variants (shows all at once)
```

### Why Multiple Stories?

Each story answers a question:

| Story | Question It Answers |
|-------|---------------------|
| `Primary` | "What does the main button look like?" |
| `Secondary` | "What's the alternative style?" |
| `Loading` | "What happens during async operations?" |
| `Disabled` | "What does an inactive button look like?" |
| `AllVariants` | "How do all options compare side by side?" |

### Story Organization

Stories are organized hierarchically:

```
Sidebar Structure:

Components/              ← Category
├── Button/             ← Component
│   ├── Primary         ← Story
│   ├── Secondary
│   ├── Destructive
│   ├── Loading
│   └── All Sizes
├── Input/
│   ├── Default
│   ├── With Label
│   ├── With Error
│   └── Form Example
└── Card/
    ├── Simple
    ├── With Header
    └── Form Card
```

The `title` in meta controls this: `title: "Components/Button"`

---

## 5. The Component Story Format (CSF) (8 minutes)

### CSF 3: The Modern Standard

Storybook 7+ uses Component Story Format version 3:

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Button } from "./Button";

// 1. META: Describes the component
const meta: Meta<typeof Button> = {
  title: "Components/Button",    // Sidebar location
  component: Button,             // The actual component
  tags: ["autodocs"],            // Enable auto-documentation
  argTypes: {                    // Control definitions
    variant: {
      control: "select",
      options: ["primary", "secondary", "destructive"],
    },
  },
  args: {                        // Default props for all stories
    children: "Button",
  },
};
export default meta;

// 2. TYPE: For TypeScript inference
type Story = StoryObj<typeof Button>;

// 3. STORIES: Each export is a story
export const Primary: Story = {
  args: {
    variant: "primary",
    children: "Primary Button",
  },
};

export const Loading: Story = {
  args: {
    loading: true,
    children: "Saving...",
  },
};
```

### Breaking Down the Parts

#### Meta (Default Export)

```tsx
const meta: Meta<typeof Button> = {
  title: "Components/Button",  // Where it appears in sidebar
  component: Button,           // Links to actual component for autodocs
  tags: ["autodocs"],          // Enables automatic docs page
  argTypes: { /* ... */ },     // Define how controls work
  args: { /* ... */ },         // Default props for ALL stories
};
export default meta;
```

#### Stories (Named Exports)

```tsx
export const Primary: Story = {
  args: {
    variant: "primary",        // Override default args
  },
};

export const AllVariants: Story = {
  render: () => (              // Custom render for complex stories
    <div className="flex gap-4">
      <Button variant="primary">Primary</Button>
      <Button variant="secondary">Secondary</Button>
    </div>
  ),
};
```

### Args vs ArgTypes

| Concept | Purpose | Example |
|---------|---------|---------|
| **args** | Default prop VALUES | `args: { variant: "primary" }` |
| **argTypes** | Control CONFIGURATION | `argTypes: { variant: { control: "select" } }` |

```tsx
argTypes: {
  variant: {
    control: "select",                          // Dropdown control
    options: ["primary", "secondary"],          // Available options
    description: "The visual style",            // Shows in docs
  },
  loading: {
    control: "boolean",                         // Checkbox control
  },
  onClick: {
    action: "clicked",                          // Logs to Actions panel
  },
},
```

---

## 6. Autodocs and Interactive Controls (5 minutes)

### Autodocs: Documentation for Free

When you add `tags: ["autodocs"]`, Storybook generates:

```
┌─────────────────────────────────────────────────────────────────┐
│  Button                                                         │
│  ─────────────────────────────────────────────────              │
│                                                                 │
│  [Primary Button]           ← Canvas showing default story      │
│                                                                 │
│  ─────────────────────────────────────────────────              │
│                                                                 │
│  Props                                                          │
│  ─────────────────────────────────────────────────              │
│  Name      │ Description            │ Default  │ Control        │
│  ─────────────────────────────────────────────────              │
│  variant   │ Visual style of button │ primary  │ [select ▼]    │
│  size      │ Size of the button     │ md       │ [select ▼]    │
│  loading   │ Shows loading spinner  │ false    │ [checkbox]    │
│  disabled  │ Disables the button    │ false    │ [checkbox]    │
│  children  │ Button content         │ -        │ [text input]  │
│                                                                 │
│  ─────────────────────────────────────────────────              │
│                                                                 │
│  Stories                                                        │
│  [Primary] [Secondary] [Loading] [Disabled] [All Variants]     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

All generated from TypeScript types and story definitions!

### Interactive Controls

Controls let anyone—designers, PMs, developers—test components:

```
Change variant from "primary" to "secondary"
    → Component instantly re-renders with new style

Toggle "loading" checkbox
    → Spinner appears

Change "children" text
    → Button label updates in real-time
```

This is **design review in action**. Designers can verify implementations without touching code.

---

## 7. Key Takeaways (4 minutes)

### Summary Visual

```
┌─────────────────────────────────────────────────────────────────┐
│                    STORYBOOK ECOSYSTEM                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   COMPONENT              STORIES              STORYBOOK UI      │
│                                                                 │
│   Button.tsx    →    Button.stories.tsx    →    Visual Catalog  │
│                                                                 │
│   - Implementation     - Primary story         - Sidebar nav    │
│   - Props interface    - Secondary story       - Canvas preview │
│   - Business logic     - Loading story         - Controls panel │
│                        - All Variants          - Autodocs       │
│                                                                 │
│   ↑                                                             │
│   │                                                             │
│   TypeScript types  ─────────────────────→  Auto-generated docs │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Three Things to Remember

1. **Stories are states, not tests** — Each story captures ONE specific configuration of a component. A Button has stories for Primary, Secondary, Loading, Disabled, etc.

2. **Stories live with components** — `Button.stories.tsx` sits next to `Button.tsx`. When the component changes, the stories are right there to update.

3. **Autodocs generate from TypeScript** — Your prop types become API documentation. Better types = better docs with zero extra effort.

### The Documentation Stack

```
┌─────────────────────────────────────────────────────────────────┐
│                    DOCUMENTATION LAYERS                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   MDX Pages (optional)                                          │
│   - Usage guidelines                                            │
│   - Best practices                                              │
│   - Do's and don'ts                                             │
│                                                                  │
│   ───────────────────────────────────────────                   │
│                                                                  │
│   Autodocs (automatic)                                          │
│   - Props table from TypeScript                                 │
│   - All stories displayed                                       │
│   - Controls for each prop                                      │
│                                                                  │
│   ───────────────────────────────────────────                   │
│                                                                  │
│   Stories (you write)                                           │
│   - Specific component states                                   │
│   - Edge cases and variations                                   │
│   - Composition examples                                        │
│                                                                  │
│   ───────────────────────────────────────────                   │
│                                                                  │
│   Component + TypeScript (foundation)                           │
│   - The actual implementation                                   │
│   - Props interface = source of truth                           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Looking Ahead

In the **lab section**, you'll:
- Set up Storybook as a docs app in your monorepo
- Configure it to find stories in your UI package
- Write comprehensive stories for Button, Input, Card, Badge, and Avatar
- Set up theme switching in the Storybook toolbar
- See autodocs generate API tables from your TypeScript types

In **Chapter 8**, we'll explore cross-platform token generation—creating iOS Swift and Android XML tokens from your single JSON source.

---

## Discussion Questions for Class

1. A designer says "the button looks wrong." How does Storybook help resolve this faster than looking at code?

2. Your team has 50 components but only 10 have stories. How would you prioritize which to document first?

3. A new developer joins and needs to use the Card component. Compare their experience with and without Storybook.

4. How would you handle documenting a component that requires context providers (like a theme or auth context)?

---

## Common Misconceptions

### "Stories are unit tests"

**Correction:** Stories are documentation, not tests. They show states, not assert behavior. (You CAN add interaction tests, but that's optional and separate.)

### "We need to write docs AND stories"

**Correction:** Stories ARE the docs. With autodocs, your TypeScript types generate the API table. Stories show usage. You rarely need separate documentation.

### "Storybook is just for designers"

**Correction:** Storybook serves everyone:
- Designers verify implementations
- Developers explore components
- PMs understand what's available
- QA tests edge cases visually

### "We'll add Storybook later"

**Correction:** Adding Storybook to existing components is hard. Start with it from day one. Write the story as you write the component.

---

## Storybook Best Practices

### Story Naming

```tsx
// GOOD: Clear, specific names
export const Primary: Story = {};
export const WithError: Story = {};
export const LoadingState: Story = {};
export const AllVariants: Story = {};

// BAD: Vague names
export const Default: Story = {};    // Default what?
export const Test: Story = {};       // Not descriptive
export const Example1: Story = {};   // Meaningless
```

### Story Organization

```tsx
// GOOD: Logical groupings
const meta: Meta<typeof Button> = {
  title: "Components/Button",  // Category/Component
};

// For large systems:
title: "Primitives/Button"     // Layer 2
title: "Patterns/AuthForm"     // Layer 3
title: "App/UserCard"          // Layer 4
```

### Default Args

```tsx
// GOOD: Set sensible defaults in meta
const meta: Meta<typeof Button> = {
  args: {
    children: "Button",        // Every story shows "Button" unless overridden
    variant: "primary",        // Most common variant as default
  },
};

// Stories only specify what's DIFFERENT
export const Secondary: Story = {
  args: { variant: "secondary" },  // Just the difference
};
```

---

## Additional Resources

- **Docs:** [Storybook Documentation](https://storybook.js.org/docs)
- **Tutorial:** [Storybook for React Tutorial](https://storybook.js.org/tutorials/intro-to-storybook/react/en/get-started/)
- **Addon:** [Storybook Addon Docs](https://storybook.js.org/docs/writing-docs/autodocs)
- **Example:** [Shopify Polaris Storybook](https://polaris.shopify.com/)
- **Example:** [GitHub Primer Storybook](https://primer.style/react/storybook)

---

## Preparation for Lab

Before the lab, ensure you have:
- [ ] Completed Chapters 1-6 (working themed components)
- [ ] Node.js and pnpm installed
- [ ] Basic familiarity with TypeScript interfaces
- [ ] Understanding of how your UI components work
