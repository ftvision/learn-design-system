# Design System Bootstrap Guide

This guide enables AI coding agents to scaffold a production-ready design system foundation. The agent creates the architecture and structure, then guides users to implement components specific to their application needs.

---

## Philosophy: Scaffold, Don't Prescribe

**What AI Agents Should Do:**
- ✅ Create monorepo structure and configuration
- ✅ Set up build tools and workflows
- ✅ Establish token system foundation
- ✅ Create 1-2 example components demonstrating patterns
- ✅ Generate clear documentation for extending the system

**What AI Agents Should NOT Do:**
- ❌ Generate dozens of pre-built components
- ❌ Make design decisions (colors, spacing values)
- ❌ Create business logic or app-specific components
- ❌ Prescribe exact styling or variants

**Why:** Every app is different. The agent should create a foundation that makes it easy to add components as needed, not a bloated library of unused code.

---

## Quick Start for AI Agents

```
Initialize a design system monorepo foundation:

ARCHITECTURE: 5-layer design system (tokens → primitives → patterns → app components → pages)
TECH STACK: React + TypeScript + Tailwind CSS + Turborepo + pnpm
APPROACH: Scaffold structure, create example components, guide user to extend

Phases:
1. Monorepo scaffolding (structure + build configs)
2. Token system foundation (starter tokens + Style Dictionary pipeline)
3. UI package skeleton (with Button example showing CVA pattern)
4. Web app skeleton (demonstrating UI consumption)
5. Storybook setup (ready to document new components)
6. Developer guide (how to add components, tokens, apps)

Focus on extensible foundations, not comprehensive libraries.
```

---

## Phase 1: Monorepo Scaffolding

### Objective
Create the workspace structure and build orchestration.

### What to Create

**Directory Structure:**
```
design-system/
├── packages/
│   ├── tokens/          # Design tokens (JSON → CSS/JS)
│   ├── ui/              # Component library
│   └── config/          # Shared configs (TypeScript, Tailwind, ESLint)
├── apps/
│   ├── web/             # Example Next.js app
│   └── docs/            # Storybook documentation
├── .gitignore
├── package.json         # Root workspace config
├── pnpm-workspace.yaml  # Workspace packages
├── turbo.json           # Build orchestration
└── README.md            # Getting started guide
```

**Root Configuration Files:**

`package.json`:
```json
{
  "name": "design-system",
  "private": true,
  "packageManager": "pnpm@8.15.0",
  "scripts": {
    "dev": "turbo dev",
    "build": "turbo build",
    "lint": "turbo lint",
    "clean": "turbo clean && rm -rf node_modules"
  },
  "devDependencies": {
    "turbo": "^2.0.0",
    "prettier": "^3.0.0",
    "typescript": "^5.0.0"
  }
}
```

`pnpm-workspace.yaml`:
```yaml
packages:
  - 'packages/*'
  - 'apps/*'
```

`turbo.json`:
```json
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "build/**", "storybook-static/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "dependsOn": ["^lint"]
    }
  }
}
```

`.gitignore`:
```
node_modules/
dist/
build/
.next/
.turbo/
storybook-static/
*.log
.DS_Store
.env*.local
```

### Validation
- [ ] `pnpm install` completes successfully
- [ ] Directory structure matches specification
- [ ] All config files are valid JSON/YAML

---

## Phase 2: Design Tokens Foundation

### Objective
Set up Style Dictionary to transform design tokens from JSON to multiple formats.

### What to Create

**Package Structure:**
```
packages/tokens/
├── src/
│   ├── colors.json      # Color palette (user will customize)
│   ├── spacing.json     # Spacing scale (user will customize)
│   ├── typography.json  # Font settings (user will customize)
│   └── README.md        # Guide on adding/modifying tokens
├── build/               # Generated (gitignored)
├── package.json
└── style-dictionary.config.js
```

**Key Files:**

