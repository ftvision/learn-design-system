# Lecture Notes: Understanding Design Systems (Part 1 - Theory)

**Duration:** 30-45 minutes
**Chapter:** 01 - Understanding Design Systems

---

## Lecture Outline

1. Opening Question
2. Defining Design Systems (The Misconception vs. Reality)
3. The 5-Layer Model
4. Two Types of Design Systems
5. The Monorepo Architecture
6. Key Takeaways

---

## 1. Opening Question (3 minutes)

> **Ask the class:** "When I say 'design system,' what comes to mind?"

**Expected answers:** Component library, Figma files, style guide, color palette, Bootstrap, Material UI...

**Instructor note:** Write these on the board. Most answers will focus on UI components or visual design. This sets up the key insight: design systems are *much more* than component libraries.

---

## 2. Defining Design Systems: The Misconception vs. Reality (5 minutes)

### The Common Misconception

"A design system is a collection of reusable UI components."

### The Reality

A design system is a **complete, layered architecture** that connects design decisions to implementation across your entire product.

**Key definition:**
> A design system is the single source of truth that groups all the elements that allow teams to design, realize, and develop a product.

Think of it as the **DNA of your product**—it encodes how everything should look, behave, and connect together.

---

## 3. The 5-Layer Model (15 minutes)

### Visual: The Layer Cake

```
┌─────────────────────────────────────────────────┐
│         Layer 5: Pages/Views                    │  ← /dashboard, /settings
│         (What users see)                        │
├─────────────────────────────────────────────────┤
│         Layer 4: App Components                 │  ← BookingCard, UserProfile
│         (Product-specific, with business logic) │
├─────────────────────────────────────────────────┤
│         Layer 3: Pattern Components             │  ← AuthForm, DataTable, Modal
│         (Composed, reusable patterns)           │
├─────────────────────────────────────────────────┤
│         Layer 2: Primitive Components           │  ← Button, Input, Card, Badge
│         (Basic UI building blocks)              │
├─────────────────────────────────────────────────┤
│         Layer 1: Design Tokens                  │  ← colors, spacing, typography
│         (The foundation - raw values)           │
└─────────────────────────────────────────────────┘
```

### Breaking Down Each Layer

#### Layer 1: Design Tokens (The Foundation)

**What:** Raw values that define your visual language.

**Examples:**
```css
--color-primary-500: #2196F3;
--spacing-md: 16px;
--font-size-lg: 1.25rem;
--radius-md: 8px;
```

**Why it matters:** Change `--color-primary-500` once, and every button, link, and accent across your app updates automatically.

**Analogy:** Design tokens are like the **ingredients** in a kitchen. You can't make a dish without them, but they're not a dish by themselves.

---

#### Layer 2: Primitive Components (The Building Blocks)

**What:** Basic, atomic UI elements with no business logic.

**Examples:**
- `<Button>` - clickable action
- `<Input>` - text entry
- `<Card>` - container
- `<Badge>` - status indicator

**Characteristics:**
- Generic and reusable
- No knowledge of your business domain
- Accept design tokens for styling
- Could be used by *any* product

**Analogy:** These are the **basic recipes**—a cake, a soup, a salad. Useful on their own, but need to be combined for a full meal.

---

#### Layer 3: Pattern Components (The Compositions)

**What:** Combinations of primitives that solve common UI problems.

**Examples:**
- `<AuthForm>` = Input + Input + Button + validation
- `<DataTable>` = Table + Pagination + Sorting + Filtering
- `<SearchBar>` = Input + Button + Dropdown

**Characteristics:**
- More opinionated than primitives
- Still reusable across different contexts
- May have some internal state

**Analogy:** These are **standard dishes** like "Caesar Salad" or "Tomato Soup"—they combine ingredients in a known way.

---

#### Layer 4: App Components (The Product-Specific)

**What:** Components unique to your product that contain business logic.

**Examples (for a booking app like Cal.com):**
- `<BookingCard>` - displays booking with cancel/reschedule actions
- `<AvailabilityCalendar>` - shows available time slots
- `<UserProfileHeader>` - displays user info with edit capability

**Characteristics:**
- Know about your data models
- Contain business logic (data fetching, mutations)
- Not meant to be shared outside your product
- Compose primitives and patterns

**Analogy:** These are **signature dishes** unique to your restaurant—they use standard ingredients and techniques but represent *your* product.

---

#### Layer 5: Pages/Views (The Final Product)

**What:** Complete screens that users interact with.

**Examples:**
- `/dashboard` - combines multiple app components
- `/settings/profile` - user settings page
- `/booking/[id]` - booking detail page

**Characteristics:**
- Route-level components
- Orchestrate data and components
- Handle page-level state and navigation

**Analogy:** The **complete meal experience**—everything plated and served together.

---

### Discussion Point: Where Do Most Tutorials Stop?

> **Ask:** "When you follow a tutorial to 'build a design system,' which layer do you usually end up at?"

