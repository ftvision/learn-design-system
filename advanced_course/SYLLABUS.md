# Advanced Design Systems: From Building to Scaling

A follow-up course for teams ready to move from building design systems to running them at scale.

---

## Course Overview

**Prerequisite:** Completion of "Design Systems: A Practical Course" or equivalent experience building design systems with tokens, components, and documentation.

**Target Audience:**
- Senior frontend engineers leading design system initiatives
- Design system team leads and managers
- Staff/Principal engineers responsible for frontend architecture
- Design technologists bridging design and engineering

**Course Philosophy:**

The foundational course taught you to **build** design systems. This course teaches you to **run** them—the organizational, process, and strategic skills that determine whether a design system succeeds or fails at scale.

```
Foundational Course              This Course
─────────────────────           ─────────────────────
"How do I build a               "How do I make sure
 Button component?"              1000 engineers use it
                                 correctly, and it evolves
                                 without breaking everything?"
```

---

## Course Structure

```
advanced_course/
├── 01-governance/              # Who decides what gets built?
├── 02-accessibility/           # Accessibility as infrastructure
├── 03-motion-interaction/      # Animation & interaction patterns
├── 04-adoption-measurement/    # Proving value with data
├── 05-versioning-migration/    # Evolving without breaking
├── 06-team-processes/          # Collaboration at scale
└── 07-capstone/                # Real-world transformation project
```

---

## Chapters

