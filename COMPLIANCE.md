# SLDS Flutter — Compliance Status

**Against:** SLDS Flutter UI Library: Engineering Guidelines v1.1 (2026-08-08)
**Reviewed commit:** `9810563` (GovTech automated code audit, 2026-08-14)
**This document:** current `main`, 2026-08-15

This is the response to the compliance review. It records what has changed
since the reviewed commit, what is fixed, and what is still open — including
two defects the review did not find, and three places where this repository
knowingly diverges from the guidelines.

---

## 1. The reviewed commit is not the current state

The audit covers `9810563`. Substantial work landed between that commit and
the review being written, and more has landed since. Measured against the
review's own scorecard:

| # | Section | Audit verdict | Now |
|---|---------|---------------|-----|
| 1 | Purpose, scope, device floor | Fail | Partial — floor declared and tested; credential/PII contract still absent |
| 2 | Package architecture | Fail | **Pass** — `slds_tokens` is pure Dart, one-way dependency enforced in CI |
| 3 | Versioning and distribution | Fail | Partial — real CHANGELOG at 0.1.0; registry still an open §12 decision |
| 4 | Theming | Fail | **Pass** — explicit `ColorScheme`, cached statics, high contrast reachable |
| 5 | Accessibility | Fail | Partial — focus, contrast, touch targets and reduced motion fixed; semantics coverage incomplete |
| 6 | Localization | Partial | Partial — all strings through the delegate, intl layer added; si/ta review is the only gap |
| 7 | API design | Partial | Partial — `color` removed everywhere, `heroTag` and badge semantics fixed; dartdoc incomplete |
| 8 | Testing | Fail | **Pass with a disclosed deviation** — goldens, contrast and guideline matchers all in CI |
| 9 | Documentation and catalog | Partial | Partial |
| 10 | Contribution and governance | Not evidenced | Partial — CODEOWNERS and PR/issue templates added; owner handles are placeholders |
| 11 | Definition of Done | 0 of 5 components pass | Improved, not yet met — see §4 below |

Findings the audit raised that are now **closed**: C1 (package architecture), C2 (`color` override),
C3 (no CI), C4 (no goldens), C5 (no high contrast), C6 (no component theming
layer — addressed differently, see §5), M1 (theme methods), M2 (ColorScheme
role coverage), M3 (badge semantics), M4 (heroTag), M7 (device floor), M8
(lint set), M9 (versioning hygiene), and minors 1, 3, 4, 5, 6, 7, 9.

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
| Semantics missing on ~29 widgets | §5 | The form controls (checkbox, radio, toggle) are done; dropdown, search bar, OTP input and the pickers are not |
| si/ta translations unreviewed | §6 (M6) | **The one localization blocker left.** All 21 strings are machine-drafted; §6 treats unverified as missing. Needs a Sinhala and a Tamil speaker |
| Golden coverage is partial | §8 | 61 images across 5 components; the remaining 46 need the same matrix |
| `EdgeInsetsDirectional` not used widely | §5 | One RTL golden proves the button mirrors; the rest is unverified |
| Credential/PII marker convention | §1 (M7) | No credential component exists yet; the contract should exist before the first one |
| 309 undocumented public members | §7 | Ratcheted in CI so the count can only fall |
| Private pub registry | §3, §12 | Open GovTech decision; the package is `publish_to: none` until it is made |

---

## 4. Definition of Done

The audit's headline was "0 of 5 components pass". That is no longer the right
measure — there are 51 components — but the honest answer is that **no
component fully meets all 13 criteria yet**. The blocking gaps are DoD 3
(semantics on most components), DoD 5 (si/ta translations still unreviewed),
DoD 7 (goldens for every component), DoD 9 (dartdoc) and DoD 13 (manual
TalkBack/VoiceOver pass, which has not been performed).

`SldsButton` is closest: tokens, three themes, 48px targets, live-region
loading announcement, full golden matrix including RTL and si/ta, guideline
matchers, and a CHANGELOG entry. It still needs complete dartdoc and the
manual assistive-technology pass.

---

## 5. Deliberate divergences

All three are decisions taken knowingly. They are recorded here rather than
left to be discovered at re-audit.

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

Current: 485 component tests, 118 token tests, all passing. Contrast is
94 pass / 0 fail, from 75 / 19 at the reviewed commit.
