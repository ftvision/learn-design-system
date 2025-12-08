# DTCG Design Tokens Format Specification

A guide to understanding the W3C Design Tokens Community Group specification and how it relates to this course.

---

## What is the DTCG Specification?

The **Design Tokens Community Group (DTCG)** specification is a W3C community effort to create a **universal, standardized JSON format** for design tokens. It aims to solve a fundamental interoperability problem in the design tools ecosystem.

**Official Spec:** https://www.designtokens.org/tr/drafts/format/

### The Problem It Solves

Every design tool (Figma, Sketch, Style Dictionary, Adobe XD, etc.) currently uses its own proprietary token format. This creates integration barriers for design system teams who need custom translators for every tool combination.

```
Before DTCG:
┌─────────┐     ┌─────────┐     ┌─────────┐
│  Figma  │     │ Sketch  │     │  Adobe  │
│ Format  │     │ Format  │     │ Format  │
└────┬────┘     └────┬────┘     └────┬────┘
     │               │               │
     └───────────────┼───────────────┘
                     │
            Custom translators needed
            for every tool combination

After DTCG:
┌─────────┐     ┌─────────┐     ┌─────────┐
│  Figma  │     │ Sketch  │     │  Adobe  │
└────┬────┘     └────┬────┘     └────┬────┘
     │               │               │
     └───────────────┼───────────────┘
                     │
              ┌──────┴──────┐
              │ DTCG Format │  ← One universal format
              │   (.tokens) │
              └─────────────┘
```

---

## Current Status

**Status:** Draft Community Group Report

> ⚠️ **Important:** The spec explicitly warns: "Do not attempt to implement this version... Do not reference this version as authoritative."

However, tools like **Style Dictionary v4** and **Tokens Studio** already support the DTCG format, making it mature enough for practical use. Just be aware the spec may continue to evolve.

### Who Created It?

The specification is developed by the Design Tokens Community Group under W3C, with editors including:
- Louis Chenais
- Kathleen McMahon
- Drew Powers
- Matthew Ström-Awn
- Donna Vitan

---

## How to Read the Specification

### For Most Readers: Recommended Path

1. **Read the Introduction** — Understand the "why" behind standardization
2. **Skip to "Design Token" section** — Learn the core `$value`, `$type` properties
3. **Review Type definitions** — Understand color, dimension, typography, etc.
4. **Study the examples** — Scattered throughout the document

### Key Sections Worth Understanding

| Section | What You'll Learn |
|---------|-------------------|
| **Design Token** | The `$value`, `$type`, `$description` properties |
| **Groups** | How to organize tokens hierarchically |
| **Aliases** | How tokens can reference other tokens (`{color.primary}`) |
| **Types** | The 8 primitive types + 5 composite types |

---

## The Format at a Glance

### Basic Token Structure

```json
{
  "color": {
    "primary": {
      "$value": "#3B82F6",
      "$type": "color",
      "$description": "Primary brand color"
    },
    "primary-hover": {
      "$value": "{color.primary}",
      "$type": "color"
    }
  },
  "spacing": {
    "md": {
      "$value": "16px",
      "$type": "dimension"
    }
  }
}
```

### Token Properties

| Property | Required | Description |
|----------|----------|-------------|
| `$value` | Yes | The actual token value |
| `$type` | Yes | Token category from spec-defined types |
| `$description` | No | Explanatory text for documentation |
| `$extensions` | No | Vendor-specific metadata |
| `$deprecated` | No | Deprecation status with optional explanation |

### Reserved Characters

These characters cannot be used in token or group names:
- `$` (dollar sign)
- `{` and `}` (curly braces)
- `.` (period)

### File Format

| Aspect | Specification |
|--------|--------------|
| MIME type | `application/design-tokens+json` |
| File extensions | `.tokens` or `.tokens.json` |

---

## The Type System

### Primitive Types (8)

| Type | Example Value | Use Case |
|------|---------------|----------|
| `color` | `#3B82F6`, `rgb(59, 130, 246)` | Any color value |
| `dimension` | `16px`, `1rem`, `0.5em` | Spacing, sizing, borders |
| `fontFamily` | `"Inter", sans-serif` | Font stacks |
| `fontWeight` | `500`, `bold`, `semibold` | Text weight |
| `duration` | `200ms`, `0.3s` | Animation timing |
| `cubicBezier` | `[0.4, 0, 0.2, 1]` | Easing curves |
| `number` | `1.5`, `16`, `0` | Unitless numbers (line-height, z-index) |
| `string` | `"anything"` | Arbitrary strings |

### Composite Types (5)

Composite tokens combine multiple sub-values into a structured object.

#### Typography

```json
{
  "heading-1": {
    "$type": "typography",
    "$value": {
      "fontFamily": "Inter",
      "fontSize": "32px",
      "fontWeight": 700,
      "lineHeight": 1.2,
      "letterSpacing": "-0.02em"
    }
  }
}
```

#### Shadow

```json
{
  "shadow-md": {
    "$type": "shadow",
    "$value": {
      "color": "#00000026",
      "offsetX": "0px",
      "offsetY": "4px",
      "blur": "6px",
      "spread": "-1px"
    }
  }
}
```

#### Border

```json
{
  "border-default": {
    "$type": "border",
    "$value": {
      "color": "#E5E7EB",
      "width": "1px",
      "style": "solid"
    }
  }
}
```

#### Gradient

```json
{
  "gradient-primary": {
    "$type": "gradient",
    "$value": {
      "type": "linear",
      "angle": "90deg",
      "stops": [
        { "color": "#3B82F6", "position": "0%" },
        { "color": "#8B5CF6", "position": "100%" }
      ]
    }
  }
}
```