`package.json`:
```json
{
  "name": "@myapp/tokens",
  "version": "0.0.0",
  "private": true,
  "main": "build/js/tokens.js",
  "types": "build/js/tokens.d.ts",
  "scripts": {
    "build": "style-dictionary build",
    "clean": "rm -rf build"
  },
  "devDependencies": {
    "style-dictionary": "^4.0.0"
  }
}
```

`style-dictionary.config.js`:
```javascript
module.exports = {
  source: ['src/**/*.json'],
  platforms: {
    css: {
      transformGroup: 'css',
      buildPath: 'build/css/',
      files: [{
        destination: 'variables.css',
        format: 'css/variables'
      }]
    },
    js: {
      transformGroup: 'js',
      buildPath: 'build/js/',
      files: [
        { destination: 'tokens.js', format: 'javascript/es6' },
        { destination: 'tokens.d.ts', format: 'typescript/es6-declarations' }
      ]
    }
  }
};
```

**Starter Token Files (Minimal):**

`src/colors.json` - Provide basic grayscale:
```json
{
  "color": {
    "gray": {
      "50": { "value": "#F9FAFB" },
      "100": { "value": "#F3F4F6" },
      "500": { "value": "#6B7280" },
      "900": { "value": "#111827" }
    }
  }
}
```

`src/spacing.json` - Basic scale:
```json
{
  "spacing": {
    "1": { "value": "0.25rem" },
    "2": { "value": "0.5rem" },
    "4": { "value": "1rem" },
    "8": { "value": "2rem" }
  }
}
```

`src/typography.json` - System fonts:
```json
{
  "font": {
    "family": {
      "sans": { "value": "system-ui, sans-serif" }
    },
    "size": {
      "sm": { "value": "0.875rem" },
      "base": { "value": "1rem" },
      "lg": { "value": "1.125rem" }
    }
  }
}
```

**src/README.md** - Guide users:
```markdown
# Design Tokens

## Adding New Tokens

1. Edit JSON files in `src/`
2. Run `pnpm build` to regenerate outputs
3. Tokens are available as CSS variables and JS exports

## Examples

### Adding a Color
```json
{
  "color": {
    "brand": {
      "primary": { "value": "#3B82F6" }
    }
  }
}
```

Generates:
- CSS: `--color-brand-primary: #3B82F6;`
- JS: `export const colorBrandPrimary = '#3B82F6';`

### Adding Spacing
Use rem units for responsive sizing.

### Platform Extensions
To add iOS/Android outputs, extend `style-dictionary.config.js` platforms.
```

### Validation
- [ ] `pnpm --filter @myapp/tokens build` succeeds
- [ ] Generates `build/css/variables.css` with CSS variables
- [ ] Generates `build/js/tokens.js` with JS exports

---

## Phase 3: Shared Config Package

### Objective
Create reusable TypeScript and Tailwind configurations.

### What to Create

```
packages/config/
├── tsconfig/
│   ├── base.json
│   ├── react.json
│   └── nextjs.json
├── tailwind.config.js
├── package.json
└── README.md
```

**Key Configs:**

`tsconfig/base.json` - Foundation:
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  }
}
```

`tsconfig/react.json` - Extends base:
```json
{
  "extends": "./base.json",
  "compilerOptions": {
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "jsx": "react-jsx"
  }
}
```

`tailwind.config.js` - Base configuration (users extend):
```javascript
module.exports = {
  theme: {
    extend: {
      // Users will extend with their token values
    }
  }
};
```

### Validation
- [ ] Config files are valid JSON
- [ ] No build step needed (pure config)

---

## Phase 4: UI Package Skeleton

### Objective
Create component library structure with ONE example component showing the pattern.

### What to Create

```
packages/ui/
├── src/
│   ├── components/
│   │   └── Button.tsx       # Example component
│   ├── lib/
│   │   └── utils.ts         # cn() utility
│   └── index.tsx            # Exports
├── package.json
├── tsconfig.json
├── tailwind.config.js
└── README.md                # Guide on adding components
```

