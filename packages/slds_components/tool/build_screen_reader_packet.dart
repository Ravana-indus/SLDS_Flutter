// Builds the reviewer packet for the manual TalkBack/VoiceOver pass (DoD 13).
//
// DoD 13 requires one screen-reader pass per release, on every component that
// shipped or changed. It is the one criterion no test can close: the automated
// suite asserts that a semantic label *exists*, never that what a blind
// citizen hears makes sense. "Button, button" passes every matcher in the
// repository and is useless out loud.
//
// So this does for DoD 13 what build_translation_packet.dart does for §6 —
// it does not perform the pass, it removes the reasons not to. The tester gets
// one page: every component, its Widgetbook path, the interactive surface to
// exercise, and a verdict column. What is already machine-checked is listed
// once at the top and deliberately left off the per-component checklist, so
// nobody spends a morning re-measuring tap targets a matcher already proved.
//
// Run: dart run tool/build_screen_reader_packet.dart
// Writes: build/screen_reader_packet.html

// HTML is assembled from adjacent string literals that deliberately join
// without a space — a space between two tags would render as stray
// whitespace in a table cell.
// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'dart:convert';
import 'dart:io';

/// Callback parameters that mark a widget as reachable by a screen reader.
///
/// A component exposing none of these is presentational: the tester confirms
/// it is *skipped* by the reader rather than trying to focus it, which is a
/// different check with a different failure mode.
const _interactive = <String>[
  'onPressed',
  'onTap',
  'onChanged',
  'onSubmitted',
  'onSelected',
  'onExpansionChanged',
  'onRefresh',
  'onDismissed',
  'onClosed',
];

/// What the automated suite already proves, so the manual pass can skip it.
///
/// Listing this is the point of the packet. A tester who does not know what is
/// covered re-checks everything, runs out of patience, and the pass stops
/// happening — which is the current state.
const _alreadyAutomated = <String, String>{
  'Tap target ≥48dp':
      'slds_accessibility_guidelines_test.dart — androidTapTargetGuideline '
      'and iOSTapTargetGuideline over the interactive set',
  'Text contrast (WCAG AA)':
      'textContrastGuideline in the same file, plus 120 token pairings in '
      'slds_tokens/test/contrast_test.dart',
  'Every tap target carries a label':
      'labeledTapTargetGuideline — proves a label exists, NOT that it reads '
      'well. Judging the wording is this pass.',
  'Loading state announces':
      'The live-region assertions in slds_accessibility_guidelines_test.dart',
  'Labels are localized, not baked in':
      'slds_localized_semantics_test.dart across en/si/ta',
};

/// The checks that genuinely need ears, in the order a tester should run them.
///
/// Deliberately short. A 52-component pass at ten checks each is a thousand
/// judgements and will not get done; these five are the ones that actually
/// catch defects a matcher cannot see.
const _checks = <({String name, String what})>[
  (
    name: 'Reads sensibly',
    what:
        'Swipe to the component. Does the spoken output identify what it '
        'is and what it does, in words a citizen would use? '
        '"Button, button" fails.',
  ),
  (
    name: 'Role and state',
    what:
        'Is it announced as the right kind of control, with its state — '
        'checked, expanded, selected, disabled, required? A toggle that '
        'never says '
        '"on"/"off" fails.',
  ),
  (
    name: 'Focus order',
    what:
        'Swipe forward through the whole screen. Does focus move in reading '
        'order, with nothing skipped and nothing unreachable?',
  ),
  (
    name: 'Operable by gesture',
    what:
        'Activate it the screen-reader way (double-tap; for sliders and '
        'steppers the volume/adjust gestures). Does it actually work '
        'without sight?',
  ),
  (
    name: 'Change is announced',
    what:
        'When acting on it changes the screen — a sheet opens, an error '
        'appears, a value updates — is that announced, or silent?',
  ),
];

/// Components whose contract is to be invisible to the reader.
///
/// These fail by being *focusable*, not by being unlabelled — a divider that
/// takes focus makes a citizen swipe through noise to reach the next control.
const _decorative = <String>{'slds_divider'};

/// Not user-facing, so not part of the pass.
///
/// `SldsFocus` is the focus-ring helper every other widget composes; it has no
/// standalone Widgetbook use case because there is nothing to look at. It is
/// exercised implicitly by the focus-order check on everything else.
const _notTestable = <String>{'slds_focus'};

