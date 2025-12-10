# Lab 9.2: Build Modal & Select Components

## Objective

Build the Modal and Select UI components for the capstone project. These are reusable primitives that will be used by the app components.

## Time Estimate

~45 minutes

## Prerequisites

- Completed Lab 9.1 (types and mock data)
- Understanding of CSS variables for theming
- Familiarity with React hooks (useEffect, useId)

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Create Modal.tsx with ModalHeader, ModalTitle, ModalBody, ModalFooter
2. Create Select.tsx component
3. Create Storybook stories for both
4. Update index.tsx exports

### Manual Setup

Navigate to UI package:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/packages/ui/src/components
```

## Exercises

### Exercise 1: Build Modal Component

Create `packages/ui/src/components/Modal.tsx`:

```tsx
"use client";

import * as React from "react";
import { cn } from "../lib/utils";

interface ModalProps {
  open: boolean;
  onClose: () => void;
  children: React.ReactNode;
  className?: string;
}

export function Modal({ open, onClose, children, className }: ModalProps) {
  // Close on escape key
  React.useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === "Escape") onClose();
    };
    if (open) {
      document.addEventListener("keydown", handleEscape);
      document.body.style.overflow = "hidden";
    }
    return () => {
      document.removeEventListener("keydown", handleEscape);
      document.body.style.overflow = "";
    };
  }, [open, onClose]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      {/* Backdrop */}
      <div
        className="fixed inset-0 bg-black/50 backdrop-blur-sm"
        onClick={onClose}
        aria-hidden="true"
      />
      {/* Modal content */}
      <div
        role="dialog"
        aria-modal="true"
        className={cn(
          "relative z-50 w-full max-w-lg mx-4",
          "bg-[var(--color-bg)] rounded-lg shadow-lg",
          "border border-[var(--color-border)]",
          className
        )}
      >
        {children}
      </div>
    </div>
  );
}
```

**Key features:**
- Escape key closes the modal
- Body scroll locked when open
- Backdrop click closes
- Uses CSS variables for theming

### Exercise 2: Add Modal Sub-components

Add to `Modal.tsx`:

```tsx
export function ModalHeader({
  className,
  children,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn(
        "px-6 py-4 border-b border-[var(--color-border)]",
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
}

export function ModalTitle({
  className,
  ...props
}: React.HTMLAttributes<HTMLHeadingElement>) {
  return (
    <h2
      className={cn(
        "text-lg font-semibold text-[var(--color-text)]",
        className
      )}
      {...props}
    />
  );
}

export function ModalBody({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("px-6 py-4", className)} {...props} />;
}

export function ModalFooter({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn(
        "px-6 py-4 border-t border-[var(--color-border)] flex justify-end gap-2",
        className
      )}
      {...props}
    />
  );
}
```

### Exercise 3: Build Select Component

Create `packages/ui/src/components/Select.tsx`:

```tsx
import * as React from "react";
import { cn } from "../lib/utils";

export interface SelectOption {
  value: string;
  label: string;
}

interface SelectProps
  extends Omit<React.SelectHTMLAttributes<HTMLSelectElement>, "onChange"> {
  options: SelectOption[];
  label?: string;
  error?: string;
  onChange?: (value: string) => void;
}

export const Select = React.forwardRef<HTMLSelectElement, SelectProps>(
  ({ className, options, label, error, onChange, id, ...props }, ref) => {
    const selectId = id || React.useId();

    return (
      <div className="w-full">
        {label && (
          <label
            htmlFor={selectId}
            className="block text-sm font-medium text-[var(--color-text)] mb-1.5"
          >
            {label}
          </label>
        )}
        <select
          ref={ref}
          id={selectId}
          className={cn(
            "flex h-10 w-full rounded-md border px-3 py-2 text-sm",
            "bg-[var(--color-bg)] text-[var(--color-text)]",
            "border-[var(--color-border)]",
            "focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]",
            "disabled:cursor-not-allowed disabled:opacity-50",
            error && "border-[var(--color-error)]",
            className
          )}
          onChange={(e) => onChange?.(e.target.value)}
          {...props}
        >
          {options.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
        {error && (
          <p className="mt-1 text-sm text-[var(--color-error)]">{error}</p>
        )}
      </div>
    );
  }
);
Select.displayName = "Select";
```

### Exercise 4: Write Modal Stories

Create `packages/ui/src/components/Modal.stories.tsx`:

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { useState } from "react";
import { Modal, ModalHeader, ModalTitle, ModalBody, ModalFooter } from "./Modal";
import { Button } from "./Button";
import { Input } from "./Input";

const meta: Meta<typeof Modal> = {
  title: "Components/Modal",
  component: Modal,
  tags: ["autodocs"],
  parameters: {
    layout: "centered",
  },
};

export default meta;
type Story = StoryObj<typeof Modal>;

export const Default: Story = {
  render: () => {
    const [open, setOpen] = useState(false);
    return (
      <>
        <Button onClick={() => setOpen(true)}>Open Modal</Button>
        <Modal open={open} onClose={() => setOpen(false)}>
          <ModalHeader>
            <ModalTitle>Modal Title</ModalTitle>
          </ModalHeader>
          <ModalBody>
            <p className="text-[var(--color-text-muted)]">
              This is the modal body content.
            </p>
          </ModalBody>
          <ModalFooter>
            <Button variant="ghost" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button onClick={() => setOpen(false)}>Confirm</Button>
          </ModalFooter>
        </Modal>
      </>
    );
  },
};

export const WithForm: Story = {
  render: () => {
    const [open, setOpen] = useState(false);
    return (
      <>
        <Button onClick={() => setOpen(true)}>Open Form Modal</Button>
        <Modal open={open} onClose={() => setOpen(false)}>
          <ModalHeader>
            <ModalTitle>Edit Profile</ModalTitle>
          </ModalHeader>
          <ModalBody className="space-y-4">
            <Input label="Name" placeholder="Enter your name" />
            <Input label="Email" type="email" placeholder="Enter your email" />
          </ModalBody>
          <ModalFooter>
            <Button variant="ghost" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button onClick={() => setOpen(false)}>Save</Button>
          </ModalFooter>
        </Modal>
      </>
    );
  },
};

export const Confirmation: Story = {
  render: () => {
    const [open, setOpen] = useState(false);
    return (
      <>
        <Button variant="secondary" onClick={() => setOpen(true)}>
          Delete Item
        </Button>
        <Modal open={open} onClose={() => setOpen(false)}>
          <ModalHeader>
            <ModalTitle>Confirm Delete</ModalTitle>
          </ModalHeader>
          <ModalBody>
            <p className="text-[var(--color-text-muted)]">
              Are you sure you want to delete this item? This action cannot be
              undone.
            </p>
          </ModalBody>
          <ModalFooter>
            <Button variant="ghost" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button
              className="bg-[var(--color-error)] hover:bg-red-600"
              onClick={() => setOpen(false)}
            >
              Delete
            </Button>
          </ModalFooter>
        </Modal>
      </>
    );
  },
};
```

### Exercise 5: Write Select Stories

Create `packages/ui/src/components/Select.stories.tsx`:

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { Select } from "./Select";

const meta: Meta<typeof Select> = {
  title: "Components/Select",
  component: Select,
  tags: ["autodocs"],
  argTypes: {
    label: { control: "text" },
    error: { control: "text" },
    disabled: { control: "boolean" },
  },
};

export default meta;
type Story = StoryObj<typeof Select>;

const roleOptions = [
  { value: "admin", label: "Admin" },
  { value: "member", label: "Member" },
  { value: "guest", label: "Guest" },
];

export const Default: Story = {
  args: {
    options: roleOptions,
  },
};

export const WithLabel: Story = {
  args: {
    label: "Select Role",
    options: roleOptions,
  },
};

export const WithError: Story = {
  args: {
    label: "Select Role",
    options: roleOptions,
    error: "Please select a role",
  },
};

export const Disabled: Story = {
  args: {
    label: "Select Role",
    options: roleOptions,
    disabled: true,
  },
};

export const CountrySelect: Story = {
  args: {
    label: "Country",
    options: [
      { value: "us", label: "United States" },
      { value: "uk", label: "United Kingdom" },
      { value: "ca", label: "Canada" },
      { value: "au", label: "Australia" },
    ],
  },
};
```

### Exercise 6: Update Exports

Update `packages/ui/src/index.tsx`:

```tsx
// Add these exports
export {
  Modal,
  ModalHeader,
  ModalTitle,
  ModalBody,
  ModalFooter,
} from "./components/Modal";
export { Select, type SelectOption } from "./components/Select";
```

## Key Concepts

### Modal Accessibility

| Feature | Implementation |
|---------|----------------|
| Escape key | `useEffect` with keydown listener |
| Focus trap | aria-modal="true" |
| Backdrop click | onClick handler on overlay |
| Body scroll lock | document.body.style.overflow |

### CSS Variable Usage

All colors use CSS variables for theme support:

```tsx
// Good - uses theme variables
className="bg-[var(--color-bg)] text-[var(--color-text)]"

// Bad - hardcoded colors
className="bg-white text-gray-900"
```

### Compound Components Pattern

Modal uses the compound component pattern:

```tsx
<Modal open={open} onClose={onClose}>
  <ModalHeader>...</ModalHeader>
  <ModalBody>...</ModalBody>
  <ModalFooter>...</ModalFooter>
</Modal>
```

This provides flexibility while maintaining structure.

## Checklist

Before proceeding to Lab 9.3:

- [ ] Modal component created with all sub-components
- [ ] Select component created with label and error states
- [ ] Modal stories show default, form, and confirmation variants
- [ ] Select stories show label, error, and disabled states
- [ ] Both components use CSS variables for colors
- [ ] Index exports updated

## Troubleshooting

### Modal doesn't close on escape

Check that `useEffect` dependencies include `open` and `onClose`:
```tsx
React.useEffect(() => {
  // ...
}, [open, onClose]);  // Both required
```

### Select onChange not firing

Ensure you're using the custom onChange prop:
```tsx
onChange={(value) => console.log(value)}  // Correct
onChange={(e) => console.log(e.target.value)}  // Won't work with our API
```

### Storybook not showing stories

Run `npm run storybook` from the monorepo root or packages/ui directory.

## Next

Proceed to Lab 9.3 to build the TeamMemberRow and InviteMemberModal app components.
