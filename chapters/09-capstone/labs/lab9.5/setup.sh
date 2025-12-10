#!/bin/bash

# Lab 9.5 Setup Script
# Final review and self-check for the capstone project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="$SCRIPT_DIR/../../../04-monorepo-architecture/labs/lab4.1"
WEB_DIR="$MONOREPO_DIR/apps/web"
UI_DIR="$MONOREPO_DIR/packages/ui"

echo "=== Lab 9.5: Final Review & Self-Check ==="
echo ""

# Check if monorepo exists
if [ ! -d "$MONOREPO_DIR" ]; then
    echo "Error: Chapter 4 monorepo not found at $MONOREPO_DIR"
    echo "Please complete Chapter 4 labs first."
    exit 1
fi

echo "=== Files You Should Have ==="
echo ""
echo "Types & Data:"
if [ -f "$WEB_DIR/types/team.ts" ]; then
    echo "  ✓ types/team.ts"
else
    echo "  ✗ types/team.ts (missing)"
fi
if [ -f "$WEB_DIR/data/mockTeamMembers.ts" ]; then
    echo "  ✓ data/mockTeamMembers.ts"
else
    echo "  ✗ data/mockTeamMembers.ts (missing)"
fi

echo ""
echo "UI Components (packages/ui/):"
if [ -f "$UI_DIR/src/components/Modal.tsx" ]; then
    echo "  ✓ Modal.tsx"
else
    echo "  ✗ Modal.tsx (missing)"
fi
if [ -f "$UI_DIR/src/components/Select.tsx" ]; then
    echo "  ✓ Select.tsx"
else
    echo "  ✗ Select.tsx (missing)"
fi
if [ -f "$UI_DIR/src/components/Modal.stories.tsx" ]; then
    echo "  ✓ Modal.stories.tsx"
else
    echo "  ✗ Modal.stories.tsx (missing)"
fi
if [ -f "$UI_DIR/src/components/Select.stories.tsx" ]; then
    echo "  ✓ Select.stories.tsx"
else
    echo "  ✗ Select.stories.tsx (missing)"
fi

echo ""
echo "App Components (apps/web/components/team/):"
if [ -f "$WEB_DIR/components/team/TeamMemberRow.tsx" ]; then
    echo "  ✓ TeamMemberRow.tsx"
else
    echo "  ✗ TeamMemberRow.tsx (missing)"
fi
if [ -f "$WEB_DIR/components/team/InviteMemberModal.tsx" ]; then
    echo "  ✓ InviteMemberModal.tsx"
else
    echo "  ✗ InviteMemberModal.tsx (missing)"
fi
if [ -f "$WEB_DIR/components/team/TeamMemberList.tsx" ]; then
    echo "  ✓ TeamMemberList.tsx"
else
    echo "  ✗ TeamMemberList.tsx (missing)"
fi

echo ""
echo "Page:"
if [ -f "$WEB_DIR/app/team/page.tsx" ]; then
    echo "  ✓ app/team/page.tsx"
else
    echo "  ✗ app/team/page.tsx (missing)"
fi

echo ""
echo "=== Functional Requirements Checklist ==="
echo ""
echo "View & Display:"
echo "  [ ] Members display with avatar, name, email"
echo "  [ ] Role badge shows for each member"
echo "  [ ] Pending status shows for invited members"
echo "  [ ] Owner cannot be removed"
echo ""
echo "Search & Filter:"
echo "  [ ] Search filters by name"
echo "  [ ] Search filters by email"
echo "  [ ] Role filter buttons work"
echo "  [ ] Empty state shows when no matches"
echo ""
echo "Invite Flow:"
echo "  [ ] Invite button opens modal"
echo "  [ ] Email validation works"
echo "  [ ] Loading state shows on submit"
echo "  [ ] Modal closes on success"
echo ""
echo "Theme Support:"
echo "  [ ] Theme toggle works everywhere"
echo "  [ ] No hardcoded colors"

echo ""
echo "=== Technical Requirements Checklist ==="
echo ""
echo "Component Architecture:"
echo "  [ ] UI components in packages/ui/"
echo "  [ ] App components in apps/web/components/team/"
echo "  [ ] Page in apps/web/app/team/"
echo "  [ ] Types in apps/web/types/"
echo ""
echo "Tokenization:"
echo "  [ ] All colors use var(--color-*)"
echo "  [ ] No hardcoded hex colors"
echo ""
echo "Type Safety:"
echo "  [ ] TeamMember interface defined"
echo "  [ ] TeamInvite interface defined"
echo "  [ ] Props interfaces for all components"

echo ""
echo "=== 5-Layer Architecture ==="
echo ""
cat << 'EOF'
┌─────────────────────────────────────────────────────────────────┐
│ LAYER 5: Pages                                                   │
│ └── app/team/page.tsx                                           │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 4: App Components                                         │
│ └── components/team/                                            │
│     ├── TeamMemberList.tsx                                      │
│     ├── TeamMemberRow.tsx                                       │
│     └── InviteMemberModal.tsx                                   │
├─────────────────────────────────────────────────────────────────┤
│ LAYERS 2-3: UI Components                                       │
│ └── packages/ui/src/components/                                 │
│     ├── Modal.tsx                                               │
│     └── Select.tsx                                              │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 1: Design Tokens                                          │
│ └── packages/tokens/ + theme.css                               │
└─────────────────────────────────────────────────────────────────┘
EOF

echo ""
echo "=== Self-Assessment ==="
echo ""
echo "Rate yourself (1-5) on each criterion:"
echo ""
echo "  Feature completeness:     [ ]"
echo "  Component architecture:   [ ]"
echo "  Design token usage:       [ ]"
echo "  Theme support:            [ ]"
echo "  Code quality:             [ ]"
echo "  Documentation (stories):  [ ]"
echo ""

echo "=== What You've Learned ==="
echo ""
echo "  ✓ The 5-layer architecture of design systems"
echo "  ✓ How to create and use design tokens"
echo "  ✓ Building accessible primitive components"
echo "  ✓ Monorepo architecture with Turborepo"
echo "  ✓ Separating UI from app components"
echo "  ✓ Implementing themes with CSS variables"
echo "  ✓ Documenting with Storybook"
echo "  ✓ Cross-platform token generation"
echo "  ✓ Integrating everything into a real feature"
echo ""

echo "=== Congratulations! ==="
echo ""
echo "You've completed the Design System course!"
echo ""
echo "Next steps:"
echo "  1. Review the README.md for written reflection"
echo "  2. Explore Cal.com and Supabase codebases"
echo "  3. Apply these patterns to your own projects"
echo ""