void main() {
  final widgetDir = Directory('lib/src/widgets');
  if (!widgetDir.existsSync()) {
    stderr.writeln('Run this from the slds_components package root.');
    exit(2);
  }

  final useCaseDir = Directory('../../widgetbook/lib/use_cases');
  final useCases = useCaseDir.existsSync()
      ? useCaseDir
            .listSync()
            .whereType<File>()
            .map(
              (f) => f.uri.pathSegments.last.replaceAll('_use_cases.dart', ''),
            )
            .toSet()
      : <String>{};

  final rows = <_Component>[];
  for (final file in widgetDir.listSync().whereType<File>()) {
    if (!file.path.endsWith('.dart')) continue;
    final slug = file.uri.pathSegments.last.replaceAll('.dart', '');
    final src = file.readAsStringSync();

    final classes = RegExp(
      r'^class (Slds\w+)',
      multiLine: true,
    ).allMatches(src).map((m) => m.group(1)!).toList();
    if (classes.isEmpty || _notTestable.contains(slug)) continue;

    // The tester looks for the component by the name it has in Widgetbook,
    // which follows the file. Sorting puts SldsAccordionItem before
    // SldsAccordion, so match the filename first and fall back to source
    // order.
    final pascal = slug
        .substring(5)
        .split('_')
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join();
    final expected = 'Slds$pascal';
    classes.sort((a, b) {
      if (a == expected) return -1;
      if (b == expected) return 1;
      return 0;
    });

    final surface = _interactive.where((c) => src.contains('$c:')).toList();
    final hasSemantics = RegExp(
      r'Semantics\(|MergeSemantics|ExcludeSemantics|semanticLabel|semanticsLabel',
    ).hasMatch(src);

    rows.add(
      _Component(
        slug: slug,
        names: classes,
        surface: surface,
        decorative: _decorative.contains(slug),
        declaresSemantics: hasSemantics,
        inWidgetbook: useCases.contains(slug),
      ),
    );
  }
  rows.sort((a, b) => a.slug.compareTo(b.slug));

  final out = File('build/screen_reader_packet.html')
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(_render(rows));

  final interactive = rows.where((r) => r.surface.isNotEmpty).length;
  final missing = rows.where((r) => !r.inWidgetbook).length;

  stdout
    ..writeln('Wrote ${out.path}')
    ..writeln()
    ..writeln(
      '${rows.length} components — $interactive interactive, '
      '${rows.length - interactive} presentational.',
    )
    ..writeln(
      '${rows.length * _checks.length} judgements at '
      '${_checks.length} checks each.',
    );
  if (missing > 0) {
    stdout.writeln(
      '$missing have no Widgetbook use case; the packet marks them "no '
      'harness" — they cannot be reached on device until one exists.',
    );
  }
}

class _Component {
  _Component({
    required this.slug,
    required this.names,
    required this.surface,
    required this.decorative,
    required this.declaresSemantics,
    required this.inWidgetbook,
  });

  final String slug;
  final List<String> names;
  final List<String> surface;
  final bool decorative;
  final bool declaresSemantics;
  final bool inWidgetbook;
}

String _e(String s) => const HtmlEscape().convert(s);

