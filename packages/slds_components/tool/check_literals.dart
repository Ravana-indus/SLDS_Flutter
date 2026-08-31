// Fails the build when widget code gains new colour literals.
//
// The SLDS engineering guidelines (§2) prohibit raw values in widgets: every
// colour must resolve from `slds_tokens` or from `ThemeData`. The library
// currently violates that in a known set of files, so this check is a ratchet
// rather than a flat ban — `tool/literal_baseline.txt` records how many
// violations each file is allowed, and the check fails if a file exceeds its
// allowance or if a file not in the baseline has any at all.
//
// Cleanup lowers the numbers; nothing can raise them. When a file reaches zero
// its line is deleted, and when the baseline is empty this whole mechanism
// goes away and the rule becomes an outright ban.
//
// Run: dart run tool/check_literals.dart

import 'dart:io';

/// Directory the rule applies to.
const _widgetDir = 'lib/src/widgets';

/// Where the per-file allowances live.
const _baselineFile = 'tool/literal_baseline.txt';

/// Raw `Color(0x…)` constructions.
final _hexLiteral = RegExp(r'Color\(\s*0x[0-9a-fA-F]{6,8}');

/// Material's named colours (`Colors.white`, `Colors.black54`, …).
///
/// `Colors.` followed by an uppercase letter is a swatch shade accessor like
/// `Colors.red[500]`, which is equally disallowed, so the pattern accepts both.
///
/// `Colors.transparent` is excluded: it carries no palette value, so it is
/// not a design decision the token layer can own. Widgets use it to suppress
/// Material's state layer where the design gives a control no surface, and
/// there is nothing for a token to say about "no colour at all".
final _namedColor = RegExp(r'\bColors\.(?!transparent\b)[a-zA-Z]');

void main(List<String> args) {
  final dir = Directory(_widgetDir);
  if (!dir.existsSync()) {
    stderr.writeln('Run this from the slds_components package root.');
    exit(2);
  }

  final baseline = _readBaseline();
  final counts = <String, int>{};
  final examples = <String, List<String>>{};

  for (final file in dir.listSync().whereType<File>()) {
    if (!file.path.endsWith('.dart')) continue;
    final name = file.uri.pathSegments.last;

    var count = 0;
    final found = <String>[];
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (_isComment(line)) continue;

      for (final match in [
        ..._hexLiteral.allMatches(line),
        ..._namedColor.allMatches(line),
      ]) {
        count++;
        if (found.length < 3) {
          found.add('    $name:${i + 1}  ${line.trim()}');
        }
        // Silence the unused-local warning without changing behaviour.
        match.start;
      }
    }

    if (count > 0) {
      counts[name] = count;
      examples[name] = found;
    }
  }

  final failures = <String>[];
  final improvements = <String>[];

  counts.forEach((file, count) {
    final allowed = baseline[file];
    if (allowed == null) {
      failures.add(
        '  $file has $count colour literal(s) but is not in the baseline.\n'
        '${examples[file]!.join('\n')}',
      );
    } else if (count > allowed) {
      failures.add(
        '  $file has $count colour literal(s), baseline allows $allowed.\n'
        '${examples[file]!.join('\n')}',
      );
    } else if (count < allowed) {
      improvements.add('  $file: $allowed -> $count');
    }
  });

  for (final file in baseline.keys) {
    if (!counts.containsKey(file)) {
      improvements.add(
        '  $file: ${baseline[file]} -> 0 (remove from baseline)',
      );
    }
  }

  final total = counts.values.fold(0, (a, b) => a + b);
  final allowedTotal = baseline.values.fold(0, (a, b) => a + b);

  if (failures.isNotEmpty) {
    stderr.writeln('Colour literals are not allowed in widget code (§2).');
    stderr.writeln('Resolve the colour from a token instead.\n');
    stderr.writeln(failures.join('\n\n'));
    stderr.writeln('\n$total literal(s) found, baseline allows $allowedTotal.');
    exit(1);
  }

  stdout.writeln('Colour literals: $total (baseline $allowedTotal).');
  if (improvements.isNotEmpty) {
    stdout.writeln('\nBaseline can be lowered:');
    stdout.writeln(improvements.join('\n'));
    stdout.writeln('\nUpdate $_baselineFile to lock in the improvement.');
  }
}

/// Whether [line] is entirely a comment, and so exempt.
///
/// Doc comments routinely name colours (`[Colors.white]`) when explaining what
/// a widget replaced them with; only real code counts.
bool _isComment(String line) {
  final trimmed = line.trimLeft();
  return trimmed.startsWith('//') || trimmed.startsWith('*');
}

Map<String, int> _readBaseline() {
  final file = File(_baselineFile);
  if (!file.existsSync()) return {};

  final result = <String, int>{};
  for (final line in file.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length != 2) {
      stderr.writeln('Malformed baseline line: $line');
      exit(2);
    }
    result[parts[0]] = int.parse(parts[1]);
  }
  return result;
}