**Answer:** Layer 2 (primitives). Most tutorials teach you to build a Button, maybe a Card. But a real product needs all 5 layers working together.

**The gap:** Understanding how Layer 4 and Layer 5 connect to Layers 1-3 is what separates hobby projects from production applications.

---

## 4. Two Types of Design Systems (7 minutes)

### Type A: Generic UI Libraries

**Examples:** Chakra UI, Radix, shadcn/ui, Material UI

**Characteristics:**
| Aspect | Generic UI Library |
|--------|-------------------|
| Layers covered | 1-3 (tokens, primitives, some patterns) |
| Distribution | npm package |
| Audience | Many different products |
| Customization | You adapt it to your needs |
| Business logic | None |

**How you use them:**
```bash
npm install @radix-ui/react-button
```

Then customize for your product.

---

### Type B: Product Design Systems

**Examples:** Cal.com's internal system, Supabase's internal system

**Characteristics:**
| Aspect | Product Design System |
|--------|----------------------|
| Layers covered | 1-5 (everything) |
| Distribution | Internal monorepo package |
| Audience | One product (or product family) |
| Customization | Already customized for you |
| Business logic | Layers 4-5 include it |

**How you use them:**
```tsx
import { Button } from "@calcom/ui";
import { BookingCard } from "@/components/booking";
```

Already tailored to your product.

---

### The Key Question

> "Should I use Chakra/Radix/shadcn, or build my own?"

**Answer:** Both!

Most product design systems:
1. **Start with** a generic UI library (Radix primitives, for example)
2. **Wrap and customize** them in Layer 2
3. **Build Layers 3-5** on top

You're not choosing between them—you're choosing *where to start*.

---

## 5. The Monorepo Architecture (8 minutes)

### Why Do Cal.com and Supabase Use Monorepos?

```
my-product/
├── packages/
│   ├── tokens/           # Layer 1
│   ├── ui/               # Layers 2-3
│   └── config/           # Shared configs
├── apps/
│   ├── web/
│   │   ├── components/   # Layer 4
│   │   └── app/          # Layer 5
│   └── docs/             # Storybook
├── turbo.json
└── pnpm-workspace.yaml
```

### Benefits of Monorepo Structure

| Benefit | Explanation |
|---------|-------------|
| **Instant updates** | Change `packages/ui/Button` → immediately available in `apps/web/` |
| **No publishing overhead** | No need to npm publish for internal packages |
| **Shared types** | TypeScript types flow across packages |
| **Single clone** | One `git clone` gets everything |
| **Consistent versions** | All apps use the same version of UI |

### The Import Path

**From `apps/web/page.tsx`:**
```tsx
// Importing from the shared UI package
import { Button, Card } from "@mycompany/ui";

// Importing from app-specific components
import { BookingCard } from "@/components/booking";
```

**The `package.json` connection:**
```json
{
  "dependencies": {
    "@mycompany/ui": "workspace:*"
  }
}
```

`workspace:*` tells the package manager: "This dependency lives in this monorepo, not on npm."

---

### Discussion: When to Add Where?

> "You need to build a new component. How do you decide where it goes?"

**Add to `packages/ui/` when:**
- It's generic (could be used by any feature)
- It has no business logic
- It's a basic building block or common pattern
- Other apps in the monorepo might use it

**Add to `apps/web/components/` when:**
- It's specific to your product's domain
- It contains business logic (API calls, state management)
- It composes UI components with product-specific behavior
- Only this app needs it

---

## 6. Key Takeaways (2 minutes)

### Summary Slide

```
Design System = 5 Layers Working Together

    Tokens → Primitives → Patterns → App Components → Pages
      ↓          ↓           ↓              ↓            ↓
    Values   Building    Composed      Product      User
             Blocks      Patterns      Specific    Interface
```

### Three Things to Remember

1. **A design system is NOT just a component library** — it's a complete architecture from tokens to pages.

2. **Generic UI libraries (Layers 1-3) and product design systems (Layers 1-5) serve different purposes** — and you often use both together.

3. **Monorepos enable seamless flow** from shared packages to app-specific code, without publishing overhead.

---

## Looking Ahead

In the **lab section**, you'll:
- Clone Cal.com and explore its 5-layer structure
- Trace a component from a page down to its tokens
- Compare Cal.com's approach with Supabase's two-tier UI system

In **Chapter 2**, we'll dive deep into Layer 1: Design Tokens—the foundation everything else builds on.

---

## Discussion Questions for Class

1. Can you think of a component in your current project that's in the wrong layer?
2. Have you ever struggled because a component had business logic mixed with UI logic?
3. What would break in your app if you changed a color in 50 different places instead of one token?

---

## Additional Resources

- **Book:** "Design Systems" by Alla Kholmatova
- **Book:** "Atomic Design" by Brad Frost (free at atomicdesign.bradfrost.com)
- **Article:** [Cal.com Handbook: Monorepo](https://handbook.cal.com/engineering/codebase/monorepo-turborepo)
- **Video:** Any conference talk by Nathan Curtis on design systems
