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

Sinhala/Tamil text uses `Noto Sans Sinhala`/`Noto Sans Tamil` as a font
fallback (see `SldsTypography`) — the font asset files are not bundled yet,
add them under `packages/slds_components/fonts/` when available.

**The si/ta translations in the `.arb` files were machine-drafted, not
reviewed by a Sinhala/Tamil speaker — verify before shipping.**

## Design tokens

`packages/slds_components/lib/src/tokens/` currently holds **placeholder**
color values (`SldsColors`) — GovTech's official published token spec was not
available when this was scaffolded. `SldsTypography`'s Desktop/Mobile type
scale (Google Sans, exact px/line-height/letter-spacing) matches the
Foundation Documentation spec. Replace `SldsColors` once the real spec is
available; the shape is what's meant to stay stable for consumers.

## Dark mode

`SldsTheme.light()` and `SldsTheme.dark()` are both seeded from the same
`SldsColors` tokens via `ColorScheme.fromSeed` — install both:

```dart
MaterialApp(
  theme: SldsTheme.light(),
  darkTheme: SldsTheme.dark(),
  themeMode: ThemeMode.system, // or let the user toggle it
  // ...
)
```

Widgetbook itself defaults to its **Light** theme in the toolbar (Dark is
selectable) — see `widgetbook/lib/main.dart`'s `MaterialThemeAddon`.

## Responsive type

`SldsTypography.desktop`/`.mobile` swap at `SldsBreakpoints.mobile` (600px
width). Wrap `MaterialApp.builder` with `SldsResponsiveText` to have the
active `TextTheme` follow window/screen width automatically:

```dart
MaterialApp(
  theme: SldsTheme.light(),
  builder: (context, child) => SldsResponsiveText(child: child!),
  // ...
)
```

## Per-instance color override

Components resolve color from the ambient `Theme`'s `ColorScheme` by
default (so they follow light/dark mode), but accept an optional `color`
param to override the accent for one instance without forking the widget —
e.g. `SldsButton(color: Colors.purple, ...)`.

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
