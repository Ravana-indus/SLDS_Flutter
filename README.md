# SLDS Flutter

Flutter component library for **SLDS** — the design system for Sri Lanka's
government digital services, maintained by GovTech Sri Lanka — plus a
[Widgetbook](https://widgetbook.io) app for developing components in isolation.

## Layout

```
packages/slds_components/   # the published package: tokens, theme, widgets
widgetbook/                 # Widgetbook preview app (depends on slds_components)
```

This is a [Dart pub workspace](https://dart.dev/tools/pub/workspaces) managed
with [Melos](https://melos.invertase.dev).

## Getting started

```sh
dart pub get      # or: melos bootstrap
melos run gen        # generate Widgetbook use-case directories
melos run widgetbook  # launch Widgetbook (Chrome)
melos run test        # run tests in all packages
```

## Adding a component

1. Add the widget under `packages/slds_components/lib/src/widgets/`, export it
   from `packages/slds_components/lib/slds_components.dart`.
2. Add a `@widgetbook.UseCase` in `widgetbook/lib/use_cases/`.
3. `melos run gen` to regenerate `main.directories.g.dart`.

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

`SldsTypography.desktop`/`.mobile` swap at `SldsTypography.breakpoint` (600px
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
