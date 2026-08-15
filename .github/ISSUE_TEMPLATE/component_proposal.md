---
name: Component proposal
about: Propose a new component for the library (§10)
title: "[Component] "
labels: proposal, needs-triage
---

<!--
§10: new components enter through a proposal reviewed by the architecture
owner *before* implementation starts. This is what stops the library
accumulating five slightly different date pickers.

A component used by only one application stays in that application until a
second consumer appears.
-->

## Name

<!-- e.g. SldsCredentialCard. All public widgets use the Slds prefix (§7). -->

## Design spec reference

<!-- Link the Figma frame or Foundation Documentation section. A component
     without a spec reference cannot be reviewed against anything. -->

## Consuming applications

§10 requires at least two applications that need this component.

1.
2.

## API sketch

```dart
// Prefer named variants over free-form styling parameters. A widget
// approaching 12 constructor parameters is a signal to split it (§7).
```

## States

Which of the mandatory set apply, and which genuinely do not (§7)?

| State | Applies | Notes |
|-------|---------|-------|
| default | | |
| focus | | |
| hover | | |
| pressed | | |
| disabled | | |
| loading | | |
| empty | | |
| error | | |
| offline | | |
| stale | | |

## Credential or PII data

Does this component render identity or credential data (Driving Licence,
Revenue Licence, Emission Certificate, Motor Insurance)?

- [ ] No
- [ ] Yes — it must expose the screenshot/recording restriction marker, and
      its semantics labels must describe fields rather than speak values (§1)

## Proposed owner

<!-- Every component has a named owner responsible for defects and
     upgrades (§10). -->
