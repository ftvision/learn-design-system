# Chapter 8 Study Plan: Cross-Platform Tokens

## Part 1: Theory (20 minutes)

### 1.1 The Challenge

Different platforms have different ways of defining design values:

| Platform | Format | Example |
|----------|--------|---------|
| Web | CSS Variables | `--color-primary: #3B82F6;` |
| iOS | Swift | `static let primary = UIColor(red: 0.23, ...)` |
| Android | XML | `<color name="primary">#FF3B82F6</color>` |
| React Native | JS Object | `primary: '#3B82F6'` |

Without automation, you'd maintain 4 separate files manually. Style Dictionary solves this.

### 1.2 Style Dictionary Transforms

Style Dictionary applies **transforms** to convert tokens:

```
Token: { "value": "#3B82F6" }
                │
    ┌───────────┼───────────────┐
    ▼           ▼               ▼
  CSS         iOS Swift       Android
  #3B82F6     UIColor(        #FF3B82F6
              red: 0.23,      (with alpha)
              green: 0.51,
              blue: 0.96)
```

### 1.3 Transform Groups

Style Dictionary has built-in transform groups:

| Group | Transforms Applied |
|-------|-------------------|
| `css` | Name to kebab-case, colors to hex |
| `ios-swift-separate` | Name to camelCase, colors to UIColor |
| `android` | Name to snake_case, colors to 8-digit hex |
| `js` | Name to camelCase, keep values as strings |

### 1.4 Single Source of Truth

```
tokens/src/colors.json  ─────┐
tokens/src/spacing.json ─────┼──► Style Dictionary ──► build/css/
tokens/src/typography.json ──┘                    ──► build/ios/
                                                  ──► build/android/
                                                  ──► build/ts/
```

Change once, update everywhere.

---

## Part 2: Labs

### Lab 8.1: Configure Multi-Platform Build (~30 minutes)

**Objective:** Configure Style Dictionary to generate tokens for CSS, JS, TypeScript, iOS, and Android.

**Topics:**
- Platform configuration in Style Dictionary
- Transform groups and their effects
- Build path organization

**Key Concepts:**
- Single source of truth
- Platform-specific formatting
- Filter functions for token selection

[→ Go to Lab 8.1](./labs/lab8.1/README.md)

---

### Lab 8.2: Add Token Types & Build (~25 minutes)

**Objective:** Add type attributes to tokens for filtering and build all platform outputs.

**Topics:**
- Token type attribute
- Type-based filtering
- Running multi-platform build

**Key Concepts:**
- Why types enable filtering
- Build process overview
- Verifying build output

[→ Go to Lab 8.2](./labs/lab8.2/README.md)

---

### Lab 8.3: iOS Swift Output (~25 minutes)

**Objective:** Understand generated iOS Swift files and native iOS usage patterns.

**Topics:**
- UIColor format and RGB values
- Swift enum structure
- SwiftUI and UIKit usage

**Key Concepts:**
- iOS color representation
- CGFloat for dimensions
- Integration workflow

[→ Go to Lab 8.3](./labs/lab8.3/README.md)

---

### Lab 8.4: Android XML Output (~25 minutes)

**Objective:** Understand Android XML resources and React Native token usage.

**Topics:**
- Android resources XML format
- 8-digit hex with alpha
- Layout XML and Kotlin usage
- React Native StyleSheet

**Key Concepts:**
- Android resource system
- Density-independent pixels
- Cross-platform comparison

[→ Go to Lab 8.4](./labs/lab8.4/README.md)

---

### Lab 8.5: Study Carbon & Reflection (~25 minutes)

**Objective:** Study IBM Carbon's approach and reflect on cross-platform strategies.

**Topics:**
- IBM Carbon repository exploration
- Alternative tools comparison
- Written reflection

**Key Concepts:**
- Real-world token architecture
- Extension strategies
- Dark theme handling

[→ Go to Lab 8.5](./labs/lab8.5/README.md)

---

## Part 3: Self-Check & Reflection

### Files You Should Have

```
packages/tokens/
├── src/
│   ├── colors.json
│   ├── spacing.json
│   └── typography.json
├── build/
│   ├── css/
│   │   └── variables.css
│   ├── js/
│   │   └── tokens.js
│   ├── ts/
│   │   ├── tokens.ts
│   │   └── tokens.d.ts
│   ├── ios/
│   │   ├── Colors.swift
│   │   ├── Spacing.swift
│   │   └── Typography.swift
│   └── android/
│       ├── colors.xml
│       ├── dimens.xml
│       └── font_sizes.xml
└── style-dictionary.config.js
```

### Self-Check

Before moving to Chapter 9, verify:

- [ ] Style Dictionary generates iOS Swift files
- [ ] Style Dictionary generates Android XML files
- [ ] TypeScript output works for React Native
- [ ] You understand how native apps consume these files
- [ ] You explored IBM Carbon's token approach

### Written Reflection

1. **Why generate tokens for multiple platforms instead of copying values?**
   ```


   ```

2. **What happens if you need to change a color across all platforms?**
   ```


   ```

3. **How would you add a new platform (like Flutter)?**
   ```


   ```

---

## Extension Exercises

### Exercise 8.1: Add Flutter Support

Create a custom format for Flutter/Dart:

```javascript
// In style-dictionary.config.js
const StyleDictionary = require('style-dictionary');

StyleDictionary.registerFormat({
  name: 'flutter/class.dart',
  formatter: function({ dictionary }) {
    return `class AppColors {\n` +
      dictionary.allTokens
        .filter(token => token.type === 'color')
        .map(token => `  static const ${token.name} = Color(0xFF${token.value.slice(1)});`)
        .join('\n') +
      '\n}\n';
  }
});
```

### Exercise 8.2: Add Dark Theme for Mobile

Create separate dark theme files for iOS/Android:
1. Add dark token values with theme attribute
2. Filter tokens by theme
3. Generate platform-specific dark mode resources

### Exercise 8.3: Token Documentation Generator

Create a documentation format that outputs:
- Token name and value
- Platform-specific usage examples
- Visual color swatches

---

## Next Chapter

In Chapter 9, you'll learn about versioning and publishing your design system packages.
