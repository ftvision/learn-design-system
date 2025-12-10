# Lab 5.3: ContactForm with Validation

## Objective

Build a ContactForm component that demonstrates form handling, validation logic, and submission states in app components.

## Time Estimate

~35 minutes

## Prerequisites

- Completed Labs 5.1-5.2
- Understanding of React forms and hooks

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Ensure previous labs are complete
2. Create the ContactForm component

### Manual Setup

Navigate to your web app components:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/apps/web/components
```

## Exercises

### Exercise 1: Examine the ContactForm Structure

Open `apps/web/components/ContactForm.tsx` and note the structure:

```tsx
"use client";

import { useState, useCallback } from "react";
import {
  Button,
  Input,
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from "@myapp/ui";

interface ContactFormData {
  name: string;
  email: string;
  subject: string;
  message: string;
}

interface ContactFormProps {
  onSubmit: (data: ContactFormData) => Promise<void>;
  onCancel?: () => void;
}
```

**Key observations:**
- Form data interface is app-specific
- `onSubmit` is async (returns Promise)
- Uses UI components from design system

### Exercise 2: Understand Validation Logic

The validation function contains **business rules**:

```tsx
function validateForm(data: ContactFormData): Partial<Record<keyof ContactFormData, string>> {
  const errors: Partial<Record<keyof ContactFormData, string>> = {};

  if (!data.name.trim()) {
    errors.name = "Name is required";
  } else if (data.name.length < 2) {
    errors.name = "Name must be at least 2 characters";
  }

  if (!data.email.trim()) {
    errors.email = "Email is required";
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.email)) {
    errors.email = "Please enter a valid email address";
  }

  if (!data.subject.trim()) {
    errors.subject = "Subject is required";
  }

  if (!data.message.trim()) {
    errors.message = "Message is required";
  } else if (data.message.length < 10) {
    errors.message = "Message must be at least 10 characters";
  }

  return errors;
}
```

**Why is validation in the app component, not UI?**
- Validation rules are business-specific
- Error messages match product tone
- Minimum lengths are business decisions
- Email regex might vary by product

### Exercise 3: State Management Pattern

The form manages multiple states:

```tsx
// Form data
const [formData, setFormData] = useState<ContactFormData>({
  name: "",
  email: "",
  subject: "",
  message: "",
});

// Validation errors
const [errors, setErrors] = useState<Partial<Record<keyof ContactFormData, string>>>({});

// Submission states
const [isSubmitting, setIsSubmitting] = useState(false);
const [submitError, setSubmitError] = useState<string | null>(null);
const [submitSuccess, setSubmitSuccess] = useState(false);
```

**State types:**
| State | Purpose |
|-------|---------|
| `formData` | Current form values |
| `errors` | Field-level validation errors |
| `isSubmitting` | Loading state during submission |
| `submitError` | Server/network error message |
| `submitSuccess` | Show success UI |

### Exercise 4: Input Change Handler

```tsx
const handleChange = useCallback(
  (field: keyof ContactFormData) =>
    (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
      const value = e.target.value;
      setFormData((prev) => ({ ...prev, [field]: value }));
      // Clear error when user starts typing
      if (errors[field]) {
        setErrors((prev) => ({ ...prev, [field]: undefined }));
      }
    },
  [errors]
);
```

**Pattern breakdown:**
1. Returns a handler for a specific field
2. Updates form data immutably
3. Clears field error on change (UX improvement)
4. Uses `useCallback` for performance

### Exercise 5: Form Submission Flow

```tsx
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  setSubmitError(null);

  // 1. Validate
  const validationErrors = validateForm(formData);
  if (Object.keys(validationErrors).length > 0) {
    setErrors(validationErrors);
    return;
  }

  // 2. Submit
  setIsSubmitting(true);
  try {
    await onSubmit(formData);
    setSubmitSuccess(true);
    // Reset form
    setFormData({ name: "", email: "", subject: "", message: "" });
  } catch (error) {
    setSubmitError(
      error instanceof Error ? error.message : "Something went wrong"
    );
  } finally {
    setIsSubmitting(false);
  }
};
```

**Flow:**
1. Prevent default form submission
2. Validate all fields
3. If errors, show them and stop
4. If valid, show loading state
5. Call async `onSubmit`
6. Handle success or error
7. Always clear loading state

### Exercise 6: UI States

The form has multiple UI states:

**Success state:**
```tsx
if (submitSuccess) {
  return (
    <Card>
      <CardContent className="py-12 text-center">
        <div className="text-4xl mb-4">✓</div>
        <h3>Message Sent!</h3>
        <Button onClick={() => setSubmitSuccess(false)}>
          Send Another Message
        </Button>
      </CardContent>
    </Card>
  );
}
```

**Error state (inline):**
```tsx
{submitError && (
  <div className="p-3 text-sm text-red-600 bg-red-50 rounded-md">
    {submitError}
  </div>
)}
```

**Loading state:**
```tsx
<Button type="submit" loading={isSubmitting}>
  Send Message
</Button>
```

### Exercise 7: Where Validation Belongs

| Validation Type | Where | Why |
|-----------------|-------|-----|
| Required field | App component | Business rule |
| Min/max length | App component | Business rule |
| Email format | App component | Regex might vary |
| Input disabled state | UI component | Visual state |
| Error styling | UI component | Design system concern |

The `Input` UI component accepts an `error` prop but doesn't know what validation produced it.

## Key Concepts

### Form State Pattern

```tsx
interface FormState {
  data: T;              // Form values
  errors: Record<keyof T, string>;  // Field errors
  isSubmitting: boolean; // Loading
  submitError: string;   // Server error
  submitSuccess: boolean; // Success state
}
```

### Controlled vs Uncontrolled

This form uses **controlled inputs**:
```tsx
<Input
  value={formData.name}           // Value from state
  onChange={handleChange("name")} // Updates state
/>
```

Alternative: **uncontrolled** with refs (less common in React):
```tsx
<input ref={nameRef} defaultValue="" />
```

### Error Clearing UX

Good UX: clear error when user starts fixing it:
```tsx
if (errors[field]) {
  setErrors((prev) => ({ ...prev, [field]: undefined }));
}
```

Bad UX: keep showing error until form is revalidated.

## Checklist

Before proceeding to Lab 5.4:

- [ ] ContactForm component created
- [ ] Understand validation logic placement
- [ ] Understand form state management
- [ ] Understand submission flow
- [ ] Can explain why validation isn't in UI package

## Troubleshooting

### Form not submitting

Make sure the button has `type="submit"`:
```tsx
<Button type="submit">Send</Button>
```

### Errors not clearing

Check the `handleChange` function clears errors:
```tsx
if (errors[field]) {
  setErrors((prev) => ({ ...prev, [field]: undefined }));
}
```

### Textarea not styled

The textarea is a native element with inline styles. In a real project, you might create a `Textarea` UI component.

## Next

Proceed to Lab 5.4 to build the ProductCard component.
