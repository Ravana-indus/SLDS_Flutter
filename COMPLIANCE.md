# SLDS Flutter — Compliance Status

**Against:** SLDS Flutter UI Library: Engineering Guidelines v1.1 (2026-08-08)
**Reviewed commit:** `9810563` (GovTech automated code audit, 2026-08-14)
**This document:** current `main`, 2026-08-15

This is the response to the compliance review. It records what has changed
since the reviewed commit, what is fixed, and what is still open — including
two defects the review did not find, and two places where this repository
knowingly diverges from the guidelines.

---

## 1. The reviewed commit is not the current state

The audit covers `9810563`. Substantial work landed between that commit and
the review being written, and more has landed since. Measured against the
review's own scorecard:

| # | Section | Audit verdict | Now |
|---|---------|---------------|-----|
| 1 | Purpose, scope, device floor | Fail | Partial — device floor still undeclared |
| 2 | Package architecture | Fail | **Pass** — `slds_tokens` is pure Dart, one-way dependency enforced in CI |
| 3 | Versioning and distribution | Fail | Partial — real CHANGELOG at 0.1.0; registry still an open §12 decision |
| 4 | Theming | Fail | **Pass** — explicit `ColorScheme`, cached statics, high contrast reachable |
| 5 | Accessibility | Fail | Partial — focus, contrast and touch targets fixed; semantics coverage incomplete |
| 6 | Localization | Partial | Partial — string set expanded; si/ta still unreviewed, no intl layer |
| 7 | API design | Partial | Partial — `heroTag`, variant constraints, badge semantics fixed; `color` remains on 18 widgets |
| 8 | Testing | Fail | **Pass with a disclosed deviation** — goldens, contrast and guideline matchers all in CI |
| 9 | Documentation and catalog | Partial | Partial |
| 10 | Contribution and governance | Not evidenced | Not evidenced — CODEOWNERS/templates still absent |
| 11 | Definition of Done | 0 of 5 components pass | Improved, not yet met — see §4 below |

Findings the audit raised that are now **closed**: C1 (package architecture),
C3 (no CI), C4 (no goldens), C5 (no high contrast), C6 (no component theming
layer — addressed differently, see §5), M1 (theme methods), M2 (ColorScheme
role coverage), M3 (badge semantics), M4 (heroTag), M8 (lint set), M9
(versioning hygiene), and minors 1, 3, 4, 5, 6, 7, 9.

Several were already closed before the review was written — `slds_tokens`,
the CI workflow, the bundled fonts and the pubspec metadata all predate it.
The component count also moved from 5 to 51.

---

## 2. Two defects the audit did not find

Both were discovered while verifying the audit rather than acting on it.

### The focus indicator was invisible

In the light palette the focus ring was a pale yellow measuring **1.30:1**
against the page background, where WCAG 2.2 requires 3.0:1 for non-text
contrast. WCAG 2.4.7 (Focus Visible) and 1.4.11 (Non-text Contrast) were
therefore failing together, on a citizen-facing national service.

Compounding it, the ring helper was applied in 3 of 51 widgets while 41
managed a `FocusNode`, and the controls that drew their own ring used the
accent gold, which is not contrast-checked against the surfaces it sits on.

Fixed: the ring is now a contrast-checked stroke (16.25:1 in light, 18.88:1
in dark) with the gold retained as the outer halo, so the indicator keeps its
SLDS character while the contrast comes from the stroke.

### Two token systems were live at once

The repository carried both a legacy token layer inside `slds_components` and
the newer `slds_tokens` package, with **different values for the same roles**
(`0xFFF0B429` against `0xffffc700` for the primary accent). 38 widgets read
one, 12 read the other, and both were publicly exported. `SldsTheme` built
from the legacy path, which is why the high-contrast palette existed but no
component could render in it.

Fixed: the legacy layer is deleted and every widget resolves from one source.

---

## 3. What is still open

Ordered by what a re-audit is most likely to reject.

