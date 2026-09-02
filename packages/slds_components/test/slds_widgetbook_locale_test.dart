// Guards the Widgetbook Locale addon against being silently defeated.
//
// Several components take a nullable label that falls back to
// `context.sldsStrings.<key>` when null. A use case that passes a hardcoded
// English string into one of those parameters shadows the fallback, so
// switching the Locale addon changes nothing on screen and the component
// looks untranslated when it is not. That is a Widgetbook-only defect —
// invisible to every widget test, because the components themselves are
// correct.
//
// This reads the sources rather than rendering: it catches the mistake in any
// use case, including ones written after this test, which per-component
// widget tests would not.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('no use case shadows a localized default', () {
    final widgets = Directory('lib/src/widgets');
    final useCases = Directory('../../widgetbook/lib/use_cases');
    if (!useCases.existsSync()) {
      markTestSkipped('widgetbook package not present');
      return;
    }

    // param -> localized key, for every `foo ?? context.sldsStrings.bar`.
    final fallback = RegExp(
      r'(?:widget\.)?(\w+)\s*\?\?\s*context\.sldsStrings\.(\w+)',
    );

    final offenders = <String>[];
    for (final file in widgets.listSync().whereType<File>()) {
      if (!file.path.endsWith('.dart')) continue;
      final slug = file.uri.pathSegments.last.replaceAll('.dart', '');
      final useCase = File('${useCases.path}/${slug}_use_cases.dart');
      if (!useCase.existsSync()) continue;

      final source = useCase.readAsStringSync();
      for (final m in fallback.allMatches(file.readAsStringSync())) {
        final param = m.group(1)!;
        final passed = RegExp('\\b$param:\\s*([^,\n]+)').firstMatch(source);
        if (passed == null) continue; // not passed at all — fallback runs

        // The fix is to pass null when the knob is blank, so the widget's own
        // localized default is what renders.
        final value = passed.group(1)!.trim();
        if (!value.contains('isEmpty ? null') && !value.contains('null')) {
          offenders.add(
            '  ${slug}_use_cases.dart passes `$param: $value`, which shadows '
            'the localized default `context.sldsStrings.${m.group(2)}`',
          );
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These use cases defeat the Widgetbook Locale addon:\n'
          '${offenders.join('\n')}\n\n'
          'Drop the English initialValue and pass null when the knob is '
          'blank:\n'
          "  final hint = context.knobs.string(label: 'Hint');\n"
          '  ...\n'
          '  hintText: hint.isEmpty ? null : hint,',
    );
  });
}