#### Transition

```json
{
  "transition-default": {
    "$type": "transition",
    "$value": {
      "duration": "200ms",
      "delay": "0ms",
      "timingFunction": [0.4, 0, 0.2, 1]
    }
  }
}
```

---

## Aliases and References

Tokens can reference other tokens using curly brace syntax:

```json
{
  "color": {
    "blue": {
      "500": {
        "$value": "#3B82F6",
        "$type": "color"
      }
    },
    "primary": {
      "$value": "{color.blue.500}",
      "$type": "color"
    }
  },
  "button": {
    "background": {
      "$value": "{color.primary}",
      "$type": "color"
    }
  }
}
```

This creates a reference chain: `button.background` → `color.primary` → `color.blue.500` → `#3B82F6`

---

## DTCG vs Style Dictionary Format

### Property Name Differences

| Aspect | Style Dictionary (original) | DTCG Spec |
|--------|---------------------------|-----------|
| Value property | `value` | `$value` |
| Type property | `type` | `$type` |
| Description | `comment` | `$description` |
| File extension | `.json` | `.tokens` or `.tokens.json` |

### Example Comparison

**Style Dictionary Original Format:**

```json
{
  "color": {
    "primary": {
      "value": "#3B82F6",
      "type": "color",
      "comment": "Primary brand color"
    }
  }
}
```

**DTCG Format:**

```json
{
  "color": {
    "primary": {
      "$value": "#3B82F6",
      "$type": "color",
      "$description": "Primary brand color"
    }
  }
}
```

### Migration Path

Style Dictionary v4 supports **both formats**. The migration is simply adding `$` prefixes to property names.

---

## Groups and Organization

Groups are containers for organizing tokens hierarchically. They have no semantic meaning—they're purely organizational.

```json
{
  "color": {
    "$description": "All color tokens",

    "brand": {
      "$description": "Brand colors",
      "primary": {
        "$value": "#3B82F6",
        "$type": "color"
      },
      "secondary": {
        "$value": "#10B981",
        "$type": "color"
      }
    },

    "semantic": {
      "$description": "Semantic colors",
      "success": {
        "$value": "{color.brand.secondary}",
        "$type": "color"
      },
      "error": {
        "$value": "#EF4444",
        "$type": "color"
      }
    }
  }
}
```

### Group-Level Type Inheritance

You can set `$type` at the group level to avoid repetition:

```json
{
  "spacing": {
    "$type": "dimension",
    "xs": { "$value": "4px" },
    "sm": { "$value": "8px" },
    "md": { "$value": "16px" },
    "lg": { "$value": "24px" },
    "xl": { "$value": "32px" }
  }
}
```

All tokens in the `spacing` group inherit `$type: "dimension"`.

---

## Relationship to This Course

In this course, you use **Style Dictionary** with its original format. Here's how DTCG fits in:

```
Style Dictionary Original Format (course uses this)
        ↓
   (compatible with)
        ↓
DTCG Format (Style Dictionary v4 supports both)
        ↓
   (becoming)
        ↓
Industry Standard (Figma, Tokens Studio, Specify adopting)
```

### Recommendation

When starting **new projects**, consider using the DTCG format (`$value`, `$type`) since:
1. Style Dictionary v4 supports it natively
2. Tokens Studio uses it
3. It's the direction the industry is moving
4. Better tool interoperability in the future

For **existing projects**, there's no urgency to migrate—both formats work.

---

## Extensions ($extensions)

The spec allows vendor-specific metadata via `$extensions`:

```json
{
  "color": {
    "primary": {
      "$value": "#3B82F6",
      "$type": "color",
      "$extensions": {
        "com.figma": {
          "variableId": "VariableID:123:456",
          "codeSyntax": {
            "iOS": "ColorPrimary"
          }
        },
        "com.tokens-studio": {
          "modify": {
            "type": "lighten",
            "value": "10%"
          }
        }
      }
    }
  }
}
```

Extensions use reverse domain notation (`com.figma`, `com.tokens-studio`) to avoid conflicts.

---

## Deprecation

Tokens can be marked as deprecated:

```json
{
  "color": {
    "brand-blue": {
      "$value": "#3B82F6",
      "$type": "color",
      "$deprecated": "Use color.primary instead"
    },
    "primary": {
      "$value": "{color.brand-blue}",
      "$type": "color"
    }
  }
}
```

This helps with migration paths when evolving your token system.

---

## Tools Supporting DTCG Format

| Tool | DTCG Support |
|------|-------------|
| **Style Dictionary v4** | Full support (reads and writes) |
| **Tokens Studio** | Full support (Figma plugin) |
| **Specify** | Full support |
| **Supernova** | Full support |
| **Figma Variables** | Partial (export via plugins) |

---

## Key Takeaways

1. **DTCG is the future standard** — It's a W3C community effort to create universal token interoperability.

2. **Still a draft** — The spec is not final, but mature enough for production use.

3. **Easy migration** — Just add `$` prefixes to property names.

4. **Use for new projects** — If starting fresh, prefer DTCG format for better future compatibility.

5. **Style Dictionary supports both** — No breaking changes required for existing projects.

---

## Resources

- [DTCG Specification (Draft)](https://www.designtokens.org/tr/drafts/format/)
- [Design Tokens Community Group](https://www.designtokens.org/)
- [Style Dictionary v4 DTCG Support](https://styledictionary.com/info/tokens/)
- [Tokens Studio Documentation](https://docs.tokens.studio/)
- [W3C Community Groups](https://www.w3.org/community/design-tokens/)
