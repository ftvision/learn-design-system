# Chapter 7 Study Plan: Documentation with Storybook

## Part 1: Theory (15 minutes)

### 1.1 The Story Format

Stories in Storybook 7+ use the Component Story Format (CSF) 3:

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

---

## Part 2: Lab - Set Up Storybook (30 minutes)

### Lab 7.1: Create Storybook App

```bash
cd apps
mkdir docs
cd docs
npx storybook@latest init --type react --builder vite
```

When prompted:
- Framework: React
- Builder: Vite
- Add ESLint plugin: Yes

### Lab 7.2: Update package.json

Update `apps/docs/package.json`:

```json
{
  "name": "@myapp/docs",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "dev": "storybook dev -p 6006",
    "build": "storybook build",
    "preview": "npx http-server storybook-static"
  },
  "dependencies": {
    "@myapp/ui": "workspace:*",
    "@myapp/tokens": "workspace:*",
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "devDependencies": {
    "@storybook/addon-essentials": "^8.0.0",
    "@storybook/addon-interactions": "^8.0.0",
    "@storybook/addon-links": "^8.0.0",
    "@storybook/blocks": "^8.0.0",
    "@storybook/react": "^8.0.0",
    "@storybook/react-vite": "^8.0.0",
    "@storybook/test": "^8.0.0",
    "storybook": "^8.0.0",
    "vite": "^5.0.0"
  }
}
```

### Lab 7.3: Configure Storybook

Update `.storybook/main.ts`:

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

### Lab 7.4: Configure Preview

Update `.storybook/preview.ts`:

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
        { name: "gray", value: "#f3f4f6" },
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

---

## Part 3: Lab - Write Button Stories (30 minutes)

### Lab 7.5: Create Button Stories

Create `packages/ui/src/components/Button.stories.tsx`:

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Button } from "./Button";

const meta: Meta<typeof Button> = {
  title: "Components/Button",
  component: Button,
  tags: ["autodocs"],
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
  args: {
    children: "Button",
    variant: "primary",
    size: "md",
    loading: false,
    disabled: false,
  },
};

export default meta;
type Story = StoryObj<typeof Button>;

// Individual variant stories
export const Primary: Story = {
  args: {
    variant: "primary",
    children: "Primary Button",
  },
};

export const Secondary: Story = {
  args: {
    variant: "secondary",
    children: "Secondary Button",
  },
};

export const Destructive: Story = {
  args: {
    variant: "destructive",
    children: "Delete Item",
  },
};

export const Outline: Story = {
  args: {
    variant: "outline",
    children: "Outline Button",
  },
};

export const Ghost: Story = {
  args: {
    variant: "ghost",
    children: "Ghost Button",
  },
};

export const Link: Story = {
  args: {
    variant: "link",
    children: "Link Button",
  },
};

// Size stories
export const Small: Story = {
  args: {
    size: "sm",
    children: "Small",
  },
};

export const Large: Story = {
  args: {
    size: "lg",
    children: "Large Button",
  },
};

// State stories
export const Loading: Story = {
  args: {
    loading: true,
    children: "Saving...",
  },
};

export const Disabled: Story = {
  args: {
    disabled: true,
    children: "Disabled",
  },
};

// Showcase story
export const AllVariants: Story = {
  render: () => (
    <div className="flex flex-wrap gap-4">
      <Button variant="primary">Primary</Button>
      <Button variant="secondary">Secondary</Button>
      <Button variant="destructive">Destructive</Button>
      <Button variant="outline">Outline</Button>
      <Button variant="ghost">Ghost</Button>
      <Button variant="link">Link</Button>
    </div>
  ),
};

