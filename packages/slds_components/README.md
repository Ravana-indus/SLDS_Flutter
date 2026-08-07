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
  theme: SldsTheme.light(),
  home: SldsButton(label: 'Continue', onPressed: () {}),
);
```
