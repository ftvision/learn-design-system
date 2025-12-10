#!/bin/bash

# Lab 2.4 Setup Script
# Creates Style Dictionary config, builds tokens, and creates test HTML

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB21_DIR="$SCRIPT_DIR/../lab2.1"
LAB22_DIR="$SCRIPT_DIR/../lab2.2"
LAB23_DIR="$SCRIPT_DIR/../lab2.3"
TOKENS_DIR="$LAB21_DIR/packages/tokens"

echo "=== Lab 2.4 Setup: Build and Test Tokens ==="
echo ""

# Ensure all previous labs are complete
if [ ! -d "$TOKENS_DIR" ]; then
    echo "Lab 2.1 not complete. Running setup..."
    cd "$LAB21_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$TOKENS_DIR/src/colors.json" ]; then
    echo "Lab 2.2 not complete. Running setup..."
    cd "$LAB22_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

if [ ! -f "$TOKENS_DIR/src/spacing.json" ]; then
    echo "Lab 2.3 not complete. Running setup..."
    cd "$LAB23_DIR" && ./setup.sh && cd "$SCRIPT_DIR"
fi

# Create Style Dictionary config
CONFIG_FILE="$TOKENS_DIR/style-dictionary.config.js"
if [ -f "$CONFIG_FILE" ]; then
    echo "style-dictionary.config.js already exists. Skipping."
else
    echo "Creating Style Dictionary configuration..."
    cat > "$CONFIG_FILE" << 'EOF'
module.exports = {
  source: ['src/**/*.json'],
  platforms: {
    // CSS Custom Properties
    css: {
      transformGroup: 'css',
      buildPath: 'build/css/',
      files: [
        {
          destination: 'variables.css',
          format: 'css/variables',
          options: {
            outputReferences: true
          }
        }
      ]
    },

    // JavaScript ES6
    js: {
      transformGroup: 'js',
      buildPath: 'build/js/',
      files: [
        {
          destination: 'tokens.js',
          format: 'javascript/es6'
        }
      ]
    },

    // TypeScript
    ts: {
      transformGroup: 'js',
      buildPath: 'build/ts/',
      files: [
        {
          destination: 'tokens.ts',
          format: 'javascript/es6'
        }
      ]
    },

    // JSON (useful for other tools)
    json: {
      transformGroup: 'js',
      buildPath: 'build/json/',
      files: [
        {
          destination: 'tokens.json',
          format: 'json/nested'
        }
      ]
    }
  }
};
EOF
fi

# Build the tokens
echo ""
echo "Building tokens..."
cd "$TOKENS_DIR"
npm run build

# Create test HTML file
TEST_FILE="$TOKENS_DIR/test.html"
if [ -f "$TEST_FILE" ]; then
    echo "test.html already exists. Skipping."
else
    echo "Creating test.html..."
    cat > "$TEST_FILE" << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <title>Design Token Test</title>
  <link rel="stylesheet" href="build/css/variables.css">
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: var(--font-family-sans);
      padding: var(--spacing-6);
      background: var(--color-neutral-50);
      color: var(--color-neutral-900);
      line-height: var(--font-line-height-normal);
    }

    h1 {
      font-size: var(--font-size-2xl);
      font-weight: var(--font-weight-bold);
      margin-bottom: var(--spacing-4);
    }

    .card {
      background: var(--color-neutral-0);
      padding: var(--spacing-6);
      border-radius: var(--border-radius-lg);
      box-shadow: var(--shadow-md);
      margin-bottom: var(--spacing-4);
    }

    .button {
      display: inline-block;
      background: var(--color-primary-500);
      color: white;
      padding: var(--spacing-2) var(--spacing-4);
      border: none;
      border-radius: var(--border-radius-default);
      font-size: var(--font-size-sm);
      font-weight: var(--font-weight-medium);
      cursor: pointer;
      margin-right: var(--spacing-2);
    }

    .button:hover {
      background: var(--color-primary-600);
    }

    .button--success {
      background: var(--color-success-default);
    }

    .button--success:hover {
      background: var(--color-success-dark);
    }

    .button--error {
      background: var(--color-error-default);
    }

    .button--error:hover {
      background: var(--color-error-dark);
    }

    .text-muted {
      color: var(--color-neutral-600);
      font-size: var(--font-size-sm);
    }

    .spacing-demo {
      display: flex;
      gap: var(--spacing-2);
      margin-top: var(--spacing-4);
    }

    .spacing-box {
      background: var(--color-primary-100);
      padding: var(--spacing-2);
      border-radius: var(--border-radius-sm);
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>Design Token Test</h1>
    <p class="text-muted" style="margin-bottom: var(--spacing-4);">
      This page demonstrates design tokens in action.
    </p>

    <h2 style="font-size: var(--font-size-lg); margin-bottom: var(--spacing-3);">Buttons</h2>
    <div style="margin-bottom: var(--spacing-4);">
      <button class="button">Primary</button>
      <button class="button button--success">Success</button>
      <button class="button button--error">Error</button>
    </div>

    <h2 style="font-size: var(--font-size-lg); margin-bottom: var(--spacing-3);">Spacing Scale</h2>
    <div class="spacing-demo">
      <div class="spacing-box" style="width: var(--spacing-4);">4</div>
      <div class="spacing-box" style="width: var(--spacing-8);">8</div>
      <div class="spacing-box" style="width: var(--spacing-12);">12</div>
      <div class="spacing-box" style="width: var(--spacing-16);">16</div>
    </div>
  </div>

  <div class="card">
    <h2 style="font-size: var(--font-size-lg); margin-bottom: var(--spacing-3);">Shadow Scale</h2>
    <div style="display: flex; gap: var(--spacing-4); flex-wrap: wrap;">
      <div style="padding: var(--spacing-4); background: white; box-shadow: var(--shadow-sm);">shadow-sm</div>
      <div style="padding: var(--spacing-4); background: white; box-shadow: var(--shadow-default);">shadow-default</div>
      <div style="padding: var(--spacing-4); background: white; box-shadow: var(--shadow-md);">shadow-md</div>
      <div style="padding: var(--spacing-4); background: white; box-shadow: var(--shadow-lg);">shadow-lg</div>
    </div>
  </div>
</body>
</html>
EOF
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Build output:"
ls -la "$TOKENS_DIR/build/"
echo ""
echo "Next steps:"
echo "  1. Read the README.md for this lab"
echo "  2. Open test.html in your browser: open $TOKENS_DIR/test.html"
echo "  3. Inspect the generated files in build/"
echo "  4. Proceed to Lab 2.5 to compare with real projects"
echo ""
