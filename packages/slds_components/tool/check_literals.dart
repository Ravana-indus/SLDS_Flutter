// Fails the build when widget code gains new raw-value literals.
//
// The SLDS engineering guidelines (§2) prohibit raw values in widgets: every
// colour, size, duration and radius must resolve from `slds_tokens` or from
// `ThemeData`. The library currently violates that in a known set of files, so
// this check is a ratchet rather than a flat ban — a baseline file records how
// many violations each file is allowed, and the check fails if a file exceeds
// its allowance or if a file not in the baseline has any at all.
//
// Two rules run, each with its own baseline: colours and dimensions. They are
// separate because the colour backlog is nearly drained while the dimension
// one is not, and merging them would hide progress on either.
//
// Cleanup lowers the numbers; nothing can raise them. When a file reaches zero
// its line is deleted, and when a baseline is empty this whole mechanism goes
// away for that rule and it becomes an outright ban.
//
// Run: dart run tool/check_literals.dart

import 'dart:io';

/// Directory the rules apply to.
const _widgetDir = 'lib/src/widgets';

/// One ratchet: a named rule, its patterns, and where its allowances live.
class _Rule {
  const _Rule(this.noun, this.baselineFile, this.patterns);

  /// What the rule counts, for messages ('colour literal', 'dimension').
  final String noun;

  /// Per-file allowances for this rule.
  final String baselineFile;

  /// Anything matching is a violation.
  final List<RegExp> patterns;
}

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

/// Raw numbers given to the constructors that carry a design decision.
///
/// Deliberately narrow. A bare number in widget code is not automatically a
/// token violation — `_selectedHour12 < 10`, `i * 30`, `maxLines: 2` and
/// `alpha: 0.4` are all arithmetic or semantics, not spacing. What §2 is about
/// is the values a designer owns: padding, gaps, sizes, radii and stroke
/// widths. Matching those constructors by name keeps the signal high enough
/// that the number is worth acting on.
///
/// `0` is excluded throughout: zero padding is the absence of a value, and
/// there is nothing for a token to say about it.
final _dimensionLiterals = <RegExp>[
  // EdgeInsets.all(12), .symmetric(horizontal: 8), .only(top: 4), …
  //
  // The lookbehind keeps `EdgeInsets.all(dimensions.space8 * 2)` clean: the
  // multiplier is arithmetic on a token, not a hardcoded inset. Only a number
  // that is not preceded by an identifier or an operator counts.
  RegExp(
    r'EdgeInsets(?:Directional)?\.\w+\([^)]*?'
    r'(?<![.\w])(?<![*+/\-]\s)(?<![*+/\-])\b[1-9][\d.]*',
  ),
  // BorderRadius.circular(20), Radius.circular(8)
  RegExp(r'(?:BorderRadius|Radius)\.circular\(\s*[1-9][\d.]*'),
  // SizedBox(width: 12, height: 8) — but not SizedBox.shrink() or expand()
  RegExp(r'SizedBox\([^)]*\b(?:width|height):\s*[1-9][\d.]*'),
  // width: on a border side or container stroke
  RegExp(r'\bwidth:\s*[1-9][\d.]*\s*[,)]'),
  // Explicit sizes on icons and gaps
  RegExp(r'\bsize:\s*[1-9][\d.]*\s*[,)]'),
  RegExp(r'\b(?:blurRadius|spreadRadius|elevation):\s*[1-9][\d.]*'),
];

final _rules = <_Rule>[
  _Rule('colour literal', 'tool/literal_baseline.txt', [
    _hexLiteral,
    _namedColor,
  ]),
  _Rule('dimension', 'tool/dimension_baseline.txt', _dimensionLiterals),
];

void main(List<String> args) {
  final dir = Directory(_widgetDir);
  if (!dir.existsSync()) {
    stderr.writeln('Run this from the slds_components package root.');
    exit(2);
  }

  var failed = false;
  for (final rule in _rules) {
    if (!_check(dir, rule)) failed = true;
  }
  if (failed) exit(1);
}

/// Runs one rule over [dir]. Returns whether it passed.
bool _check(Directory dir, _Rule rule) {
  final baseline = _readBaseline(rule.baselineFile);
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
        for (final pattern in rule.patterns) ...pattern.allMatches(line),
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
        '  $file has $count ${rule.noun}(s) but is not in the baseline.\n'
        '${examples[file]!.join('\n')}',
      );
    } else if (count > allowed) {
      failures.add(
        '  $file has $count ${rule.noun}(s), baseline allows $allowed.\n'
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
    stderr.writeln('Raw ${rule.noun}s are not allowed in widget code (§2).');
    stderr.writeln('Resolve the value from a token instead.\n');
    stderr.writeln(failures.join('\n\n'));
    stderr.writeln('\n$total found, baseline allows $allowedTotal.');
    return false;
  }

  stdout.writeln('${rule.noun}s: $total (baseline $allowedTotal).');
  if (improvements.isNotEmpty) {
    stdout.writeln('  baseline can be lowered:');
    stdout.writeln(improvements.join('\n'));
    stdout.writeln('  update ${rule.baselineFile} to lock it in.');
  }
  return true;
}

/// Whether [line] is entirely a comment, and so exempt.
///
/// Doc comments routinely name colours (`[Colors.white]`) when explaining what
/// a widget replaced them with; only real code counts.
bool _isComment(String line) {
  final trimmed = line.trimLeft();
  return trimmed.startsWith('//') || trimmed.startsWith('*');
}

Map<String, int> _readBaseline(String path) {
  final file = File(path);
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
