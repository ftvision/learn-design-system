#!/bin/bash

# Lab 5.4 Setup Script
# Creates ProductCard component

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB51_DIR="$SCRIPT_DIR/../lab5.1"
LAB52_DIR="$SCRIPT_DIR/../lab5.2"
LAB53_DIR="$SCRIPT_DIR/../lab5.3"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"

echo "=== Lab 5.4 Setup: ProductCard Component ==="
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

# Create ProductCard component
PRODUCTCARD_FILE="$WEB_DIR/components/ProductCard.tsx"
if [ -f "$PRODUCTCARD_FILE" ]; then
    echo "ProductCard.tsx already exists. Skipping."
else
    echo "Creating ProductCard component..."
    cat > "$PRODUCTCARD_FILE" << 'EOF'
import { Card, CardContent, Badge, Button } from "@myapp/ui";
import type { Product } from "@/types";

interface ProductCardProps {
  product: Product;
  onAddToCart?: (product: Product) => void;
  onViewDetails?: (product: Product) => void;
}

export function ProductCard({
  product,
  onAddToCart,
  onViewDetails,
}: ProductCardProps) {
  // Business logic: format price
  const formattedPrice = new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: product.currency,
  }).format(product.price);

  // Business logic: determine stock badge
  const stockBadge = product.inStock
    ? { variant: "success" as const, text: "In Stock" }
    : { variant: "error" as const, text: "Out of Stock" };

  return (
    <Card className="overflow-hidden">
      {/* Product image */}
      <div className="aspect-square bg-gray-100 relative">
        {product.imageUrl ? (
          <img
            src={product.imageUrl}
            alt={product.name}
            className="w-full h-full object-cover"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-gray-400">
            No image
          </div>
        )}
        {/* Category badge */}
        <Badge className="absolute top-2 left-2" variant="default">
          {product.category}
        </Badge>
      </div>

      <CardContent className="p-4">
        {/* Product info */}
        <div className="mb-3">
          <h3 className="font-semibold text-gray-900 truncate">
            {product.name}
          </h3>
          <p className="text-sm text-gray-500 line-clamp-2">
            {product.description}
          </p>
        </div>

        {/* Price and stock */}
        <div className="flex items-center justify-between mb-4">
          <span className="text-lg font-bold text-gray-900">
            {formattedPrice}
          </span>
          <Badge variant={stockBadge.variant}>{stockBadge.text}</Badge>
        </div>

        {/* Actions */}
        <div className="flex gap-2">
          {onViewDetails && (
            <Button
              variant="secondary"
              size="sm"
              className="flex-1"
              onClick={() => onViewDetails(product)}
            >
              Details
            </Button>
          )}
          {onAddToCart && (
            <Button
              variant="primary"
              size="sm"
              className="flex-1"
              disabled={!product.inStock}
              onClick={() => onAddToCart(product)}
            >
              Add to Cart
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  );
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $PRODUCTCARD_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Understand business logic patterns"
echo "  3. Compare with UserCard"
echo "  4. Proceed to Lab 5.5 for demo page"
echo ""
