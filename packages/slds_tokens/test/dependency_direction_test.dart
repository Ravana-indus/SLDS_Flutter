// Enforces the one-way dependency flow in §2: `slds_tokens` must never
// depend on Flutter, so tokens stay consumable by codegen, web exports and
// design tooling — and so the contrast check can run as a plain Dart test.

import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('no Flutter or dart:ui imports anywhere in lib/', () {
    // Matches import/export directives only. Doc comments legitimately
    // mention `dart:ui` when explaining why it is absent.
    final banned = RegExp(
      r'''^\s*(import|export)\s+['"](package:flutter|dart:ui)''',
      multiLine: true,
    );

    final offenders = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;

      final source = entity.readAsStringSync();
      for (final match in banned.allMatches(source)) {
        final line =
            '\n'.allMatches(source.substring(0, match.start)).length + 1;
        offenders.add('${entity.path}:$line  ${match.group(0)!.trim()}');
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'slds_tokens must stay Flutter-free (§2). Move anything needing a '
          'Flutter type into slds_components instead:\n${offenders.join('\n')}',
    );
  });

  test('the package declares no dependencies', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final deps = RegExp(
      r'^dependencies:\s*$(.*?)^\S',
      multiLine: true,
      dotAll: true,
    ).firstMatch(pubspec);

    // A `dependencies:` block with entries would be a supply-chain liability
    // for every consuming app, and §2 requires architecture sign-off for each.
    if (deps != null) {
      final entries = deps
          .group(1)!
          .split('\n')
          .where((l) => l.trim().isNotEmpty && !l.trim().startsWith('#'))
          .toList();
      expect(
        entries,
        isEmpty,
        reason:
            'slds_tokens should have no runtime dependencies, found:\n'
            '${entries.join('\n')}',
      );
    }
  });
}
