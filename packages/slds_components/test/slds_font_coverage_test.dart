// Glyph-coverage check for the bundled font (§ typography).
//
// The type tokens set no `fontFamilyFallback`, on the claim that the bundled
// Google Sans covers Latin, Sinhala and Tamil in one family. That claim is
// what makes a single metric set valid across every supported locale — if it
// were false, si/ta text would silently fall back to a platform font with
// different metrics, or render as tofu.
//
// This parses the font's own `cmap` and asserts the claim directly, so a
// future font swap that drops a script fails here rather than in production.
// `slds_type_specimen_test.dart` is the visual counterpart: this proves the
// codepoints exist, that one proves they shape and render.
@Tags(['fonts'])
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

/// Every codepoint the font's character map claims to support.
Set<int> _cmapCodepoints(Uint8List bytes) {
  final data = ByteData.sublistView(bytes);
  final tableCount = data.getUint16(4);

  var cmapOffset = -1;
  for (var i = 0; i < tableCount; i++) {
    final record = 12 + 16 * i;
    final tag = String.fromCharCodes(bytes.sublist(record, record + 4));
    if (tag == 'cmap') cmapOffset = data.getUint32(record + 8);
  }
  expect(cmapOffset, isNot(-1), reason: 'the font has no cmap table');

  final codepoints = <int>{};
  final subtableCount = data.getUint16(cmapOffset + 2);
  for (var i = 0; i < subtableCount; i++) {
    final entry = cmapOffset + 4 + 8 * i;
    final subtable = cmapOffset + data.getUint32(entry + 4);
    switch (data.getUint16(subtable)) {
      // Format 4: the standard BMP mapping, stored as segment ranges.
      case 4:
        final segments = data.getUint16(subtable + 6) ~/ 2;
        final endBase = subtable + 14;
        final startBase = endBase + segments * 2 + 2;
        for (var s = 0; s < segments; s++) {
          final end = data.getUint16(endBase + s * 2);
          final start = data.getUint16(startBase + s * 2);
          // 0xFFFF terminates the segment list rather than mapping anything.
          if (end == 0xFFFF) continue;
          for (var c = start; c <= end; c++) {
            codepoints.add(c);
          }
        }
      // Format 12: full-Unicode mapping, stored as explicit groups.
      case 12:
        final groups = data.getUint32(subtable + 12);
        for (var g = 0; g < groups; g++) {
          final group = subtable + 16 + 12 * g;
          final start = data.getUint32(group);
          final end = data.getUint32(group + 4);
          for (var c = start; c <= end; c++) {
            codepoints.add(c);
          }
        }
    }
  }
  return codepoints;
}

void main() {
  late Set<int> covered;

  setUpAll(() {
    final file = File('fonts/GoogleSans-Regular.ttf');
    expect(
      file.existsSync(),
      isTrue,
      reason: 'the bundled font is missing; run from the package root',
    );
    covered = _cmapCodepoints(file.readAsBytesSync());
  });

  test('the bundled font covers the scripts SLDS ships', () {
    // One representative word per script, matching the type specimen.
    const samples = {
      'Latin': 'Hello',
      'Tamil': 'வணக்கம்',
      'Sinhala': 'ආයුබෝවන්',
    };

    for (final entry in samples.entries) {
      final missing = entry.value.runes
          .where((r) => !covered.contains(r))
          .map((r) => 'U+${r.toRadixString(16).toUpperCase()}')
          .toList();
      expect(
        missing,
        isEmpty,
        reason:
            '${entry.key} is unsupported by the bundled font, so the missing '
            'fontFamilyFallback would leave it to a platform substitute',
      );
    }
  });

  test('the font covers every character the shipped translations use', () {
    // The real test of the no-fallback decision: not a sample word, but
    // every character that actually reaches a screen.
    for (final locale in ['en', 'si', 'ta']) {
      final arb = File('lib/src/l10n/slds_$locale.arb').readAsStringSync();
      final missing = <String>{};
      for (final rune in arb.runes) {
        // Skip ASCII: the ARB's own JSON punctuation and keys are Latin.
        if (rune < 0x80) continue;
        if (!covered.contains(rune)) {
          missing.add('U+${rune.toRadixString(16).toUpperCase()}');
        }
      }
      expect(
        missing,
        isEmpty,
        reason: 'slds_$locale.arb uses characters the bundled font lacks',
      );
    }
  });

  test('Sinhala and Tamil blocks are covered, not just the samples', () {
    // A sample word can pass while the block is half-missing, which would
    // strand any string the samples happen not to use.
    const blocks = {
      'Sinhala': (0x0D80, 0x0DFF),
      'Tamil': (0x0B80, 0x0BFF),
    };
    // U+0D81 SINHALA SIGN CANDRABINDU was added in Unicode 13.0 (2020) and
    // is absent from this build of the font. It is a rare nasalisation mark;
    // documented here so its absence is a known gap rather than a surprise.
    const knownGaps = {0x0D81};

    blocks.forEach((script, range) {
      final (lo, hi) = range;
      final missing = <int>[];
      for (var c = lo; c <= hi; c++) {
        if (!covered.contains(c) && !knownGaps.contains(c)) missing.add(c);
      }
      // Reserved codepoints in these blocks are legitimately unmapped, so
      // this asserts a high floor rather than exhaustive coverage.
      final present = (hi - lo + 1) - missing.length;
      expect(
        present,
        greaterThan(64),
        reason: '$script coverage collapsed to $present codepoints',
      );
    });
  });
}