**package.json** - Dependencies:
```json
{
  "name": "@myapp/ui",
  "version": "0.0.0",
  "private": true,
  "main": "src/index.tsx",
  "dependencies": {
    "@myapp/tokens": "workspace:*",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0"
  },
  "devDependencies": {
    "@myapp/config": "workspace:*",
    "@types/react": "^18.2.0",
    "react": "^18.2.0",
    "tailwindcss": "^3.4.0",
    "typescript": "^5.0.0"
  },
  "peerDependencies": {
    "react": "^18.2.0"
  }
}
```

**src/lib/utils.ts** - Essential utility:
```typescript
import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

**src/components/Button.tsx** - Example showing CVA pattern:
```typescript
import * as React from 'react';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '../lib/utils';

const buttonVariants = cva(
  'inline-flex items-center justify-center rounded-md font-medium transition-colors',
  {
    variants: {
      variant: {
        primary: 'bg-gray-900 text-white hover:bg-gray-800',
        secondary: 'bg-gray-100 text-gray-900 hover:bg-gray-200'
      },
      size: {
        sm: 'h-8 px-3 text-sm',
        md: 'h-10 px-4'
      }
    },
    defaultVariants: {
      variant: 'primary',
      size: 'md'
    }
  }
);

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, ...props }, ref) => {
    return (
      <button
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    );
  }
);
Button.displayName = 'Button';
```

**src/index.tsx**:
```typescript
export { Button, type ButtonProps } from './components/Button';
export { cn } from './lib/utils';
```

**README.md** - Component development guide:
```markdown
# UI Components

## Architecture

This package contains **primitive components** (Layer 2) - reusable UI building blocks with no business logic.

## Adding a New Component

### 1. Create Component File
Create `src/components/YourComponent.tsx`:

```typescript
import * as React from 'react';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '../lib/utils';

const yourComponentVariants = cva(
  'base-classes-always-applied',
  {
    variants: {
      variant: {
        default: 'variant-specific-classes',
        // Add more variants
      },
      size: {
        sm: 'size-specific-classes',
        md: 'size-specific-classes'
      }
    },
    defaultVariants: {
      variant: 'default',
      size: 'md'
    }
  }
);

export interface YourComponentProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof yourComponentVariants> {}

export const YourComponent = React.forwardRef<HTMLDivElement, YourComponentProps>(
  ({ className, variant, size, ...props }, ref) => {
    return (
      <div
        className={cn(yourComponentVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    );
  }
);
YourComponent.displayName = 'YourComponent';
```

### 2. Export from Index
Add to `src/index.tsx`:
```typescript
export { YourComponent, type YourComponentProps } from './components/YourComponent';
```

### 3. Create Story
Add `stories/YourComponent.stories.tsx` in docs app.

## Component Patterns

### Using forwardRef
All interactive components should use `React.forwardRef` for ref forwarding.

### Using CVA (Class Variance Authority)
CVA provides type-safe variant management. Define variants in `cva()`, use with props.

### Using cn() Utility
Merge Tailwind classes safely: `cn(baseClasses, conditionalClasses, className)`.

## What Belongs Here

✅ Buttons, Inputs, Cards, Badges, Avatars (no business logic)
✅ Layout components (Container, Stack, Grid)
✅ Feedback components (Alert, Toast, Spinner)

