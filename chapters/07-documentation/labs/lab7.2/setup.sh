#!/bin/bash

# Lab 7.2 Setup Script
# Creates Button stories for Storybook

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
UI_DIR="$MONOREPO_DIR/packages/ui"
COMPONENTS_DIR="$UI_DIR/src/components"

echo "=== Lab 7.2 Setup: Write Button Stories ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if Lab 7.1 is complete
DOCS_DIR="$MONOREPO_DIR/apps/docs"
if [ ! -d "$DOCS_DIR/.storybook" ]; then
    echo "Error: Storybook not set up."
    echo "Please complete Lab 7.1 first."
    exit 1
fi

# Check if Button component exists
if [ ! -f "$COMPONENTS_DIR/Button.tsx" ]; then
    echo "Warning: Button.tsx not found."
    echo "Stories may not work without the component."
fi

# Create Button stories
STORIES_FILE="$COMPONENTS_DIR/Button.stories.tsx"
if [ -f "$STORIES_FILE" ]; then
    echo "Button.stories.tsx already exists. Skipping."
else
    echo "Creating Button.stories.tsx..."
    cat > "$STORIES_FILE" << 'EOF'
import type { Meta, StoryObj } from "@storybook/react";
import { Button } from "./Button";

const meta: Meta<typeof Button> = {
  title: "Components/Button",
  component: Button,
  tags: ["autodocs"],
  argTypes: {
    variant: {
      control: "select",
      options: ["primary", "secondary", "destructive", "outline", "ghost", "link"],
      description: "The visual style of the button",
    },
    size: {
      control: "select",
      options: ["sm", "md", "lg", "icon"],
      description: "The size of the button",
    },
    disabled: {
      control: "boolean",
      description: "Disables the button",
    },
    children: {
      control: "text",
      description: "Button content",
    },
  },
  args: {
    children: "Button",
    variant: "primary",
    size: "md",
    disabled: false,
  },
};

export default meta;
type Story = StoryObj<typeof Button>;

// Variant stories
export const Primary: Story = {
  args: {
    variant: "primary",
    children: "Primary Button",
  },
};

export const Secondary: Story = {
  args: {
    variant: "secondary",
    children: "Secondary Button",
  },
};

export const Destructive: Story = {
  args: {
    variant: "destructive",
    children: "Delete Item",
  },
};

export const Outline: Story = {
  args: {
    variant: "outline",
    children: "Outline Button",
  },
};

export const Ghost: Story = {
  args: {
    variant: "ghost",
    children: "Ghost Button",
  },
};

export const Link: Story = {
  args: {
    variant: "link",
    children: "Link Button",
  },
};

// Size stories
export const Small: Story = {
  args: {
    size: "sm",
    children: "Small",
  },
};

export const Medium: Story = {
  args: {
    size: "md",
    children: "Medium",
  },
};

export const Large: Story = {
  args: {
    size: "lg",
    children: "Large Button",
  },
};

// State stories
export const Disabled: Story = {
  args: {
    disabled: true,
    children: "Disabled",
  },
};

// Showcase stories
export const AllVariants: Story = {
  render: () => (
    <div className="flex flex-wrap gap-4">
      <Button variant="primary">Primary</Button>
      <Button variant="secondary">Secondary</Button>
      <Button variant="destructive">Destructive</Button>
      <Button variant="outline">Outline</Button>
      <Button variant="ghost">Ghost</Button>
      <Button variant="link">Link</Button>
    </div>
  ),
};

export const AllSizes: Story = {
  render: () => (
    <div className="flex items-center gap-4">
      <Button size="sm">Small</Button>
      <Button size="md">Medium</Button>
      <Button size="lg">Large</Button>
    </div>
  ),
};

export const VariantsBySize: Story = {
  render: () => (
    <div className="space-y-4">
      <div className="flex items-center gap-4">
        <Button variant="primary" size="sm">Primary SM</Button>
        <Button variant="primary" size="md">Primary MD</Button>
        <Button variant="primary" size="lg">Primary LG</Button>
      </div>
      <div className="flex items-center gap-4">
        <Button variant="secondary" size="sm">Secondary SM</Button>
        <Button variant="secondary" size="md">Secondary MD</Button>
        <Button variant="secondary" size="lg">Secondary LG</Button>
      </div>
      <div className="flex items-center gap-4">
        <Button variant="outline" size="sm">Outline SM</Button>
        <Button variant="outline" size="md">Outline MD</Button>
        <Button variant="outline" size="lg">Outline LG</Button>
      </div>
    </div>
  ),
};
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $STORIES_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Run Storybook: cd $DOCS_DIR && pnpm dev"
echo "  3. View Button stories at http://localhost:6006"
echo "  4. Test the Controls panel"
echo ""
