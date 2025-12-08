# Lecture Notes: Cross-Platform Tokens (Part 1 - Theory)

**Duration:** 30-45 minutes
**Chapter:** 08 - Cross-Platform Tokens

---

## Lecture Outline

1. Opening Question
2. The Platform Diversity Problem
3. Style Dictionary: The Universal Translator
4. Transforms and Transform Groups
5. Platform-Specific Output Formats
6. The Multi-Platform Workflow
7. Key Takeaways

---

## 1. Opening Question (3 minutes)

> **Ask the class:** "Your company has a web app, an iOS app, and an Android app. The brand color needs to change from blue to purple. How many files do you update?"

**Expected answers:** "Three?" "One for each platform?" "Depends on how it's set up..."

**Instructor note:** Without cross-platform tokens, this is a nightmare—hunting through CSS files, Swift files, and XML resources. With a proper token pipeline, the answer is: **one JSON file**.

**Follow-up:** "What if I told you one change to a JSON file could automatically update CSS, Swift, Kotlin, and even Flutter?"

---

## 2. The Platform Diversity Problem (8 minutes)

### Each Platform Speaks a Different Language

The same color value needs to be expressed differently:

| Platform | Format | Example |
|----------|--------|---------|
| **Web (CSS)** | Hex or RGB | `--color-primary: #3B82F6;` |
| **iOS (Swift)** | UIColor | `UIColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1)` |
| **Android (XML)** | ARGB Hex | `<color name="primary">#FF3B82F6</color>` |
| **React Native** | JS String | `primary: '#3B82F6'` |
| **Flutter (Dart)** | Color class | `Color(0xFF3B82F6)` |

### The Manual Approach (Don't Do This)

```
Designer updates brand color in Figma
         │
         ▼
Developer copies hex value: #3B82F6
         │
    ┌────┴────┬────────────┬──────────────┐
    ▼         ▼            ▼              ▼
 Update    Update       Update         Update
 CSS       Swift        XML            Dart
 file      file         file           file
    │         │            │              │
    ▼         ▼            ▼              ▼
 Commit    Commit       Commit         Commit
 to web    to iOS       to Android     to Flutter
 repo      repo         repo           repo

Problems:
- 4 manual updates
- 4 opportunities for typos
- 4 code reviews
- Values drift over time
- "Is this the right blue?"
```

### The Automated Approach (Do This)

```
Designer updates brand color in Figma
         │
         ▼
Developer updates tokens/colors.json
         │
         ▼
   Style Dictionary runs
         │
    ┌────┴────┬────────────┬──────────────┐
    ▼         ▼            ▼              ▼
variables.css  Colors.swift  colors.xml   colors.dart
    │         │            │              │
    ▼         ▼            ▼              ▼
 Same hex  Converted to   Converted to   Converted to
 #3B82F6   UIColor        ARGB hex       Color class

Single source of truth → Multiple correct outputs
```

> **Key insight:** The token JSON file is the single source of truth. Style Dictionary handles all the platform-specific translations.

---

## 3. Style Dictionary: The Universal Translator (10 minutes)

### What Style Dictionary Does

Style Dictionary is a build tool that:
1. **Reads** token definitions (JSON/YAML)
2. **Transforms** values for each platform
3. **Formats** output in platform-specific syntax
4. **Writes** files to the build directory

### The Transformation Pipeline