❌ User-specific components (UserCard, ProductCard) - these go in apps/
❌ Forms with validation - these go in apps/
❌ API-connected components - these go in apps/
```

### Validation
- [ ] Button component exports and has types
- [ ] cn() utility works
- [ ] No TypeScript errors

---

## Phase 5: Web Application Skeleton

### Objective
Create a Next.js app demonstrating how to consume the UI library.

### What to Create

```
apps/web/
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx         # Examples using Button
│   │   └── globals.css
│   ├── components/          # Layer 4 (app-specific) - empty for now
│   └── types/
│       └── index.ts
├── package.json
├── next.config.js
├── tsconfig.json
└── tailwind.config.js
```

**package.json**:
```json
{
  "name": "@myapp/web",
  "version": "0.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "@myapp/ui": "workspace:*",
    "@myapp/tokens": "workspace:*",
    "next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@myapp/config": "workspace:*",
    "@types/node": "^20.0.0",
    "@types/react": "^18.2.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0",
    "tailwindcss": "^3.4.0",
    "typescript": "^5.0.0"
  }
}
```

**next.config.js** - Critical for monorepo:
```javascript
module.exports = {
  transpilePackages: ['@myapp/ui', '@myapp/tokens']
};
```

**tailwind.config.js** - Must include UI package:
```javascript
const baseConfig = require('@myapp/config/tailwind.config.js');

module.exports = {
  ...baseConfig,
  content: [
    './src/**/*.{js,ts,jsx,tsx,mdx}',
    '../../packages/ui/src/**/*.{ts,tsx}'  // Critical!
  ]
};
```

**src/app/globals.css**:
```css
@import '@myapp/tokens/build/css/variables.css';

@tailwind base;
@tailwind components;
@tailwind utilities;
```

**src/app/page.tsx** - Simple example:
```typescript
import { Button } from '@myapp/ui';

export default function Home() {
  return (
    <main className="min-h-screen p-8">
      <h1 className="text-2xl font-bold mb-4">Design System Demo</h1>
      <div className="flex gap-2">
        <Button variant="primary">Primary</Button>
        <Button variant="secondary">Secondary</Button>
      </div>
    </main>
  );
}
```

**src/components/README.md** - Guide on app components:
```markdown
# App Components (Layer 4)

This directory contains **app-specific components** that:
- Have business logic
- Know about your data models (User, Product, etc.)
- Compose primitives from @myapp/ui
- Should NOT be moved to packages/ui

## Example: UserCard

```typescript
import { Card, Avatar, Badge, Button } from '@myapp/ui';
import type { User } from '@/types';

interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
}

export function UserCard({ user, onEdit }: UserCardProps) {
  return (
    <Card>
      <Avatar src={user.avatar} alt={user.name} />
      <h3>{user.name}</h3>
      <Badge>{user.role}</Badge>
      {onEdit && <Button onClick={() => onEdit(user)}>Edit</Button>}
    </Card>
  );
}
```

## When to Create App Components

