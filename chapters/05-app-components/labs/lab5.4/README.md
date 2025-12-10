# Lab 5.4: ProductCard Component

## Objective

Build a ProductCard component that displays product information with business-specific formatting and conditional actions.

## Time Estimate

~25 minutes

## Prerequisites

- Completed Labs 5.1-5.3
- Understanding of the Product type from Lab 5.1

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure previous labs are complete
2. Create the ProductCard component

### Manual Setup

Navigate to your web app components:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/apps/web/components
```

## Exercises

### Exercise 1: Examine the ProductCard Component

Open `apps/web/components/ProductCard.tsx`:

```tsx
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
```

### Exercise 2: Identify Business Logic

**Price formatting:**
```tsx
const formattedPrice = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: product.currency,
}).format(product.price);
```
- Uses `Intl.NumberFormat` for locale-aware formatting
- Currency comes from product data
- Business decision: "en-US" locale

**Stock status:**
```tsx
const stockBadge = product.inStock
  ? { variant: "success" as const, text: "In Stock" }
  : { variant: "error" as const, text: "Out of Stock" };
```
- Maps boolean to visual representation
- Business decision: green for in-stock, red for out

**Add to cart disabled:**
```tsx
<Button
  disabled={!product.inStock}
  onClick={() => onAddToCart(product)}
>
  Add to Cart
</Button>
```
- Business rule: can't add out-of-stock items

### Exercise 3: Compare with UserCard

| Aspect | UserCard | ProductCard |
|--------|----------|-------------|
| Entity | User | Product |
| Business logic | Role restrictions, date formatting | Price formatting, stock status |
| Conditional UI | Admin delete restriction | Out-of-stock disable |
| Actions | Edit, Delete | Add to Cart, View Details |

Both follow the same pattern:
1. Import UI primitives
2. Accept business entity as prop
3. Apply business logic
4. Compose UI components

### Exercise 4: Image Handling Pattern

```tsx
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
</div>
```

**Pattern:**
1. Fixed aspect ratio container (`aspect-square`)
2. Background color as fallback
3. Conditional image or placeholder
4. `object-cover` for proper image scaling

### Exercise 5: When to Use UI vs App Components

**UI Component (packages/ui):**
- `<Card />` - generic container
- `<Badge variant="success" />` - visual variant
- `<Button disabled={true} />` - interactive element

**App Component (apps/web):**
- `<ProductCard product={p} />` - knows about Product type
- Stock badge logic - maps `inStock` to variant
- Price formatting - business-specific locale

### Exercise 6: Type Safety Benefits

TypeScript helps catch errors:

```tsx
interface ProductCardProps {
  product: Product;  // Must have all Product fields
  onAddToCart?: (product: Product) => void;  // Callback gets typed product
}

// This would error:
<ProductCard product={{ name: "Test" }} />
// Error: Missing required fields: id, description, price, etc.

// This is correct:
<ProductCard product={fullProduct} onAddToCart={(p) => {
  console.log(p.price);  // TypeScript knows p is Product
}} />
```

## Key Concepts

### Business Formatting Functions

Common patterns for app components:

```tsx
// Price formatting
const formatPrice = (price: number, currency: string) =>
  new Intl.NumberFormat("en-US", { style: "currency", currency }).format(price);

// Date formatting
const formatDate = (date: Date) =>
  new Intl.DateTimeFormat("en-US", { dateStyle: "medium" }).format(date);

// Status mapping
const statusToVariant = (status: string) => ({
  active: "success",
  pending: "warning",
  inactive: "error",
}[status] || "default");
```

### Conditional Actions

Pattern for optional action buttons:

```tsx
{onAction && (
  <Button
    disabled={!canPerformAction}
    onClick={() => onAction(entity)}
  >
    Action
  </Button>
)}
```

- Check if handler exists (`onAction &&`)
- Apply business rules (`disabled={!canPerformAction}`)
- Pass entity to handler (`onAction(entity)`)

## Checklist

Before proceeding to Lab 5.5:

- [ ] ProductCard component created
- [ ] Understand price formatting
- [ ] Understand stock status logic
- [ ] Can compare UserCard and ProductCard patterns
- [ ] Understand conditional action rendering

## Troubleshooting

### Price showing wrong format

Check the `currency` prop matches a valid ISO currency code:
```tsx
// Valid
currency: "USD"
currency: "EUR"

// Invalid
currency: "dollars"
```

### Image not showing

Check `imageUrl` is a valid URL:
```tsx
imageUrl: "https://example.com/image.jpg"  // Valid
imageUrl: "/images/product.jpg"            // Valid (relative)
imageUrl: "image.jpg"                      // May not work
```

## Next

Proceed to Lab 5.5 to create the demo page and compare with real projects.