| # | Chapter | Time | What You'll Learn |
|---|---------|------|-------------------|
| 1 | [Governance & Contribution](#chapter-1-governance--contribution) | 3 hrs | RFC process, decision records, component lifecycle |
| 2 | [Accessibility Infrastructure](#chapter-2-accessibility-infrastructure) | 4 hrs | Testing automation, ARIA patterns, compliance strategy |
| 3 | [Motion & Interaction](#chapter-3-motion--interaction) | 3 hrs | Motion tokens, animation system, reduced motion |
| 4 | [Adoption & Measurement](#chapter-4-adoption--measurement) | 3 hrs | Metrics, analytics, proving ROI |
| 5 | [Versioning & Migration](#chapter-5-versioning--migration) | 4 hrs | Semver strategy, codemods, deprecation workflows |
| 6 | [Team & Process](#chapter-6-team--process) | 3 hrs | Team models, communication, roadmapping |
| 7 | [Capstone: System Transformation](#chapter-7-capstone) | 8 hrs | Apply everything to a real scenario |

**Total time:** ~28 hours

---

## Chapter Details

### Chapter 1: Governance & Contribution

**Goal:** Establish clear processes for how your design system evolves.

**Topics:**
- The governance spectrum (dictatorship → democracy)
- Component lifecycle: proposal → experimental → stable → deprecated
- RFC (Request for Comments) process
- Architecture Decision Records (ADRs)
- Breaking change policies
- Review processes (design review, code review, accessibility review)

**Lab:** Create a governance document and RFC template for your design system.

**Case Study:** How Shopify Polaris handles contributions from 50+ teams.

```
┌─────────────────────────────────────────────────────────────────┐
│                    COMPONENT LIFECYCLE                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   💡 Proposal                                                    │
│    │  └── RFC document, problem statement, alternatives          │
│    ▼                                                             │
│   🧪 Experimental                                                │
│    │  └── Unstable API, limited use, gathering feedback          │
│    ▼                                                             │
│   ✅ Stable                                                      │
│    │  └── Documented, tested, semantic versioning                │
│    ▼                                                             │
│   ⚠️ Deprecated                                                  │
│    │  └── Migration guide, warnings, sunset timeline             │
│    ▼                                                             │
│   🗑️ Removed                                                     │
│       └── Major version bump, codemod provided                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Deliverables:**
- [ ] Governance document
- [ ] RFC template
- [ ] ADR template
- [ ] Component proposal checklist

---

### Chapter 2: Accessibility Infrastructure

**Goal:** Build accessibility into the system, not as an afterthought.

**Topics:**
- WCAG 2.1 AA vs AAA compliance strategy
- Accessibility token layer (focus rings, contrast ratios)
- Automated testing (axe-core, jest-axe, Storybook a11y addon)
- Manual testing protocols (screen readers, keyboard)
- ARIA patterns library
- Focus management in complex components
- Color contrast validation in token pipeline

**Lab:** Add comprehensive accessibility testing to your component library.

**Case Study:** How Adobe built React Aria as accessibility infrastructure.

```
┌─────────────────────────────────────────────────────────────────┐
│                 ACCESSIBILITY TESTING PYRAMID                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│                        ┌─────────┐                               │
│                        │ Manual  │  Screen reader, real users    │
│                        │ Testing │                               │
│                       ┌┴─────────┴┐                              │
│                       │Integration│  Storybook a11y addon        │
│                       │  Testing  │  Cypress accessibility       │
│                      ┌┴───────────┴┐                             │
│                      │    Unit     │  jest-axe on components     │
│                      │   Testing   │  Focus trap tests           │
│                     ┌┴─────────────┴┐                            │
│                     │    Static     │  ESLint jsx-a11y           │
│                     │   Analysis    │  TypeScript ARIA props     │
│                     └───────────────┘                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Deliverables:**
- [ ] Accessibility testing setup (jest-axe, Storybook addon)
- [ ] Screen reader testing checklist
- [ ] Focus management patterns documentation
- [ ] Color contrast validation in token build

---

### Chapter 3: Motion & Interaction

**Goal:** Create a systematic approach to animation and interaction.

**Topics:**
- Motion token system (duration, easing, delay)
- Animation principles for UI (enter, exit, feedback, transition)
- Reduced motion support (`prefers-reduced-motion`)
- Loading states and skeleton patterns
- Micro-interactions library
- Gesture patterns for touch interfaces
- Performance considerations (GPU acceleration, will-change)

**Lab:** Build a motion token system and animate key components.

**Case Study:** Material Design's motion system and IBM Carbon's animation guidelines.

```
┌─────────────────────────────────────────────────────────────────┐
│                    MOTION TOKEN SYSTEM                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   tokens/motion.json                                             │
│   {                                                              │
│     "motion": {                                                  │
│       "duration": {                                              │
│         "instant": { "$value": "0ms" },                         │
│         "fast":    { "$value": "100ms" },                       │
│         "normal":  { "$value": "200ms" },                       │
│         "slow":    { "$value": "300ms" },                       │
│         "slower":  { "$value": "500ms" }                        │
│       },                                                         │
│       "easing": {                                                │
│         "ease-in":     { "$value": [0.4, 0, 1, 1] },            │
│         "ease-out":    { "$value": [0, 0, 0.2, 1] },            │
│         "ease-in-out": { "$value": [0.4, 0, 0.2, 1] }           │
│       }                                                          │
│     }                                                            │
│   }                                                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Deliverables:**
- [ ] Motion tokens (duration, easing)
- [ ] Animated component variants (Button, Modal, Toast)
- [ ] Reduced motion support
- [ ] Loading/skeleton components
- [ ] Motion guidelines documentation

---

### Chapter 4: Adoption & Measurement

**Goal:** Prove the value of your design system with data.

**Topics:**
- Defining success metrics (adoption, coverage, satisfaction)
- Quantitative metrics (component usage, bundle size, build time)
- Qualitative metrics (developer surveys, support tickets)
- Instrumentation and analytics
- Storybook analytics integration
- Building adoption dashboards
- Communicating value to stakeholders
- Identifying adoption barriers

**Lab:** Set up adoption tracking and build a metrics dashboard.

**Case Study:** How Figma measures design system value.

```
┌─────────────────────────────────────────────────────────────────┐
│                    ADOPTION METRICS FRAMEWORK                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   LAGGING INDICATORS (Outcomes)                                  │
│   ├── Design system component coverage (% of UI)                │
│   ├── Time to ship new features                                 │
│   ├── Design-to-dev handoff time                                │
│   └── Accessibility audit pass rate                             │
│                                                                  │
│   LEADING INDICATORS (Predictors)                                │
│   ├── Storybook page views                                      │
│   ├── npm download trends                                       │
│   ├── Slack/Discord question volume                             │
│   └── New team onboarding time                                  │
│                                                                  │
│   HEALTH INDICATORS (System Quality)                             │
│   ├── Bundle size over time                                     │
│   ├── Build/test time                                           │
│   ├── Open issues / PRs                                         │
│   └── Documentation coverage                                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Deliverables:**
- [ ] Metrics definition document
- [ ] Component usage tracking setup
- [ ] Adoption dashboard (or spreadsheet)
- [ ] Stakeholder presentation template

---

### Chapter 5: Versioning & Migration

**Goal:** Evolve your design system without breaking consumer apps.

**Topics:**
- Semantic versioning for component libraries
- Breaking vs non-breaking changes
- Deprecation workflows and timelines
- Writing codemods (jscodeshift)
- Changelog automation (conventional commits)
- Release channels (stable, next, canary)
- Multi-version documentation
- Coordinated releases across packages

**Lab:** Create a deprecation workflow and write a codemod.

**Case Study:** How React and MUI handle major version migrations.

```
┌─────────────────────────────────────────────────────────────────┐
│                    RELEASE STRATEGY                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Release Channels                                               │
│   ─────────────────                                              │
│   @latest   →  Stable, production-ready                         │
│   @next     →  Release candidate, testing                       │
│   @canary   →  Experimental, daily builds                       │
│                                                                  │
│   Deprecation Timeline                                           │
│   ────────────────────                                           │
│   v3.0: Component is stable                                     │
│   v3.5: Deprecation warning added, migration guide written      │
│   v4.0: Component removed, codemod provided                     │
│                                                                  │
│   Breaking Change Checklist                                      │
│   ─────────────────────────                                      │
│   [ ] Documented in CHANGELOG                                   │
│   [ ] Migration guide written                                   │
│   [ ] Codemod created (if possible)                            │
│   [ ] Announced in release notes                                │
│   [ ] Support channel prepared for questions                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Deliverables:**
- [ ] Versioning policy document
- [ ] Deprecation workflow
- [ ] Sample codemod
- [ ] Changelog automation setup
- [ ] Migration guide template

---

### Chapter 6: Team & Process

**Goal:** Structure your team and processes for sustainable success.

**Topics:**
- Team models (centralized, federated, hybrid)
- Roles on a design system team
- Designer-developer collaboration workflows
- Design-dev handoff best practices
- Communication channels (Slack, office hours, newsletters)
- Roadmap planning and prioritization
- Stakeholder management
- Handling exceptions and one-offs

**Lab:** Create a team charter and communication plan.

**Case Study:** Team structures at Shopify, Atlassian, and GitHub.

```
┌─────────────────────────────────────────────────────────────────┐
│                    TEAM MODELS COMPARISON                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   CENTRALIZED                                                    │
│   ┌─────────────────────────────────────────┐                   │
│   │         Design System Team              │                   │
│   │  (owns everything, all contributions)   │                   │
│   └─────────────────────────────────────────┘                   │
│   ✅ Consistency  ❌ Bottleneck  ❌ Disconnected                 │
│                                                                  │
│   FEDERATED                                                      │
│   ┌─────────┐  ┌─────────┐  ┌─────────┐                         │
│   │ Team A  │  │ Team B  │  │ Team C  │  (all contribute)       │
│   └─────────┘  └─────────┘  └─────────┘                         │
│   ✅ Distributed  ❌ Inconsistent  ❌ No direction               │
│                                                                  │
│   HYBRID (Recommended)                                           │
│   ┌─────────────────────────────────────────┐                   │
│   │         Core Team (3-5 people)          │                   │
│   │  Strategy, primitives, governance       │                   │
│   └──────────────────┬──────────────────────┘                   │
│                      │                                           │
│   ┌─────────┐  ┌─────┴─────┐  ┌─────────┐                       │
│   │ Team A  │  │ Team B    │  │ Team C  │  (contributors)       │
│   │contribut│  │contributes│  │contribut│                       │
│   └─────────┘  └───────────┘  └─────────┘                       │
│   ✅ Balance of consistency and velocity                        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Deliverables:**
- [ ] Team charter document
- [ ] RACI matrix for design system decisions
- [ ] Communication plan (channels, cadence)
- [ ] Roadmap template
- [ ] Exception request process

---

### Chapter 7: Capstone — System Transformation

**Goal:** Apply everything to transform a real (or realistic) design system.

**Scenario:** You're brought in to improve an existing design system that has:
- Low adoption (teams building custom components)
- No governance (anyone can merge anything)
- Accessibility issues flagged in audit
- No versioning strategy (frequent breaking changes)
- Unclear ownership (no dedicated team)

**Deliverables:**
1. **Audit report** — Current state assessment
2. **Governance proposal** — RFC process, component lifecycle
3. **Accessibility plan** — Testing setup, compliance roadmap
4. **Metrics dashboard** — Adoption tracking
5. **Versioning strategy** — Semver policy, deprecation workflow
6. **Team charter** — Roles, responsibilities, communication
7. **90-day roadmap** — Prioritized action plan
8. **Stakeholder presentation** — Pitch your transformation plan

**Evaluation Criteria:**
- Addresses all six topic areas
- Realistic and actionable recommendations
- Clear prioritization
- Measurable success criteria
- Considers organizational constraints

---

## Assessment

| Component | Weight | Description |
|-----------|--------|-------------|
| Chapter Labs | 40% | Hands-on deliverables from each chapter |
| Capstone Project | 40% | Comprehensive transformation plan |
| Participation | 20% | Discussion, peer feedback, presentations |

---

## Schedule (Suggested)

### Week 1-2: Governance & Accessibility
- Chapter 1: Governance & Contribution
- Chapter 2: Accessibility Infrastructure

### Week 3-4: System Design
- Chapter 3: Motion & Interaction
- Chapter 4: Adoption & Measurement

### Week 5-6: Operations & Capstone
- Chapter 5: Versioning & Migration
- Chapter 6: Team & Process
- Chapter 7: Capstone (begin)

### Week 7-8: Capstone Completion
- Capstone work and presentations

---

## Required Readings

### Books
- "Design Systems" by Alla Kholmatova (Chapters on governance)
- "Inclusive Components" by Heydon Pickering (Accessibility)

### Articles
- [Team Models for Scaling Design Systems](https://medium.com/eightshapes-llc/team-models-for-scaling-a-design-system-2cf9d03be6a0) — Nathan Curtis
- [Measuring Design System Success](https://www.figma.com/blog/measuring-the-value-of-design-systems/) — Figma
- [The Salesforce Design System Governance Model](https://medium.com/salesforce-ux/the-salesforce-team-model-for-scaling-a-design-system-d89c2a2d404b)

### Documentation
- [Shopify Polaris Contribution Guidelines](https://polaris.shopify.com/contributing)
- [GitHub Primer Governance](https://primer.style/guides/contribute)
- [Material Design Motion Guidelines](https://m3.material.io/styles/motion/overview)

---

## Tools & Technologies

| Category | Tools |
|----------|-------|
| Accessibility Testing | axe-core, jest-axe, Storybook a11y addon, NVDA, VoiceOver |
| Codemods | jscodeshift, ts-morph |
| Analytics | Storybook analytics, custom instrumentation, Omlet |
| Documentation | Storybook, zeroheight, Supernova |
| Communication | Slack, Notion, Loom |

---

## Instructor Notes

This course works best with:
- **Real examples** from students' own organizations
- **Guest speakers** from companies with mature design systems
- **Peer review** of capstone projects
- **Discussion-heavy sessions** on governance and team topics

The capstone should feel like a consulting engagement—analyzing a real situation and proposing solutions.

---

## Resources

### Communities
- [Design Systems Slack](https://design.systems/slack)
- [Clarity Conference](https://www.clarityconf.com/)
- [Design Systems London/NYC Meetups](https://www.meetup.com/topics/design-systems/)

### Open-Source Design Systems to Study
| System | Best For Learning |
|--------|-------------------|
| [Shopify Polaris](https://polaris.shopify.com/) | Governance, contribution |
| [GitHub Primer](https://primer.style/) | Accessibility, multi-platform |
| [Adobe Spectrum](https://spectrum.adobe.com/) | Accessibility infrastructure |
| [IBM Carbon](https://carbondesignsystem.com/) | Motion, cross-platform |
| [Atlassian Design System](https://atlassian.design/) | Scale, enterprise |

---

*This syllabus is a starting point. Adapt based on your students' experience and organizational contexts.*
