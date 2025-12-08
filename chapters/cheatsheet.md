# Design Systems Cheat Sheet

A quick reference guide covering all major concepts from the course.

---

## The 5-Layer Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│  Layer 5: Pages/Views          /dashboard, /settings            │
├─────────────────────────────────────────────────────────────────┤
│  Layer 4: App Components       UserCard, ProductCard            │
├─────────────────────────────────────────────────────────────────┤
│  Layer 3: Pattern Components   AuthForm, DataTable, Modal       │
├─────────────────────────────────────────────────────────────────┤
│  Layer 2: Primitive Components Button, Input, Card, Badge       │
├─────────────────────────────────────────────────────────────────┤
│  Layer 1: Design Tokens        colors, spacing, typography      │
└─────────────────────────────────────────────────────────────────┘
```

### Quick Decision Guide

| Question | Answer |
|----------|--------|
| Could ANY app use this component? | → `packages/ui/` (Layers 2-3) |
| Does it know about User, Product, Order? | → `apps/web/components/` (Layer 4) |
| Is it a raw value (color, spacing)? | → `packages/tokens/` (Layer 1) |
| Is it a full page with routing? | → `apps/web/app/` (Layer 5) |

---

## Design Tokens

### Token Structure (JSON)

```json
{
  "color": {
    "primary": {
      "500": {
        "value": "#3B82F6",
        "type": "color",
        "comment": "Default primary"
      }
    }
  }
}
```

### Primitive vs Semantic Tokens

| Type | Purpose | Example |
|------|---------|---------|
| **Primitive** | Raw values (constant) | `--blue-500: #3B82F6` |
| **Semantic** | Meaning (changes per theme) | `--color-primary: var(--blue-500)` |

### Naming Conventions

```
Category → Property → Variant → State
color    → primary  → 500     → (none)
color    → primary  → hover   → (none)
spacing  → md       → (none)  → (none)
font     → size     → lg      → (none)
```

### Style Dictionary Config

```javascript
module.exports = {
  source: ["src/**/*.json"],
  platforms: {
    css: {
      transformGroup: "css",
      buildPath: "build/css/",
      files: [{ destination: "variables.css", format: "css/variables" }]
    }
  }
};
```

### Build Command

```bash
npx style-dictionary build
```

---

## Primitive Components

### The Variant Pattern (CVA)

```tsx
import { cva } from "class-variance-authority";

const buttonVariants = cva(
  // Base styles (always applied)
  "inline-flex items-center justify-center rounded-md font-medium",
  {
    variants: {
      variant: {
        primary: "bg-blue-600 text-white hover:bg-blue-700",
        secondary: "bg-gray-100 text-gray-900 hover:bg-gray-200",
        destructive: "bg-red-600 text-white hover:bg-red-700",
      },
      size: {
        sm: "h-8 px-3 text-sm",
        md: "h-10 px-4 text-base",
        lg: "h-12 px-6 text-lg",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  }
);
```

### The `cn` Utility

```typescript
import { clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

// Usage: cn("px-4", isActive && "bg-blue", className)
```

### Component Props Pattern

```tsx
interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,  // Native props
    VariantProps<typeof buttonVariants> {                 // Variant props
  loading?: boolean;                                       // Custom props
}
```

### Accessibility Checklist

| Feature | Implementation |
|---------|---------------|
| Label association | `<label htmlFor={id}>` |
| Error state | `aria-invalid="true"` |
| Description | `aria-describedby={errorId}` |
| Focus visible | `focus-visible:ring-2` |
| Disabled state | `disabled:opacity-50` |

---

## Monorepo Architecture

### Folder Structure

```
my-product/
├── packages/
│   ├── tokens/          # @myapp/tokens
│   ├── ui/              # @myapp/ui
│   └── config/          # @myapp/config
├── apps/
│   ├── web/             # Next.js app
│   └── docs/            # Storybook
├── package.json
├── pnpm-workspace.yaml
└── turbo.json
```

### pnpm-workspace.yaml

```yaml
packages:
  - 'packages/*'
  - 'apps/*'
```

### Workspace Dependencies

```json
{
  "dependencies": {
    "@myapp/ui": "workspace:*",
    "@myapp/tokens": "workspace:*"
  }
}
```

### turbo.json

```json
{
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

### Key Commands

| Command | Purpose |
|---------|---------|
| `pnpm install` | Install all dependencies |
| `pnpm dev` | Run all dev servers |
| `pnpm build` | Build all packages in order |
| `pnpm --filter @myapp/ui build` | Build specific package |

---

## App Components

### UI vs App Components

| UI Components (`packages/ui/`) | App Components (`apps/web/components/`) |
|-------------------------------|----------------------------------------|
| Generic, reusable | Product-specific |
| No business logic | Contains business logic |
| `<Button>`, `<Card>` | `<UserCard>`, `<ProductCard>` |
| No domain types | Knows User, Product, Order |

### App Component Anatomy

```tsx
// 1. Import UI components
import { Card, Avatar, Badge, Button } from "@myapp/ui";

// 2. Import business types
import type { User } from "@/types";

// 3. Business-contextual props
interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
}

// 4. Compose UI + business logic
export function UserCard({ user, onEdit }: UserCardProps) {
  const canEdit = user.role !== "admin";  // Business rule

  return (
    <Card>
      <Avatar src={user.avatarUrl} />
      <Badge>{user.role}</Badge>
      {canEdit && <Button onClick={() => onEdit(user)}>Edit</Button>}
    </Card>
  );
}
```

---

## Theming

### Theme Token Structure

```css
/* Primitives (constant) */
:root {
  --gray-50: #F9FAFB;
  --gray-900: #111827;
  --blue-500: #3B82F6;
}

