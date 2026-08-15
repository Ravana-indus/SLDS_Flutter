import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: child),
    ),
  );

  testWidgets('renders a plain line when child is null', (tester) async {
    await pump(tester, const SldsDivider());
    expect(find.byType(Divider), findsOneWidget);
    expect(find.byType(Row), findsNothing);
  });

  testWidgets('renders child centered between two rule segments', (
    tester,
  ) async {
    await pump(tester, const SldsDivider(child: Text('Button')));
    expect(find.byType(Divider), findsNWidgets(2));
    expect(find.text('Button'), findsOneWidget);
  });

  testWidgets('fills the available width', (tester) async {
    await pump(
      tester,
      const SizedBox(width: 300, child: SldsDivider(child: Text('Button'))),
    );
    expect(tester.getSize(find.byType(SldsDivider)).width, 300);
  });
}