```
┌─────────────────────────────────────────────────────────────────┐
│                  STYLE DICTIONARY PIPELINE                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   SOURCE                                                         │
│   tokens/colors.json ─────────────────────────┐                  │
│   tokens/spacing.json ────────────────────────┤                  │
│   tokens/typography.json ─────────────────────┤                  │
│                                               ▼                  │
│                                         ┌──────────┐             │
│                                         │  PARSE   │             │
│                                         └────┬─────┘             │
│                                              │                   │
│                                              ▼                   │
│                                       ┌────────────┐             │
│                                       │ TRANSFORM  │             │
│                                       └──────┬─────┘             │
│                                              │                   │
│              ┌───────────────┬───────────────┼───────────────┐   │
│              ▼               ▼               ▼               ▼   │
│         ┌────────┐      ┌────────┐      ┌────────┐     ┌────────┐│
│         │  CSS   │      │  iOS   │      │Android │     │   JS   ││
│         │ format │      │ format │      │ format │     │ format ││
│         └───┬────┘      └───┬────┘      └───┬────┘     └───┬────┘│
│             ▼               ▼               ▼               ▼    │
│        variables.css   Colors.swift    colors.xml     tokens.js  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Configuration Structure

```javascript
// style-dictionary.config.js
module.exports = {
  // Where to find token source files
  source: ["src/**/*.json"],

  // Output configurations per platform
  platforms: {
    css: {
      transformGroup: "css",        // Which transforms to apply
      buildPath: "build/css/",      // Where to write files
      files: [{
        destination: "variables.css",  // Output filename
        format: "css/variables",       // Output format
      }],
    },

    ios: {
      transformGroup: "ios-swift",
      buildPath: "build/ios/",
      files: [{
        destination: "Colors.swift",
        format: "ios-swift/enum.swift",
        filter: { type: "color" },    // Only include colors
      }],
    },

    android: {
      transformGroup: "android",
      buildPath: "build/android/",
      files: [{
        destination: "colors.xml",
        format: "android/colors",
        filter: { type: "color" },
      }],
    },
  },
};
```

---

## 4. Transforms and Transform Groups (8 minutes)

### What is a Transform?

A **transform** modifies a token's name or value for a specific platform.

Example: The color `#3B82F6`

| Transform | Input | Output |
|-----------|-------|--------|
| `color/hex` | `#3B82F6` | `#3B82F6` (no change) |
| `color/UIColor` | `#3B82F6` | `UIColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1)` |
| `color/hex8android` | `#3B82F6` | `#FF3B82F6` (adds alpha) |

### Name Transforms

Tokens need different naming conventions per platform:

| Transform | Input | Output |
|-----------|-------|--------|
| `name/cti/kebab` | `color.primary.500` | `color-primary-500` |
| `name/cti/camel` | `color.primary.500` | `colorPrimary500` |
| `name/cti/snake` | `color.primary.500` | `color_primary_500` |
| `name/cti/pascal` | `color.primary.500` | `ColorPrimary500` |

### Transform Groups

A **transform group** bundles multiple transforms together:

| Group | Included Transforms |
|-------|-------------------|
| `css` | `name/cti/kebab`, `color/hex`, `size/rem` |
| `ios-swift` | `name/cti/camel`, `color/UIColorSwift`, `size/swift/remToCGFloat` |
| `android` | `name/cti/snake`, `color/hex8android`, `size/remToSp` |
| `js` | `name/cti/camel`, `color/hex` |

### Visualizing Transforms

```
Token: {
  path: ["color", "primary", "500"],
  value: "#3B82F6"
}
        │
        ▼
   CSS Transform Group
        │
   ┌────┴────────────────────┐
   │  name/cti/kebab         │  "color-primary-500"
   │  color/hex              │  "#3B82F6"
   └────┬────────────────────┘
        │
        ▼
   --color-primary-500: #3B82F6;

        │
        ▼
   iOS Transform Group
        │
   ┌────┴────────────────────┐
   │  name/cti/camel         │  "colorPrimary500"
   │  color/UIColorSwift     │  UIColor(red:green:blue:alpha:)
   └────┬────────────────────┘
        │
        ▼
   static let colorPrimary500 = UIColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1)
```

---

## 5. Platform-Specific Output Formats (7 minutes)

### CSS Output

```css
/* build/css/variables.css */
:root {
  --color-primary-500: #3B82F6;
  --color-primary-600: #2563EB;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
  --font-size-base: 1rem;
}
```

**Usage:**
```css
.button {
  background-color: var(--color-primary-500);
  padding: var(--spacing-md);
}
```

### iOS Swift Output

```swift
// build/ios/Colors.swift
import UIKit

public enum Colors {
    public static let colorPrimary500 = UIColor(
        red: 0.231,
        green: 0.510,
        blue: 0.965,
        alpha: 1.0
    )
    public static let colorPrimary600 = UIColor(
        red: 0.145,
        green: 0.388,
        blue: 0.922,
        alpha: 1.0
    )
}
```

