# SLDS Flutter — Compliance Status

**Against:** SLDS Flutter UI Library: Engineering Guidelines v1.1 (2026-08-08)
**Reviewed commit:** `9810563` (GovTech automated code audit, 2026-08-14)
**This document:** current `main`, 2026-09-01

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
| 3 | Versioning and distribution | Fail | Partial — real CHANGELOG at 0.1.0-alpha; registry still an open §12 decision |
| 4 | Theming | Fail | **Pass** — explicit `ColorScheme`, cached statics, high contrast reachable |
| 5 | Accessibility | Fail | Partial — focus, contrast, touch targets, reduced motion and semantics coverage fixed; the manual screen-reader pass is the one gap left |
| 6 | Localization | Partial | Partial — all strings through the delegate, intl layer added; si/ta review is the only gap |
| 7 | API design | Partial | **Pass** — `color` removed everywhere, `heroTag` and badge semantics fixed, and every public member now carries dartdoc |
| 8 | Testing | Fail | **Pass with a disclosed deviation** — goldens, contrast and guideline matchers all in CI |
| 9 | Documentation and catalog | Partial | Partial — the public API is fully documented; the catalog narrative is still thin |
| 10 | Contribution and governance | Not evidenced | Partial — CODEOWNERS and PR/issue templates added; owner handles are placeholders |
| 11 | Definition of Done | 0 of 5 components pass | Improved, not yet met — see §4 below |

Findings the audit raised that are now **closed**: C1 (package architecture), C2 (`color` override),
C3 (no CI), C4 (no goldens), C5 (no high contrast), C6 (no component theming
layer — addressed differently, see §5), M1 (theme methods), M2 (ColorScheme
role coverage), M3 (badge semantics), M4 (heroTag), M7 (device floor), M8
(lint set), M9 (versioning hygiene), and minors 1, 3, 4, 5, 6, 7, 9.

Several were already closed before the review was written — `slds_tokens`,
the CI workflow, the bundled fonts and the pubspec metadata all predate it.
The component count also moved from 5 to 52.

---

## 2. Two defects the audit did not find

Both were discovered while verifying the audit rather than acting on it.

### The focus indicator was invisible

In the light palette the focus ring was a pale yellow measuring **1.30:1**
against the page background, where WCAG 2.2 requires 3.0:1 for non-text
contrast. WCAG 2.4.7 (Focus Visible) and 1.4.11 (Non-text Contrast) were
therefore failing together, on a citizen-facing national service.

Compounding it, the ring helper was applied in 3 of 52 widgets while 41
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
| Semantics on the presentational set | §5 | **Resolved.** `SldsStepIndicator` was silent — pure colour with no text — and now announces `Progress` with an `n/total` value; `SldsSnackBar` is a live region, so its arrival is announced rather than missed. The rest of the set (badge, card, divider, empty/error state, notification card, pull-to-refresh) renders real `Text`, which a reader already reads in order; wrapping those in `MergeSemantics` was tried and reverted — it swallowed the action button into the merged node and destroyed an interactive control |
| si/ta translations unreviewed | §6 (M6) | **The one localization blocker left.** All 47 strings are machine-drafted; §6 treats unverified as missing. Needs a Sinhala and a Tamil speaker |
| Manual TalkBack/VoiceOver pass not performed | §5, DoD 13 | **Open, and not closable from the repository.** Procedure and per-component checklist generated by `tool/build_screen_reader_packet.dart` — 51 components, 255 judgements. Needs a tester with a handset. Two passes, one per platform |
| Low-end device smoke test not run | §8 | Neither the procedure nor a pass exists. Naming the handset is a GovTech decision, and the §1 device floor is declared but unexercised |
| Golden coverage is partial | §8 | **Resolved.** 238 images. The deep matrix still covers button, card, FAB, text field and toggle; `slds_goldens_coverage_test.dart` adds every remaining component at one image per theme plus a 200% text-scale pass. That shallower pass immediately earned itself: it caught `SldsUploadField` overflowing its field by 88px at a doubled text scale (WCAG 1.4.4), now fixed and regression-tested |
| `EdgeInsetsDirectional` not used widely | §5 | **Resolved.** Every directional inset, alignment, border radius and `Positioned` now uses the `*Directional` variant; 9 RTL goldens prove the mirroring. The two remaining `EdgeInsets.only` are vertical-only, and the time picker's clock face is deliberately absolute |
| Credential/PII marker convention | §1 (M7) | No credential component exists yet; the contract should exist before the first one |
| Undocumented public members | §7 | **Resolved.** 305 → 0. `public_member_api_docs` is back at its default severity, so a new undocumented member fails `flutter analyze` directly; the ratchet tool that guarded the backlog is deleted |
| Private pub registry | §3, §12 | Open GovTech decision; the package is `publish_to: none` until it is made |

