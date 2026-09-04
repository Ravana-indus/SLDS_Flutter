// Bold text (§5).
//
// Flutter's own [Text] widget merges `FontWeight.bold` in automatically
// whenever `MediaQuery.boldTextOf(context)` is true (see
// packages/flutter/lib/src/widgets/text.dart, `Text.build`), so an SLDS
// component gets this for free as long as it renders through [Text] rather
// than fighting the OS setting with a hardcoded weight — see the dartdoc on
// `SldsTokensContext.slds` in slds_tokens.dart. This test proves that claim
// end to end for a real component rather than trusting the framework
// behavior blind.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

Future<void> _pumpWithBoldText(
  WidgetTester tester,
  Widget child, {
  required bool boldText,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(boldText: boldText),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('SldsButton label renders bold when the OS bold-text '
      'setting is on', (tester) async {
    await _pumpWithBoldText(
      tester,
      SldsButton(label: 'Continue', onPressed: () {}),
      boldText: true,
    );

    final rendered = tester.renderObject<RenderParagraph>(
      find.descendant(of: find.byType(SldsButton), matching: find.byType(Text)),
    );
    expect(rendered.text.style!.fontWeight, FontWeight.bold);
  });

  testWidgets('SldsButton label does not force bold when the setting is off', (
    tester,
  ) async {
    await _pumpWithBoldText(
      tester,
      SldsButton(label: 'Continue', onPressed: () {}),
      boldText: false,
    );

    final rendered = tester.renderObject<RenderParagraph>(
      find.descendant(of: find.byType(SldsButton), matching: find.byType(Text)),
    );
    expect(rendered.text.style!.fontWeight, isNot(FontWeight.bold));
  });
}
