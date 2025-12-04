# Chapter 9: Capstone Project

## Chapter Goal

Apply everything you've learned to build a complete feature that demonstrates:
- Design tokens flowing through the system
- Primitive components from your UI package
- App components with business logic
- Theming that works across all components
- Storybook documentation

## The Project: Team Management Feature

Build a "Team Settings" page that allows users to:
- View team members in a list
- Invite new members via a modal
- Edit member roles
- Remove members (with confirmation)
- Filter and search members
- Toggle between light and dark themes

## What You'll Build

### UI Components (packages/ui/)
- Modal/Dialog component
- Select/Dropdown component
- Table component (optional)
- ConfirmDialog component

### App Components (apps/web/components/)
- TeamMemberRow
- InviteMemberModal
- EditRoleModal
- ConfirmDeleteDialog
- TeamMemberFilters

### Pages
- /team - Main team management page

## Requirements

### Functional Requirements
- [ ] Display list of team members with avatar, name, email, role
- [ ] Search members by name or email
- [ ] Filter by role (admin, member, guest)
- [ ] Invite new member (opens modal with form)
- [ ] Edit member role (inline or via modal)
- [ ] Delete member (with confirmation dialog)
- [ ] Handle loading and error states

### Technical Requirements
- [ ] All UI components use design tokens
- [ ] All UI components have Storybook stories
- [ ] Light/dark theme works throughout
- [ ] App components properly separate UI from logic
- [ ] TypeScript types for all entities

## Time Estimate

- Planning: 30 minutes
- Building UI components: 2-3 hours
- Building app components: 2-3 hours
- Storybook stories: 1 hour
- Polish and testing: 1 hour

## Success Criteria

- [ ] Feature works end-to-end
- [ ] Components use tokens for all styling
- [ ] Theme toggle works
- [ ] Storybook shows all components
- [ ] Code is well-organized

## Submission

When complete, your project should demonstrate:
1. Understanding of the 5-layer architecture
2. Proper separation of UI and app components
3. Token-based styling with theming
4. Component documentation with Storybook
