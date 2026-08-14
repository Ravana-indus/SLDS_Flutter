import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  group('bundled font assets', () {
    test('every weight declared in the pubspec exists on disk', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final assets = RegExp(
        r'-\s*asset:\s*(\S+)',
      ).allMatches(pubspec).map((m) => m.group(1)!).toList();

      expect(
        assets,
        isNotEmpty,
        reason: 'no font assets declared in pubspec.yaml',
      );

      for (final asset in assets) {
        expect(
          File(asset).existsSync(),
          isTrue,
          reason: '$asset is declared in pubspec.yaml but missing on disk',
        );
      }
    });

    test('the OFL licence ships alongside the fonts', () {
      // Redistributing an OFL font requires the licence to travel with it.
      final licence = File('fonts/OFL.txt');
      expect(licence.existsSync(), isTrue);
      expect(licence.readAsStringSync(), contains('SIL Open Font License'));
    });

    test('font files are real TrueType data, not HTML error pages', () {
      // A failed CDN download writes a plausible-looking file; check the magic
      // number so a broken asset fails here rather than silently rendering in
      // a substituted font.
      for (final file in Directory('fonts').listSync().whereType<File>()) {
        if (!file.path.endsWith('.ttf')) continue;
        final header = file.readAsBytesSync().take(4).toList();
        expect(
          header,
          anyOf(
            equals([0x00, 0x01, 0x00, 0x00]), // TrueType outlines
            equals(utf8.encode('true')),
            equals(utf8.encode('OTTO')), // CFF outlines
          ),
          reason: '${file.path} is not a font file',
        );
      }
    });
  });

  group('type scale', () {
    testWidgets('resolves the bundled family, package-qualified', (
      tester,
    ) async {
      late TextStyle style;
      await tester.pumpWidget(
        MaterialApp(
          theme: SldsTheme.light,
          home: Builder(
            builder: (context) {
              style = context.slds.typography.body1;
              return const SizedBox();
            },
          ),
        ),
      );

      // Flutter rewrites `fontFamily` to `packages/<pkg>/<family>` when a
      // package is given, which is what makes the asset resolve downstream.
      expect(style.fontFamily, 'packages/slds_components/Google Sans');
    });

    testWidgets('no fallback chain — one family covers every locale', (
      tester,
    ) async {
      late TextStyle style;
      await tester.pumpWidget(
        MaterialApp(
          theme: SldsTheme.light,
          home: Builder(
            builder: (context) {
              style = context.slds.typography.body1;
              return const SizedBox();
            },
          ),
        ),
      );

      // Google Sans covers Latin, Sinhala and Tamil, so substitution should
      // never kick in. A fallback list reappearing here means someone
      // reintroduced a font that does not cover all three scripts.
      expect(style.fontFamilyFallback, anyOf(isNull, isEmpty));
    });
  });
}
