// Credential screenshot/recording marker (Credential and Privacy Handling).
//
// The library exposes `isCredential` so a host app's route can apply
// screenshot/screen-recording restriction and app-switcher obscuring; the
// library does not enforce the restriction itself. This just proves the
// flag is a real, readable constructor field — the OS-level enforcement is
// out of scope for a widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  test('isCredential defaults to false', () {
    const list = SldsSummaryList(rows: []);
    expect(list.isCredential, isFalse);
  });

  test('isCredential round-trips when set', () {
    const list = SldsSummaryList(rows: [], isCredential: true);
    expect(list.isCredential, isTrue);
  });

  testWidgets('a credential list still renders normally', (tester) async {
    // Synthetic — never a real licence number.
    const rows = [SldsSummaryRow(label: 'Licence number', value: 'B1234567')];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: SldsLocalizations.localizationsDelegates,
        supportedLocales: SldsLocalizations.supportedLocales,
        theme: SldsTheme.light,
        home: const Scaffold(
          body: SldsSummaryList(rows: rows, isCredential: true),
        ),
      ),
    );

    expect(find.text('Licence number'), findsOneWidget);
    expect(find.text('B1234567'), findsOneWidget);
  });
}
