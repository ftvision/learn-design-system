# Lab 8.4: Android XML Output

## Objective

Understand the generated Android XML files and how Android apps consume design tokens, plus React Native usage.

## Time Estimate

~25 minutes

## Prerequisites

- Completed Lab 8.3 (iOS output examined)
- Build directory contains Android files

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that the build exists
2. Display Android XML file contents
3. Show usage examples for Android and React Native

### Manual Setup

Navigate to your tokens build:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/packages/tokens/build/android
```

## Exercises

### Exercise 1: Examine colors.xml

Open `build/android/colors.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
  colors.xml
  Do not edit directly
  Generated on [date]
-->
<resources>
  <color name="color_primary_50">#ffeff6ff</color>
  <color name="color_primary_100">#ffdbeafe</color>
  <color name="color_primary_500">#ff3b82f6</color>
  <color name="color_primary_600">#ff2563eb</color>
  <color name="color_gray_50">#fff9fafb</color>
  <color name="color_gray_900">#ff111827</color>
  <color name="color_success">#ff22c55e</color>
  <color name="color_warning">#fff59e0b</color>
  <color name="color_error">#ffef4444</color>
</resources>
```

**Key observations:**
- Standard Android resources XML format
- 8-digit hex with alpha prefix (`#AARRGGBB`)
- `ff` prefix = fully opaque
- Snake_case naming convention

### Exercise 2: Understand the Transformation

| Token (JSON) | Android Output |
|--------------|----------------|
| `color.primary.500` | `color_primary_500` |
| `#3B82F6` | `#ff3b82f6` |
| Nested structure | Flattened with underscores |

The transform group `android`:
1. Converts name to snake_case
2. Adds alpha prefix to hex colors
3. Outputs in Android resources format

### Exercise 3: Examine dimens.xml

Open `build/android/dimens.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<resources>
  <dimen name="spacing_0">0dp</dimen>
  <dimen name="spacing_1">4dp</dimen>
  <dimen name="spacing_2">8dp</dimen>
  <dimen name="spacing_3">12dp</dimen>
  <dimen name="spacing_4">16dp</dimen>
  <dimen name="spacing_6">24dp</dimen>
  <dimen name="spacing_8">32dp</dimen>
</resources>
```

Dimension values use `dp` (density-independent pixels).

### Exercise 4: Android Layout XML Usage

In a layout file:

```xml
<!-- res/layout/primary_button.xml -->
<Button
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:background="@color/color_primary_500"
    android:textColor="@color/color_white"
    android:paddingStart="@dimen/spacing_4"
    android:paddingEnd="@dimen/spacing_4"
    android:paddingTop="@dimen/spacing_2"
    android:paddingBottom="@dimen/spacing_2"
    android:text="Submit" />
```

### Exercise 5: Android Kotlin Usage

In Kotlin code:

```kotlin
import android.widget.Button
import androidx.core.content.ContextCompat

class CustomButton(context: Context) : Button(context) {
    init {
        // Using color resource
        setBackgroundColor(
            ContextCompat.getColor(context, R.color.color_primary_500)
        )
        setTextColor(
            ContextCompat.getColor(context, R.color.color_white)
        )

        // Using dimension resource
        val padding = resources.getDimensionPixelSize(R.dimen.spacing_4)
        setPadding(padding, padding, padding, padding)
    }
}
```

### Exercise 6: Jetpack Compose Usage

In Compose:

```kotlin
import androidx.compose.material.Button
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.res.dimensionResource

@Composable
fun PrimaryButton(
    text: String,
    onClick: () -> Unit
) {
    Button(
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(
            backgroundColor = colorResource(R.color.color_primary_500)
        ),
        contentPadding = PaddingValues(
            horizontal = dimensionResource(R.dimen.spacing_4),
            vertical = dimensionResource(R.dimen.spacing_2)
        )
    ) {
        Text(
            text = text,
            color = colorResource(R.color.color_white)
        )
    }
}
```

### Exercise 7: React Native Usage

For React Native, use the TypeScript output:

```tsx
// Import generated tokens
import { tokens } from '@myapp/tokens';
// or
import { colorPrimary500, spacing4 } from '@myapp/tokens';

import { StyleSheet, TouchableOpacity, Text } from 'react-native';

const styles = StyleSheet.create({
  button: {
    backgroundColor: tokens.colorPrimary500,
    paddingHorizontal: parseInt(tokens.spacing4),
    paddingVertical: parseInt(tokens.spacing2),
    borderRadius: 8,
  },
  text: {
    color: tokens.colorWhite,
    fontWeight: tokens.fontWeightMedium,
  },
});

function PrimaryButton({ title, onPress }) {
  return (
    <TouchableOpacity style={styles.button} onPress={onPress}>
      <Text style={styles.text}>{title}</Text>
    </TouchableOpacity>
  );
}
```

## Key Concepts

### Android Resources System

```
res/
├── values/
│   ├── colors.xml      # Color definitions
│   ├── dimens.xml      # Dimension definitions
│   └── strings.xml     # String definitions
└── values-night/
    └── colors.xml      # Dark theme colors
```

### Resource References

| In XML | In Kotlin | Type |
|--------|-----------|------|
| `@color/name` | `R.color.name` | Color |
| `@dimen/name` | `R.dimen.name` | Dimension |
| `@string/name` | `R.string.name` | String |

### 8-Digit Hex Format

```
#AARRGGBB
 │ └─────── RGB color
 └──────── Alpha (opacity)

#ff3b82f6
 ff = 100% opaque
 3b82f6 = blue color
```

### Cross-Platform Comparison

| Aspect | iOS | Android | React Native |
|--------|-----|---------|--------------|
| Colors | UIColor | @color/name | '#hex' string |
| Spacing | CGFloat | @dimen/name | number |
| Format | Swift enum | XML resources | JS/TS object |

## Checklist

Before proceeding to Lab 8.5:

- [ ] colors.xml generated correctly
- [ ] dimens.xml generated correctly
- [ ] Understand 8-digit hex format
- [ ] Understand XML layout usage
- [ ] Understand Kotlin code usage
- [ ] Understand React Native usage

## Troubleshooting

### Color looks different

Verify alpha prefix:
- `#ff3b82f6` = opaque blue
- `#803b82f6` = 50% transparent blue
- Missing `ff` prefix causes transparency

### "Cannot resolve symbol R.color"

Ensure:
- XML file is in `res/values/` directory
- Project has been rebuilt
- Resource name matches exactly

### React Native spacing issues

Spacing tokens may be strings like "16px":
```tsx
// Parse to number for RN
paddingHorizontal: parseInt(tokens.spacing4)
// or use token value directly if numeric
```

## Next

Proceed to Lab 8.5 to study IBM Carbon and reflect on cross-platform tokens.
