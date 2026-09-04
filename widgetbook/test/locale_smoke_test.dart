// Proves the Locale addon actually reaches the demo copy: the same use-case
// text must differ between en, si and ta. Guards the regression this fixes —
// hardcoded English literals in a use case look fine until someone switches
// language and the preview does not.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';
import 'package:slds_widgetbook/support/demo_copy.dart';

void main() {
  Future<DemoCopy> copyFor(WidgetTester tester, String code) async {
    late DemoCopy copy;
    await tester.pumpWidget(
      MaterialApp(
        locale: Locale(code),
        localizationsDelegates: SldsLocalizations.localizationsDelegates,
        supportedLocales: SldsLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            copy = DemoCopy.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    return copy;
  }

  testWidgets('demo copy differs per locale', (tester) async {
    final en = await copyFor(tester, 'en');
    final si = await copyFor(tester, 'si');
    final ta = await copyFor(tester, 'ta');

    for (final key in ['Continue', 'Email', 'National Identity Card']) {
      expect(en[key], isNot(equals(si[key])), reason: '$key not translated to si');
      expect(en[key], isNot(equals(ta[key])), reason: '$key not translated to ta');
      expect(si[key], isNot(equals(ta[key])), reason: '$key si and ta identical');
    }
  });

  testWidgets('si and ta render in their own scripts', (tester) async {
    final si = await copyFor(tester, 'si');
    final ta = await copyFor(tester, 'ta');

    // Sinhala U+0D80–U+0DFF, Tamil U+0B80–U+0BFF.
    expect(RegExp(r'[඀-෿]').hasMatch(si['Continue']), isTrue);
    expect(RegExp(r'[஀-௿]').hasMatch(ta['Continue']), isTrue);
  });

  testWidgets('an unknown locale falls back to English', (tester) async {
    final fr = await copyFor(tester, 'fr');
    expect(fr['Continue'], 'Continue');
  });

  testWidgets('an unknown key returns itself', (tester) async {
    final en = await copyFor(tester, 'en');
    expect(en['not a real key'], 'not a real key');
  });
}
