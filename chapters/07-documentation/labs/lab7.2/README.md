# Lab 7.2: Write Button Stories

## Objective

Create comprehensive Storybook stories for the Button component, covering all variants, sizes, and states.

## Time Estimate

~25 minutes

## Prerequisites

- Completed Lab 7.1 (Storybook setup)
- Button component exists in UI package

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that Lab 7.1 is complete
2. Create Button.stories.tsx in the UI package

### Manual Setup

Navigate to your UI package:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/packages/ui/src/components
```

## Exercises

### Exercise 1: Understand Story Structure

A complete story file has:

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Button } from "./Button";

// 1. Meta - Component metadata
const meta: Meta<typeof Button> = {
  title: "Components/Button",  // Sidebar location
  component: Button,           // Component to document
  tags: ["autodocs"],          // Enable auto-documentation
  argTypes: { /* controls */ },
  args: { /* defaults */ },
};
export default meta;

// 2. Type helper
type Story = StoryObj<typeof Button>;

// 3. Individual stories (named exports)
export const Primary: Story = {
  args: { variant: "primary", children: "Click me" },
};
```

### Exercise 2: Examine ArgTypes

ArgTypes define how props appear in the Controls panel:

```tsx
argTypes: {
  variant: {
    control: "select",
    options: ["primary", "secondary", "destructive", "outline", "ghost", "link"],
    description: "The visual style of the button",
  },
  size: {
    control: "select",
    options: ["sm", "md", "lg", "icon"],
    description: "The size of the button",
  },
  loading: {
    control: "boolean",
    description: "Shows a loading spinner",
  },
  disabled: {
    control: "boolean",
    description: "Disables the button",
  },
  children: {
    control: "text",
    description: "Button content",
  },
},
```

**Control types:**
- `select` - Dropdown menu
- `boolean` - Checkbox
- `text` - Text input
- `number` - Number input
- `color` - Color picker
- `object` - JSON editor

### Exercise 3: Examine Default Args

Default args apply to all stories unless overridden:

```tsx
args: {
  children: "Button",
  variant: "primary",
  size: "md",
  loading: false,
  disabled: false,
},
```

This means every story starts with these props, and individual stories only need to specify differences.

### Exercise 4: Study Individual Stories

Each named export is a story:

```tsx
// Simple story - just override args
export const Primary: Story = {
  args: {
    variant: "primary",
    children: "Primary Button",
  },
};

// Story with custom render
export const AllVariants: Story = {
  render: () => (
    <div className="flex flex-wrap gap-4">
      <Button variant="primary">Primary</Button>
      <Button variant="secondary">Secondary</Button>
      <Button variant="destructive">Destructive</Button>
    </div>
  ),
};
```

**When to use `render`:**
- Showing multiple components together
- Complex layouts
- Components that need wrapper elements
- Demonstrating composition

### Exercise 5: Run and Test

1. Start Storybook:
   ```bash
   cd apps/docs
   pnpm dev
   ```

2. Open http://localhost:6006

3. Navigate to Components → Button

4. Test the Controls panel:
   - Change variant dropdown
   - Toggle disabled
   - Edit children text
   - Watch component update live

## Key Concepts

### Story Categories

Organize stories by what they demonstrate:

| Category | Examples | Purpose |
|----------|----------|---------|
| **Variants** | Primary, Secondary, Ghost | Visual styles |
| **Sizes** | Small, Medium, Large | Size options |
| **States** | Loading, Disabled | Interactive states |
| **Showcase** | AllVariants, AllSizes | Overview displays |

### Story Naming

Story names become:
- Sidebar entries: `export const Primary` → "Primary" in sidebar
- URLs: `?path=/story/components-button--primary`

Use PascalCase for story names, descriptive but concise.

### Args vs Render

**Use `args` when:**
- Simple prop changes
- Want Controls panel to work
- Single component display

**Use `render` when:**
- Multiple components
- Custom layouts
- Wrapper elements needed
- Args don't apply directly

### Autodocs

The `tags: ["autodocs"]` enables automatic documentation:
- Props table from TypeScript types
- All stories displayed together
- Description from JSDoc comments

## Checklist

Before proceeding to Lab 7.3:

- [ ] Button.stories.tsx created
- [ ] All variants have stories (primary, secondary, etc.)
- [ ] Size stories created
- [ ] State stories created (loading, disabled)
- [ ] Showcase stories work (AllVariants, AllSizes)
- [ ] Controls panel works for all props
- [ ] Stories appear in Storybook sidebar

## Troubleshooting

### Stories not appearing

1. Check file extension is `.stories.tsx`
2. Verify `main.ts` includes the path
3. Restart Storybook

### Controls not showing

1. Verify `argTypes` are defined
2. Check prop names match component props
3. Ensure component has TypeScript types

### "Cannot find module" errors

Run from monorepo root:
```bash
pnpm install
```

### Render function not working

Ensure you're returning JSX:
```tsx
render: () => (
  <div>Content</div>  // Correct
),
// NOT
render: () => {
  <div>Content</div>  // Wrong - missing return
},
```

## Next

Proceed to Lab 7.3 to write Input and Card stories.