export const AllSizes: Story = {
  render: () => (
    <div className="flex items-center gap-4">
      <Button size="sm">Small</Button>
      <Button size="md">Medium</Button>
      <Button size="lg">Large</Button>
    </div>
  ),
};
```

---

## Part 4: Lab - Write Input Stories (20 minutes)

### Lab 7.6: Create Input Stories

Create `packages/ui/src/components/Input.stories.tsx`:

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Input } from "./Input";

const meta: Meta<typeof Input> = {
  title: "Components/Input",
  component: Input,
  tags: ["autodocs"],
  argTypes: {
    label: {
      control: "text",
      description: "Label text above the input",
    },
    placeholder: {
      control: "text",
    },
    error: {
      control: "text",
      description: "Error message to display",
    },
    hint: {
      control: "text",
      description: "Hint text below the input",
    },
    disabled: {
      control: "boolean",
    },
    type: {
      control: "select",
      options: ["text", "email", "password", "number", "tel", "url"],
    },
  },
  args: {
    placeholder: "Enter text...",
  },
};

export default meta;
type Story = StoryObj<typeof Input>;

export const Default: Story = {};

export const WithLabel: Story = {
  args: {
    label: "Email Address",
    placeholder: "you@example.com",
    type: "email",
  },
};

export const WithHint: Story = {
  args: {
    label: "Password",
    type: "password",
    hint: "Must be at least 8 characters",
  },
};

export const WithError: Story = {
  args: {
    label: "Email",
    type: "email",
    value: "invalid-email",
    error: "Please enter a valid email address",
  },
};

export const Disabled: Story = {
  args: {
    label: "Disabled Input",
    value: "Cannot edit this",
    disabled: true,
  },
};

// Form example
export const FormExample: Story = {
  render: () => (
    <form className="space-y-4 max-w-md">
      <Input label="Full Name" placeholder="John Doe" />
      <Input label="Email" type="email" placeholder="john@example.com" />
      <Input
        label="Password"
        type="password"
        hint="Must be at least 8 characters"
      />
      <Input
        label="Confirm Password"
        type="password"
        error="Passwords do not match"
      />
    </form>
  ),
};
```

---

## Part 5: Lab - Write Card Stories (20 minutes)

### Lab 7.7: Create Card Stories

Create `packages/ui/src/components/Card.stories.tsx`:

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from "./Card";
import { Button } from "./Button";
import { Input } from "./Input";

const meta: Meta<typeof Card> = {
  title: "Components/Card",
  component: Card,
  tags: ["autodocs"],
  argTypes: {
    padding: {
      control: "select",
      options: ["none", "sm", "md", "lg"],
    },
    hoverable: {
      control: "boolean",
    },
  },
};

export default meta;
type Story = StoryObj<typeof Card>;

export const Simple: Story = {
  args: {
    children: (
      <p>This is a simple card with some content.</p>
    ),
  },
};

export const WithHeader: Story = {
  render: () => (
    <Card>
      <CardHeader>
        <CardTitle>Card Title</CardTitle>
        <CardDescription>
          This is a description of what this card is about.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <p>Main content goes here.</p>
      </CardContent>
    </Card>
  ),
};

export const WithFooter: Story = {
  render: () => (
    <Card>
      <CardHeader>
        <CardTitle>Confirm Action</CardTitle>
      </CardHeader>
      <CardContent>
        <p>Are you sure you want to proceed with this action?</p>
      </CardContent>
      <CardFooter className="justify-end">
        <Button variant="ghost">Cancel</Button>
        <Button>Confirm</Button>
      </CardFooter>
    </Card>
  ),
};

export const FormCard: Story = {
  render: () => (
    <Card className="max-w-md">
      <CardHeader>
        <CardTitle>Create Account</CardTitle>
        <CardDescription>
          Enter your details to create a new account.
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <Input label="Name" placeholder="John Doe" />
        <Input label="Email" type="email" placeholder="john@example.com" />
        <Input label="Password" type="password" />
      </CardContent>
      <CardFooter>
        <Button className="w-full">Create Account</Button>
      </CardFooter>
    </Card>
  ),
};

export const Hoverable: Story = {
  args: {
    hoverable: true,
    children: (
      <p>Hover over this card to see the effect.</p>
    ),
  },
};

