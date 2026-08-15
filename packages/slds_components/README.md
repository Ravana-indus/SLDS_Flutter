Flutter components, design tokens, and theming for the Sri Lanka Design
System (SLDS).

## Features

- Design tokens: colors, spacing, breakpoints, typography
- Themed widgets: button, icon button, link button, FAB, card
- Built-in localization: English, Sinhala (si), Tamil (ta)

## Getting started

```yaml
dependencies:
  slds_components: ^0.0.1
```

## Usage

```dart
import 'package:slds_components/slds_components.dart';

MaterialApp(
  theme: SldsTheme.light,
  darkTheme: SldsTheme.dark,
  highContrastTheme: SldsTheme.highContrast,
  highContrastDarkTheme: SldsTheme.highContrast,
  localizationsDelegates: SldsLocalizations.localizationsDelegates,
  supportedLocales: SldsLocalizations.supportedLocales,
  home: SldsButton(label: 'Continue', onPressed: () {}),
);
```

The themes are cached statics rather than methods: `SldsTheme.light()`
called inside a `build` would allocate a new `ThemeData`, re-running every
token lookup, on every frame.

Components take no `color` parameter — variants carry emphasis, and colour
resolves from the ambient token set. See the root
[README](../../README.md#colors-come-from-tokens-not-parameters).
