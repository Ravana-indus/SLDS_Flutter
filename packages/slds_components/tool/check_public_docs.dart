// Ratchet for missing dartdoc on public members (§7).
//
// §7 requires a doc comment on every public member. 329 are still missing, so
// the analyzer rule is downgraded to `info` in analysis_options.yaml rather
// than failing the build outright. This check keeps that from becoming
// permanent: the count may fall, never rise.
//
// Run from the package root:
//   dart run tool/check_public_docs.dart

import 'dart:convert';
import 'dart:io';

/// The number of `public_member_api_docs` findings allowed.
///
/// Lower this whenever documentation lands. When it reaches zero, delete this
/// tool and restore the rule to its default severity.
const _allowed = 305;

Future<int> main() async {
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln('Run from the slds_components package root.');
    return 2;
  }

  final result = await Process.run('flutter', [
    'analyze',
    '--no-fatal-infos',
    '--no-fatal-warnings',
  ], stdoutEncoding: utf8);

  final findings = LineSplitter.split(
    result.stdout as String,
  ).where((line) => line.contains('public_member_api_docs')).length;

  if (findings > _allowed) {
    stderr
      ..writeln('Undocumented public members: $findings (allowed $_allowed).')
      ..writeln()
      ..writeln('§7 requires a dartdoc comment on every public member. New')
      ..writeln('public API must ship documented — the allowance covers the')
      ..writeln('existing backlog only, and may not grow.');
    return 1;
  }

  stdout.writeln('Undocumented public members: $findings (allowed $_allowed).');
  if (findings < _allowed) {
    stdout
      ..writeln()
      ..writeln('Improvement: lower _allowed in tool/check_public_docs.dart')
      ..writeln('to $findings to lock it in.');
  }
  return 0;
}