export const NoPadding: Story = {
  args: {
    padding: "none",
    children: (
      <img
        src="https://picsum.photos/400/200"
        alt="Sample"
        className="w-full h-48 object-cover rounded-lg"
      />
    ),
  },
};
```

---

## Part 6: Lab - Write Badge and Avatar Stories (15 minutes)

### Lab 7.8: Create Badge Stories

Create `packages/ui/src/components/Badge.stories.tsx`:

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Badge } from "./Badge";

const meta: Meta<typeof Badge> = {
  title: "Components/Badge",
  component: Badge,
  tags: ["autodocs"],
  argTypes: {
    variant: {
      control: "select",
      options: ["default", "primary", "success", "warning", "error", "outline"],
    },
    children: {
      control: "text",
    },
  },
  args: {
    children: "Badge",
  },
};

export default meta;
type Story = StoryObj<typeof Badge>;

export const Default: Story = {};

export const Primary: Story = {
  args: { variant: "primary", children: "Primary" },
};

export const Success: Story = {
  args: { variant: "success", children: "Success" },
};

export const Warning: Story = {
  args: { variant: "warning", children: "Warning" },
};

export const Error: Story = {
  args: { variant: "error", children: "Error" },
};

export const AllVariants: Story = {
  render: () => (
    <div className="flex flex-wrap gap-2">
      <Badge variant="default">Default</Badge>
      <Badge variant="primary">Primary</Badge>
      <Badge variant="success">Success</Badge>
      <Badge variant="warning">Warning</Badge>
      <Badge variant="error">Error</Badge>
      <Badge variant="outline">Outline</Badge>
    </div>
  ),
};
```

### Lab 7.9: Create Avatar Stories

Create `packages/ui/src/components/Avatar.stories.tsx`:

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Avatar } from "./Avatar";

const meta: Meta<typeof Avatar> = {
  title: "Components/Avatar",
  component: Avatar,
  tags: ["autodocs"],
  argTypes: {
    size: {
      control: "select",
      options: ["xs", "sm", "md", "lg", "xl"],
    },
    src: {
      control: "text",
    },
    alt: {
      control: "text",
    },
    fallback: {
      control: "text",
    },
  },
};

export default meta;
type Story = StoryObj<typeof Avatar>;

export const WithImage: Story = {
  args: {
    src: "https://i.pravatar.cc/150?u=1",
    alt: "John Doe",
  },
};

export const WithFallback: Story = {
  args: {
    alt: "John Doe",
    fallback: "JD",
  },
};

export const WithBrokenImage: Story = {
  args: {
    src: "https://broken-image-url.com/404.jpg",
    alt: "Jane Smith",
  },
};

export const AllSizes: Story = {
  render: () => (
    <div className="flex items-center gap-4">
      <Avatar size="xs" src="https://i.pravatar.cc/150?u=1" alt="User" />
      <Avatar size="sm" src="https://i.pravatar.cc/150?u=2" alt="User" />
      <Avatar size="md" src="https://i.pravatar.cc/150?u=3" alt="User" />
      <Avatar size="lg" src="https://i.pravatar.cc/150?u=4" alt="User" />
      <Avatar size="xl" src="https://i.pravatar.cc/150?u=5" alt="User" />
    </div>
  ),
};
```

---

## Part 7: Lab - Run and Test Storybook (15 minutes)

### Lab 7.10: Run Storybook

```bash
cd apps/docs
pnpm install
pnpm dev
```

Open http://localhost:6006

### Lab 7.11: Verify Stories

Check that:
- [ ] All components appear in the sidebar
- [ ] Stories render correctly
- [ ] Controls panel shows all props
- [ ] Changing controls updates the component
- [ ] Autodocs generate API tables
- [ ] Background switching works for theme testing

---

## Part 8: Lab - Add Theme Toggle to Storybook (15 minutes)

### Lab 7.12: Add Theme Toolbar

Update `.storybook/preview.ts`:

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

Now you can toggle themes from the Storybook toolbar.

---

## Part 9: Reflection (15 minutes)

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

## Part 10: Self-Check

Before moving to Chapter 8, verify:

- [ ] Storybook runs without errors
- [ ] All UI components have stories
- [ ] Controls work for all components
- [ ] Theme toggle works in toolbar
- [ ] Stories are organized logically

---

## Files You Should Have

```
apps/docs/
├── .storybook/
│   ├── main.ts
│   └── preview.ts
├── stories/
│   └── (welcome stories)
└── package.json

packages/ui/src/components/
├── Button.stories.tsx
├── Input.stories.tsx
├── Card.stories.tsx
├── Badge.stories.tsx
└── Avatar.stories.tsx
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

\`\`\`tsx
import { Button } from "@myapp/ui";

<Button variant="primary">Click me</Button>
\`\`\`

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
import { userEvent, within } from "@storybook/test";

export const ClickTest: Story = {
  args: {
    children: "Click me",
    onClick: fn(),
  },
  play: async ({ canvasElement, args }) => {
    const canvas = within(canvasElement);
    const button = canvas.getByRole("button");
    await userEvent.click(button);
    expect(args.onClick).toHaveBeenCalled();
  },
};
```