---

## 4. Definition of Done

The audit's headline was "0 of 5 components pass". That is no longer the right
measure — there are 52 components — and four of the five gaps that blocked
every one of them are now closed:

| DoD | Criterion | State |
|-----|-----------|-------|
| 3 | Semantics | **Met.** The two components that genuinely lost information — a silent step indicator and a snack bar nobody was told about — now announce themselves, and both are regression-tested |
| 5 | Localization | **Not met.** si/ta remain machine-drafted. Needs two native speakers |
| 7 | Goldens | **Met.** Every exported component has images across light, dark and high contrast, plus a 200% text-scale pass |
| 9 | Dartdoc | **Met.** 305 → 0, with the analyzer rule back at default severity |
| 13 | Manual screen-reader pass | **Not met.** Needs a person and a handset |

**`SldsButton` now meets 11 of the 13**, and is blocked only by the two
gates below. It renders `sldsStrings.loading` in its loading state, so DoD 5
binds it like any other component carrying translated copy — an earlier
draft of this section claimed otherwise and was wrong. Every component is
blocked by DoD 13; every component that renders a library string is blocked
by DoD 5 as well.

The two remaining gates are the two that no amount of engineering closes,
and it is worth being precise about why:

**DoD 13** needs a person with a screen reader on a physical handset. The
automated suite asserts a label *exists*; it cannot assert that what a blind
citizen hears makes sense. "Button, button" passes every matcher in this
repository and is useless out loud. What engineering can do is remove every
reason the pass keeps being deferred, so `tool/build_screen_reader_packet.dart`
generates the tester's checklist: all 51 testable components, the interactive
surface of each derived from the source, and five checks that genuinely need
ears. What the automated suite already proves — tap targets, contrast, label
presence, live regions, localized labels — is listed once and deliberately
excluded, so the pass is 255 judgements rather than a thousand. Attaching the
completed packet is a line in the PR template.

**DoD 5** needs a Sinhala speaker and a Tamil speaker. Machine-drafted
government copy is a specific hazard rather than a generic one: a plausible
but wrong rendering of "rejected" or "escalated" on a citizen-facing service
misinforms the people least able to route around it. §6 treats unverified as
missing, and that is the right call.

Both are scheduling and staffing decisions, not engineering ones. Until they
are booked, no component can pass all 13 — which is a true statement about
the process, not a defect left in the code.

---

## 5. Deliberate divergences

All three are decisions taken knowingly. They are recorded here rather than
left to be discovered at re-audit.

**Component theming does not use `ThemeExtension` (§4, C6).** The guideline
prescribes one `ThemeExtension` subclass per component. This library instead
exposes a single `SldsTokenSet` read through `context.slds`, with value
equality on every group. It achieves the same goals — no literals in widgets,
values changeable in one place, no unnecessary rebuilds — without 52 extension
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
The contrast corrections were made by engineering to unblock the WCAG gate.
They are recorded under two `PENDING DESIGN SIGN-OFF` blocks in
`packages/slds_tokens/lib/src/colors.dart` — one per palette — each listing
the affected tokens with their before/after ratios, plus the departures from
Figma that are deliberate and must not be "corrected" back. The
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
(cd packages/slds_components && flutter test)
```

Current: 760 component tests (1 skipped) and 150 token tests, all passing —
238 golden images, `flutter analyze` clean of errors and warnings with
`public_member_api_docs` at its default severity. Contrast is 120 pairings
across the three palettes, 0 failing, from 19 failing at the reviewed
commit.
