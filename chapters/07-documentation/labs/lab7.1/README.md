# Lab 7.1: Set Up Storybook

## Objective

Set up Storybook as a documentation and development tool for your UI component library.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Chapter 6 (theming)
- Completed Chapter 4 (monorepo with UI package)
- Node.js 18+ installed

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that the monorepo exists
2. Create the docs app directory
3. Set up Storybook configuration files
4. Install dependencies

### Manual Setup

Navigate to your monorepo:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1
```

## Exercises

### Exercise 1: Understand the Story Format

Stories in Storybook 8 use Component Story Format (CSF) 3:

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

// Each named export is a story
export const Primary: Story = {
  args: {
    children: "Click me",
    variant: "primary",
  },
};
```

**Key elements:**
- `Meta` - Component metadata (title, component, defaults)
- `Story` - A specific state of the component
- `args` - Props passed to the component
- `tags: ["autodocs"]` - Enables automatic documentation

### Exercise 2: Understand Key Concepts

| Concept | Purpose |
|---------|---------|
| **Meta** | Describes the component (title, component, default args) |
| **Story** | A specific state/variant of the component |
| **Args** | Props passed to the component in that story |
| **ArgTypes** | Define controls for props (select, boolean, etc.) |
| **Decorators** | Wrap stories (for providers, padding, themes) |
| **Tags** | Enable features like `autodocs` |

### Exercise 3: Examine the Project Structure

After setup, you'll have:

```
apps/docs/
├── .storybook/
│   ├── main.ts      # Storybook configuration
│   └── preview.ts   # Story decorators and parameters
├── stories/
│   └── Welcome.mdx  # Welcome page
└── package.json     # Dependencies
```

### Exercise 4: Examine main.ts Configuration

Open `apps/docs/.storybook/main.ts`:

```typescript
import type { StorybookConfig } from "@storybook/react-vite";

const config: StorybookConfig = {
  stories: [
    "../stories/**/*.mdx",
    "../stories/**/*.stories.@(js|jsx|mjs|ts|tsx)",
    // Include UI package stories
    "../../../packages/ui/src/**/*.stories.@(js|jsx|ts|tsx)",
  ],
  addons: [
    "@storybook/addon-links",
    "@storybook/addon-essentials",
    "@storybook/addon-interactions",
  ],
  framework: {
    name: "@storybook/react-vite",
    options: {},
  },
  docs: {
    autodocs: "tag",
  },
};

export default config;
```

**Key points:**
- `stories` - Glob patterns for finding story files
- Includes `packages/ui/src/**/*.stories.*` to load UI package stories
- `addons` - Storybook plugins for controls, actions, etc.
- `framework` - React with Vite builder
- `autodocs: "tag"` - Generate docs for components with `tags: ["autodocs"]`

### Exercise 5: Examine preview.ts Configuration

Open `apps/docs/.storybook/preview.ts`:

```typescript
import type { Preview } from "@storybook/react";
import "@myapp/ui/styles";  // Import theme CSS

const preview: Preview = {
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
    backgrounds: {
      default: "light",
      values: [
        { name: "light", value: "#ffffff" },
        { name: "dark", value: "#030712" },
      ],
    },
  },
  decorators: [
    (Story, context) => {
      // Apply dark class when dark background is selected
      const isDark = context.globals.backgrounds?.value === "#030712";
      document.documentElement.classList.toggle("dark", isDark);

      return (
        <div style={{ padding: "1rem" }}>
          <Story />
        </div>
      );
    },
  ],
};

export default preview;
```

**Key points:**
- Imports theme CSS so components are styled
- `parameters.backgrounds` - Adds background switcher
- `decorators` - Wraps all stories with padding and theme handling

## Key Concepts

### Why Storybook?

1. **Isolated development** - Build components without running full app
2. **Documentation** - Auto-generated docs from props
3. **Visual testing** - See all component states at once
4. **Design review** - Share with designers for feedback
5. **Accessibility testing** - Built-in a11y addon

### Story Organization

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

The `title` in Meta determines the sidebar location:
- `title: "Components/Button"` → Components → Button
- `title: "Forms/Input"` → Forms → Input

### Vite vs Webpack

Storybook supports both builders:
- **Vite** (recommended) - Faster, modern, works well with monorepos
- **Webpack** - More plugins available, legacy support

We use Vite for faster startup and HMR.

## Checklist

Before proceeding to Lab 7.2:

- [ ] apps/docs directory created
- [ ] .storybook/main.ts configured
- [ ] .storybook/preview.ts configured with theme CSS
- [ ] package.json has correct dependencies
- [ ] Understand story format (Meta, Story, args)
- [ ] Understand main.ts configuration
- [ ] Understand preview.ts decorators

## Troubleshooting

### "Cannot find module '@myapp/ui'"

Run from monorepo root:
```bash
pnpm install
```

### Storybook won't start

Check Node.js version:
```bash
node --version  # Should be 18+
```

### Stories not appearing

1. Check `stories` glob patterns in main.ts
2. Verify story files have `.stories.tsx` extension
3. Check for TypeScript errors in story files

### Theme CSS not loading

1. Verify `@myapp/ui/styles` export exists in UI package.json
2. Check import in preview.ts

## Next

Proceed to Lab 7.2 to write Button stories.
