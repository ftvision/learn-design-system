# Chapter 7 Study Plan: Documentation with Storybook

## Part 1: Theory (15 minutes)

### 1.1 The Story Format

Stories in Storybook 8 use the Component Story Format (CSF) 3:

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Button } from "./Button";

// Meta describes the component
const meta: Meta<typeof Button> = {
  title: "Components/Button",
  component: Button,
  tags: ["autodocs"],
};
export default meta;

// Type for stories
type Story = StoryObj<typeof Button>;

// Each export is a story
export const Primary: Story = {
  args: {
    children: "Click me",
    variant: "primary",
  },
};
```

### 1.2 Key Concepts

| Concept | Purpose |
|---------|---------|
| **Meta** | Describes the component (title, component, args) |
| **Story** | A specific state of the component |
| **Args** | Props passed to the component |
| **ArgTypes** | Define controls for props |
| **Decorators** | Wrap stories (for providers, styling) |
| **Tags** | Enable features like autodocs |

### 1.3 Story Organization

```
Components/
├── Button/
│   ├── Primary
│   ├── Secondary
│   ├── Loading
│   └── All Sizes
├── Input/
│   ├── Default
│   ├── With Label
│   └── With Error
└── Card/
    ├── Simple
    └── With Actions
```

### 1.4 Why Storybook?

1. **Isolated development** - Build components without running full app
2. **Documentation** - Auto-generated docs from TypeScript props
3. **Visual testing** - See all component states at once
4. **Design review** - Share with designers for feedback
5. **Accessibility testing** - Built-in a11y addon available

---

## Part 2: Labs

### Lab 7.1: Set Up Storybook (~30 minutes)

**Objective:** Set up Storybook as a documentation tool for the UI component library.

**Topics:**
- Creating docs app with Storybook
- Configuring main.ts and preview.ts
- Importing theme CSS

**Key Concepts:**
- Story file patterns and discovery
- Decorator configuration
- Framework and builder setup

[→ Go to Lab 7.1](./labs/lab7.1/README.md)

---

### Lab 7.2: Write Button Stories (~25 minutes)

**Objective:** Create comprehensive stories for the Button component.

**Topics:**
- ArgTypes for controls
- Default args
- Variant and size stories
- Showcase stories with render function

**Key Concepts:**
- Story structure (meta, type, exports)
- Controls panel configuration
- When to use args vs render

[→ Go to Lab 7.2](./labs/lab7.2/README.md)

---

### Lab 7.3: Write Input & Card Stories (~30 minutes)

**Objective:** Create stories for Input and Card components.

**Topics:**
- Form component stories
- Compound component composition
- Cross-component stories

**Key Concepts:**
- Documenting validation states
- Showing compound components together
- Real-world usage examples

[→ Go to Lab 7.3](./labs/lab7.3/README.md)

---

### Lab 7.4: Write Badge & Avatar Stories (~20 minutes)

**Objective:** Create stories for Badge and Avatar components.

**Topics:**
- Status indicator variants
- Image and fallback handling
- Size showcases

**Key Concepts:**
- Testing edge cases (broken images)
- Visual component documentation
- Grouped displays

[→ Go to Lab 7.4](./labs/lab7.4/README.md)

---

### Lab 7.5: Theme Toggle & Testing (~25 minutes)

**Objective:** Add theme toggle and verify all components in both themes.

**Topics:**
- Global types for toolbar
- Theme decorator pattern
- Component verification

**Key Concepts:**
- Toolbar configuration
- Global decorators
- Theme testing strategy

[→ Go to Lab 7.5](./labs/lab7.5/README.md)

---

## Part 3: Self-Check & Reflection

### Files You Should Have

```
apps/docs/
├── .storybook/
│   ├── main.ts
│   └── preview.ts
├── stories/
│   └── Welcome.mdx
├── package.json
└── tsconfig.json

packages/ui/src/components/
├── Button.stories.tsx
├── Input.stories.tsx
├── Card.stories.tsx
├── Badge.stories.tsx
└── Avatar.stories.tsx
```

### Self-Check

Before moving to Chapter 8, verify:

- [ ] Storybook runs without errors
- [ ] All UI components have stories
- [ ] Controls work for all components
- [ ] Theme toggle works in toolbar
- [ ] Stories are organized logically
- [ ] Autodocs generate for components

### Written Reflection

1. **What are the benefits of documenting components with Storybook?**
   ```


   ```

2. **What's the difference between args and argTypes?**
   ```


   ```

3. **How do decorators help with theming in Storybook?**
   ```


   ```

---

## Extension Exercises

### Exercise 7.1: Add MDX Documentation

Create `packages/ui/src/components/Button.mdx`:

```mdx
import { Canvas, Meta, Story } from "@storybook/blocks";
import * as ButtonStories from "./Button.stories";

<Meta of={ButtonStories} />

# Button

Buttons trigger actions when clicked.

## Usage

```tsx
import { Button } from "@myapp/ui";

<Button variant="primary">Click me</Button>
```

## Variants

<Canvas of={ButtonStories.AllVariants} />

## Best Practices

- Use primary buttons for main actions
- Use secondary buttons for less important actions
- Use destructive buttons for dangerous actions
```

### Exercise 7.2: Add Interaction Tests

Add tests to verify interactions:

```tsx
import { userEvent, within, expect } from "@storybook/test";

export const ClickTest: Story = {
  args: {
    children: "Click me",
  },
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    const button = canvas.getByRole("button");
    await userEvent.click(button);
    // Add assertions
  },
};
```

### Exercise 7.3: Add Accessibility Addon

```bash
pnpm add -D @storybook/addon-a11y
```

Add to main.ts addons array to enable accessibility testing.

---

## Next Chapter

In Chapter 8, you'll learn about testing components with unit tests and visual regression testing.
