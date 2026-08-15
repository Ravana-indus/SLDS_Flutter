// §6: a component with a missing translation in any supported locale does
// not ship. This asserts the three ARB files stay in lockstep.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Keys present in the template but deliberately absent elsewhere.
///
/// Empty, and should stay that way — a locale missing a string is a shipping
/// blocker, not something to record here.
const _knownGaps = <String, Set<String>>{};

/// Whether [message] is made only of `{placeholders}`, punctuation and
/// whitespace — no words a translator could act on.
///
/// `"{label}: {value}"` is the same in every language; treating it as an
/// untranslated string would be a false positive. Deliberately narrow: a
/// single letter outside a placeholder makes this false.
bool _isPlaceholdersAndPunctuationOnly(String message) {
  final withoutPlaceholders = message.replaceAll(RegExp(r'\{[^}]*\}'), '');
  return !RegExp(r'\p{L}', unicode: true).hasMatch(withoutPlaceholders);
}

Map<String, String> _messages(String locale) {
  final file = File('lib/src/l10n/slds_$locale.arb');
  expect(file.existsSync(), isTrue, reason: 'missing ARB for "$locale"');

  final decoded = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return {
    for (final entry in decoded.entries)
      // `@@locale` is metadata; `@key` entries are descriptions of the key
      // above them, not messages in their own right.
      if (!entry.key.startsWith('@')) entry.key: entry.value as String,
  };
}

void main() {
  const template = 'en';
  const translations = ['si', 'ta'];

  test("every locale defines exactly the template's keys", () {
    final expected = _messages(template).keys.toSet();
    expect(expected, isNotEmpty, reason: 'template ARB is empty');

    for (final locale in translations) {
      final actual = _messages(locale).keys.toSet();
      final missing = expected.difference(actual)
        ..removeAll(_knownGaps[locale] ?? const <String>{});
      final extra = actual.difference(expected);

      expect(
        missing,
        isEmpty,
        reason: '"$locale" is missing: ${missing.join(', ')}',
      );
      expect(
        extra,
        isEmpty,
        reason:
            '"$locale" defines keys absent from the template: '
            '${extra.join(', ')}',
      );
    }
  });

  test('no translation is left as the untranslated English string', () {
    // A copied-over English value passes a key-presence check but is not a
    // translation. Catch the ones that were never localised.
    final english = _messages(template);

    for (final locale in translations) {
      final actual = _messages(locale);
      final untranslated = <String>[];

      actual.forEach((key, value) {
        if (english[key] != value) return;
        // A message made only of placeholders and punctuation has no words
        // to translate, so matching English is correct rather than a miss.
        // Anything with a letter in it outside a placeholder does not
        // qualify — keep this narrow.
        if (_isPlaceholdersAndPunctuationOnly(value)) return;
        untranslated.add(key);
      });

      expect(
        untranslated,
        isEmpty,
        reason:
            '"$locale" still holds the English text for: '
            '${untranslated.join(', ')}',
      );
    }
  });

  test('no message is blank', () {
    for (final locale in [template, ...translations]) {
      _messages(locale).forEach((key, value) {
        expect(
          value.trim(),
          isNotEmpty,
          reason: '"$locale" has an empty value for "$key"',
        );
      });
    }
  });
}
