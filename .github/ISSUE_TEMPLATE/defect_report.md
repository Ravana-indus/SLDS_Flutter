---
name: Defect report
about: Report a defect in a shipped component (§10)
title: "[Defect] "
labels: defect, needs-triage
---

<!--
§10: defects are reported through this tracker, not through chat or email.
Each issue gets a triage label within five working days. The tracker is the
record — an undocumented report does not obligate the maintainers.
-->

## Component and version

- Component:
- `slds_components` version:
- Flutter version:

## What happens

<!-- Actual behaviour. -->

## What should happen

<!-- Expected behaviour, and the spec or guideline section it comes from
     if there is one. -->

## Reproduction

```dart
// The smallest widget tree that shows the defect.
```

## Environment

- [ ] Android — API level:
- [ ] iOS — version:
- [ ] Web
- [ ] Desktop

Please state the screen width if layout is involved. The library's declared
floor is 320dp (§1), and defects at the low end matter: this is a
citizen-facing platform, so low-end devices are a large share of real users.

## Accessibility impact

- [ ] None known
- [ ] Screen reader — TalkBack / VoiceOver
- [ ] Contrast or use of colour
- [ ] Touch target size
- [ ] Text scaling (up to 200%)
- [ ] Keyboard or focus order
- [ ] Reduced motion

An accessibility defect on a government service is a compliance issue, not a
cosmetic one — say so here if it is one, so triage can rank it properly.

## Screenshots

<!-- Use synthetic data only. Never attach a screenshot containing a real
     NIC, licence or vehicle number (§1). -->
