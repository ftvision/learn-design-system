# Chapter 4 Study Plan: Monorepo Architecture

## Part 1: Theory (20 minutes)

### 1.1 Monorepo Fundamentals

A **monorepo** is a single repository containing multiple packages or applications. For design systems, this means:

```
my-product/
├── packages/       # Shared code (libraries)
│   ├── tokens/    # npm: @myapp/tokens
│   ├── ui/        # npm: @myapp/ui
│   └── config/    # npm: @myapp/config
└── apps/          # Applications (not published to npm)
    ├── web/       # Your main app
    └── docs/      # Documentation site
```

### 1.2 Workspace Dependencies

Instead of npm publishing, packages reference each other with `workspace:*`:

```json
// apps/web/package.json
{
  "dependencies": {
    "@myapp/ui": "workspace:*",      // Resolves to packages/ui
    "@myapp/tokens": "workspace:*"   // Resolves to packages/tokens
  }
}
```

**What `workspace:*` means:**
- `workspace:` = Look in this monorepo
- `*` = Use whatever version is in the workspace

### 1.3 Turborepo

Turborepo orchestrates builds across packages:

```json
// turbo.json
{
  "tasks": {
    "build": {
      "dependsOn": ["^build"],  // Build dependencies first
      "outputs": ["dist/**"]
    }
  }
}
```

When you run `turbo build`:
1. Builds `packages/tokens` first (no dependencies)
2. Then `packages/ui` (depends on tokens)
3. Finally `apps/web` (depends on ui)

### 1.4 Benefits

| Feature | Benefit |
|---------|---------|
| Single git clone | Everything in one place |
| Workspace dependencies | No npm publish cycle |
| Shared configs | Consistent TypeScript, ESLint, Tailwind |
| Turborepo caching | Faster builds (skip unchanged packages) |
| Atomic changes | Update UI and app together |

---

## Part 2: Lab - Initialize the Monorepo (30 minutes)

### Lab 4.1: Create Root Structure

Starting fresh (or restructure existing work):

```bash
# Create a new directory
mkdir design-system-course
cd design-system-course

# Create the folder structure
mkdir -p packages/{tokens,ui,config} apps/web
```

### Lab 4.2: Create Root package.json

Create `package.json` at the root:

```json
{
  "name": "design-system-course",
  "private": true,
  "scripts": {
    "dev": "turbo dev",
    "build": "turbo build",
    "lint": "turbo lint",
    "clean": "turbo clean && rm -rf node_modules"
  },
  "devDependencies": {
    "turbo": "^2.0.0"
  },
  "packageManager": "pnpm@8.15.0"
}
```

### Lab 4.3: Create pnpm-workspace.yaml

Create `pnpm-workspace.yaml`:

```yaml
packages:
  - 'packages/*'
  - 'apps/*'
```

This tells pnpm which directories contain packages.

### Lab 4.4: Create turbo.json

Create `turbo.json`:

```json
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "build/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "dependsOn": ["^build"]
    },
    "clean": {
      "cache": false
    }
  }
}
```

**Understanding the config:**
- `dependsOn: ["^build"]` = Build dependencies first (tokens → ui → app)
- `outputs` = What to cache
- `persistent: true` = Keep running (for dev servers)

---

## Part 3: Lab - Set Up Shared Configurations (30 minutes)

### Lab 4.5: Create TypeScript Config Package

Create `packages/config/package.json`:

```json
{
  "name": "@myapp/config",
  "version": "0.0.0",
  "private": true,
  "exports": {
    "./tsconfig/base": "./tsconfig/base.json",
    "./tsconfig/react": "./tsconfig/react.json",
    "./tsconfig/nextjs": "./tsconfig/nextjs.json",
    "./tailwind": "./tailwind.config.js"
  }
}
```

