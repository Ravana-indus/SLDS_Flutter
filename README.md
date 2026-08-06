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

## Design tokens

`packages/slds_components/lib/src/tokens/` currently holds **placeholder**
values (`SldsColors`, `SldsSpacing`, `SldsTypography`) — GovTech's official
published token spec was not available when this was scaffolded. Replace the
values once you have the real spec; the shape is what's meant to stay stable
for consumers.