/* Semantic - Light (default) */
:root {
  --color-bg: var(--white);
  --color-text: var(--gray-900);
  --color-primary: var(--blue-600);
}

/* Semantic - Dark */
.dark {
  --color-bg: var(--gray-950);
  --color-text: var(--gray-50);
  --color-primary: var(--blue-500);
}
```

### Using Theme Tokens

```tsx
// In components - ALWAYS use semantic tokens
<div className="bg-[var(--color-bg)] text-[var(--color-text)]">
<button className="bg-[var(--color-primary)]">
```

### Prevent Flash of Wrong Theme

```html
<head>
  <script>
    (function() {
      const theme = localStorage.getItem('theme');
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      if (theme === 'dark' || (!theme && prefersDark)) {
        document.documentElement.classList.add('dark');
      }
    })();
  </script>
</head>
```

### Theme Hook

```typescript
type Theme = "light" | "dark" | "system";

function useTheme() {
  const [theme, setTheme] = useState<Theme>("system");

  useEffect(() => {
    const root = document.documentElement;
    if (theme === "dark") {
      root.classList.add("dark");
      localStorage.setItem("theme", "dark");
    } else if (theme === "light") {
      root.classList.remove("dark");
      localStorage.setItem("theme", "light");
    } else {
      localStorage.removeItem("theme");
      // Follow system preference
    }
  }, [theme]);

  return { theme, setTheme };
}
```

---

## Storybook

### Story Format (CSF 3)

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
      options: ["primary", "secondary", "destructive"],
    },
  },
  args: {
    children: "Button",
  },
};
export default meta;

type Story = StoryObj<typeof Button>;

export const Primary: Story = {
  args: { variant: "primary" },
};

export const AllVariants: Story = {
  render: () => (
    <div className="flex gap-4">
      <Button variant="primary">Primary</Button>
      <Button variant="secondary">Secondary</Button>
    </div>
  ),
};
```

### Storybook Config (.storybook/main.ts)

```typescript
const config: StorybookConfig = {
  stories: [
    "../stories/**/*.stories.@(js|jsx|ts|tsx)",
    "../../../packages/ui/src/**/*.stories.@(js|jsx|ts|tsx)",
  ],
  addons: ["@storybook/addon-essentials"],
  framework: "@storybook/react-vite",
  docs: { autodocs: "tag" },
};
```

### Key Commands

| Command | Purpose |
|---------|---------|
| `pnpm storybook dev -p 6006` | Run Storybook |
| `pnpm storybook build` | Build static site |

---

## Cross-Platform Tokens

### Platform Output Comparison

| Platform | Format | Example |
|----------|--------|---------|
| Web (CSS) | Custom Properties | `--color-primary: #3B82F6;` |
| iOS (Swift) | UIColor | `UIColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1)` |
| Android (XML) | ARGB Hex | `<color name="primary">#FF3B82F6</color>` |
| React Native | JS String | `primary: '#3B82F6'` |

### Multi-Platform Config

```javascript
module.exports = {
  source: ["src/**/*.json"],
  platforms: {
    css: {
      transformGroup: "css",
      buildPath: "build/css/",
      files: [{ destination: "variables.css", format: "css/variables" }]
    },
    ios: {
      transformGroup: "ios-swift",
      buildPath: "build/ios/",
      files: [{
        destination: "Colors.swift",
        format: "ios-swift/enum.swift",
        filter: { type: "color" }
      }]
    },
    android: {
      transformGroup: "android",
      buildPath: "build/android/",
      files: [{
        destination: "colors.xml",
        format: "android/colors",
        filter: { type: "color" }
      }]
    }
  }
};
```

---

## Quick Reference: Common Patterns

### Component File Structure

```
packages/ui/src/components/
├── Button.tsx           # Component implementation
├── Button.stories.tsx   # Storybook stories
└── index.ts             # Barrel export
```

### Barrel Export Pattern

```tsx
// packages/ui/src/index.tsx
export { Button, type ButtonProps } from "./components/Button";
export { Input, type InputProps } from "./components/Input";
export { Card, CardHeader, CardContent } from "./components/Card";
```

### Import in App

```tsx
// apps/web/app/page.tsx
import { Button, Input, Card } from "@myapp/ui";
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Cannot find module '@myapp/ui'" | Run `pnpm install` from root |
| Theme not applying | Check `.dark` class on `<html>` |
| Styles not updating | Check Tailwind content paths include packages |
| Build order wrong | Verify `dependsOn: ["^build"]` in turbo.json |
| Component not in Storybook | Check stories path in .storybook/main.ts |

---

## Key Principles to Remember

1. **Tokens are the foundation** — Every color, spacing, and typography value should come from tokens.

2. **Primitives are generic** — UI components have no business logic and work for any app.

3. **App components compose primitives** — They add business context without reimplementing UI.

4. **Semantic tokens enable theming** — Components use `--color-bg`, not `--gray-900`.

5. **Stories are documentation** — If it works in Storybook, it's documented.

6. **Monorepos enable instant updates** — `workspace:*` links packages without publishing.

7. **Build bottom-up** — Tokens → Primitives → Patterns → App Components → Pages.

---

## Resources

- [Style Dictionary Docs](https://amzn.github.io/style-dictionary/)
- [CVA (class-variance-authority)](https://cva.style/)
- [Storybook Docs](https://storybook.js.org/docs)
- [Turborepo Docs](https://turbo.build/repo/docs)
- [Cal.com GitHub](https://github.com/calcom/cal.com)
- [Supabase GitHub](https://github.com/supabase/supabase)
