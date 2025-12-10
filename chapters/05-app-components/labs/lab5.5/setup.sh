#!/bin/bash

# Lab 5.5 Setup Script
# Creates demo page and reference symlinks

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB51_DIR="$SCRIPT_DIR/../lab5.1"
LAB52_DIR="$SCRIPT_DIR/../lab5.2"
LAB53_DIR="$SCRIPT_DIR/../lab5.3"
LAB54_DIR="$SCRIPT_DIR/../lab5.4"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../../.." && pwd)"
REFERENCES_DIR="$REPO_ROOT/references"

echo "=== Lab 5.5 Setup: Demo Page & Compare ==="
echo ""

# Ensure previous labs are complete
if [ ! -f "$WEB_DIR/components/UserCard.tsx" ]; then
    echo "Lab 5.1 not complete. Running setup..."
    cd "$LAB51_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$WEB_DIR/components/UserList.tsx" ]; then
    echo "Lab 5.2 not complete. Running setup..."
    cd "$LAB52_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$WEB_DIR/components/ContactForm.tsx" ]; then
    echo "Lab 5.3 not complete. Running setup..."
    cd "$LAB53_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$WEB_DIR/components/ProductCard.tsx" ]; then
    echo "Lab 5.4 not complete. Running setup..."
    cd "$LAB54_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

# Update demo page
PAGE_FILE="$WEB_DIR/app/page.tsx"
echo "Updating demo page..."
cat > "$PAGE_FILE" << 'EOF'
import { UserList } from "@/components/UserList";
import { ContactForm } from "@/components/ContactForm";
import { ProductCard } from "@/components/ProductCard";
import type { User, Product } from "@/types";

// Mock data
const users: User[] = [
  {
    id: "1",
    name: "Alice Johnson",
    email: "alice@example.com",
    role: "admin",
    avatarUrl: "https://i.pravatar.cc/150?u=alice",
    createdAt: new Date("2023-01-15"),
  },
  {
    id: "2",
    name: "Bob Smith",
    email: "bob@example.com",
    role: "member",
    avatarUrl: "https://i.pravatar.cc/150?u=bob",
    createdAt: new Date("2023-06-20"),
  },
  {
    id: "3",
    name: "Carol Williams",
    email: "carol@example.com",
    role: "member",
    createdAt: new Date("2024-02-10"),
  },
  {
    id: "4",
    name: "David Brown",
    email: "david@example.com",
    role: "guest",
    avatarUrl: "https://i.pravatar.cc/150?u=david",
    createdAt: new Date("2024-03-01"),
  },
];

const products: Product[] = [
  {
    id: "1",
    name: "Wireless Headphones",
    description: "Premium noise-canceling wireless headphones with 30-hour battery life.",
    price: 299.99,
    currency: "USD",
    imageUrl: "https://picsum.photos/400/400?random=1",
    inStock: true,
    category: "Electronics",
  },
  {
    id: "2",
    name: "Leather Notebook",
    description: "Handcrafted leather journal with 200 pages of premium paper.",
    price: 45.00,
    currency: "USD",
    imageUrl: "https://picsum.photos/400/400?random=2",
    inStock: true,
    category: "Office",
  },
  {
    id: "3",
    name: "Smart Watch",
    description: "Fitness tracking smartwatch with heart rate monitor and GPS.",
    price: 399.99,
    currency: "USD",
    imageUrl: "https://picsum.photos/400/400?random=3",
    inStock: false,
    category: "Electronics",
  },
];

export default function Home() {
  return (
    <main className="min-h-screen bg-gray-50">
      <div className="max-w-6xl mx-auto p-8 space-y-12">
        <h1 className="text-3xl font-bold text-gray-900">App Components Demo</h1>

        {/* User List Section */}
        <section>
          <h2 className="text-2xl font-semibold mb-4">Team Members</h2>
          <UserList
            users={users}
            onEditUser={(user) => console.log("Edit:", user)}
            onDeleteUser={(user) => console.log("Delete:", user)}
          />
        </section>

        {/* Products Section */}
        <section>
          <h2 className="text-2xl font-semibold mb-4">Featured Products</h2>
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {products.map((product) => (
              <ProductCard
                key={product.id}
                product={product}
                onAddToCart={(p) => console.log("Add to cart:", p)}
                onViewDetails={(p) => console.log("View details:", p)}
              />
            ))}
          </div>
        </section>

        {/* Contact Form Section */}
        <section className="max-w-xl">
          <h2 className="text-2xl font-semibold mb-4">Get in Touch</h2>
          <ContactForm
            onSubmit={async (data) => {
              // Simulate API call
              await new Promise((resolve) => setTimeout(resolve, 1500));
              console.log("Form submitted:", data);
            }}
          />
        </section>
      </div>
    </main>
  );
}
EOF

# Create symlink to cal.com if references exist
if [ -d "$REFERENCES_DIR/cal.com" ]; then
    if [ ! -L "$SCRIPT_DIR/cal.com" ] && [ ! -d "$SCRIPT_DIR/cal.com" ]; then
        echo "Creating symlink to Cal.com..."
        ln -s ../../../../../references/cal.com "$SCRIPT_DIR/cal.com"
    fi
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files updated:"
echo "  - $PAGE_FILE"
echo ""
if [ -L "$SCRIPT_DIR/cal.com" ]; then
    echo "Reference projects available:"
    echo "  - cal.com/ -> Cal.com repository"
    echo ""
fi
echo "Next steps:"
echo "  1. Run the demo: cd $MONOREPO_DIR && pnpm dev"
echo "  2. Open http://localhost:3000"
echo "  3. Study Cal.com's app components"
echo "  4. Complete the reflection questions"
echo ""
