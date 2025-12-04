# Chapter 8: Cross-Platform Tokens

## Chapter Goal

By the end of this chapter, you will:
- Generate tokens for iOS (Swift) and Android (Kotlin/XML)
- Understand how Style Dictionary transforms work
- Set up a build pipeline for multi-platform output
- Know how native apps consume design tokens

## Prerequisites

- Completed Chapters 1-7
- Working token system from Chapter 2
- Basic understanding of iOS/Android development (helpful but not required)

## Key Concepts

### The Token Flow

```
tokens/colors.json
         │
         ▼
   Style Dictionary
         │
    ┌────┴────┬────────────┐
    ▼         ▼            ▼
variables.css  Colors.swift  colors.xml
    │              │            │
    ▼              ▼            ▼
  Web App      iOS App     Android App
```

### Why Cross-Platform?

- **Consistency**: Same blue on web, iOS, and Android
- **Single source of truth**: Change once, update everywhere
- **Automation**: No manual copying of values

## What You'll Build

- Style Dictionary config for iOS and Android
- Swift color enums for iOS
- XML color resources for Android
- TypeScript types for React Native

## Time Estimate

- Theory: 20 minutes
- Lab exercises: 1.5 hours
- Reflection: 10 minutes

## Success Criteria

- [ ] Style Dictionary generates iOS Swift files
- [ ] Style Dictionary generates Android XML files
- [ ] Understand how native apps would use these files
- [ ] Compared with IBM Carbon's approach

## Next Chapter

Chapter 9 ties everything together in a capstone project.
