// Fails a release when a translation has not been reviewed by a speaker (§6).
//
// §6 treats an unverified translation as missing, and a missing translation
// blocks shipping. Until now that rule lived only in prose — README, CLAUDE.md
// and a CHANGELOG line all say the si/ta strings are machine-drafted, and
// nothing stopped a release going out anyway. Prose is not a gate.
//
// This makes the rule executable. Each translated .arb carries a review
// marker; a locale counts as reviewed when a named person and a date are
// recorded and the count matches the strings actually shipped. Adding a new
// string after a sign-off invalidates it, which is the point: the twelve
// strings the accessibility work added were never in front of the reviewer,
// so a stale sign-off would be worse than none.
//
// The check is advisory by default so day-to-day work is not blocked by a
// gap everyone already knows about. Pass --release (as the release workflow
// does) to make it fail the build.
//
// Run: dart run tool/check_translation_review.dart [--release]

import 'dart:convert';
import 'dart:io';

/// Locales that require sign-off. `en` is the source, not a translation.
const _reviewedLocales = <String>['si', 'ta'];

const _dir = 'lib/src/l10n';

void main(List<String> args) {
  final releaseMode = args.contains('--release');

  final source = _readArb('en');
  if (source == null) {
    stderr.writeln('Run this from the slds_components package root.');
    exit(2);
  }
  final stringCount = _countStrings(source);

  final problems = <String>[];

  for (final locale in _reviewedLocales) {
    final arb = _readArb(locale);
    if (arb == null) {
      problems.add('$locale: slds_$locale.arb is missing.');
      continue;
    }

    final reviewer = (arb['@@x-reviewed-by'] as String? ?? '').trim();
    final date = (arb['@@x-reviewed-on'] as String? ?? '').trim();
    final reviewedCount = arb['@@x-reviewed-count'] as int? ?? 0;

    if (reviewer.isEmpty || date.isEmpty) {
      problems.add(
        '$locale: not reviewed. All $stringCount strings are machine-drafted '
        'and no speaker has signed them off.',
      );
      continue;
    }

    // A sign-off covers the strings that existed when it was given. New keys
    // since then are unreviewed, even though the locale looks signed off.
    if (reviewedCount != stringCount) {
      problems.add(
        '$locale: sign-off is stale. $reviewer reviewed $reviewedCount '
        'strings on $date; the library now ships $stringCount. The '
        '${stringCount - reviewedCount} added since need reviewing, and '
        '@@x-reviewed-count updating to $stringCount.',
      );
    }
  }

  if (problems.isEmpty) {
    stdout.writeln(
      'Translation review: ${_reviewedLocales.join(", ")} signed off '
      'at $stringCount strings.',
    );
    return;
  }

  final sink = releaseMode ? stderr : stdout;
  sink.writeln(
    releaseMode
        ? 'Translation review incomplete — §6 blocks this release:'
        : 'Translation review incomplete (advisory; --release fails):',
  );
  for (final problem in problems) {
    sink.writeln('  · $problem');
  }
  sink.writeln(
    '\nGenerate the reviewer packet with:\n'
    '  dart run tool/build_translation_packet.dart\n'
    "then record the sign-off in the locale's .arb:\n"
    '  "@@x-reviewed-by": "Name", "@@x-reviewed-on": "YYYY-MM-DD", '
    '"@@x-reviewed-count": $stringCount',
  );

  if (releaseMode) exit(1);
}

Map<String, dynamic>? _readArb(String locale) {
  final file = File('$_dir/slds_$locale.arb');
  if (!file.existsSync()) return null;
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

/// Translatable keys, excluding `@`-prefixed metadata and `@@` globals.
int _countStrings(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).length;
