# Lab 4.4: Create Web App

## Objective

Create a Next.js application that consumes the UI components and tokens packages from the monorepo.

## Time Estimate

~45 minutes

## Prerequisites

- Completed Labs 4.1-4.3
- Understanding of Next.js basics

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure previous labs are complete
2. Create a Next.js app structure in apps/web
3. Configure workspace dependencies
4. Create a demo page using UI components

### Manual Setup

For manual Next.js setup:
```bash
cd ../lab4.1/apps/web
npx create-next-app@latest . --typescript --tailwind --app --no-src-dir --no-import-alias
```

## Exercises

### Exercise 1: Examine App's package.json

Open `apps/web/package.json`:

```json
{
  "name": "@myapp/web",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "@myapp/tokens": "workspace:*",
    "@myapp/ui": "workspace:*",
    "next": "14.2.0",
    "react": "^18",
    "react-dom": "^18"
  },
  "devDependencies": {
    "@myapp/config": "workspace:*",
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "autoprefixer": "^10.0.0",
    "postcss": "^8",
    "tailwindcss": "^3.4.0",
    "typescript": "^5"
  }
}
```

**Key workspace dependencies:**
- `@myapp/tokens: workspace:*` - Access design tokens
- `@myapp/ui: workspace:*` - Access UI components
- `@myapp/config: workspace:*` - Shared TypeScript config

### Exercise 2: Configure TypeScript

Examine `apps/web/tsconfig.json`:

```json
{
  "extends": "@myapp/config/tsconfig/nextjs",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

This:
- Extends the shared Next.js TypeScript config
- Adds `@/*` path alias for local imports
- Includes Next.js type definitions

### Exercise 3: Configure Tailwind

Examine `apps/web/tailwind.config.ts`:

```typescript
import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    // Include UI package content
    "../../packages/ui/src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};

export default config;
```

**Critical:** The content array includes:
- Local app files (`./app/**/*`)
- **UI package files** (`../../packages/ui/src/**/*`)

Without this, Tailwind won't see classes used in UI components!

### Exercise 4: Understand the Import Path

When you write:
```tsx
import { Button } from "@myapp/ui";
```

Here's the resolution chain:

1. **Node looks for** `@myapp/ui`
2. **Checks pnpm-workspace.yaml** → `packages/*` is a workspace
3. **Finds** `packages/ui/package.json` with `name: "@myapp/ui"`
4. **Reads exports** → `".": "./src/index.tsx"`
5. **Loads** `packages/ui/src/index.tsx`
6. **Follows export** → `export { Button } from "./components/Button"`
7. **Gets** the Button component

### Exercise 5: Examine the Demo Page

Open `apps/web/app/page.tsx`:

```tsx
import {
  Button,
  Input,
  Card,
  CardHeader,
  CardTitle,
  CardContent,
  CardFooter
} from "@myapp/ui";

export default function Home() {
  return (
    <main className="min-h-screen p-8 bg-gray-50">
      <div className="max-w-2xl mx-auto space-y-8">
        <h1 className="text-3xl font-bold text-gray-900">
          Design System Demo
        </h1>

        {/* Button variants */}
        <section>
          <h2 className="text-xl font-semibold mb-4">Buttons</h2>
          <div className="flex flex-wrap gap-4">
            <Button variant="primary">Primary</Button>
            <Button variant="secondary">Secondary</Button>
            <Button variant="destructive">Destructive</Button>
            <Button variant="outline">Outline</Button>
            <Button variant="ghost">Ghost</Button>
            <Button variant="link">Link</Button>
          </div>
        </section>

        {/* More sections... */}
      </div>
    </main>
  );
}
```

This page:
- Imports components from `@myapp/ui`
- Demonstrates button variants
- Shows form components in a Card

### Exercise 6: Examine Layout and Globals

**Layout** (`app/layout.tsx`):
```tsx
import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Design System Demo",
  description: "Monorepo design system demo",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
```

**Global CSS** (`app/globals.css`):
```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

This loads Tailwind's styles, which will include classes from both the app and UI package.

### Exercise 7: How Next.js Handles Workspace Packages

Next.js has built-in support for workspace packages:

1. **Transpilation**: Next.js automatically transpiles TypeScript from workspace packages
2. **Hot Reload**: Changes in `packages/ui` trigger browser updates
3. **No Build Step**: Source files are used directly (no need to build UI package first for dev)

This is why:
- `packages/ui` exports `.tsx` files directly
- `packages/ui/package.json` has `"main": "./src/index.tsx"`

## Key Concepts

### Tailwind Content Configuration

Tailwind uses the `content` array to find class names:

```typescript
content: [
  "./app/**/*.{js,ts,jsx,tsx,mdx}",
  "../../packages/ui/src/**/*.{js,ts,jsx,tsx}",  // UI package!
]
```

**Why this matters:**
- Tailwind only generates CSS for classes it finds
- If UI package isn't included, component styles break
- The path is relative to the Tailwind config file

### Next.js Workspace Detection

Next.js v13+ automatically handles workspace packages by:
1. Detecting pnpm workspaces
2. Transpiling TypeScript from linked packages
3. Enabling fast refresh for workspace code changes

### Path Aliases

The `@/*` path alias in tsconfig:

```json
{
  "paths": {
    "@/*": ["./*"]
  }
}
```

Allows:
```tsx
import { MyComponent } from "@/components/MyComponent";
// Instead of
import { MyComponent } from "../../../components/MyComponent";
```

## Checklist

Before proceeding to Lab 4.5:

- [ ] apps/web/package.json has workspace dependencies
- [ ] apps/web/tsconfig.json extends @myapp/config/tsconfig/nextjs
- [ ] apps/web/tailwind.config.ts includes UI package path
- [ ] apps/web/app/page.tsx imports from @myapp/ui
- [ ] apps/web/app/globals.css has Tailwind directives
- [ ] You understand how imports resolve to workspace packages

## Troubleshooting

### "Module not found: Can't resolve '@myapp/ui'"

1. Make sure `packages/ui/package.json` exists with correct name
2. Check `apps/web/package.json` has `"@myapp/ui": "workspace:*"`
3. Run `pnpm install` from root

### "Cannot find module 'react'"

React should come from the app's dependencies. Check:
```json
{
  "dependencies": {
    "react": "^18",
    "react-dom": "^18"
  }
}
```

### Tailwind classes not applying

1. Check `tailwind.config.ts` includes the UI package path
2. Make sure path is relative: `../../packages/ui/src/**/*`
3. Verify `globals.css` has `@tailwind` directives

### TypeScript errors about workspace package

Make sure `packages/ui/tsconfig.json` is valid:
```json
{
  "extends": "@myapp/config/tsconfig/react"
}
```

## Next

Proceed to Lab 4.5 to build and run the entire monorepo.
