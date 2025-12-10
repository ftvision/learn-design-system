# Lab 7.3: Write Input & Card Stories

## Objective

Create Storybook stories for Input and Card components, demonstrating form patterns and content containers.

## Time Estimate

~30 minutes

## Prerequisites

- Completed Lab 7.2 (Button stories)
- Input and Card components exist in UI package

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that previous labs are complete
2. Create Input.stories.tsx
3. Create Card.stories.tsx

### Manual Setup

Navigate to your UI package:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/packages/ui/src/components
```

## Exercises

### Exercise 1: Study Input Stories

Open `Input.stories.tsx` and examine the structure:

```tsx
const meta: Meta<typeof Input> = {
  title: "Components/Input",
  component: Input,
  tags: ["autodocs"],
  argTypes: {
    label: { control: "text" },
    placeholder: { control: "text" },
    error: { control: "text" },
    hint: { control: "text" },
    disabled: { control: "boolean" },
    type: {
      control: "select",
      options: ["text", "email", "password", "number", "tel", "url"],
    },
  },
};
```

**Input-specific patterns:**
- `error` prop for validation states
- `hint` prop for helper text
- `type` prop for different input modes

### Exercise 2: Form Example Story

The FormExample story shows real-world usage:

```tsx
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

**Why include composite stories?**
- Show components in context
- Demonstrate spacing/layout
- Real-world validation scenarios

### Exercise 3: Study Card Stories

Cards are compound components with multiple parts:

```tsx
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from "./Card";
```

Each part has a purpose:
- `Card` - Container with border/shadow
- `CardHeader` - Top section for title/description
- `CardTitle` - Heading text
- `CardDescription` - Subtitle text
- `CardContent` - Main content area
- `CardFooter` - Bottom section for actions

### Exercise 4: Compound Component Stories

Cards need stories showing composition:

```tsx
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
```

**Pattern:** For compound components, use `render` to show the composition.

### Exercise 5: Cross-Component Stories

The FormCard story combines multiple components:

```tsx
export const FormCard: Story = {
  render: () => (
    <Card className="max-w-md">
      <CardHeader>
        <CardTitle>Create Account</CardTitle>
        <CardDescription>Enter your details.</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <Input label="Name" placeholder="John Doe" />
        <Input label="Email" type="email" />
        <Input label="Password" type="password" />
      </CardContent>
      <CardFooter>
        <Button className="w-full">Create Account</Button>
      </CardFooter>
    </Card>
  ),
};
```

**Benefits:**
- Shows how components work together
- Documents real usage patterns
- Useful for design review

## Key Concepts

### Story Types by Component

| Component Type | Story Focus | Example Stories |
|---------------|-------------|-----------------|
| **Simple** (Button) | Props/variants | Primary, Secondary, Sizes |
| **Form** (Input) | States, validation | WithError, WithHint |
| **Compound** (Card) | Composition | WithHeader, WithFooter |
| **Combined** | Integration | FormCard, FormExample |

### Documenting Compound Components

Options for compound components:

**Option 1: Separate stories per sub-component**
```
Card/
├── Card
├── CardHeader
├── CardTitle
└── CardFooter
```

**Option 2: Combined stories (recommended)**
```
Card/
├── Simple
├── WithHeader
├── WithFooter
└── FormCard
```

Combined stories better show real usage.

### Input States Matrix

Document all input states:

| State | Props | Visual |
|-------|-------|--------|
| Default | - | Normal border |
| With value | `value="text"` | Text displayed |
| Focused | (CSS) | Focus ring |
| Disabled | `disabled` | Grayed out |
| Error | `error="message"` | Red border + message |

### ArgTypes for Inputs

Common argTypes for form components:

```tsx
argTypes: {
  value: { control: "text" },
  defaultValue: { control: "text" },
  placeholder: { control: "text" },
  disabled: { control: "boolean" },
  required: { control: "boolean" },
  error: { control: "text" },
  onChange: { action: "changed" },  // Logs to Actions panel
}
```

## Checklist

Before proceeding to Lab 7.4:

- [ ] Input.stories.tsx created
- [ ] Input stories cover: default, with label, with error, disabled
- [ ] FormExample story shows inputs in context
- [ ] Card.stories.tsx created
- [ ] Card stories show compound composition
- [ ] FormCard combines Input, Button, Card
- [ ] Stories appear in Storybook sidebar

## Troubleshooting

### Card sub-components not exported

Check UI package index.tsx exports:
```tsx
export { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from "./components/Card";
```

### Input error state not showing

Verify Input component accepts `error` prop and styles it:
```tsx
<Input error="This is an error" />
```

### Form layout issues

Wrap inputs in a container with spacing:
```tsx
<div className="space-y-4">
  <Input ... />
  <Input ... />
</div>
```

### Actions panel not showing onChange

Add action argType:
```tsx
argTypes: {
  onChange: { action: "changed" },
}
```

## Next

Proceed to Lab 7.4 to write Badge and Avatar stories.
