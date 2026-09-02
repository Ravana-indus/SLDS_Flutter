# SLDS Flutter

Flutter component library for **SLDS** — the design system for Sri Lanka's
government digital services, maintained by GovTech Sri Lanka — plus a
[Widgetbook](https://widgetbook.io) app for developing components in
isolation, and an example app showing how to consume the library in a real
Flutter app.

## Repo layout

This is a [Dart pub workspace](https://dart.dev/tools/pub/workspaces)
managed with [Melos](https://melos.invertase.dev). Three packages, each a
workspace member (listed in the root `pubspec.yaml`):

```
packages/slds_components/   # the published package: design tokens, theme, widgets, l10n
widgetbook/                 # Widgetbook preview app — browse slds_components in isolation
app/                         # example Flutter app — consumes slds_components, bloc + clean architecture
```

`slds_components` has no dependency on the other two — `widgetbook` and
`app` both depend on it via a workspace path dependency
(`slds_components: {path: ../packages/slds_components}`), so local edits to
the design system are picked up immediately by both without publishing.

### app

Example Flutter application demonstrating how a real app consumes
`slds_components`. Structured with **Clean Architecture**
(domain/data/presentation per feature) and **flutter_bloc** for state
management. See [`app/README.md`](app/README.md) for the architecture
breakdown and how to add a feature.

## Getting started

```sh
dart pub get      # or: melos bootstrap
melos run gen        # generate Widgetbook use-case directories
melos run widgetbook  # launch Widgetbook (Chrome)
melos run test        # run tests in all packages
```

To run the example app:

```sh
cd app
flutter run           # pick a connected device/simulator, or -d chrome
```

## Adding a component (to slds_components)

1. Add the widget under `packages/slds_components/lib/src/widgets/`, export it
   from `packages/slds_components/lib/slds_components.dart`.
2. Add a `@widgetbook.UseCase` in `widgetbook/lib/use_cases/`.
3. `melos run gen` to regenerate `main.directories.g.dart`.
4. Use it from `app/` (or any consumer) via
   `import 'package:slds_components/slds_components.dart';`.

## Adding a feature (to app)

See [`app/README.md`](app/README.md#adding-a-feature) — each feature gets
its own `domain/` (business rules), `data/` (repositories, only if needed),
and `presentation/` (bloc + pages) folders under `app/lib/features/<name>/`.

## Localization

`slds_components` ships English, Sinhala, and Tamil strings for the few
labels the components themselves own (currently: the loading-state
accessibility announcement). Source strings live in
`packages/slds_components/lib/src/l10n/*.arb`; run `flutter gen-l10n`
inside that package after editing them.

Host apps must install the generated delegates alongside their own:

```dart
MaterialApp(
  localizationsDelegates: SldsLocalizations.localizationsDelegates,
  supportedLocales: SldsLocalizations.supportedLocales,
  // ...
)
```

Google Sans is bundled with the package and covers Latin, Sinhala and Tamil
in one family, so all three supported locales render from the same metrics
with no font substitution.

**The si/ta translations in the `.arb` files were machine-drafted, not
reviewed by a Sinhala/Tamil speaker — verify before shipping.** The
guidelines (§6) treat an unverified translation the same as a missing one.

### Getting a translation reviewed

Build a self-contained page with every string, its meaning, where it appears
and a verdict column:

```sh
cd packages/slds_components
dart run tool/build_translation_packet.dart   # → build/translation_packet.html
```

Send that one file to a reviewer — it needs no app, checkout or tooling, and
the screen-reader-only strings (spoken by TalkBack/VoiceOver but never
visible, so a mistake in one is invisible until a blind citizen hits it) are
listed first.

Record the sign-off in the reviewed locale's `.arb`:

```json
"@@x-reviewed-by": "Name", "@@x-reviewed-on": "2026-09-01", "@@x-reviewed-count": 47
```

`tool/check_translation_review.dart` reads those. It is advisory on every
push and blocking in the release workflow (`--release`). The count is what
keeps a sign-off honest: adding a string after a review invalidates it, since
the new string was never in front of the reviewer.

## Design tokens

Raw values live in `packages/slds_tokens` as pure Dart — colours as ARGB
ints, plus dimensions, typography metrics, motion durations and opacities.
No Flutter import, so the tokens stay consumable by codegen, web exports and
design tooling, and the WCAG contrast check can run as a plain unit test.

`slds_components` materialises them into `Color` and `TextStyle` once, and
widgets read the result through `context.slds`:

```dart
final tokens = context.slds;
Container(
  padding: EdgeInsets.all(tokens.dimensions.space16),
  decoration: BoxDecoration(
    color: tokens.colors.surfaceCard,
    borderRadius: BorderRadius.circular(tokens.dimensions.radiusLg),
  ),
  child: Text('...', style: tokens.typography.body1),
)
```

`context.slds` tracks the ambient theme, the OS high-contrast setting and
`MediaQuery.disableAnimations`, so a widget reading it gets the right
palette and motion without checking for them itself.

Some colour values were adjusted by engineering to clear WCAG 2.2 AA and are
marked `PENDING DESIGN SIGN-OFF` in `slds_tokens/lib/src/colors.dart` — see
[COMPLIANCE.md](COMPLIANCE.md).

## Themes

`SldsTheme.light`, `.dark` and `.highContrast` are cached statics, not
methods — assigning `SldsTheme.light()` inside a `build` would rebuild the
entire theme every frame. Install all three:

```dart
MaterialApp(
  theme: SldsTheme.light,
  darkTheme: SldsTheme.dark,
  highContrastTheme: SldsTheme.highContrast,
  highContrastDarkTheme: SldsTheme.highContrast,
  themeMode: ThemeMode.system, // or let the user toggle it
  localizationsDelegates: SldsLocalizations.localizationsDelegates,
  supportedLocales: SldsLocalizations.supportedLocales,
)
```

That is the entire integration. Every `ColorScheme` role is set explicitly
from tokens, so nothing falls back to Material's default palette.

Widgetbook defaults to its **Light** theme in the toolbar (Dark is
selectable) — see `widgetbook/lib/main.dart`'s `MaterialThemeAddon`.

## Colors come from tokens, not parameters

Every component resolves colour from the ambient SLDS token set, so it
follows light, dark and high-contrast themes with no work from the caller.

There is deliberately **no per-instance `color` override**. The engineering
guidelines prohibit them (§4) because escape hatches are how design systems
fragment — five apps each nudging the accent is exactly what the system
exists to prevent. Use a variant to change emphasis:

```dart
SldsButton(
  label: 'Delete',
  variant: SldsButtonVariant.destructive,
  onPressed: _delete,
)
```

If a design genuinely needs a colour the tokens do not carry, raise a token
request against the Figma source of truth rather than overriding locally —
a value added in one app is invisible to the design team and gets
overwritten by the next sync.

## Widgetbook toolbar

`widgetbook/lib/main.dart` wires the full addon set, all in the toolbar at
the top of the preview:

- **Theme** — Light / Dark (`MaterialThemeAddon`, defaults to Light)
- **Locale** — en / si / ta (`LocalizationAddon`)
- **Viewport** — None (freeform, follows the browser/window) plus every
  built-in iOS, Android, macOS, Windows, and Linux device preset
  (`ViewportAddon(Viewports.all)`) — this is the "run on an emulator" view;
  Widgetbook itself already runs as a normal web app (`flutter run -d chrome`
  / `flutter build web`), so no separate web target was needed
- **Alignment** — reposition the use-case within its canvas (`AlignmentAddon`)
- **Text Scale** — simulate OS accessibility text-scaling, 0.5×–2.0×
  (`TextScaleAddon`)
- **Grid** — overlay a spacing/alignment grid (`GridAddon`)
- **Inspector** — toggle Flutter's widget-inspector overlay (`InspectorAddon`)
- **Zoom** — zoom the canvas in/out (`ZoomAddon`)
