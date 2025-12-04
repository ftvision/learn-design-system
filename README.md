# Design Systems: A Practical Course

A hands-on course for learning to build design systems for web and mobile applications.

## Course Philosophy

This course blends **theory with practice**. Each chapter introduces concepts and immediately applies them through labs and exercises. You'll study real open-source projects (Cal.com, Supabase) alongside building your own system.

## Prerequisites

- Basic React and TypeScript knowledge
- Git and Node.js installed
- A code editor (VS Code recommended)

## Course Structure

```
chapters/
├── 01-understanding/      # What is a design system?
├── 02-design-tokens/      # Colors, spacing, typography
├── 03-primitive-components/ # Button, Input, Card
├── 04-monorepo-architecture/ # Turborepo setup
├── 05-app-components/     # Business-specific components
├── 06-theming/            # Light/dark mode
├── 07-documentation/      # Storybook
├── 08-cross-platform/     # iOS, Android tokens
└── 09-capstone/           # Final project
```

## Chapters

| # | Chapter | Time | What You'll Learn |
|---|---------|------|-------------------|
| 1 | [Understanding Design Systems](./chapters/01-understanding/) | 2 hrs | 5-layer architecture, exploring real codebases |
| 2 | [Design Tokens](./chapters/02-design-tokens/) | 2 hrs | Style Dictionary, multi-platform output |
| 3 | [Primitive Components](./chapters/03-primitive-components/) | 3 hrs | CVA, accessible components |
| 4 | [Monorepo Architecture](./chapters/04-monorepo-architecture/) | 2.5 hrs | Turborepo, workspace dependencies |
| 5 | [App Components](./chapters/05-app-components/) | 2.5 hrs | Business logic, composition |
| 6 | [Theming](./chapters/06-theming/) | 2 hrs | CSS variables, dark mode |
| 7 | [Documentation](./chapters/07-documentation/) | 2.5 hrs | Storybook setup, stories |
| 8 | [Cross-Platform](./chapters/08-cross-platform/) | 2 hrs | iOS, Android token generation |
| 9 | [Capstone Project](./chapters/09-capstone/) | 6 hrs | Build a complete feature |

**Total time:** ~24 hours

## Each Chapter Contains

- **README.md** - Chapter goals, key concepts, success criteria
- **STUDY_PLAN.md** - Theory sections, step-by-step labs, exercises, reflection questions

## The 5-Layer Model

This course teaches you to build all 5 layers:

```
┌─────────────────────────────────────────────┐
│ Layer 5: Pages/Views                        │  ← Chapter 5, 9
├─────────────────────────────────────────────┤
│ Layer 4: App Components                     │  ← Chapter 5
├─────────────────────────────────────────────┤
│ Layer 3: Pattern Components                 │  ← Chapter 3
├─────────────────────────────────────────────┤
│ Layer 2: Primitive Components               │  ← Chapter 3
├─────────────────────────────────────────────┤
│ Layer 1: Design Tokens                      │  ← Chapter 2
└─────────────────────────────────────────────┘
```

## What You'll Build

By the end of this course, you'll have:

```
design-system-course/
├── packages/
│   ├── tokens/           # Design tokens (colors, spacing, etc.)
│   ├── ui/               # Reusable components (Button, Card, etc.)
│   └── config/           # Shared configs (TypeScript, Tailwind)
├── apps/
│   ├── web/              # Next.js app using your design system
│   └── docs/             # Storybook documentation
├── turbo.json            # Monorepo orchestration
└── pnpm-workspace.yaml   # Workspace config
```

## Real-World Examples

Throughout the course, you'll study these open-source projects:

| Project | Repository | Key Learning |
|---------|------------|--------------|
| **Cal.com** | [github.com/calcom/cal.com](https://github.com/calcom/cal.com) | Monorepo with UI package |
| **Supabase** | [github.com/supabase/supabase](https://github.com/supabase/supabase) | Two-tier UI (primitives + patterns) |
| **IBM Carbon** | [github.com/carbon-design-system/carbon](https://github.com/carbon-design-system/carbon) | Cross-platform tokens |

## How to Use This Course

1. **Start with Chapter 1** - Don't skip! It sets up the mental model.
2. **Do the labs** - Hands-on practice is essential.
3. **Complete the exercises** - They reinforce concepts.
4. **Answer reflection questions** - They help internalize learning.
5. **Check the self-check lists** - Verify understanding before moving on.

## Getting Started

```bash
# Clone this repo
git clone <this-repo>
cd design-system-course

# Start with Chapter 1
open chapters/01-understanding/README.md
```

## Resources

### Books
- "Design Systems" by Alla Kholmatova
- "Atomic Design" by Brad Frost (free online)

### Documentation
- [Turborepo Docs](https://turbo.build/repo/docs)
- [Style Dictionary Docs](https://amzn.github.io/style-dictionary)
- [Storybook Docs](https://storybook.js.org/docs)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)

### Community
- [Design Systems Slack](https://design.systems/slack)
- [Storybook Discord](https://discord.gg/storybook)

---

Good luck on your design system journey!
