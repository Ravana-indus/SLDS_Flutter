# Changelog

All notable changes to `slds_components` are recorded here. This package
follows semantic versioning (§3): a renamed parameter, a changed default or a
removed widget is a breaking change. A change that alters a golden without
changing the API is a minor bump at minimum, with before/after images.

Pre-1.0 the API is not yet stable: `0.x` releases may break without a major
bump, and `-alpha` releases carry no compatibility promise at all. Alpha
ordering is semver's, so `0.1.0-alpha` precedes `0.1.0` — pin an exact
version while consuming a pre-release.

## 0.1.0-alpha

First release addressing the GovTech compliance review of commit `9810563`
against *SLDS Flutter UI Library: Engineering Guidelines v1.1*.

Breaking. The library is not yet published to the private registry, so no
consuming app is affected — this is the cheapest possible moment for the
removals below.

### Breaking changes

**The per-instance `color` parameter is removed** from `SldsButton`,
`SldsCard`, `SldsTextField`, `SldsCheckbox` and their forwarders (§4
prohibits per-instance style overrides; escape hatches are how design
systems fragment). Variants are the supported way to change emphasis.

```dart
// Before
SldsButton(label: 'Delete', color: Colors.red, onPressed: _delete)

// After — the variant carries the meaning, and the token carries the colour
SldsButton(
  label: 'Delete',
  variant: SldsButtonVariant.destructive,
  onPressed: _delete,
)
```

**`SldsTheme.light()` / `.dark()` become fields, not methods** (§4 requires
cached statics; a method allocated a new `ThemeData`, re-running every token
lookup, on each call — including calls from inside a `build`).

```dart
// Before
MaterialApp(theme: SldsTheme.light(), darkTheme: SldsTheme.dark())

// After
MaterialApp(
  theme: SldsTheme.light,
  darkTheme: SldsTheme.dark,
  highContrastTheme: SldsTheme.highContrast,
  highContrastDarkTheme: SldsTheme.highContrast,
)
```

**The legacy token classes are removed**: `SldsColors`, `SldsSpacing`,
`SldsTypography` and `SldsBreakpoints`. They duplicated the `slds_tokens`
palette with different values, so a widget's appearance depended on which
of the two it happened to read. Everything now resolves from one source.

```dart
// Before
padding: const EdgeInsets.all(SldsSpacing.lg)
if (SldsBreakpoints.isMobile(context)) ...

// After
padding: EdgeInsets.all(context.slds.dimensions.space16)
if (context.sldsIsMobile) ...
```

`SldsResponsiveText` is retained but is now a pass-through: the type scale is
theme-independent and carried by `SldsTheme`, so it no longer swaps text
themes by width.

**`SldsDatePicker.rangeColor` is removed** — the last surviving per-instance
colour override (§4). The range fill now resolves from the
`datePickerRangeHighlight` token, so it follows the palette instead of being
pinned by the caller.

```dart
// Before
SldsDatePicker(rangeColor: const Color(0xFFFFF7D6), onApply: _apply)

// After — the token carries the colour in every palette
SldsDatePicker(onApply: _apply)
```

### Added

- `SldsTheme.highContrast`, and `context.slds` honours
  `MediaQuery.highContrast`. The high-contrast palette existed but was
  unreachable, so no component could render in it (§4, §11).
- `SldsOpacityTokens` in `slds_tokens`, so the disabled dim is its own token
  group rather than living in the colour file.
- `SldsFab.heroTag`. Two FABs on one route previously threw a duplicate-hero
  exception at runtime (§7).
- `SldsFocusRing` widget and an exported `sldsFocusRing`, so controls do not
  each reimplement WCAG 2.2 Focus Appearance.
- Library strings `close`, `retry`, `error`, `dismiss` and the plural
  `unreadCount`, in en/si/ta. Previously only `loading` existed (§6).
- Golden test harness and matrix: variant × theme × text scale, plus si/ta at
  200% and an RTL image (§8).
- Rendered-tree accessibility tests using Flutter's `meetsGuideline`
  matchers, and a `ColorScheme` role-coverage test (§4, §8).

### Fixed — accessibility

- **The date picker, time picker and service card ignored the palette.** The
  range-selection fill (`#FFF7D6`), the selected-day and clock numerals
  (`#1C1B1F`) and the selected service card (`#E3EDFF`) were hardcoded in the
  widgets, so all three rendered identically in light, dark and high
  contrast — the high-contrast palette existed but these components could not
  reach it. They now resolve from two new tokens,
  `datePickerRangeHighlight` and `serviceCardSelectedBackground`, whose dark
  and high-contrast values are engineering proposals recorded under a
  `PENDING DESIGN SIGN-OFF` block in `slds_tokens/lib/src/colors.dart` and
  covered by the blocking contrast check.

  Alters 8 goldens (`date_picker_*`, `time_picker_dialog_*`). In the light
  palette the only change is the selected numeral darkening from `#1C1B1F` to
  the `textStaticBlack` token; in dark and high contrast the selection fills
  change substantially, which is the defect being fixed. The clock-face
  numeral colour was also a dead ternary — both arms were `#1C1B1F`.

- **The focus indicator was effectively invisible.** In the light palette the
  ring measured 1.30:1 against the page where WCAG 1.4.11 requires 3.0:1, so
  2.4.7 and 1.4.11 were failing together. It is now a contrast-checked
  stroke, with the gold retained as the halo.
- 19 token pairs failed WCAG 2.2 AA (16 light, 3 dark): tertiary text,
  default borders, input helper and icon colours, the success colour and
  seven badge text colours. All now pass, and the CI contrast check is
  blocking rather than advisory.
- Touch targets below the 48×48 floor (§5): `SldsLinkButton` collapsed to the
  text glyph box, `SldsToggle` was 28px and 24px tall, `SldsTopNavBar`
  actions were 32×32, and `SldsButton` shrink-wrapped to 44px on desktop.
- `SldsFab`'s badge announced "3" rather than "3 unread notifications" — the
  guideline's own counter-example — and with a tooltip the tappable node had
  no accessible name at all.
- Loading states announce as live regions, so entering the state is spoken
  when it happens rather than only when focus next lands there.

### Fixed — other

- `SldsDialog`'s action row overflowed a phone-width dialog when both a
  cancel and a confirm button were present.
- `SldsFab` accepted the full `SldsButtonVariant` enum but rendered
  `tertiary` and `text` as a filled primary; it now asserts on them.
- `SldsFab` wrapped an empty `Tooltip` when no tooltip was given, adding a
  blank node to the semantics tree.
- `SldsTopNavBar` reserved a different box for enabled and disabled actions,
  shifting the row by 8px.

### Notes

- **Token values pending design sign-off.** The contrast corrections were
  made by engineering to clear WCAG. §9 makes the design team the source of
  truth for token values, so each changed value is annotated with its
  before/after ratio in `slds_tokens/lib/src/colors.dart` for confirmation or
  replacement at the next Figma sync.
- **Goldens are generated on macOS**, not the Linux reference platform §8
  requires. See the note in `.github/workflows/ci.yaml` for the migration
  path.
- The si/ta translations remain machine-drafted and unreviewed by a speaker.
  §6 requires review before shipping.

## 0.0.1

- Initial scaffold: tokens, light/dark themes, and the first components.
