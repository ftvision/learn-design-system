# Lab 8.3: iOS Swift Output

## Objective

Understand the generated iOS Swift files and how native iOS apps consume design tokens.

## Time Estimate

~25 minutes

## Prerequisites

- Completed Lab 8.2 (tokens built)
- Build directory contains iOS files

## Setup

### Quick Setup

```bash
./setup.sh
```

This will:
1. Check that the build exists
2. Display iOS Swift file contents
3. Show usage examples

### Manual Setup

Navigate to your tokens build:
```bash
cd ../../../04-monorepo-architecture/labs/lab4.1/packages/tokens/build/ios
```

## Exercises

### Exercise 1: Examine Colors.swift

Open `build/ios/Colors.swift`:

```swift
//
// Colors.swift
//
// Do not edit directly
// Generated on [date]
//

import UIKit

public enum Colors {
    public static let colorPrimary50 = UIColor(red: 0.937, green: 0.965, blue: 1.000, alpha: 1)
    public static let colorPrimary100 = UIColor(red: 0.859, green: 0.918, blue: 0.996, alpha: 1)
    public static let colorPrimary500 = UIColor(red: 0.231, green: 0.510, blue: 0.965, alpha: 1)
    public static let colorPrimary600 = UIColor(red: 0.145, green: 0.388, blue: 0.922, alpha: 1)
    public static let colorGray50 = UIColor(red: 0.976, green: 0.980, blue: 0.984, alpha: 1)
    public static let colorGray900 = UIColor(red: 0.067, green: 0.094, blue: 0.153, alpha: 1)
    public static let colorSuccess = UIColor(red: 0.133, green: 0.773, blue: 0.369, alpha: 1)
    public static let colorWarning = UIColor(red: 0.961, green: 0.620, blue: 0.043, alpha: 1)
    public static let colorError = UIColor(red: 0.937, green: 0.267, blue: 0.267, alpha: 1)
}
```

**Key observations:**
- Generated as `public enum` - prevents instantiation
- Static properties - accessed directly
- `UIColor` with RGB values 0-1 range
- Automatic name conversion (kebab → camelCase)

### Exercise 2: Understand the Transformation

| Token (JSON) | Swift Output |
|--------------|--------------|
| `color.primary.500` | `colorPrimary500` |
| `#3B82F6` | `UIColor(red: 0.231, green: 0.510, blue: 0.965, alpha: 1)` |
| `type: "color"` | (used for filtering) |

The transform group `ios-swift-separate`:
1. Converts name to camelCase
2. Converts hex to RGB float values
3. Generates UIColor initializer

### Exercise 3: SwiftUI Usage

In a SwiftUI view:

```swift
import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(Color(Colors.colorWhite))
                .padding(.horizontal, Spacing.spacing4)
                .padding(.vertical, Spacing.spacing2)
        }
        .background(Color(Colors.colorPrimary500))
        .cornerRadius(8)
    }
}
```

Note: SwiftUI uses `Color()` wrapper around `UIColor`.

### Exercise 4: UIKit Usage

In a UIKit view:

```swift
import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = Colors.colorPrimary500
        setTitleColor(Colors.colorWhite, for: .normal)
        layer.cornerRadius = 8
        contentEdgeInsets = UIEdgeInsets(
            top: CGFloat(Spacing.spacing2),
            left: CGFloat(Spacing.spacing4),
            bottom: CGFloat(Spacing.spacing2),
            right: CGFloat(Spacing.spacing4)
        )
    }
}
```

### Exercise 5: Examine Spacing.swift

Open `build/ios/Spacing.swift`:

```swift
public enum Spacing {
    public static let spacing0: CGFloat = 0
    public static let spacing1: CGFloat = 4
    public static let spacing2: CGFloat = 8
    public static let spacing3: CGFloat = 12
    public static let spacing4: CGFloat = 16
    public static let spacing6: CGFloat = 24
    public static let spacing8: CGFloat = 32
}
```

Spacing values are output as `CGFloat` for direct use in layouts.

## Key Concepts

### Why Enums?

Swift enums with static properties:
- Cannot be instantiated (namespace only)
- Autocomplete-friendly
- Type-safe
- No memory overhead

### UIColor vs Color

| Framework | Color Type |
|-----------|------------|
| UIKit | `UIColor` |
| SwiftUI | `Color` (wraps UIColor) |
| AppKit (macOS) | `NSColor` |

Generated `UIColor` works with both UIKit and SwiftUI (via `Color(uiColor:)`).

### Integration Workflow

```
1. Generate tokens: npm run build
2. Copy to iOS project: cp build/ios/*.swift MyApp/Tokens/
3. Import in code: import MyApp // or specific file
4. Use: Colors.colorPrimary500
```

### Keeping Tokens Updated

Options:
1. **Manual copy** - Run build, copy files
2. **Git submodule** - Tokens repo as submodule
3. **Swift Package** - Publish as SPM package
4. **CI/CD** - Auto-generate and commit

## Checklist

Before proceeding to Lab 8.4:

- [ ] Colors.swift generated correctly
- [ ] Spacing.swift generated correctly
- [ ] Understand UIColor RGB format
- [ ] Understand SwiftUI usage pattern
- [ ] Understand UIKit usage pattern
- [ ] Can explain why enums are used

## Troubleshooting

### Colors look wrong

Check hex to RGB conversion:
- `#3B82F6` → `59, 130, 246` → `0.231, 0.510, 0.965`
- RGB values should be 0-1 range, not 0-255

### "Cannot find type 'Colors'"

Ensure:
- File is added to Xcode project
- File is in correct target membership
- Module is imported if in separate module

### Spacing values are integers

Check the format output:
- `ios-swift/enum.swift` should output CGFloat
- Dimension type should be applied

## Next

Proceed to Lab 8.4 to examine the Android XML output.
