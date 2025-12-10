# Lab 7.4: Write Badge & Avatar Stories

## Objective

Create Storybook stories for Badge and Avatar components, demonstrating status indicators and user imagery.

## Time Estimate

~20 minutes

## Prerequisites

- Completed Lab 7.3 (Input & Card stories)
- Badge and Avatar components exist in UI package

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that previous labs are complete
2. Create Badge.stories.tsx
3. Create Avatar.stories.tsx

### Manual Setup

Navigate to your UI package:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/packages/ui/src/components
```

## Exercises

### Exercise 1: Study Badge Stories

Badges are simple components with variant-focused stories:

```tsx
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
```

**Badge patterns:**
- Status indicators: success, warning, error
- Categories/tags: default, primary
- Outline for subtle emphasis

### Exercise 2: AllVariants Showcase

For simple components, showcase stories are valuable:

```tsx
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

This lets viewers see all options at once.

### Exercise 3: Study Avatar Stories

Avatars have more complex behavior:

```tsx
argTypes: {
  size: {
    control: "select",
    options: ["xs", "sm", "md", "lg", "xl"],
  },
  src: {
    control: "text",
    description: "Image URL",
  },
  alt: {
    control: "text",
    description: "Alt text (also used for fallback initials)",
  },
  fallback: {
    control: "text",
    description: "Fallback text when image fails",
  },
},
```

**Avatar states:**
- With image: Shows the image
- Without image: Shows initials fallback
- Broken image: Falls back gracefully

### Exercise 4: Testing Image Fallbacks

Avatar stories should test edge cases:

```tsx
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
    src: "https://broken-url.com/404.jpg",
    alt: "Jane Smith",
  },
};
```

**Testing tip:** Use a deliberately broken URL to test fallback behavior.

### Exercise 5: Size Showcase

For components with size variants, show them together:

```tsx
export const AllSizes: Story = {
  render: () => (
    <div className="flex items-center gap-4">
      <Avatar size="xs" src="..." alt="User" />
      <Avatar size="sm" src="..." alt="User" />
      <Avatar size="md" src="..." alt="User" />
      <Avatar size="lg" src="..." alt="User" />
      <Avatar size="xl" src="..." alt="User" />
    </div>
  ),
};
```

**Design tip:** Use `items-center` to align different-sized avatars.

## Key Concepts

### Status Badge Usage

| Variant | Use Case | Example |
|---------|----------|---------|
| `success` | Positive status | "Active", "Paid" |
| `warning` | Needs attention | "Pending", "Review" |
| `error` | Problem/negative | "Failed", "Overdue" |
| `primary` | Highlighted info | "New", "Featured" |
| `default` | Neutral category | "Tag", "Category" |
| `outline` | Subtle indicator | "Draft", "v2.0" |

### Avatar Fallback Strategy

```
1. Try to load src image
   └─ Success → Show image
   └─ Fail → Use fallback prop
      └─ Has fallback → Show fallback text
      └─ No fallback → Generate from alt
         └─ "John Doe" → "JD"
```

### Documenting Visual Components

For visual components like Badge and Avatar:

1. **Individual variants** - One story per variant
2. **Showcase story** - All variants together
3. **Size story** - All sizes compared
4. **Edge cases** - Broken images, long text

### Using External Images

For avatar stories, use reliable placeholder services:
- `https://i.pravatar.cc/150?u={id}` - Random faces
- `https://picsum.photos/150` - Random photos
- `https://via.placeholder.com/150` - Solid colors

## Checklist

Before proceeding to Lab 7.5:

- [ ] Badge.stories.tsx created
- [ ] Badge stories cover all variants
- [ ] AllVariants showcase story works
- [ ] Avatar.stories.tsx created
- [ ] Avatar stories cover: with image, fallback, broken image
- [ ] AllSizes story shows size comparison
- [ ] Stories appear in Storybook sidebar

## Troubleshooting

### Images not loading in stories

1. Check network connectivity
2. Try different placeholder service
3. Verify URL is complete (https://)

### Badge text overflowing

Badge component should handle text:
```tsx
<Badge className="truncate max-w-[100px]">Very Long Badge Text</Badge>
```

### Avatar initials not generating

Check Avatar component logic:
```tsx
const initials = alt
  ?.split(" ")
  .map((n) => n[0])
  .join("")
  .toUpperCase()
  .slice(0, 2);
```

### Sizes not aligned

Use flexbox with alignment:
```tsx
<div className="flex items-center gap-4">
  {/* Avatars align on center */}
</div>
```

## Next

Proceed to Lab 7.5 to add theme toggle and test Storybook.