**Usage:**
```swift
// SwiftUI
Button("Submit") { }
    .background(Color(Colors.colorPrimary500))

// UIKit
button.backgroundColor = Colors.colorPrimary500
```

### Android XML Output

```xml
<!-- build/android/colors.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<resources>
  <color name="color_primary_500">#FF3B82F6</color>
  <color name="color_primary_600">#FF2563EB</color>
</resources>
```

**Usage:**
```xml
<!-- Layout XML -->
<Button
    android:background="@color/color_primary_500"
    android:text="Submit" />
```

```kotlin
// Kotlin
button.setBackgroundColor(
    ContextCompat.getColor(context, R.color.color_primary_500)
)
```

### React Native / TypeScript Output

```typescript
// build/ts/tokens.ts
export const ColorPrimary500 = "#3B82F6";
export const ColorPrimary600 = "#2563EB";
export const SpacingSm = 8;
export const SpacingMd = 16;
```

**Usage:**
```tsx
import { ColorPrimary500, SpacingMd } from '@myapp/tokens';

const styles = StyleSheet.create({
  button: {
    backgroundColor: ColorPrimary500,
    padding: SpacingMd,
  },
});
```

---

## 6. The Multi-Platform Workflow (5 minutes)

### The Development Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    CROSS-PLATFORM WORKFLOW                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   1. DESIGN CHANGE                                               │
│      Designer: "The primary color should be #8B5CF6"            │
│                                                                  │
│   2. UPDATE SOURCE                                               │
│      Developer edits tokens/colors.json:                        │
│      "primary": { "500": { "value": "#8B5CF6" } }               │
│                                                                  │
│   3. BUILD                                                       │
│      $ npm run build                                            │
│      Style Dictionary generates all platform files              │
│                                                                  │
│   4. DISTRIBUTE                                                  │
│      ┌─────────────┬─────────────┬─────────────┐                │
│      │    Web      │    iOS      │   Android   │                │
│      ├─────────────┼─────────────┼─────────────┤                │
│      │ npm package │ Swift pkg   │ Maven/Gradle│                │
│      │ or copy CSS │ or CocoaPod │ or copy XML │                │
│      └─────────────┴─────────────┴─────────────┘                │
│                                                                  │
│   5. APPS UPDATE                                                 │
│      All platforms now have the new purple                      │
│      No manual copying, no typos, no drift                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Filtering Tokens by Type

Not every platform needs every token. Use filters:

```javascript
// Only colors go to Colors.swift
{
  destination: "Colors.swift",
  format: "ios-swift/enum.swift",
  filter: {
    type: "color",  // Only tokens with type: "color"
  },
}

// Only spacing goes to dimens.xml
{
  destination: "dimens.xml",
  format: "android/dimens",
  filter: {
    type: "dimension",
  },
}
```

This requires marking tokens with types:

```json
{
  "color": {
    "primary": {
      "500": {
        "value": "#3B82F6",
        "type": "color"        // ← Type for filtering
      }
    }
  },
  "spacing": {
    "md": {
      "value": "16px",
      "type": "dimension"      // ← Type for filtering
    }
  }
}
```

---

## 7. Key Takeaways (4 minutes)

### Summary Visual

```
┌─────────────────────────────────────────────────────────────────┐
│                 CROSS-PLATFORM TOKEN ARCHITECTURE                │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│                    ┌──────────────────┐                          │
│                    │  tokens/*.json   │                          │
│                    │  (Single Source) │                          │
│                    └────────┬─────────┘                          │
│                             │                                    │
│                             ▼                                    │
│                    ┌──────────────────┐                          │
│                    │ Style Dictionary │                          │
│                    │  (Build Tool)    │                          │
│                    └────────┬─────────┘                          │
│                             │                                    │
│         ┌───────────────────┼───────────────────┐                │
│         ▼                   ▼                   ▼                │
│   ┌──────────┐        ┌──────────┐        ┌──────────┐          │
│   │   CSS    │        │  Swift   │        │   XML    │          │
│   │ Web App  │        │ iOS App  │        │ Android  │          │
│   └──────────┘        └──────────┘        └──────────┘          │
│                                                                  │
│   Same values, different formats, perfect consistency            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Three Things to Remember

1. **One source, many outputs** — A single JSON file generates CSS, Swift, XML, Dart, and any other format you need. Change once, update everywhere.

2. **Transforms handle platform differences** — Style Dictionary converts `#3B82F6` to `UIColor(red:green:blue:)` for iOS, `#FF3B82F6` for Android, etc. You don't do this manually.