String _render(List<_Component> rows) {
  final b = StringBuffer()
    ..writeln('<!doctype html><meta charset="utf-8">')
    ..writeln('<title>SLDS — screen reader pass (DoD 13)</title>')
    ..writeln('<style>')
    ..writeln(
      'body{font:15px/1.55 system-ui,sans-serif;margin:0 auto;padding:32px;'
      'max-width:1100px;color:#222}'
      'h1{margin:0 0 4px}h2{margin:34px 0 10px;font-size:19px}'
      '.sub{color:#666;margin:0 0 22px}'
      'table{border-collapse:collapse;width:100%;margin-bottom:10px}'
      'th,td{border:1px solid #ddd;padding:7px 9px;text-align:left;'
      'vertical-align:top;font-size:14px}'
      'th{background:#f4f4f4}'
      'code{background:#f4f4f4;padding:1px 4px;border-radius:3px;'
      'font-size:12.5px}'
      '.note{background:#fffbe6;border-left:4px solid #ffc700;'
      'padding:12px 16px;margin:18px 0}'
      '.skip{background:#eef7ee;border-left:4px solid #059669;'
      'padding:12px 16px;margin:18px 0}'
      '.v{width:74px;text-align:center;color:#999}'
      '.tag{font-size:11.5px;padding:1px 6px;border-radius:3px;'
      'background:#eee;color:#555;white-space:nowrap}'
      '.warn{background:#fde8e8;color:#912}'
      '.dec{background:#eef;color:#448}'
      '@media print{.note,.skip{break-inside:avoid}tr{break-inside:avoid}}',
    )
    ..writeln('</style>')
    ..writeln('<h1>Manual screen reader pass</h1>')
    ..writeln(
      '<p class="sub">SLDS Flutter · DoD 13 · slds_components 0.1.0-alpha · '
      'one pass per release, every component that shipped or changed</p>',
    );

  b
    ..writeln(
      '<div class="note"><strong>This is the criterion no test can '
      'close.</strong> The suite proves a label <em>exists</em>. It cannot '
      'hear that the label makes sense. <code>"Button, button"</code> passes '
      'every matcher in this repository and is useless to a blind citizen — '
      'judging that is the whole job here.</div>',
    )
    ..writeln('<h2>Before you start</h2>')
    ..writeln(
      '<p>Run Widgetbook on a physical handset — not a simulator; '
      'VoiceOver and TalkBack behave differently there. Two passes are '
      'required, one per platform.</p>',
    )
    ..writeln('<table>')
    ..writeln('<tr><th>Android</th><th>iOS</th></tr>')
    ..writeln(
      '<tr><td>TalkBack on. Swipe right/left to move, double-tap to '
      'activate, two-finger swipe to scroll.</td>'
      '<td>VoiceOver on. Swipe right/left to move, double-tap to activate, '
      'rotor for headings and form controls.</td></tr>',
    )
    ..writeln('</table>')
    ..writeln(
      '<p><code>cd widgetbook &amp;&amp; flutter run</code> — pick the '
      'device, then navigate to each component below by name.</p>',
    );

  b
    ..writeln(
      '<div class="skip"><strong>Already automated — do not re-check '
      'these.</strong> Listed so the pass stays small enough to finish.'
      '<table style="margin-top:10px">',
    )
    ..writeln('<tr><th>Check</th><th>Where it is proved</th></tr>');
  _alreadyAutomated.forEach((k, v) {
    b.writeln('<tr><td>${_e(k)}</td><td>${_e(v)}</td></tr>');
  });
  b.writeln('</table></div>');

  b
    ..writeln('<h2>The five checks</h2>')
    ..writeln(
      '<p>Applied to every component in the table below. Anything '
      'other than a clear pass is a defect — file it with the spoken output '
      'quoted verbatim, because the wording <em>is</em> the bug.</p>',
    )
    ..writeln(
      '<table><tr><th style="width:150px">Check</th><th>What you are '
      'judging</th></tr>',
    );
  for (final c in _checks) {
    b.writeln(
      '<tr><td><strong>${_e(c.name)}</strong></td><td>${_e(c.what)}</td></tr>',
    );
  }
  b.writeln('</table>');

  b
    ..writeln('<h2>Components</h2>')
    ..writeln(
      '<p>Verdict columns: <code>P</code> pass, <code>F</code> fail, '
      '<code>-</code> not applicable. A presentational component passes by '
      'being <em>skipped</em> by the reader — if it takes focus, that is a '
      'fail.</p>',
    )
    ..writeln('<table>')
    ..writeln('<tr><th>Component</th><th>Surface to exercise</th>');
  for (final c in _checks) {
    b.writeln('<th class="v">${_e(c.name.split(' ').first)}</th>');
  }
  b.writeln('<th>Spoken output / notes</th></tr>');

  for (final r in rows) {
    final tags = <String>[
      if (r.decorative) '<span class="tag dec">presentational</span>',
      if (!r.inWidgetbook) '<span class="tag warn">no harness</span>',
      if (r.surface.isNotEmpty && !r.declaresSemantics)
        '<span class="tag">semantics via Material</span>',
    ].join(' ');

    final surface = r.decorative
        ? 'Must NOT take focus'
        : r.surface.isEmpty
        ? 'Read-only — confirm it is announced, and only once'
        : r.surface.map((s) => '<code>${_e(s)}</code>').join(' ');

    b
      ..writeln(
        '<tr><td><strong>${_e(r.names.first)}</strong>'
        '${tags.isEmpty ? '' : '<br>$tags'}</td>',
      )
      ..writeln('<td>$surface</td>');
    for (var i = 0; i < _checks.length; i++) {
      b.writeln('<td class="v"></td>');
    }
    b.writeln('<td></td></tr>');
  }

  b
    ..writeln('</table>')
    ..writeln('<h2>Sign-off</h2>')
    ..writeln('<table>')
    ..writeln(
      '<tr><th>Platform</th><th>Reader + version</th><th>Device + OS'
      '</th><th>Tester</th><th>Date</th><th>Result</th></tr>',
    )
    ..writeln(
      '<tr><td>Android</td><td></td><td></td><td></td><td></td>'
      '<td></td></tr>',
    )
    ..writeln(
      '<tr><td>iOS</td><td></td><td></td><td></td><td></td>'
      '<td></td></tr>',
    )
    ..writeln('</table>')
    ..writeln(
      '<p class="sub">Record the outcome against the release in '
      'CHANGELOG.md and flip the DoD 13 row in COMPLIANCE.md. A pass with '
      'open defects still counts as performed — note the defect numbers.</p>',
    );

  return b.toString();
}
