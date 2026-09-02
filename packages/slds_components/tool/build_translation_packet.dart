// Builds the reviewer packet for the si/ta translation review (§6, M6).
//
// §6 treats an unverified translation as missing, and a missing translation
// blocks shipping. The gate is a human who reads the language — no test can
// stand in for it. What engineering *can* do is make that person's job small:
// this emits one self-contained HTML page with every string side by side,
// what it means, where it appears, and a verdict column.
//
// Without it a reviewer opens three .arb files, matches keys by eye, and has
// no idea which strings a citizen actually sees. That friction is why this
// row has stayed open, not the size of the job — 47 strings is an afternoon.
//
// Run: dart run tool/build_translation_packet.dart
// Writes: build/translation_packet.html

// HTML is assembled from adjacent string literals that deliberately join
// without a space — a space between two tags would render as stray
// whitespace in a table cell.
// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'dart:convert';
import 'dart:io';

/// Locales reviewed against English. English is the source, not a review
/// target — it is what the reviewer checks the other two against.
const _targets = <String, String>{'si': 'Sinhala', 'ta': 'Tamil'};

/// Strings a screen reader speaks but no one ever sees.
///
/// Called out because they carry the highest risk in the set: a wrong visible
/// label gets spotted by anyone opening the app, while a wrong semantic label
/// is invisible until a blind citizen hits it with TalkBack. Reviewers should
/// start here.
const _screenReaderOnly = <String>{
  'loading',
  'progress',
  'removeItem',
  'stepOf',
  'labelledValue',
  'digitOf',
  'clearSearch',
  'recentSearch',
  'suggestion',
  'previousMonth',
  'nextMonth',
  'selectHour',
  'selectMinute',
  'required',
  'expanded',
  'collapsed',
  'back',
  'menu',
  'close',
};

void main() {
  final dir = Directory('lib/src/l10n');
  if (!dir.existsSync()) {
    stderr.writeln('Run this from the slds_components package root.');
    exit(2);
  }

  final en = _readArb('en');
  final translations = {
    for (final locale in _targets.keys) locale: _readArb(locale),
  };

  final keys = en.keys.where((k) => !k.startsWith('@')).toList()..sort();

  final rows = <_Row>[];
  for (final key in keys) {
    final meta = en['@$key'] as Map<String, dynamic>?;
    rows.add(
      _Row(
        key: key,
        english: en[key] as String,
        description: meta?['description'] as String? ?? '',
        placeholders:
            (meta?['placeholders'] as Map<String, dynamic>?)?.keys.toList() ??
            const [],
        translations: {
          for (final locale in _targets.keys)
            locale: translations[locale]![key] as String? ?? '',
        },
        usedIn: _widgetsUsing(key),
        screenReaderOnly: _screenReaderOnly.contains(key),
      ),
    );
  }

  // Screen-reader strings first: highest risk, least likely to be caught by
  // anyone simply using the app.
  rows.sort((a, b) {
    if (a.screenReaderOnly != b.screenReaderOnly) {
      return a.screenReaderOnly ? -1 : 1;
    }
    return a.key.compareTo(b.key);
  });

  final out = File('build/translation_packet.html')
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(_render(rows));

  final unused = rows.where((r) => r.usedIn.isEmpty).length;
  stdout
    ..writeln('Wrote ${out.path}')
    ..writeln(
      '${rows.length} strings · '
      '${rows.where((r) => r.screenReaderOnly).length} screen-reader-only · '
      '$unused not referenced by any widget',
    );
}

