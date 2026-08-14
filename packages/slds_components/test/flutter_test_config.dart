// Test harness configuration, applied to every test in this package.
//
// Its one job is loading the real fonts. Without a FontLoader, Flutter's test
// environment renders every glyph in the Ahem placeholder font — uniform
// black boxes — so a golden would prove nothing about text layout, line
// breaking, or the vertical fit of Sinhala and Tamil glyphs, which §6 names
// as the highest-risk clipping case.

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadBundledFonts();
  await _loadMaterialIcons();
  return testMain();
}

/// Registers the Material icon font shipped with the Flutter SDK.
///
/// Icons are glyphs in a font, so without this every `Icon` in a golden
/// renders as a tofu box and an icon-bearing component's image proves
/// nothing. The font lives in the SDK cache rather than this repository, so
/// the path is resolved from the running SDK instead of being hardcoded; if
/// it cannot be found the goldens still generate, just without icons.
Future<void> _loadMaterialIcons() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null) return;

  final font = File(
    '$flutterRoot/bin/cache/artifacts/material_fonts/'
    'MaterialIcons-Regular.otf',
  );
  if (!font.existsSync()) return;

  final loader = FontLoader('MaterialIcons')
    ..addFont(font.readAsBytes().then((bytes) => ByteData.sublistView(bytes)));
  await loader.load();
}

/// Registers the Google Sans faces vendored in `fonts/` under the same family
/// name the widgets ask for.
///
/// The family is qualified with the package prefix because
/// [SldsTextStyleTokenX.toTextStyle] sets `package: 'slds_components'`, and
/// Flutter resolves a package-provided font under that prefixed name.
Future<void> _loadBundledFonts() async {
  const family = 'packages/slds_components/Google Sans';
  const faces = <String>[
    'fonts/GoogleSans-Regular.ttf',
    'fonts/GoogleSans-Medium.ttf',
    'fonts/GoogleSans-Bold.ttf',
  ];

  final loader = FontLoader(family);
  var loaded = 0;
  for (final path in faces) {
    final file = File(path);
    if (!file.existsSync()) continue;
    loader.addFont(
      file.readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
    );
    loaded++;
  }

  if (loaded != faces.length) {
    // Loud rather than silent: a missing face degrades goldens to a fallback
    // font, which looks like an unrelated diff on every text-bearing image.
    throw StateError(
      'Expected ${faces.length} bundled font faces, found $loaded. '
      'Golden tests would render in a substitute font. Run from the '
      'package root so the relative paths in fonts/ resolve.',
    );
  }

  await loader.load();
}