| Item | Section | State |
|------|---------|-------|
| `color` parameter on 18 widgets | §4 (C2) | Removed from the button, card, text field and checkbox families; the rest still carry it |
| Semantics missing on 32 widgets | §5 | Includes interactive controls: dropdown, search bar, OTP input, date/time pickers |
| Hardcoded English semantic labels | §5, §6 | Present labels are not routed through the delegate, so a si/ta screen reader hears English |
| si/ta translations unreviewed | §6 (M6) | Machine-drafted. §6: a component with an unverified translation does not ship |
| No intl formatting layer | §6 (M6) | Dates, numbers and LKR currency still formatted ad hoc |
| Golden coverage is partial | §8 | 61 images across 5 components; the remaining 46 need the same matrix |
| `EdgeInsetsDirectional` not used | §5 | One RTL golden now proves the button mirrors; the rest is unverified |
| Reduced motion not honoured in widgets | §5 | The token layer reads `disableAnimations`; widgets do not yet act on it |
| Device floor undeclared | §1 (M7) | No minSdk pin to API 24, no documented 320dp floor |
| Credential/PII marker convention | §1 (M7) | No credential component exists yet; the contract should exist before the first one |
| Governance scaffolding | §10 | No CODEOWNERS, issue or PR templates, named owners |
| 329 undocumented public members | §7 | Ratcheted in CI so the count can only fall |

---

## 4. Definition of Done

The audit's headline was "0 of 5 components pass". That is no longer the right
measure — there are 51 components — but the honest answer is that **no
component fully meets all 13 criteria yet**. The blocking gaps are DoD 3
(semantics), DoD 5 (localized strings and intl formatting), DoD 7 (goldens for
every component), DoD 9 (dartdoc) and DoD 13 (manual TalkBack/VoiceOver pass,
which has not been performed).

`SldsButton` is closest: tokens, three themes, 48px targets, live-region
loading announcement, full golden matrix including RTL and si/ta, guideline
matchers, and a CHANGELOG entry. It still needs complete dartdoc and the
manual assistive-technology pass.

---

## 5. Deliberate divergences

Both are engineering decisions taken knowingly. They are recorded here rather
than left to be discovered.

**Component theming does not use `ThemeExtension` (§4, C6).** The guideline
prescribes one `ThemeExtension` subclass per component. This library instead
exposes a single `SldsTokenSet` read through `context.slds`, with value
equality on every group. It achieves the same goals — no literals in widgets,
values changeable in one place, no unnecessary rebuilds — without 51 extension
classes to keep in sync. If GovTech requires the prescribed shape, the
migration is mechanical but touches every widget; we would rather agree the
approach than build it twice.

**Goldens are generated on macOS, not Linux (§8).** §8 makes Linux the sole
reference platform because font rasterisation differs between operating
systems. These images were generated on macOS at the client's direction, so
the golden CI job runs on `macos-latest` to match them. Consequence: if
GovTech's own CI compares on Linux, the matrix must be regenerated there
first. The migration path is recorded in `.github/workflows/ci.yaml`.

**Token values are engineering proposals pending design sign-off (§9).** §9
makes the design team the source of truth for token values via the Figma sync.
The 19 contrast corrections were made by engineering to unblock the WCAG gate.
Each is annotated `PENDING DESIGN SIGN-OFF` in
`packages/slds_tokens/lib/src/colors.dart` with its before/after ratio. The
now-blocking CI check is what proves any replacement still passes.

---

## 6. What CI enforces today

A red build blocks merge, with no override path.

| Check | Section |
|-------|---------|
| Format | §8 |
| Analyze with `very_good_analysis`, failing on warnings and errors | §8 |
| Dependency direction (`slds_tokens` never imports Flutter) | §2 |
| WCAG contrast on every declared token pair — **blocking**, was advisory | §5, §8 |
| Colour-literal ratchet over `widgets/` | §2 |
| Public-member documentation ratchet | §7 |
| Translation completeness across en/si/ta | §6 |
| Widget, semantics and `meetsGuideline` tests | §8 |
| Golden comparison | §8 |
| Widgetbook builds, generated directory not stale | §9 |

---

## 7. Verification

```sh
dart format --set-exit-if-changed packages widgetbook app
(cd packages/slds_tokens     && dart analyze --fatal-infos && dart test)
(cd packages/slds_components && flutter analyze --no-fatal-infos)
(cd packages/slds_components && dart run tool/check_literals.dart)
(cd packages/slds_components && dart run tool/check_public_docs.dart)
(cd packages/slds_components && flutter test)
```

Current: 440 component tests, 118 token tests, all passing. Contrast is
94 pass / 0 fail, from 75 / 19 at the reviewed commit.
