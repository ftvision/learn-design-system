#!/bin/bash

# Lab 9.2 Setup Script
# Creates Modal and Select UI components

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
UI_DIR="$MONOREPO_DIR/packages/ui"
COMPONENTS_DIR="$UI_DIR/src/components"

echo "=== Lab 9.2 Setup: Modal & Select Components ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if UI package exists
if [ ! -d "$UI_DIR" ]; then
    echo "Error: UI package not found at $UI_DIR"
    exit 1
fi

# Create Modal component
MODAL_FILE="$COMPONENTS_DIR/Modal.tsx"
if [ -f "$MODAL_FILE" ]; then
    echo "Modal.tsx already exists. Skipping."
else
    echo "Creating Modal.tsx..."
    cat > "$MODAL_FILE" << 'EOF'
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
EOF
fi

# Create Select component
SELECT_FILE="$COMPONENTS_DIR/Select.tsx"
if [ -f "$SELECT_FILE" ]; then
    echo "Select.tsx already exists. Skipping."
else
    echo "Creating Select.tsx..."
    cat > "$SELECT_FILE" << 'EOF'
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
EOF
fi

# Create Modal stories
MODAL_STORIES="$COMPONENTS_DIR/Modal.stories.tsx"
if [ -f "$MODAL_STORIES" ]; then
    echo "Modal.stories.tsx already exists. Skipping."
else
    echo "Creating Modal.stories.tsx..."
    cat > "$MODAL_STORIES" << 'EOF'
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
EOF
fi

# Create Select stories
SELECT_STORIES="$COMPONENTS_DIR/Select.stories.tsx"
if [ -f "$SELECT_STORIES" ]; then
    echo "Select.stories.tsx already exists. Skipping."
else
    echo "Creating Select.stories.tsx..."
    cat > "$SELECT_STORIES" << 'EOF'
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
EOF
fi

echo ""
echo "=== Updating index.tsx exports ==="
INDEX_FILE="$UI_DIR/src/index.tsx"
if grep -q "Modal" "$INDEX_FILE" 2>/dev/null; then
    echo "Modal already exported in index.tsx"
else
    echo "Adding Modal export..."
    echo "" >> "$INDEX_FILE"
    echo "export {" >> "$INDEX_FILE"
    echo "  Modal," >> "$INDEX_FILE"
    echo "  ModalHeader," >> "$INDEX_FILE"
    echo "  ModalTitle," >> "$INDEX_FILE"
    echo "  ModalBody," >> "$INDEX_FILE"
    echo "  ModalFooter," >> "$INDEX_FILE"
    echo "} from \"./components/Modal\";" >> "$INDEX_FILE"
fi

if grep -q "Select" "$INDEX_FILE" 2>/dev/null; then
    echo "Select already exported in index.tsx"
else
    echo "Adding Select export..."
    echo "export { Select, type SelectOption } from \"./components/Select\";" >> "$INDEX_FILE"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $MODAL_FILE"
echo "  - $SELECT_FILE"
echo "  - $MODAL_STORIES"
echo "  - $SELECT_STORIES"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Run Storybook to view the components"
echo "  3. Verify theme toggle works on both components"
echo "  4. Proceed to Lab 9.3 to build app components"
echo ""
