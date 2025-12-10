#!/bin/bash

# Lab 7.3 Setup Script
# Creates Input and Card stories for Storybook

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
UI_DIR="$MONOREPO_DIR/packages/ui"
COMPONENTS_DIR="$UI_DIR/src/components"

echo "=== Lab 7.3 Setup: Write Input & Card Stories ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

# Check if Lab 7.2 is complete
if [ ! -f "$COMPONENTS_DIR/Button.stories.tsx" ]; then
    echo "Warning: Button.stories.tsx not found."
    echo "Please complete Lab 7.2 first."
fi

# Create Input stories
INPUT_STORIES="$COMPONENTS_DIR/Input.stories.tsx"
if [ -f "$INPUT_STORIES" ]; then
    echo "Input.stories.tsx already exists. Skipping."
else
    echo "Creating Input.stories.tsx..."
    cat > "$INPUT_STORIES" << 'EOF'
import type { Meta, StoryObj } from "@storybook/react";
import { Input } from "./Input";

const meta: Meta<typeof Input> = {
  title: "Components/Input",
  component: Input,
  tags: ["autodocs"],
  argTypes: {
    placeholder: {
      control: "text",
      description: "Placeholder text",
    },
    error: {
      control: "boolean",
      description: "Shows error state",
    },
    disabled: {
      control: "boolean",
      description: "Disables the input",
    },
    type: {
      control: "select",
      options: ["text", "email", "password", "number", "tel", "url"],
      description: "Input type",
    },
  },
  args: {
    placeholder: "Enter text...",
    type: "text",
    disabled: false,
    error: false,
  },
};

export default meta;
type Story = StoryObj<typeof Input>;

export const Default: Story = {};

export const WithPlaceholder: Story = {
  args: {
    placeholder: "you@example.com",
    type: "email",
  },
};

export const WithError: Story = {
  args: {
    placeholder: "Enter email",
    error: true,
  },
};

export const Disabled: Story = {
  args: {
    placeholder: "Cannot edit this",
    disabled: true,
  },
};

export const Password: Story = {
  args: {
    type: "password",
    placeholder: "Enter password",
  },
};

export const Number: Story = {
  args: {
    type: "number",
    placeholder: "0",
  },
};

// Form example
export const FormExample: Story = {
  render: () => (
    <form className="space-y-4 max-w-md">
      <div>
        <label className="block text-sm font-medium mb-1">Full Name</label>
        <Input placeholder="John Doe" />
      </div>
      <div>
        <label className="block text-sm font-medium mb-1">Email</label>
        <Input type="email" placeholder="john@example.com" />
      </div>
      <div>
        <label className="block text-sm font-medium mb-1">Password</label>
        <Input type="password" placeholder="••••••••" />
        <p className="text-xs text-gray-500 mt-1">Must be at least 8 characters</p>
      </div>
      <div>
        <label className="block text-sm font-medium mb-1">Confirm Password</label>
        <Input type="password" error />
        <p className="text-xs text-red-500 mt-1">Passwords do not match</p>
      </div>
    </form>
  ),
};

export const AllStates: Story = {
  render: () => (
    <div className="space-y-4 max-w-md">
      <div>
        <p className="text-sm text-gray-500 mb-1">Default</p>
        <Input placeholder="Default input" />
      </div>
      <div>
        <p className="text-sm text-gray-500 mb-1">Disabled</p>
        <Input placeholder="Disabled input" disabled />
      </div>
      <div>
        <p className="text-sm text-gray-500 mb-1">Error</p>
        <Input placeholder="Error input" error />
      </div>
    </div>
  ),
};
EOF
fi

# Create Card stories
CARD_STORIES="$COMPONENTS_DIR/Card.stories.tsx"
if [ -f "$CARD_STORIES" ]; then
    echo "Card.stories.tsx already exists. Skipping."
else
    echo "Creating Card.stories.tsx..."
    cat > "$CARD_STORIES" << 'EOF'
import type { Meta, StoryObj } from "@storybook/react";
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from "./Card";
import { Button } from "./Button";
import { Input } from "./Input";

const meta: Meta<typeof Card> = {
  title: "Components/Card",
  component: Card,
  tags: ["autodocs"],
  argTypes: {
    padding: {
      control: "select",
      options: ["none", "sm", "md", "lg"],
      description: "Card padding size",
    },
    hoverable: {
      control: "boolean",
      description: "Add hover effect",
    },
  },
  args: {
    padding: "md",
    hoverable: false,
  },
};

export default meta;
type Story = StoryObj<typeof Card>;

export const Simple: Story = {
  args: {
    children: <p className="text-gray-600">This is a simple card with some content.</p>,
  },
};

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
        <p>Main content goes here. This could be text, images, or other components.</p>
      </CardContent>
    </Card>
  ),
};

export const WithFooter: Story = {
  render: () => (
    <Card>
      <CardHeader>
        <CardTitle>Confirm Action</CardTitle>
      </CardHeader>
      <CardContent>
        <p>Are you sure you want to proceed with this action?</p>
      </CardContent>
      <CardFooter className="flex justify-end gap-2">
        <Button variant="ghost">Cancel</Button>
        <Button>Confirm</Button>
      </CardFooter>
    </Card>
  ),
};

export const FormCard: Story = {
  render: () => (
    <Card className="max-w-md">
      <CardHeader>
        <CardTitle>Create Account</CardTitle>
        <CardDescription>
          Enter your details to create a new account.
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <div>
          <label className="block text-sm font-medium mb-1">Name</label>
          <Input placeholder="John Doe" />
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">Email</label>
          <Input type="email" placeholder="john@example.com" />
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">Password</label>
          <Input type="password" />
        </div>
      </CardContent>
      <CardFooter>
        <Button className="w-full">Create Account</Button>
      </CardFooter>
    </Card>
  ),
};

export const Hoverable: Story = {
  args: {
    hoverable: true,
    children: <p className="text-gray-600">Hover over this card to see the shadow effect.</p>,
  },
};

export const NoPadding: Story = {
  args: {
    padding: "none",
    children: (
      <div>
        <div className="h-32 bg-gradient-to-br from-blue-500 to-purple-600 rounded-t-lg" />
        <div className="p-4">
          <p className="font-semibold">Image Card</p>
          <p className="text-sm text-gray-500">Card with no padding for full-bleed images</p>
        </div>
      </div>
    ),
  },
};

export const CardGrid: Story = {
  render: () => (
    <div className="grid md:grid-cols-3 gap-4">
      <Card hoverable>
        <CardHeader>
          <CardTitle>Feature One</CardTitle>
          <CardDescription>Description of feature one.</CardDescription>
        </CardHeader>
      </Card>
      <Card hoverable>
        <CardHeader>
          <CardTitle>Feature Two</CardTitle>
          <CardDescription>Description of feature two.</CardDescription>
        </CardHeader>
      </Card>
      <Card hoverable>
        <CardHeader>
          <CardTitle>Feature Three</CardTitle>
          <CardDescription>Description of feature three.</CardDescription>
        </CardHeader>
      </Card>
    </div>
  ),
};
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $INPUT_STORIES"
echo "  - $CARD_STORIES"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Run Storybook to view the stories"
echo "  3. Test Controls panel for Input and Card"
echo "  4. Proceed to Lab 7.4 for Badge and Avatar stories"
echo ""
