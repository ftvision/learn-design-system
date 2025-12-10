# Lab 4.1: Initialize Monorepo

## Objective

Create the monorepo root structure with pnpm workspaces and Turborepo configuration.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Chapter 2 (tokens package)
- Completed Chapter 3 (UI components)
- Node.js 18+ installed
- pnpm installed (`npm install -g pnpm`)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Create the monorepo directory structure
2. Create root package.json with Turborepo
3. Create pnpm-workspace.yaml
4. Create turbo.json configuration

### Manual Setup

```bash
# From the lab directory (labs/lab4.1/)
mkdir -p packages/{tokens,ui,config} apps/web
```

## Exercises

### Exercise 1: Understand Monorepo Structure

After setup, verify the directory structure:

```bash
ls -la packages/
ls -la apps/
```

**Expected structure:**
```
lab4.1/
├── packages/           # Shared code (libraries)
│   ├── tokens/        # npm: @myapp/tokens
│   ├── ui/            # npm: @myapp/ui
│   └── config/        # npm: @myapp/config
├── apps/              # Applications
│   └── web/           # Your main app
├── package.json       # Root package.json
├── pnpm-workspace.yaml # Workspace configuration
└── turbo.json         # Turborepo configuration
```

### Exercise 2: Examine Root package.json

Open `package.json` and understand each section:

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

**Questions to answer:**

1. Why is `private: true` set?
   - Answer: Prevents accidental publishing to npm. The root package is just a container.

2. What do the turbo scripts do?
   - `turbo dev`: Runs dev scripts in all packages that have them
   - `turbo build`: Builds all packages in dependency order
   - `turbo lint`: Runs lint across all packages
   - `turbo clean`: Removes build artifacts

3. What does `packageManager` specify?
   - Answer: Ensures everyone uses the same pnpm version

### Exercise 3: Understand pnpm-workspace.yaml

Examine `pnpm-workspace.yaml`:

```yaml
packages:
  - 'packages/*'
  - 'apps/*'
```

This tells pnpm:
- All directories under `packages/` are npm packages
- All directories under `apps/` are npm packages
- They can reference each other with `workspace:*`

### Exercise 4: Understand turbo.json

Examine `turbo.json`:

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

**Key concepts:**

| Setting | Meaning |
|---------|---------|
| `dependsOn: ["^build"]` | Build dependencies first (tokens → ui → app) |
| `outputs` | Files to cache for faster rebuilds |
| `persistent: true` | Keep running (for dev servers) |
| `cache: false` | Don't cache this task |

### Exercise 5: Visualize Build Order

When you run `turbo build`, Turborepo figures out the dependency graph:

```
@myapp/tokens  ──┐
                 ├──> @myapp/ui ──┐
@myapp/config ──┘                 ├──> @myapp/web
                                  │
          @myapp/tokens ──────────┘
```

**Build order:**
1. `@myapp/tokens` and `@myapp/config` (no dependencies, build in parallel)
2. `@myapp/ui` (depends on tokens and config)
3. `@myapp/web` (depends on tokens and ui)

## Key Concepts

### Why Monorepos for Design Systems?

| Feature | Benefit |
|---------|---------|
| Single git clone | Everything in one place |
| Workspace dependencies | No npm publish cycle needed |
| Shared configs | Consistent TypeScript, ESLint, Tailwind |
| Turborepo caching | Faster builds (skip unchanged packages) |
| Atomic changes | Update UI and app together |

### workspace:* Dependencies

In package.json files, you'll use:

```json
{
  "dependencies": {
    "@myapp/ui": "workspace:*"
  }
}
```

This means:
- `workspace:` = Look in this monorepo
- `*` = Use whatever version is in the workspace

### pnpm vs npm/yarn

pnpm creates symlinks instead of copying files:

```bash
node_modules/@myapp/ui -> ../../packages/ui
```

This is why changes reflect immediately during development.

## Checklist

Before proceeding to Lab 4.2:

- [ ] Directory structure created (packages/, apps/)
- [ ] Root package.json exists with turbo scripts
- [ ] pnpm-workspace.yaml exists
- [ ] turbo.json exists
- [ ] You understand what `dependsOn: ["^build"]` means
- [ ] You understand what `workspace:*` means

## Troubleshooting

### pnpm not found

Install pnpm globally:
```bash
npm install -g pnpm
```

### Permission denied on setup.sh

Make the script executable:
```bash
chmod +x setup.sh
./setup.sh
```

## Next

Proceed to Lab 4.2 to create shared configurations (TypeScript, Tailwind).