Create components here when they:
1. Use your specific types (User, Product, Order)
2. Make API calls
3. Have business rules (e.g., admins can't be deleted)
4. Are specific to this application

## Don't Over-Abstract

If you're only using a component in one place, keep it simple:
- Don't add variants you don't need
- Don't make it configurable if it doesn't need to be
- Inline small components in pages if appropriate
```

### Validation
- [ ] `pnpm --filter @myapp/web dev` starts successfully
- [ ] App loads at localhost:3000
- [ ] Buttons render with Tailwind styles

---

## Phase 6: Storybook Setup

### Objective
Create documentation site ready to document components.

### What to Create

```
apps/docs/
├── .storybook/
│   ├── main.ts
│   └── preview.ts
├── stories/
│   └── Button.stories.tsx   # Example for Button
├── src/
│   └── styles.css
├── package.json
└── tailwind.config.js
```

**package.json**:
```json
{
  "name": "@myapp/docs",
  "version": "0.0.0",
  "private": true,
  "scripts": {
    "dev": "storybook dev -p 6006",
    "build": "storybook build"
  },
  "dependencies": {
    "@myapp/ui": "workspace:*",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@storybook/addon-essentials": "^7.5.0",
    "@storybook/react": "^7.5.0",
    "@storybook/react-vite": "^7.5.0",
    "storybook": "^7.5.0",
    "tailwindcss": "^3.4.0",
    "vite": "^5.0.0"
  }
}
```

**.storybook/main.ts**:
```typescript
import type { StorybookConfig } from '@storybook/react-vite';

const config: StorybookConfig = {
  stories: ['../stories/**/*.stories.@(js|jsx|ts|tsx)'],
  addons: ['@storybook/addon-essentials'],
  framework: { name: '@storybook/react-vite', options: {} },
  docs: { autodocs: 'tag' }
};

export default config;
```

**stories/Button.stories.tsx** - Example:
```typescript
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from '@myapp/ui';

const meta: Meta<typeof Button> = {
  title: 'Components/Button',
  component: Button,
  tags: ['autodocs']
};

export default meta;
type Story = StoryObj<typeof Button>;

export const Primary: Story = {
  args: { children: 'Button', variant: 'primary' }
};

export const Secondary: Story = {
  args: { children: 'Button', variant: 'secondary' }
};
```

**stories/README.md** - Guide on documentation:
```markdown
# Storybook Documentation

## Adding Stories for New Components

When you add a component to @myapp/ui, create a story:

1. Create `stories/YourComponent.stories.tsx`
2. Import component from @myapp/ui
3. Define stories showing different states

## Story Template

```typescript
import type { Meta, StoryObj } from '@storybook/react';
import { YourComponent } from '@myapp/ui';

const meta: Meta<typeof YourComponent> = {
  title: 'Components/YourComponent',
  component: YourComponent,
  tags: ['autodocs'],
  argTypes: {
    variant: { control: 'select', options: ['default', 'other'] }
  }
};

export default meta;
type Story = StoryObj<typeof YourComponent>;

export const Default: Story = {
  args: { children: 'Content' }
};
```

## Running Storybook

```bash
pnpm --filter @myapp/docs dev
```

Visit http://localhost:6006
```

### Validation
- [ ] `pnpm --filter @myapp/docs dev` starts Storybook
- [ ] Button stories render correctly
- [ ] Controls work in Storybook

---

## Phase 7: Developer Documentation

### Objective
Create comprehensive guides for extending the system.

### What to Create

**Root README.md** - Overview:
```markdown
# Design System

Production-ready design system monorepo built with React, TypeScript, and Tailwind CSS.

## Architecture

5-layer design system:
```
Layer 5: Pages/Views          apps/web/app/
Layer 4: App Components       apps/web/components/
Layer 3: Pattern Components   packages/ui/ (complex)
Layer 2: Primitive Components packages/ui/ (basic)
Layer 1: Design Tokens        packages/tokens/
```

## Getting Started

### Prerequisites
- Node.js 18+
- pnpm 8+

### Installation

```bash
# Install dependencies
pnpm install

# Build tokens (required first)
pnpm --filter @myapp/tokens build

# Start all apps
pnpm dev
```

This starts:
- Web app: http://localhost:3000
- Storybook: http://localhost:6006

## Project Structure

```
design-system/
├── packages/
│   ├── tokens/    # Design tokens (colors, spacing, typography)
│   ├── ui/        # Reusable components (Button, Input, Card)
│   └── config/    # Shared configs (TypeScript, Tailwind)
├── apps/
│   ├── web/       # Next.js application
│   └── docs/      # Storybook documentation
└── turbo.json     # Monorepo build orchestration
```

## Common Tasks

### Adding a Design Token

1. Edit `packages/tokens/src/*.json`
2. Run `pnpm --filter @myapp/tokens build`
3. Tokens available as CSS variables and JS exports

[See packages/tokens/README.md](packages/tokens/README.md)

### Adding a UI Component

1. Create `packages/ui/src/components/YourComponent.tsx`
2. Export from `packages/ui/src/index.tsx`
3. Create story in `apps/docs/stories/YourComponent.stories.tsx`

[See packages/ui/README.md](packages/ui/README.md)

### Adding an App Component

1. Create `apps/web/components/YourAppComponent.tsx`
2. Import UI primitives: `import { Button } from '@myapp/ui'`
3. Add business logic specific to your app

[See apps/web/src/components/README.md](apps/web/src/components/README.md)

## Development Workflow

```bash
# Start development servers
pnpm dev

# Build all packages
pnpm build

# Lint all packages
pnpm lint

# Clean build artifacts
pnpm clean
```

## Package Dependencies

```
@myapp/web
  ├── @myapp/ui
  │   └── @myapp/tokens
  └── @myapp/config

@myapp/docs
  └── @myapp/ui
      └── @myapp/tokens
```

## Learn More

- [Design Tokens Guide](packages/tokens/README.md)
- [Component Development Guide](packages/ui/README.md)
- [App Component Guide](apps/web/src/components/README.md)
- [Storybook Guide](apps/docs/stories/README.md)

## Customization

This scaffold is intentionally minimal. Extend it by:
- Adding more design tokens (colors, shadows, borders)
- Creating components as you need them
- Adding more apps (mobile, admin, marketing)
- Adding pattern components (forms, tables, modals)
```

**CONTRIBUTING.md** - Development guide:
```markdown
# Contributing Guide

## Architecture Principles

### The 5-Layer Model

**Layer 1: Design Tokens** (packages/tokens/)
- Pure data, no code
- Single source of truth for design decisions
- Multi-platform output (web, mobile)

**Layer 2: Primitive Components** (packages/ui/)
- Reusable, generic UI elements
- No business logic
- Examples: Button, Input, Card
- Can be used in any context

**Layer 3: Pattern Components** (packages/ui/)
- Complex components combining primitives
- Reusable patterns, no business logic
- Examples: DataTable, Modal, Dropdown

**Layer 4: App Components** (apps/*/components/)
- Application-specific components
- Have business logic and domain knowledge
- Examples: UserCard, ProductList
- Compose primitives from Layer 2

**Layer 5: Pages/Views** (apps/*/app/)
- Full pages and routes
- Compose app components from Layer 4

### Key Rules

1. **Lower layers never import from higher layers**
2. **App components stay in apps/, not packages/**
3. **No business logic in packages/ui**
4. **Tokens are always JSON, never TypeScript**

## When to Create What

### Create a Design Token When:
- You need a consistent value across multiple components
- The value might need to change for theming
- Example: colors, spacing, font sizes

### Create a Primitive Component When:
- It's a generic UI element with no business logic
- It could be used in multiple apps or contexts
- You'll use it more than once
- Example: Button, Input, Badge

### Create a Pattern Component When:
- You need to combine multiple primitives in a reusable way
- The pattern is generic enough for multiple contexts
- Example: SearchableSelect, DataTable, ConfirmModal

### Create an App Component When:
- It's specific to your application domain
- It has business logic or rules
- It uses your data types (User, Product, etc.)
- Example: UserProfileCard, CheckoutSummary

### Keep in Page When:
- It's only used on one page
- It's simple enough to not need abstraction
- Moving it would make code harder to understand

## Component Development Workflow

1. **Start simple**: Create component in the page where you need it
2. **Identify reusability**: Used in 2+ places? Consider extraction
3. **Remove business logic**: Strip domain knowledge for primitives
4. **Add to UI package**: Move to packages/ui if generic enough
5. **Document**: Create Storybook story
6. **Test**: Ensure works in different contexts

## Don't Over-Abstract

Common mistakes:
- Creating reusable components too early
- Adding configuration for hypothetical use cases
- Moving app-specific logic to UI package
- Creating wrappers for single-use patterns

Better approach:
- Wait until you need a component 2-3 times
- Only add props you actually need
- Keep business logic in app components
- Duplicate simple code rather than abstract prematurely

## Performance Considerations

- Turborepo caches builds for fast rebuilds
- Only packages/tokens needs build step
- UI package runs in dev mode (no build)
- Changes to tokens trigger rebuilds
- Changes to UI trigger hot reloads
```

### Validation
- [ ] README explains how to add tokens, components, apps
- [ ] Each package has its own README
- [ ] Documentation guides users, doesn't prescribe

---

## Final Validation Checklist

### Structure
- [ ] Monorepo created with correct folder structure
- [ ] All package.json files have correct workspace dependencies
- [ ] Root scripts (dev, build, lint) work

### Tokens
- [ ] Style Dictionary generates CSS and JS outputs
- [ ] Starter tokens provided but marked for customization
- [ ] README explains how to add/modify tokens

### UI Package
- [ ] Button component demonstrates CVA pattern
- [ ] cn() utility provided
- [ ] README explains how to add components
- [ ] Only 1-2 example components (not dozens)

### Web App
- [ ] Next.js app runs and displays UI components
- [ ] Tailwind config includes UI package path
- [ ] README explains app component pattern
- [ ] components/ folder has guide, not pre-built components

### Storybook
- [ ] Storybook runs and shows Button component
- [ ] README explains how to add stories
- [ ] Ready to document new components

### Documentation
- [ ] Root README covers getting started
- [ ] CONTRIBUTING.md explains architecture
- [ ] Each package has its own README
- [ ] Guides focus on "how to extend", not prescriptive components

### Philosophy Adherence
- [ ] Scaffold created, not comprehensive library
- [ ] Users guided to create their own components
- [ ] No more than 2-3 example components
- [ ] Clear documentation on extending system
- [ ] No design decisions made (colors, spacing values)

---

## Success Criteria

After initialization, users should have:

1. ✅ **Working monorepo** with build and dev scripts
2. ✅ **Token pipeline** ready for their design decisions
3. ✅ **Component pattern** demonstrated (CVA + forwardRef)
4. ✅ **Clear architecture** (5-layer model documented)
5. ✅ **Extension guides** for adding tokens, components, apps
6. ✅ **Minimal but complete** foundation, not bloated library

Users should be able to:
- Add design tokens matching their brand
- Create components following the pattern
- Build app-specific components in apps/
- Document components in Storybook
- Understand where code belongs (layers)

---

## What NOT to Include

The agent should explicitly avoid:
- ❌ Pre-generating 20+ components users may not need
- ❌ Making design decisions (specific colors, spacing)
- ❌ Creating app-specific business logic
- ❌ Complex form validation patterns
- ❌ API integration examples
- ❌ Authentication/authorization components
- ❌ Prescriptive styling (let users choose)

---

## Customization Points

After scaffolding, users customize:

1. **Design Tokens**: Replace starter tokens with brand colors, spacing, typography
2. **Components**: Add components as needed (Input, Card, Badge, etc.)
3. **Patterns**: Create pattern components specific to needs (forms, tables)
4. **Apps**: Add more apps (mobile, admin, marketing sites)
5. **Build**: Add testing, linting, CI/CD as needed

---

## Quick Reference

### Commands After Setup

```bash
# Install and build
pnpm install
pnpm --filter @myapp/tokens build

# Start everything
pnpm dev

# Add a token
# Edit packages/tokens/src/*.json
pnpm --filter @myapp/tokens build

# Add a UI component
# Create packages/ui/src/components/NewComponent.tsx
# Export from packages/ui/src/index.tsx
# Create apps/docs/stories/NewComponent.stories.tsx

# Add an app component
# Create apps/web/components/NewAppComponent.tsx
# Import UI primitives from @myapp/ui
```

### File Paths Reference

- Tokens: `packages/tokens/src/*.json`
- UI Components: `packages/ui/src/components/*.tsx`
- App Components: `apps/web/components/*.tsx`
- Pages: `apps/web/app/*/page.tsx`
- Stories: `apps/docs/stories/*.stories.tsx`
- Shared Configs: `packages/config/`

---

**Version**: 2.0.0 (Scaffold-focused)
**Last Updated**: 2025-12-10
**Philosophy**: Scaffold, don't prescribe