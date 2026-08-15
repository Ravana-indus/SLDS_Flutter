// Shared test scaffolding.
//
// Every test file previously built its own MaterialApp, and most omitted the
// SldsLocalizations delegates — so a widget that reads a library string
// rendered untested. Building the host in one place keeps the setup honest
// and matches how a consuming app actually installs the library.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

/// The themes every golden is generated against (§8).
const sldsGoldenThemes = <String, ThemeMode>{
  'light': ThemeMode.light,
  'dark': ThemeMode.dark,
};

/// Resolves a named theme to its [ThemeData].
ThemeData sldsThemeNamed(String name) => switch (name) {
  'dark' => SldsTheme.dark,
  'hc' => SldsTheme.highContrast,
  _ => SldsTheme.light,
};

/// Wraps [child] in a themed, localized app, as a consuming app would.
///
/// [textScale] drives the 200% pass §8 requires; [locale] drives the si/ta
/// axis; [textDirection] drives the RTL golden §5 requires.
Widget wrap(
  Widget child, {
  ThemeData? theme,
  Locale? locale,
  double textScale = 1.0,
  TextDirection? textDirection,
  bool highContrast = false,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme ?? SldsTheme.light,
    locale: locale,
    localizationsDelegates: SldsLocalizations.localizationsDelegates,
    supportedLocales: SldsLocalizations.supportedLocales,
    home: Builder(
      // Inherits the ambient MediaQueryData and overrides only what the axis
      // needs. A bare MediaQueryData() would default to Size.zero and lay the
      // tree out at zero size.
      builder: (context) {
        Widget body = Scaffold(body: Center(child: child));
        if (textDirection != null) {
          body = Directionality(textDirection: textDirection, child: body);
        }
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
            highContrast: highContrast,
          ),
          child: body,
        );
      },
    ),
  );
}

/// Whether golden comparison should run on this machine.
///
/// §8 makes Linux the sole reference platform: font rasterisation differs
/// between operating systems even with identical font files, so images
/// generated on macOS or Windows will not match a Linux CI run byte for byte.
///
/// NOTE: this repository currently generates its goldens on macOS, by
/// explicit decision. The guard is kept so the intent stays visible and so
/// the suite can be pinned to a single platform later without rewriting
/// every test — set SLDS_GOLDEN_PLATFORM=linux to enforce the §8 rule.
bool get goldensEnabled {
  final required = Platform.environment['SLDS_GOLDEN_PLATFORM'];
  if (required == null || required.isEmpty) return true;
  return Platform.operatingSystem == required;
}

/// Skip reason matching [goldensEnabled], or null when goldens should run.
String? get goldenSkipReason => goldensEnabled
    ? null
    : 'Goldens are pinned to '
          '${Platform.environment['SLDS_GOLDEN_PLATFORM']}; '
          'this is ${Platform.operatingSystem}. Regenerate via CI.';

/// Asserts [finder] matches its committed golden for [name].
///
/// Images live in `test/goldens/` and are named
/// `<component>_<variant>_<theme>_x<scale>[_<locale>][_rtl].png`.
Future<void> expectGolden(Finder finder, String name) {
  return expectLater(finder, matchesGoldenFile('goldens/$name.png'));
}
