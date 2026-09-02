// §3: distribution is via the private pub registry, never a git or path
// reference, because those bypass version resolution and break reproducible
// builds in consuming apps.
//
// Today `publish_to: none` is what stops a broken publish. But that line is
// exactly what the first release deletes, and deleting it also removes the
// only thing preventing `slds_tokens` going out as an unresolvable path
// dependency. This test is the safety net that survives that edit: the moment
// the package becomes publishable, every rule that only matters at publish
// time starts being enforced.
//
// Until then the checks below are inert by design — they assert nothing about
// a package that is not being published.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Reads a top-level `key: value` from a pubspec.
///
/// Deliberately not a YAML parse: pulling in a parser for four scalar lookups
/// would add a dependency to the library's dev set to read four scalars.
/// Nested keys are out of scope, and `_pathDependencies` handles the one
/// nested case this file needs.
String? _scalar(String pubspec, String key) {
  final match = RegExp(
    '^$key:[ \\t]*(.*)\$',
    multiLine: true,
  ).firstMatch(pubspec);
  if (match == null) return null;
  return match.group(1)!.trim().replaceAll(RegExp(r'''^['"]|['"]$'''), '');
}

/// Names of dependencies declared with a `path:` reference.
///
/// Walks the `dependencies:` block line by line: a name sits at two spaces of
/// indent, and the `path:` that makes it local sits deeper, before the next
/// name. A line scan rather than one regex because the nesting is what
/// carries the meaning, and a pattern spanning it is the kind that passes on
/// a sample and silently matches nothing on the real file.
Iterable<String> _pathDependencies(String pubspec) sync* {
  var inDependencies = false;
  String? current;

  for (final line in const LineSplitter().convert(pubspec)) {
    if (line.trimLeft().startsWith('#') || line.trim().isEmpty) continue;

    // A top-level key ends the block we care about.
    if (!line.startsWith(' ')) {
      inDependencies = line.startsWith('dependencies:');
      current = null;
      continue;
    }
    if (!inDependencies) continue;

    final name = RegExp(r'^  (\w+):[ \t]*$').firstMatch(line);
    if (name != null) {
      current = name.group(1);
      continue;
    }
    if (current != null && RegExp(r'^\s+path:').hasMatch(line)) {
      yield current;
      current = null;
    }
  }
}

void main() {
  final pubspec = File('pubspec.yaml').readAsStringSync();
  final publishTo = _scalar(pubspec, 'publish_to');
  final isPublishable = publishTo != 'none';

  test('version and changelog stay in step', () {
    final version = _scalar(pubspec, 'version');
    expect(version, isNotNull, reason: 'pubspec declares no version');

    // §3 requires a human-readable CHANGELOG entry for every release. A
    // version with no matching heading means the entry was never written, or
    // the bump was made without one.
    final changelog = File('CHANGELOG.md').readAsStringSync();
    expect(
      changelog,
      contains('## $version'),
      reason:
          'CHANGELOG.md has no "## $version" entry. Every release ships one '
          '(§3), with a migration note for breaking changes.',
    );
  });

  test('a publishable package has no path dependencies', () {
    // Inert while `publish_to: none` holds. It starts biting the moment that
    // line is removed, which is the edit that would otherwise let a path
    // dependency ship.
    if (!isPublishable) {
      markTestSkipped(
        'publish_to: none — path dependencies are fine until the private '
        'registry decision (§12) lands and this package is published.',
      );
      return;
    }

    expect(
      _pathDependencies(pubspec),
      isEmpty,
      reason:
          'A published package cannot resolve a path dependency (§3). Switch '
          'it to a hosted version constraint against the private registry '
          'before removing publish_to: none.',
    );
  });
}
