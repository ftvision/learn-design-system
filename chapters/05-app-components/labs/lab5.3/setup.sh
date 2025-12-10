#!/bin/bash

# Lab 5.3 Setup Script
# Creates ContactForm component with validation

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB51_DIR="$SCRIPT_DIR/../lab5.1"
LAB52_DIR="$SCRIPT_DIR/../lab5.2"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"

echo "=== Lab 5.3 Setup: ContactForm with Validation ==="
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

# Create ContactForm component
CONTACTFORM_FILE="$WEB_DIR/components/ContactForm.tsx"
if [ -f "$CONTACTFORM_FILE" ]; then
    echo "ContactForm.tsx already exists. Skipping."
else
    echo "Creating ContactForm component..."
    cat > "$CONTACTFORM_FILE" << 'EOF'
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

// Validation rules (business logic)
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

export function ContactForm({ onSubmit, onCancel }: ContactFormProps) {
  // Form state
  const [formData, setFormData] = useState<ContactFormData>({
    name: "",
    email: "",
    subject: "",
    message: "",
  });
  const [errors, setErrors] = useState<Partial<Record<keyof ContactFormData, string>>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitError, setSubmitError] = useState<string | null>(null);
  const [submitSuccess, setSubmitSuccess] = useState(false);

  // Handle input changes
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

  // Handle form submission
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitError(null);

    // Validate
    const validationErrors = validateForm(formData);
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors);
      return;
    }

    // Submit
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

  // Success state
  if (submitSuccess) {
    return (
      <Card>
        <CardContent className="py-12 text-center">
          <div className="text-4xl mb-4">✓</div>
          <h3 className="text-lg font-semibold text-gray-900 mb-2">
            Message Sent!
          </h3>
          <p className="text-gray-500 mb-4">
            Thank you for reaching out. We&apos;ll get back to you soon.
          </p>
          <Button onClick={() => setSubmitSuccess(false)}>
            Send Another Message
          </Button>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <form onSubmit={handleSubmit}>
        <CardHeader>
          <CardTitle>Contact Us</CardTitle>
          <CardDescription>
            Fill out the form below and we&apos;ll get back to you as soon as possible.
          </CardDescription>
        </CardHeader>

        <CardContent className="space-y-4">
          {/* Submit error */}
          {submitError && (
            <div className="p-3 text-sm text-red-600 bg-red-50 rounded-md">
              {submitError}
            </div>
          )}

          {/* Form fields */}
          <div className="grid gap-4 sm:grid-cols-2">
            <Input
              label="Name"
              placeholder="Your name"
              value={formData.name}
              onChange={handleChange("name")}
              error={errors.name}
              disabled={isSubmitting}
            />
            <Input
              label="Email"
              type="email"
              placeholder="you@example.com"
              value={formData.email}
              onChange={handleChange("email")}
              error={errors.email}
              disabled={isSubmitting}
            />
          </div>

          <Input
            label="Subject"
            placeholder="What is this about?"
            value={formData.subject}
            onChange={handleChange("subject")}
            error={errors.subject}
            disabled={isSubmitting}
          />

          <div className="space-y-1">
            <label className="block text-sm font-medium text-gray-700">
              Message
            </label>
            <textarea
              rows={5}
              placeholder="Your message..."
              value={formData.message}
              onChange={handleChange("message")}
              disabled={isSubmitting}
              className={`
                w-full rounded-md border px-3 py-2 text-sm
                placeholder:text-gray-400
                focus:outline-none focus:ring-2 focus:ring-offset-0
                disabled:cursor-not-allowed disabled:opacity-50
                ${
                  errors.message
                    ? "border-red-500 focus:border-red-500 focus:ring-red-500/20"
                    : "border-gray-300 focus:border-blue-500 focus:ring-blue-500/20"
                }
              `}
            />
            {errors.message && (
              <p className="text-sm text-red-600">{errors.message}</p>
            )}
          </div>
        </CardContent>

        <CardFooter className="justify-end">
          {onCancel && (
            <Button
              type="button"
              variant="ghost"
              onClick={onCancel}
              disabled={isSubmitting}
            >
              Cancel
            </Button>
          )}
          <Button type="submit" loading={isSubmitting}>
            Send Message
          </Button>
        </CardFooter>
      </form>
    </Card>
  );
}
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
echo "  - $CONTACTFORM_FILE"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Understand form validation logic"
echo "  3. Examine state management pattern"
echo "  4. Proceed to Lab 5.4 for ProductCard"
echo ""