Create `packages/config/tsconfig/base.json`:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "isolatedModules": true
  }
}
```

Create `packages/config/tsconfig/react.json`:

```json
{
  "extends": "./base.json",
  "compilerOptions": {
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "jsx": "react-jsx",
    "noEmit": true
  }
}
```

Create `packages/config/tsconfig/nextjs.json`:

```json
{
  "extends": "./react.json",
  "compilerOptions": {
    "plugins": [{ "name": "next" }],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowJs": true
  }
}
```

### Lab 4.6: Create Shared Tailwind Config

Create `packages/config/tailwind.config.js`:

```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    // Include all packages and apps
    "../../packages/ui/src/**/*.{js,ts,jsx,tsx}",
    "./src/**/*.{js,ts,jsx,tsx}",
    "./app/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      // You can add custom theme values here
      // Or import from tokens package
    },
  },
  plugins: [],
};
```

---

## Part 4: Lab - Configure Tokens Package (20 minutes)

### Lab 4.7: Update Tokens Package

Copy your tokens work from Chapter 2 or create new:

`packages/tokens/package.json`:

```json
{
  "name": "@myapp/tokens",
  "version": "0.0.1",
  "private": true,
  "main": "./build/js/tokens.js",
  "types": "./build/ts/tokens.d.ts",
  "exports": {
    ".": "./build/js/tokens.js",
    "./css": "./build/css/variables.css"
  },
  "scripts": {
    "build": "style-dictionary build",
    "clean": "rm -rf build"
  },
  "devDependencies": {
    "style-dictionary": "^3.9.0"
  }
}
```

Make sure your token source files exist in `packages/tokens/src/`.

---

## Part 5: Lab - Configure UI Package (20 minutes)

### Lab 4.8: Update UI Package

Update `packages/ui/package.json`:

```json
{
  "name": "@myapp/ui",
  "version": "0.0.1",
  "private": true,
  "main": "./src/index.tsx",
  "module": "./src/index.tsx",
  "types": "./src/index.tsx",
  "exports": {
    ".": "./src/index.tsx",
    "./button": "./src/components/Button.tsx",
    "./input": "./src/components/Input.tsx",
    "./card": "./src/components/Card.tsx",
    "./styles.css": "./src/styles.css"
  },
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rm -rf dist",
    "lint": "eslint src/"
  },
  "dependencies": {
    "@myapp/tokens": "workspace:*",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0"
  },
  "peerDependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "devDependencies": {
    "@myapp/config": "workspace:*",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0"
  }
}
```

Update `packages/ui/tsconfig.json`:

```json
{
  "extends": "@myapp/config/tsconfig/react",
  "compilerOptions": {
    "outDir": "./dist"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

---

## Part 6: Lab - Create the Web App (45 minutes)

### Lab 4.9: Initialize Next.js App

```bash
cd apps/web
npx create-next-app@latest . --typescript --tailwind --app --no-src-dir --no-import-alias
```

When prompted:
- TypeScript: Yes
- ESLint: Yes
- Tailwind CSS: Yes
- App Router: Yes
- Import alias: No (we'll configure this)

### Lab 4.10: Update App's package.json

Edit `apps/web/package.json` to add workspace dependencies:

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
    "next": "14.x.x",
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

### Lab 4.11: Configure Tailwind for the App

Update `apps/web/tailwind.config.ts`:

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

### Lab 4.12: Update App's tsconfig.json

Update `apps/web/tsconfig.json`:

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

### Lab 4.13: Create a Test Page

Replace `apps/web/app/page.tsx`:

```tsx
import { Button, Input, Card, CardHeader, CardTitle, CardContent, CardFooter } from "@myapp/ui";

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

        {/* Button sizes */}
        <section>
          <h2 className="text-xl font-semibold mb-4">Button Sizes</h2>
          <div className="flex items-center gap-4">
            <Button size="sm">Small</Button>
            <Button size="md">Medium</Button>
            <Button size="lg">Large</Button>
          </div>
        </section>

        {/* Loading state */}
        <section>
          <h2 className="text-xl font-semibold mb-4">Loading State</h2>
          <Button loading>Saving...</Button>
        </section>

        {/* Form example */}
        <Card>
          <CardHeader>
            <CardTitle>Sign Up</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <Input
              label="Full Name"
              placeholder="John Doe"
            />
            <Input
              label="Email"
              type="email"
              placeholder="john@example.com"
              hint="We'll never share your email"
            />
            <Input
              label="Password"
              type="password"
              error="Password must be at least 8 characters"
            />
          </CardContent>
          <CardFooter className="justify-end">
            <Button variant="secondary">Cancel</Button>
            <Button>Create Account</Button>
          </CardFooter>
        </Card>
      </div>
    </main>
  );
}
```

---

## Part 7: Lab - Install and Run (15 minutes)

### Lab 4.14: Install Dependencies

From the root directory:

```bash
cd ../..  # Back to design-system-course root
pnpm install
```

This installs dependencies for ALL packages and links workspace packages.

### Lab 4.15: Build Everything

```bash
pnpm build
```

Watch the order - Turborepo builds dependencies first:
1. `@myapp/tokens` (no dependencies)
2. `@myapp/ui` (depends on tokens)
3. `@myapp/web` (depends on ui)

### Lab 4.16: Run Development

```bash
pnpm dev
```

Open http://localhost:3000 and verify:
- [ ] Page loads without errors
- [ ] Buttons render with correct styles
- [ ] Input components work
- [ ] Card layout is correct

### Lab 4.17: Test Hot Reload

1. Keep `pnpm dev` running
2. Open `packages/ui/src/components/Button.tsx`
3. Change a color (e.g., `bg-blue-600` → `bg-purple-600`)
4. Save the file
5. Watch the browser update automatically

This works because:
- Next.js transpiles workspace packages
- File changes trigger recompilation
- Hot Module Replacement updates the browser

---

## Part 8: Understanding the Connection (20 minutes)

### Lab 4.18: Trace the Import Path

When you write:
```tsx
import { Button } from "@myapp/ui";
```

Here's what happens:

1. **Resolve package name**: Node looks for `@myapp/ui`
2. **Check pnpm-workspace.yaml**: Sees `packages/*` is a workspace
3. **Find packages/ui/package.json**: Matches `name: "@myapp/ui"`
4. **Read exports**: `"." : "./src/index.tsx"`
5. **Load file**: `packages/ui/src/index.tsx`
6. **Follow exports**: `export { Button } from "./components/Button"`
7. **Load Button**: `packages/ui/src/components/Button.tsx`

### Lab 4.19: Inspect node_modules

```bash
ls -la node_modules/@myapp/
```

You'll see symlinks:
```
ui -> ../../packages/ui
tokens -> ../../packages/tokens
config -> ../../packages/config
```

pnpm creates symlinks instead of copying files. This is why changes reflect immediately.

---

## Part 9: Compare with Real Projects (15 minutes)

### Lab 4.20: Cal.com's Structure

```bash
# In cal.com repo
cat pnpm-workspace.yaml
cat turbo.json
cat apps/web/package.json | grep -A10 "dependencies"
```

**Questions:**
1. What packages does Cal.com have?
2. How do they name their packages?
3. What turbo tasks do they define?

### Lab 4.21: Supabase's Structure

```bash
# In supabase repo
cat pnpm-workspace.yaml
cat turbo.json
```

---

## Part 10: Reflection (20 minutes)

### Written Reflection

1. **What problem does a monorepo solve for design systems?**
   ```


   ```

2. **What does `workspace:*` mean in package.json?**
   ```


   ```

3. **Why does Turborepo build in a specific order?**
   ```


   ```

4. **How do changes in packages/ui appear instantly in apps/web?**
   ```


   ```

---

## Part 11: Self-Check

Before moving to Chapter 5, verify:

- [ ] `pnpm install` works without errors
- [ ] `pnpm build` builds all packages in order
- [ ] `pnpm dev` runs the app with hot reload
- [ ] Changes in UI package reflect in the app
- [ ] You understand workspace dependency resolution
- [ ] You've compared with Cal.com or Supabase structure

---

## Files You Should Have

```
design-system-course/
├── packages/
│   ├── tokens/
│   │   ├── src/
│   │   ├── package.json
│   │   └── style-dictionary.config.js
│   ├── ui/
│   │   ├── src/
│   │   │   ├── components/
│   │   │   ├── lib/
│   │   │   └── index.tsx
│   │   ├── package.json
│   │   └── tsconfig.json
│   └── config/
│       ├── tsconfig/
│       │   ├── base.json
│       │   ├── react.json
│       │   └── nextjs.json
│       ├── tailwind.config.js
│       └── package.json
├── apps/
│   └── web/
│       ├── app/
│       │   └── page.tsx
│       ├── package.json
│       ├── tsconfig.json
│       └── tailwind.config.ts
├── package.json
├── pnpm-workspace.yaml
└── turbo.json
```

---

## Troubleshooting

### "Cannot find module '@myapp/ui'"

1. Make sure `packages/ui/package.json` has `"name": "@myapp/ui"`
2. Run `pnpm install` from root
3. Check that `node_modules/@myapp/ui` is a symlink

### "Module not found: Can't resolve 'class-variance-authority'"

Dependencies need to be installed:
```bash
cd packages/ui
pnpm install
```

### "Build failed: packages/ui depends on packages/tokens"

Make sure tokens is built first:
```bash
pnpm build --filter=@myapp/tokens
pnpm build
```

### Tailwind classes not applying

Check `tailwind.config.ts` includes the UI package path:
```typescript
content: [
  // ...
  "../../packages/ui/src/**/*.{js,ts,jsx,tsx}",
]
```