Map<String, dynamic> _readArb(String locale) =>
    jsonDecode(File('lib/src/l10n/slds_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

/// Widget files referencing [key], for the "where it appears" column.
///
/// Matches `.key` rather than `sldsStrings.key`: several call sites read the
/// strings object into a local first, so the qualified form misses them and
/// would report a used string as dead.
List<String> _widgetsUsing(String key) {
  final dir = Directory('lib/src/widgets');
  if (!dir.existsSync()) return const [];

  final pattern = RegExp(r'\.' + RegExp.escape(key) + r'\b');
  final hits = <String>[];
  for (final file in dir.listSync().whereType<File>()) {
    if (!file.path.endsWith('.dart')) continue;
    if (pattern.hasMatch(file.readAsStringSync())) {
      hits.add(
        file.uri.pathSegments.last
            .replaceAll('slds_', '')
            .replaceAll('.dart', ''),
      );
    }
  }
  return hits..sort();
}

class _Row {
  _Row({
    required this.key,
    required this.english,
    required this.description,
    required this.placeholders,
    required this.translations,
    required this.usedIn,
    required this.screenReaderOnly,
  });

  final String key;
  final String english;
  final String description;
  final List<String> placeholders;
  final Map<String, String> translations;
  final List<String> usedIn;
  final bool screenReaderOnly;
}

String _esc(String s) => const HtmlEscape().convert(s);

String _render(List<_Row> rows) {
  final today = DateTime.now().toIso8601String().split('T').first;
  final buffer = StringBuffer()
    ..writeln('<!doctype html><html lang="en"><head><meta charset="utf-8">')
    ..writeln(
      '<meta name="viewport" content="width=device-width,initial-scale=1">',
    )
    ..writeln('<title>SLDS translation review — Sinhala and Tamil</title>')
    ..writeln('<style>${_css()}</style></head><body>')
    ..writeln('<header>')
    ..writeln('<h1>SLDS translation review</h1>')
    ..writeln(
      '<p class="lede">Every string the SLDS Flutter component library '
      'ships in Sinhala and Tamil. All were machine-drafted and none has '
      'been checked by a speaker, which is why the library cannot ship: the '
      'engineering guidelines (§6) treat an unverified translation the same '
      'as a missing one.</p>',
    )
    ..writeln(
      '<p class="ask"><b>What we need from you:</b> read each row and mark '
      'it <em>OK</em>, or write a correction. You do not need the app, the '
      'code, or any tooling — this page is self-contained, and you can send '
      'it back with notes in any form. The <b>English is the source</b>; the '
      'question is only whether the Sinhala or Tamil says the same thing to '
      'a citizen.</p>',
    )
    ..writeln(
      '<p class="ask">Two things matter more than elegance. <b>Placeholders '
      'like <code>{count}</code> must survive</b> exactly as written — they '
      'are replaced with real values at runtime, and a translated or dropped '
      'placeholder crashes the display. And where a term is already '
      'established in Sri Lankan government services, <b>prefer the familiar '
      'wording over a more literal one</b>.</p>',
    )
    ..writeln(
      '<p class="meta">Generated $today '
      '· ${rows.length} strings · slds_components</p>',
    )
    ..writeln('</header>');

  buffer.writeln(
    '<section class="note"><h2>Read these first</h2>'
    '<p>The rows marked <span class="tag sr">screen reader</span> are spoken '
    'aloud by TalkBack and VoiceOver but never appear on screen. A mistake in '
    'a visible label gets noticed by anyone who opens the app; a mistake in '
    'one of these stays invisible until a blind citizen encounters it. They '
    'are listed first for that reason.</p></section>',
  );

  buffer.writeln('<table>');
  buffer.writeln(
    '<thead><tr>'
    '<th class="c-key">Key &amp; meaning</th>'
    '<th class="c-en">English (source)</th>'
    '<th class="c-tr">Sinhala · සිංහල</th>'
    '<th class="c-tr">Tamil · தமிழ்</th>'
    '<th class="c-v">Verdict</th>'
    '</tr></thead><tbody>',
  );

  for (final row in rows) {
    buffer.writeln('<tr>');

    buffer.write('<td class="c-key"><code>${_esc(row.key)}</code>');
    if (row.screenReaderOnly) {
      buffer.write(' <span class="tag sr">screen reader</span>');
    }
    buffer.write('<span class="desc">${_esc(row.description)}</span>');
    if (row.usedIn.isNotEmpty) {
      buffer.write(
        '<span class="where">Appears in: ${_esc(row.usedIn.join(', '))}</span>',
      );
    } else {
      buffer.write(
        '<span class="where unused">Not currently shown by any component — '
        'still review it, it is shipped and reachable by host apps.</span>',
      );
    }
    if (row.placeholders.isNotEmpty) {
      buffer.write(
        '<span class="ph">Keep exactly: '
        '${row.placeholders.map((p) => '<code>{$p}</code>').join(' ')}</span>',
      );
    }
    buffer.writeln('</td>');

    buffer.writeln('<td class="c-en">${_esc(row.english)}</td>');
    for (final locale in _targets.keys) {
      buffer.writeln(
        '<td class="c-tr" lang="$locale">${_esc(row.translations[locale]!)}</td>',
      );
    }

    buffer.writeln(
      '<td class="c-v">'
      '<label><input type="checkbox"> si OK</label>'
      '<label><input type="checkbox"> ta OK</label>'
      '<div class="fix" contenteditable="true" '
      'data-placeholder="correction…"></div>'
      '</td>',
    );

    buffer.writeln('</tr>');
  }

  buffer
    ..writeln('</tbody></table>')
    ..writeln(
      '<footer><p>Return this page with your notes, or send corrections as a '
      'list of <code>key: corrected text</code> — whichever is easier. Every '
      'correction is applied to the source <code>.arb</code> files and the '
      'library is rebuilt from them; nothing you write here is edited by '
      'hand into the app.</p>'
      '<p class="meta">Checkboxes and notes on this page are for your own '
      'working only — they are not saved anywhere and are lost if you close '
      'the tab. Print to PDF, or write your corrections separately, to keep '
      'them.</p></footer>',
    )
    ..writeln('</body></html>');

  return buffer.toString();
}

String _css() => '''
  :root { color-scheme: light dark;
    --ink:#16202e; --soft:#4a5666; --muted:#6f7c8d; --rule:#dfe3e8;
    --panel:#fff; --ground:#f6f7f9; --sr:#8a5a00; --sr-bg:#fdf3dd; }
  @media (prefers-color-scheme: dark) { :root {
    --ink:#e9edf2; --soft:#b3bdc9; --muted:#8996a6; --rule:#2b3846;
    --panel:#141d28; --ground:#0d141d; --sr:#f0c04a; --sr-bg:#33280c; } }
  * { box-sizing: border-box; }
  body { margin:0; padding:2.5rem 1.5rem 5rem; background:var(--ground);
    color:var(--ink); font:15px/1.6 -apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif; }
  header, section.note, table, footer { max-width:82rem; margin-inline:auto; }
  h1 { font-size:1.9rem; margin:0 0 .6rem; }
  h2 { font-size:1.05rem; margin:0 0 .4rem; }
  .lede, .ask { color:var(--soft); max-width:46rem; margin:0 0 .7rem; }
  .ask b { color:var(--ink); }
  .meta { color:var(--muted); font-size:.82rem; margin:.8rem 0 0; }
  section.note { background:var(--panel); border:1px solid var(--rule);
    border-left:3px solid var(--sr); border-radius:4px;
    padding:1rem 1.15rem; margin:1.8rem auto; }
  section.note p { margin:0; color:var(--soft); font-size:.92rem; }
  table { width:100%; border-collapse:collapse; margin-top:1.8rem;
    background:var(--panel); border:1px solid var(--rule); border-radius:4px; }
  th, td { text-align:left; vertical-align:top; padding:.85rem .9rem;
    border-bottom:1px solid var(--rule); }
  thead th { position:sticky; top:0; background:var(--panel);
    font-size:.75rem; letter-spacing:.06em; text-transform:uppercase;
    color:var(--muted); border-bottom:2px solid var(--rule); }
  .c-key { width:26%; }
  .c-en { width:18%; }
  .c-tr { width:19%; font-size:1.05rem; }
  .c-v  { width:15%; }
  code { font-family:ui-monospace,SFMono-Regular,Menlo,monospace;
    font-size:.85em; background:var(--ground); padding:.1em .35em;
    border-radius:3px; }
  .desc, .where, .ph { display:block; font-size:.83rem; color:var(--soft);
    margin-top:.4rem; }
  .where { color:var(--muted); }
  .where.unused { font-style:italic; }
  .ph code { background:var(--sr-bg); color:var(--sr); }
  .tag { display:inline-block; font-size:.68rem; letter-spacing:.05em;
    text-transform:uppercase; padding:.15em .45em; border-radius:3px;
    vertical-align:middle; }
  .tag.sr { background:var(--sr-bg); color:var(--sr); }
  .c-v label { display:block; font-size:.85rem; color:var(--soft); }
  .fix { margin-top:.45rem; min-height:2.2rem; border:1px dashed var(--rule);
    border-radius:3px; padding:.35rem .45rem; font-size:.9rem; }
  .fix:empty::before { content:attr(data-placeholder); color:var(--muted); }
  .fix:focus { outline:2px solid var(--sr); border-style:solid; }
  footer { margin-top:2rem; color:var(--soft); font-size:.9rem; }
  @media print {
    body { background:#fff; padding:0; }
    thead th { position:static; }
    tr { break-inside:avoid; }
    .fix { min-height:2.6rem; }
  }
''';
