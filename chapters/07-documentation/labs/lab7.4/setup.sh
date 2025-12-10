#!/bin/bash

# Lab 7.4 Setup Script
# Creates Badge and Avatar stories for Storybook

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
UI_DIR="$MONOREPO_DIR/packages/ui"
COMPONENTS_DIR="$UI_DIR/src/components"

echo "=== Lab 7.4 Setup: Write Badge & Avatar Stories ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if previous labs are complete
if [ ! -f "$COMPONENTS_DIR/Input.stories.tsx" ]; then
    echo "Warning: Input.stories.tsx not found."
    echo "Please complete Lab 7.3 first."
fi

# Create Badge stories
BADGE_STORIES="$COMPONENTS_DIR/Badge.stories.tsx"
if [ -f "$BADGE_STORIES" ]; then
    echo "Badge.stories.tsx already exists. Skipping."
else
    echo "Creating Badge.stories.tsx..."
    cat > "$BADGE_STORIES" << 'EOF'
import type { Meta, StoryObj } from "@storybook/react";
import { Badge } from "./Badge";

const meta: Meta<typeof Badge> = {
  title: "Components/Badge",
  component: Badge,
  tags: ["autodocs"],
  argTypes: {
    variant: {
      control: "select",
      options: ["default", "primary", "success", "warning", "error", "outline"],
      description: "Visual style of the badge",
    },
    children: {
      control: "text",
      description: "Badge content",
    },
  },
  args: {
    children: "Badge",
    variant: "default",
  },
};

export default meta;
type Story = StoryObj<typeof Badge>;

export const Default: Story = {
  args: { variant: "default", children: "Default" },
};

export const Primary: Story = {
  args: { variant: "primary", children: "Primary" },
};

export const Success: Story = {
  args: { variant: "success", children: "Success" },
};

export const Warning: Story = {
  args: { variant: "warning", children: "Warning" },
};

export const Error: Story = {
  args: { variant: "error", children: "Error" },
};

export const Outline: Story = {
  args: { variant: "outline", children: "Outline" },
};

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

export const StatusExamples: Story = {
  render: () => (
    <div className="space-y-4">
      <div className="flex items-center gap-2">
        <span className="text-sm w-20">Orders:</span>
        <Badge variant="success">Paid</Badge>
        <Badge variant="warning">Pending</Badge>
        <Badge variant="error">Failed</Badge>
      </div>
      <div className="flex items-center gap-2">
        <span className="text-sm w-20">Users:</span>
        <Badge variant="primary">Admin</Badge>
        <Badge variant="default">Member</Badge>
        <Badge variant="outline">Guest</Badge>
      </div>
    </div>
  ),
};
EOF
fi

# Create Avatar stories
AVATAR_STORIES="$COMPONENTS_DIR/Avatar.stories.tsx"
if [ -f "$AVATAR_STORIES" ]; then
    echo "Avatar.stories.tsx already exists. Skipping."
else
    echo "Creating Avatar.stories.tsx..."
    cat > "$AVATAR_STORIES" << 'EOF'
import type { Meta, StoryObj } from "@storybook/react";
import { Avatar } from "./Avatar";

const meta: Meta<typeof Avatar> = {
  title: "Components/Avatar",
  component: Avatar,
  tags: ["autodocs"],
  argTypes: {
    size: {
      control: "select",
      options: ["xs", "sm", "md", "lg", "xl"],
      description: "Size of the avatar",
    },
    src: {
      control: "text",
      description: "Image URL",
    },
    alt: {
      control: "text",
      description: "Alt text for accessibility",
    },
  },
  args: {
    size: "md",
    alt: "User",
  },
};

export default meta;
type Story = StoryObj<typeof Avatar>;

export const WithImage: Story = {
  args: {
    src: "https://i.pravatar.cc/150?u=1",
    alt: "John Doe",
  },
};

export const WithFallback: Story = {
  args: {
    alt: "John Doe",
  },
};

export const WithBrokenImage: Story = {
  args: {
    src: "https://broken-image-url.com/404.jpg",
    alt: "Jane Smith",
  },
};

export const ExtraSmall: Story = {
  args: {
    size: "xs",
    src: "https://i.pravatar.cc/150?u=2",
    alt: "User",
  },
};

export const Small: Story = {
  args: {
    size: "sm",
    src: "https://i.pravatar.cc/150?u=3",
    alt: "User",
  },
};

export const Medium: Story = {
  args: {
    size: "md",
    src: "https://i.pravatar.cc/150?u=4",
    alt: "User",
  },
};

export const Large: Story = {
  args: {
    size: "lg",
    src: "https://i.pravatar.cc/150?u=5",
    alt: "User",
  },
};

export const ExtraLarge: Story = {
  args: {
    size: "xl",
    src: "https://i.pravatar.cc/150?u=6",
    alt: "User",
  },
};

export const AllSizes: Story = {
  render: () => (
    <div className="flex items-center gap-4">
      <Avatar size="xs" src="https://i.pravatar.cc/150?u=1" alt="User" />
      <Avatar size="sm" src="https://i.pravatar.cc/150?u=2" alt="User" />
      <Avatar size="md" src="https://i.pravatar.cc/150?u=3" alt="User" />
      <Avatar size="lg" src="https://i.pravatar.cc/150?u=4" alt="User" />
      <Avatar size="xl" src="https://i.pravatar.cc/150?u=5" alt="User" />
    </div>
  ),
};

export const FallbackSizes: Story = {
  render: () => (
    <div className="flex items-center gap-4">
      <Avatar size="xs" alt="Alice Brown" />
      <Avatar size="sm" alt="Bob Clark" />
      <Avatar size="md" alt="Carol Davis" />
      <Avatar size="lg" alt="Dan Evans" />
      <Avatar size="xl" alt="Eve Foster" />
    </div>
  ),
};

export const AvatarGroup: Story = {
  render: () => (
    <div className="flex -space-x-2">
      <Avatar size="md" src="https://i.pravatar.cc/150?u=10" alt="User 1" className="ring-2 ring-white" />
      <Avatar size="md" src="https://i.pravatar.cc/150?u=11" alt="User 2" className="ring-2 ring-white" />
      <Avatar size="md" src="https://i.pravatar.cc/150?u=12" alt="User 3" className="ring-2 ring-white" />
      <Avatar size="md" alt="+5" className="ring-2 ring-white" />
    </div>
  ),
};
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $BADGE_STORIES"
echo "  - $AVATAR_STORIES"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Run Storybook to view the stories"
echo "  3. Proceed to Lab 7.5 for theme toggle and testing"
echo ""
