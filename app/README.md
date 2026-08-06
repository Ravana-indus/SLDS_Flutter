# slds_app

Example Flutter application consuming the `slds_components` design system,
structured with **Clean Architecture** and **flutter_bloc** for state.

This is a skeleton — one demo feature (`home`, a theme toggle) shows the
wiring. Delete it once you add your first real feature.

## Layers

```
lib/
  features/
    home/                          # one feature = one directory
      domain/
        toggle_theme_mode.dart     # domain: pure business rule, no Flutter/IO deps
      presentation/
        bloc/
          theme_mode_cubit.dart    # presentation: Cubit/Bloc, calls domain use cases
        pages/
          home_page.dart           # presentation: widgets, built from SLDS components
  main.dart                        # composition root: builds use cases, provides blocs
```

- **domain** — business rules and use-case classes. No Flutter, no HTTP, no
  database imports. A domain class takes plain Dart types in, plain Dart
  types out, so it's trivially unit-testable.
- **data** (not present yet — add per feature when you have one) — repository
  implementations, API clients, local storage. Implements interfaces defined
  in `domain` if/when a feature needs one. Nothing here yet because the demo
  feature has no persistence; don't scaffold it speculatively.
- **presentation** — blocs/cubits (hold UI state, call domain use cases) and
  pages/widgets (render state, dispatch events). Widgets should be built
  from `slds_components` widgets wherever one exists.

Dependencies point inward: `presentation → domain`. `data` would depend on
`domain` (implementing its interfaces), never the reverse. `domain` never
imports Flutter.

### Adding a feature

```
lib/features/<name>/
  domain/         # entities, use cases, repository interfaces (if any)
  data/           # repository implementations, data sources (if any)
  presentation/
    bloc/
    pages/
```

Only add the sub-folders a feature actually needs — a feature with no
remote/local data source doesn't need a `data/` folder.

### Dependency injection

There's no DI package (get_it, injectable, …) yet — `main.dart` builds the
use case and hands it to `BlocProvider` directly:

```dart
BlocProvider(
  create: (_) => ThemeModeCubit(ToggleThemeMode()),
  child: ...,
)
```

This is enough while there are a handful of dependencies. Reach for a DI
container once wiring them by hand in `main.dart` gets unwieldy, not before.

## Using slds_components

The package is a workspace path dependency (see `pubspec.yaml`):

```dart
import 'package:slds_components/slds_components.dart';

MaterialApp(
  theme: SldsTheme.light(),
  localizationsDelegates: SldsLocalizations.localizationsDelegates,
  supportedLocales: SldsLocalizations.supportedLocales,
  home: const HomePage(),
)
```

`SldsButton`, `SldsCard`, and `SldsIconButton` are used in
`lib/features/home/presentation/pages/home_page.dart` — copy that pattern
for new screens. See the root README and
[`packages/slds_components/README.md`](../packages/slds_components/README.md)
for the full component list, or run Widgetbook (`melos run widgetbook`) to
browse them interactively.

## Run

From the repo root (this app is a member of the Melos workspace):

```sh
dart pub get              # resolve workspace deps once
cd app
flutter run                # launch on a connected device/simulator
flutter test                # run this package's tests
flutter analyze             # lint
```
