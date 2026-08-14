# Changelog

Raw design tokens for SLDS. Pure Dart, no Flutter dependency.

## 0.1.0

### Added

- `SldsOpacityTokens` — the disabled dim and scrim alpha, as their own token
  group rather than living in the colour palette (§2).
- `SldsDimensionTokens.breakpointMobile` — the mobile breakpoint as a raw
  width. The `BuildContext` helper that reads it stays in `slds_components`,
  since `BuildContext` is Flutter.

### Changed

- **Corrected 19 colour values that failed WCAG 2.2 AA.** The focus ring was
  the serious one: at 1.30:1 against the page it was effectively invisible,
  failing 2.4.7 and 1.4.11 together. Also corrected: tertiary text, default
  borders, input helper and icon colours, the success colour, and seven badge
  text colours.

  These were set by engineering to unblock the contrast gate. §9 makes the
  design team the source of truth for token values, so every changed value is
  annotated `PENDING DESIGN SIGN-OFF` in `lib/src/colors.dart` with its
  before/after ratio, for confirmation or replacement at the next Figma sync.

## 0.0.1

- Initial extraction from `slds_components`: colours as ARGB ints, dimensions,
  typography metrics, motion durations, and the WCAG contrast helpers.
