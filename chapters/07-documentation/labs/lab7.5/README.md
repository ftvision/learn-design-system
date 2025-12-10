# Lab 7.5: Theme Toggle & Testing

## Objective

Add a theme toggle to Storybook's toolbar and verify all components work correctly in both themes.

## Time Estimate

~25 minutes

## Prerequisites

- Completed Labs 7.1-7.4 (all stories created)
- Theme CSS from Chapter 6

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that all story files exist
2. Update preview.ts with theme toolbar
3. Display verification checklist

### Manual Setup

Navigate to your docs app:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/apps/docs
```

## Exercises

### Exercise 1: Add Theme Toolbar

Update `.storybook/preview.ts` with a theme toggle:

```typescript
import type { Preview } from "@storybook/react";
import "@myapp/ui/styles";

const preview: Preview = {
  globalTypes: {
    theme: {
      description: "Theme for components",
      defaultValue: "light",
      toolbar: {
        title: "Theme",
        icon: "circlehollow",
        items: [
          { value: "light", icon: "sun", title: "Light" },
          { value: "dark", icon: "moon", title: "Dark" },
        ],
        dynamicTitle: true,
      },
    },
  },
  decorators: [
    (Story, context) => {
      const theme = context.globals.theme || "light";
      document.documentElement.classList.toggle("dark", theme === "dark");

      return (
        <div
          style={{
            padding: "1rem",
            backgroundColor: theme === "dark" ? "#030712" : "#ffffff",
            minHeight: "100vh",
          }}
        >
          <Story />
        </div>
      );
    },
  ],
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
  },
};

export default preview;
```

**Key additions:**
- `globalTypes.theme` - Adds theme selector to toolbar
- `toolbar.items` - Light and dark options with icons
- Decorator applies `.dark` class and background color

### Exercise 2: Understand Toolbar Configuration

```typescript
globalTypes: {
  theme: {
    description: "Theme for components",
    defaultValue: "light",
    toolbar: {
      title: "Theme",          // Tooltip text
      icon: "circlehollow",    // Storybook icon
      items: [
        { value: "light", icon: "sun", title: "Light" },
        { value: "dark", icon: "moon", title: "Dark" },
      ],
      dynamicTitle: true,      // Show selection in toolbar
    },
  },
},
```

**Available icons:** sun, moon, circlehollow, circle, photo, etc.

### Exercise 3: Test Each Component

Run Storybook and verify each component in both themes:

```bash
cd apps/docs
pnpm dev
```

**Button Checklist:**
- [ ] Primary variant readable in light mode
- [ ] Primary variant readable in dark mode
- [ ] Focus rings visible in both themes
- [ ] Disabled state distinguishable

**Input Checklist:**
- [ ] Background contrasts with page
- [ ] Placeholder text visible
- [ ] Error state clear in both themes
- [ ] Focus ring visible

**Card Checklist:**
- [ ] Border visible in both themes
- [ ] Shadow appropriate (lighter in dark mode)
- [ ] Title/description text readable

**Badge Checklist:**
- [ ] All variants distinguishable
- [ ] Success/warning/error meanings clear
- [ ] Text contrasts with background

**Avatar Checklist:**
- [ ] Images render correctly
- [ ] Fallback text readable
- [ ] Ring/border visible if styled

### Exercise 4: Verify Controls Panel

For each component, test:

1. **Controls respond** - Changing props updates component
2. **Args persist** - Switching stories keeps control values
3. **Reset works** - Reset button returns to defaults

### Exercise 5: Test Autodocs

Navigate to each component's "Docs" tab and verify:

- [ ] Props table shows all props
- [ ] Types are correct
- [ ] Descriptions appear (from argTypes)
- [ ] Default values shown
- [ ] All stories embedded in docs page

## Key Concepts

### Global Types vs Parameters

| Feature | Purpose | Scope |
|---------|---------|-------|
| **globalTypes** | Toolbar controls | All stories |
| **parameters** | Story configuration | Per-story or global |
| **args** | Component props | Per-story |

### Decorator Pattern

Decorators wrap stories with additional context:

```typescript
decorators: [
  (Story, context) => {
    // Setup before story renders
    const theme = context.globals.theme;
    document.documentElement.classList.toggle("dark", theme === "dark");

    // Return wrapped story
    return (
      <div className="wrapper">
        <Story />
      </div>
    );
  },
],
```

**Common uses:**
- Theming (adding `.dark` class)
- Padding/layout
- Context providers (Redux, Theme, etc.)
- Mock data providers

### Theme Testing Strategy

```
For each component:
1. View in light mode → Check visual correctness
2. Switch to dark mode → Check colors adapt
3. Test interactions → Focus, hover, active
4. Check edge cases → Long text, missing props
```

## Checklist

Before completing Chapter 7:

- [ ] Theme toggle appears in Storybook toolbar
- [ ] Clicking theme toggle switches all components
- [ ] Button variants work in both themes
- [ ] Input states visible in both themes
- [ ] Card borders/shadows work in both themes
- [ ] Badge variants distinguishable in both themes
- [ ] Avatar displays correctly in both themes
- [ ] Autodocs generate for all components
- [ ] Controls panel works for all components

## Troubleshooting

### Theme toggle not appearing

1. Restart Storybook after editing preview.ts
2. Check `globalTypes` syntax
3. Verify toolbar items have values

### Dark mode not applying

1. Check that decorator adds `.dark` to `document.documentElement`
2. Verify theme CSS is imported
3. Check browser console for errors

### Background color not changing

1. Ensure decorator sets `backgroundColor` style
2. Check that `context.globals.theme` is reading correctly

### Stories look broken after theme change

1. Components may need to use theme tokens
2. Check for hardcoded colors (should use `var(--color-*)`)
3. Verify Chapter 6 was completed

### Autodocs not generating

1. Verify `tags: ["autodocs"]` in component meta
2. Check `docs: { autodocs: "tag" }` in main.ts
3. Component needs TypeScript types for props table

## Written Reflection

1. **What are the benefits of documenting components with Storybook?**
   ```


   ```

2. **How do decorators help with theming in Storybook?**
   ```


   ```

3. **What would you add to improve your component documentation?**
   ```


   ```

## Extension Exercises

### Extension 1: Add MDX Documentation

Create rich documentation pages:

```mdx
import { Meta, Canvas } from "@storybook/blocks";
import * as ButtonStories from "./Button.stories";

<Meta of={ButtonStories} />

# Button

Buttons trigger actions when clicked.

## Usage

<Canvas of={ButtonStories.Primary} />
```

### Extension 2: Add Interaction Tests

Test component interactions:

```tsx
import { userEvent, within } from "@storybook/test";

export const ClickTest: Story = {
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    const button = canvas.getByRole("button");
    await userEvent.click(button);
  },
};
```

### Extension 3: Add Accessibility Checks

Install accessibility addon:

```bash
pnpm add -D @storybook/addon-a11y
```

Add to `.storybook/main.ts`:

```typescript
addons: [
  "@storybook/addon-a11y",
  // ... other addons
],
```

## Next Chapter

In Chapter 8, you'll learn about testing components with unit tests and visual regression testing.
