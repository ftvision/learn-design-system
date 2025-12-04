# Chapter 4: Monorepo Architecture

## Chapter Goal

By the end of this chapter, you will:
- Understand why monorepos are the standard for design systems
- Set up a Turborepo-managed monorepo
- Connect your tokens and UI packages to a Next.js app
- Know how workspace dependencies work
- Configure shared tooling (TypeScript, ESLint, Tailwind)

## Prerequisites

- Completed Chapters 1-3
- Tokens package from Chapter 2
- UI package from Chapter 3
- pnpm installed (`npm install -g pnpm`)

## Key Concepts

### Why Monorepos for Design Systems?

| Without Monorepo | With Monorepo |
|-----------------|---------------|
| UI library published to npm | UI package in same repo |
| Version mismatches between app and UI | Always in sync |
| Slow publish → install cycle | Instant updates |
| Separate repos for tokens, UI, app | Everything in one place |

### The Structure

```
my-product/
├── packages/             # Shared packages
│   ├── tokens/          # Design tokens (Chapter 2)
│   ├── ui/              # UI components (Chapter 3)
│   └── config/          # Shared configs (tsconfig, tailwind)
├── apps/                # Applications
│   ├── web/             # Next.js web app
│   └── docs/            # Storybook documentation
├── package.json         # Root package.json
├── pnpm-workspace.yaml  # Workspace definition
└── turbo.json           # Build orchestration
```

### How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                         Workspace                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  packages/tokens/           packages/ui/                     │
│  ├── package.json          ├── package.json                 │
│  │   name: @myapp/tokens   │   name: @myapp/ui              │
│  │                         │   dependencies:                 │
│  │                         │     @myapp/tokens: workspace:*  │
│  │                         │                                 │
│  └── ...                   └── ...                          │
│                                   │                          │
│                     ┌─────────────┘                          │
│                     │                                        │
│  apps/web/          ▼                                        │
│  ├── package.json                                            │
│  │   dependencies:                                           │
│  │     @myapp/ui: workspace:*                                │
│  │     @myapp/tokens: workspace:*                            │
│  └── ...                                                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## What You'll Build

- A complete monorepo with Turborepo
- Next.js app that imports from `@myapp/ui`
- Shared Tailwind and TypeScript configurations
- Working dev and build pipelines

## Time Estimate

- Theory: 20 minutes
- Lab exercises: 2 hours
- Reflection: 20 minutes

## Success Criteria

- [ ] Monorepo structure is set up correctly
- [ ] `pnpm install` works at root level
- [ ] App can import from `@myapp/ui` and `@myapp/tokens`
- [ ] `pnpm dev` runs both the app and watches packages
- [ ] `pnpm build` builds everything in the right order
- [ ] Changes to UI package reflect immediately in the app

## Next Chapter

With the architecture in place, Chapter 5 teaches you to build app-specific components that consume your UI library.