3. **Filters organize output files** — Use `type: "color"` and `type: "dimension"` in tokens to route them to the correct output files (Colors.swift vs Spacing.swift).

### The Value Proposition

```
Without cross-platform tokens:
  - 4 platforms × 50 colors = 200 values to maintain
  - Brand color change = 4 PRs, 4 reviews, 4 deploys
  - "Is this the right blue?" → constant uncertainty

With cross-platform tokens:
  - 1 source × 50 colors = 50 values to maintain
  - Brand color change = 1 PR, 1 review, 1 build
  - "Is this the right blue?" → yes, it's from the source
```

---

## Looking Ahead

In the **lab section**, you'll:
- Update Style Dictionary config for iOS and Android
- Add type attributes to your tokens for proper filtering
- Build and examine Swift enums and XML resources
- Understand how native developers would consume these files
- Explore IBM Carbon's cross-platform approach

In **Chapter 9**, we'll tie everything together in a capstone project—building a complete design system from tokens to themed, documented components.

---

## Discussion Questions for Class

1. Your iOS developer says "We don't use Style Dictionary, we just copy the hex values." What's your response?

2. Android uses ARGB format (`#FF3B82F6`) while web uses RGB (`#3B82F6`). How does Style Dictionary handle this automatically?

3. A new platform (Flutter) joins your app family. What's the process to add token generation for it?

4. Should native apps consume tokens directly, or should there be a translation layer? What are the trade-offs?

---

## Common Misconceptions

### "Native developers won't use generated files"

**Correction:** Generated files are production-ready. Swift enums and XML resources are exactly what native developers expect. The format is familiar; only the source is different.

### "We can just share a JSON file across platforms"

**Correction:** Raw JSON doesn't help. iOS can't use `"#3B82F6"` directly—it needs `UIColor`. Android needs XML resources. Style Dictionary does the translation.

### "Cross-platform tokens only work for colors"

**Correction:** Colors are the easiest example, but you can generate spacing, typography, shadows, animation timing—anything that's a value. Each platform just needs the right format.

### "This is only for big companies"

**Correction:** Even a two-person team with web + mobile benefits. The setup cost is low; the consistency benefit is immediate.

---

## Real-World Examples

### IBM Carbon

IBM's Carbon Design System is the gold standard for cross-platform tokens:
- Supports web, iOS, Android, and more
- Open source: [github.com/carbon-design-system/carbon](https://github.com/carbon-design-system/carbon)
- Uses Style Dictionary under the hood

### Salesforce Lightning

Salesforce generates tokens for web and mobile:
- Theo (their token tool) inspired Style Dictionary
- Tokens power a massive ecosystem of apps

### Shopify Polaris

Shopify's Polaris tokens power:
- Web admin
- iOS app
- Android app
- React Native POS

---

## Additional Resources

- **Tool:** [Style Dictionary Documentation](https://amzn.github.io/style-dictionary/)
- **Example:** [IBM Carbon Tokens](https://github.com/carbon-design-system/carbon/tree/main/packages/colors)
- **Article:** "Design Tokens for Dummies" by Louis Chenais
- **Spec:** [Design Tokens W3C Community Group](https://design-tokens.github.io/community-group/format/)
- **Tool:** [Figma Tokens Plugin](https://www.figma.com/community/plugin/843461159747178978)

---

## Preparation for Lab

Before the lab, ensure you have:
- [ ] Completed Chapters 1-7 (working token system)
- [ ] Style Dictionary installed in packages/tokens
- [ ] Understanding of your current token structure
- [ ] Optional: Xcode installed (to verify Swift output)
- [ ] Optional: Android Studio installed (to verify XML output)
