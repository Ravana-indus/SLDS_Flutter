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

**`SldsButtonVariant.tertiary` and `.text` are replaced by `.ghost`**, to
match the Figma Button set (Primary / Secondary / Ghost / Destructive).
Ghost is borderless and transparent at rest — what `text` already rendered,
pixel for pixel. `tertiary` drew a border Figma never specified, so
`SldsDivider.withButton` (now ghost) loses that stray border.

```dart
// Before
SldsButton(label: 'Cancel', variant: SldsButtonVariant.text, onPressed: _cancel)

// After
SldsButton(label: 'Cancel', variant: SldsButtonVariant.ghost, onPressed: _cancel)
```

**`SldsSummaryBadgeStatus` is removed; `SldsSummaryRow.badgeStatus` takes
`SldsBadgeStatus`.** Figma's Summary List renders its status as an instance
of the Badge component, so the row now renders the shared `SldsBadge`
instead of a private copy of it. Rendering is unchanged.

```dart
// Before
SldsSummaryRow(label: 'Status', value: 'Approved', badgeStatus: SldsSummaryBadgeStatus.approved)

// After
SldsSummaryRow(label: 'Status', value: 'Approved', badgeStatus: SldsBadgeStatus.approved)
```

### Added

- `SldsBanner` and `SldsBannerSeverity` (success/warning/error/info) — the
  inline, non-transient counterpart to `SldsSnackBar`, with an optional
  inline action and dismiss button. The severity tints reuse the existing
  status badge token pairs rather than adding a parallel `banner/*` palette:
  Figma's banner backgrounds are already the badge backgrounds exactly, and
  its borders read the semantic `success`/`warning`/`error`/`info` tokens so
  the AA adjustment made to `success` (#1FAA63 -> #00833C) is not undone.
- `SldsTheme.highContrast`, and `context.slds` honours
  `MediaQuery.highContrast`. The high-contrast palette existed but was
  unreachable, so no component could render in it (§4, §11).
- `SldsOpacityTokens` in `slds_tokens`, so the disabled dim is its own token
  group rather than living in the colour file.
- `SldsFab.heroTag`. Two FABs on one route previously threw a duplicate-hero
  exception at runtime (§7).
- `SldsFocusRing` widget and an exported `sldsFocusRing`, so controls do not
  each reimplement WCAG 2.2 Focus Appearance.
- `SldsButton.focusNode`, to move keyboard focus to a button
  programmatically. The Widgetbook playground's new **Focused** knob uses it
  to show the Focus state.
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
- `SldsButton`'s loading state rendered in the grey disabled colours for
  every variant (most visibly Destructive, which lost its red). Loading
  blocks taps by nulling `onPressed`, which Material reports as disabled;
  the Figma loading variants keep their resting colours, so it now does too.
- `SldsCheckButton` had 6px rounded corners; Figma's Check Button
  (`1164:7065`) is square-cornered, so the radius is removed.
- `SldsFab` showed Material's ripple, translucent hover tint and hover/press
  elevation lift. It now uses the Figma hover and pressed background tokens
  (the same ones `SldsButton` uses), with no ripple and a constant shadow.
- `SldsLinkButton` primary label colour follows Figma's updated
  `Text/Secondary`: `#676767` light (was `#717171`), `#CDCDCD` dark (was
  `#BCBCBC`). Both clear WCAG AA (5.28:1 and 11.88:1 on the page).
- `SldsLinkButton` destructive label in dark mode matches Figma
  `Feedback/Error Text` exactly: `#F47272` (was `#FCA5A5`). It clears the
  page but is 3.48:1 on the `#444444` card, so that one pairing is exempted
  in the contrast test pending design review.
- `SldsFlyoutMenu` rows showed Material's ripple and pressed overlay. Figma's
  flyout defines neither; rows now hover with `Surface/Hover` (`#EEEEEE`),
  the fill Figma uses for list and dropdown item hover.
- `SldsBadge` text now uses Figma's `Mobile/Caption 1 Strong` weight (500,
  was 400) for every status, and the Success label is Figma's
  `Badge/Success/Label` `#1FAA63` (was `#007D36`). The same token colours the
  Success notification icon and the `SldsServiceCard` badge, which Figma
  also draws in `#1FAA63`. It measures 2.59:1 on the `#E0F2EC` background,
  so that pairing is exempted in the contrast test pending design review.
- `SldsBadge` Pending label is Figma's `Badge/Pending/Label` `#503D00` (was
  `#946B00`). The same token colours the Pending notification icon and the
  `SldsProcessList` current step, which Figma also draws in `#503D00`.
  9.78:1 on `#FFF8D6`.
- `SldsBadge` light colours match the live Figma Badge set (#21–#27): Error
  label `#D32F2F` (was `#D02C2C`), Info background `#FFFFFF` (was
  `#E3EDFF`), Neutral label `#676767` (was `#6C6C6C`), Draft label `#898989`
  via a new `badgeDraftText` token (Draft previously borrowed the Neutral
  text), Submitted label `#0E9DB0` (was `#007487`), Approved label `#059669`
  (was `#007C4F`). Error (4.35:1), Submitted (2.70:1) and Approved (3.24:1)
  fall below AA on their backgrounds and are exempted pending design review;
  the Approved pair also exempts `SldsProcessList`'s done step from the
  painted-contrast check.
- `SldsBadge` Escalated label is Figma's `Badge/Escalated/Text` `#F57C00`
  (was `#C04700`), #29. 2.42:1 on `#FEF0E3`, exempted pending design review.
- `SldsTooltip`'s action was a hand-built Material `InkWell` button (ripple,
  card-surface colours). Figma's action is a Button instance (Secondary,
  Small), so it is now an `SldsButton` of that variant and size: Secondary
  colours in every theme (dark: `#444444` fill, `#565656` border, white
  label) and no ripple (#32).
- `SldsErrorState` matches Figma's Error State: the status code is
  `Mobile/Display 1` (36px, 500; was 44px, 700) in `Text/Tertiary` `#BCBCBC`
  (was `#6C6C6C`), and the description is `Mobile/Caption 2` (11px; was
  14px) in `Text/Secondary` `#676767` (was `#717171`) (#33, #34). A new
  `errorStateCode` token carries the code colour so the shared
  `textTertiary` is unchanged. The code measures 1.77:1 on the page,
  exempted pending design review.
- `textPrimary` and `textSecondary` (light) now follow Figma's `Text/Primary`
  `#17171A` (was `#222222`) and `Text/Secondary` `#676767` (was `#717171`).
  `#717171` was an AA workaround for the old `#898989`; Figma's current value
  passes (5.28:1 on the page). This restyles every widget using them.
- `SldsAccordion` content inherits Figma's `Desktop/Body 2` in
  `Text/Secondary`, so plain `Text` bodies no longer render in the default
  colour (#35, #36).
- `SldsDivider` line uses Figma's `List/Divider` (`borderDecorative`,
  `#DDDDDD` light; was `borderDefault` `#8F8F8F`), 1px (#37).
- `buttonGhostLabel` (light) is Figma's `Button/Ghost/Label` `#17171A` (was
  `#222222`), so the `SldsDivider.withButton` label matches (#38). Every ghost
  button and icon button uses it.
- `SldsProgressBar` uses Figma's `Progress/Track` `#FFFFFF` (was `#EEEEEE`)
  and `Progress/Fill` `#1FAA63` (was `#00833C`) via new `progressTrack` and
  `progressFill` tokens, leaving the shared `surfaceHover`/`success` as they
  were (#39, #40). The label slot now reserves the width of "100%", so 100%
  no longer wraps onto two lines (#41).
- `SldsBanner`'s action is now `SldsLinkButton`, the Link button instance
  Figma uses in every severity (`Text/Secondary` `#676767`, 16px, 400); the
  private `_BannerActionLink` drawn in the message colour is removed. Figma's
  `#676767` clears AA on all four banner tints (4.87–5.66:1) (#43). The
  narrower action also keeps the Success banner on one row at 375pt
  (iPhone 12 mini / SE) (#44).
- `SldsBanner` Success icon and border use Figma's `Banner/Success/Icon` and
  `Banner/Success/Border` `#1FAA63` (was `success` `#00833C`) via a new
  `bannerSuccess` token, leaving the shared `success` unchanged (#45, #46).
- `SldsBanner` Warning icon and border use Figma's `Banner/Warning/Icon` and
  `Banner/Warning/Border` `#FFC700` (was `warning` `#B38A00`) via a new
  `bannerWarning` token, leaving the shared `warning` unchanged (#48, #49).
- `SldsBanner` Success background uses a new `bannerSuccessBackground` token
  (Figma `Banner/Success/Background`): dark mode is now `#064E3B` (was the
  badge's `#062B1A`); light is unchanged `#E0F2EC` (#55).
- `SldsBanner` Warning background uses a new `bannerWarningBackground` token
  (Figma `Banner/Warning/Background`): dark mode is now `#503D00` (was the
  badge's `#2E2200`); light is unchanged `#FFF8D6` (#57).
- `SldsBanner` dark mode matches Figma's dark Notification Banners (#58–#66):
  Warning icon/border `#B38A00` (was `#FFE880`); Error background
  `#7F1D1D` (was `#330D0D`) and icon/border `#D32F2F` (was the shared
  `error` `#F47272`); Info background `#17171A` (was `surfaceCard`
  `#444444`). New `bannerError`, `bannerErrorBackground` and
  `bannerInfoBackground` tokens carry them, so `error`, `surfaceCard` and the
  badge backgrounds are unchanged. Light and high-contrast are unchanged.
- Form fields match Figma's Input page (#70–#86):
  - `inputLabel` `#17171A` (was `#222222`) and `inputHelper` `#676767` (was
    `#717171`, an AA workaround for the old `#898989`; Figma's value passes).
  - `fieldLabel` is Figma's `Mobile/Body 2` at 14/18 (was 16/20), and every
    field label uses it (Input, Input Mask, Mobile Number, Text Field,
    Password, Text Area, Dropdown, Combo Box), so labels share one line box
    and the label-to-field spacing is consistent. `SldsUploadField` moves to
    `compactLabel`, keeping its Figma 16px label unchanged.
  - Disabled `SldsInput` and `SldsMobileNumberInput` stay white, as Figma.
  - `SldsInputMask` prefix/suffix cells span the full field height so their
    dividers do, and the value cell has Figma's 16px padding.
  - The value in `SldsInput`, `SldsInputMask` and `SldsMobileNumberInput` is
    padded to exactly the 48dp tap target. The old slack sat it 2–3px above
    the prefix it should line up with.
  - `SldsMobileNumberInput`: the value sits 18px after the country code
    (Figma 10 + 8); `errorText` now puts it in the error state, like its
    siblings; the error state shows Figma's red XCircle status icon.
  - The required `*` is hidden from screen readers where "required" is
    already spoken (`SldsInput`, and `SldsComboBox`, whose label now says it).
  - New `slds_form_fields_figma_test.dart` covers all of the above.
- `SldsInput` value sits 22px from its prefix and suffix, Figma's affix pad +
  gap + value pad (was 8px) (#67).
- `SldsMobileNumberInput.onClear` shows Figma's grey clear (X) button: it
  empties `controller`, then calls `onClear`. New localized `clear` string
  for its accessible name (si/ta machine-drafted, needs review).
- `inputIcon` is Figma's input icon grey `#898989` (was `#717171`): clear X,
  password eye, search and caret icons. An icon is a graphic, so the
  contrast test now holds it to WCAG 1.4.11's 3:1 (3.54:1), not the text
  floor that had pushed it darker.
- `SldsTextArea`/`SldsTextField` required marker follows the label with no
  space (`Description*`), as Figma.
- `SldsDropdown` help text sits 6px below the field (was 4px), Figma's gap
  on every form field (#91).
- `SldsComboBox` multi-select chips match Figma's Multi Select layout: the
  chip row is padded 8px inline like the placeholder (the first chip sat
  against the field's edge), and chips sit 10px apart (was 4px) (#90).
- `SldsComboBox` open state matches Figma's Combo Box (Filling / Multi
  Select) and its list item component (#92–#100):
  - The field keeps its default 1px `#BCBCBC` border while open or typing;
    the gold border and focus glow are gone (#95).
  - The caret is Figma's grey (`inputIcon`) down caret in every state, open
    included; the toggle's tooltip still says expanded/collapsed (#92).
  - Rows are inset 8px in the panel, like the search bar (#92).
  - The search bar is Figma's: 44px, `#DDDDDD` 1.5px, 12px padding, and its
    14/18 text centred on the 20px icon (#96).
  - Rows use Figma's 16px list checkbox, 8px from the text (the 20px
    `SldsCheckbox` and its 48dp tap target left a 24px gap) (#97).
  - A selected row is shown by its checked `#FFC700` box; only hover/focus
    fills the row `#EEEEEE` (radius 8, no ripple), as Figma's list item (#99).
  - Panel `#F7F7F7`, `#DDDDDD` 1px, radius 16 and `Elevation/3` were already
    Figma's (#100); row text `Desktop/Body 2` `#17171A` too (#98).
- Primary button label is Figma `Button/Primary/Label` `#17171A` in light and
  dark (was `#222222`); high contrast stays `#000000`. Shows on the
  `SldsFilterDropdown` Apply button and every other primary button (#104).
  The filter's option text and Cancel label already matched Figma (#102,
  #103).
- `SldsFab` wrapped an empty `Tooltip` when no tooltip was given, adding a
  blank node to the semantics tree.
- `SldsTopNavBar` reserved a different box for enabled and disabled actions,
  shifting the row by 8px.
- `SldsButton`'s loading state replaced the whole label with a spinner. The
  Figma loading variants (nodes `213:2006`, `215:2889`) keep the label and
  swap only the leading slot, so the label now stays and the trailing icon
  is hidden instead — SLDS-UI-002 / SLDS-UI-004.
- `SldsButton` folded Figma's 6px Text Container pad into the icon gap, so
  the pad vanished on any side without an icon — the loading state came out
  6px narrow. It is now real padding on the label, and all four Figma
  frames (148/124 at large, 156/128 at extra large) match.
- `SldsButton`'s small and medium sizes rendered 2px taller than their
  height tokens (30 and 38 against 28 and 36). Both are content-height, and
  the shared `body1` / `body2` tokens carry the type scale's other platform
  line height (Mobile Body 1 is 16/20, Desktop Body 2 is 14/22) where the
  Figma button variants want 16/24 and 14/20. The button now pins the line
  height its variant specifies rather than changing the shared tokens, which
  60+ other widgets read — SLDS-UI-007.
- `SldsDatePicker` and `SldsTimePicker` laid their Cancel/Apply footers out
  in an unflexed `Row`, which overflowed the fixed-width dialog once the
  buttons carried their correct padding. Both actions are now `Flexible`.

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
