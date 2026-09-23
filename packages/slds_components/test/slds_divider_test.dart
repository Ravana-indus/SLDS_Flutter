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

  testWidgets('withButton builds a ghost, Small-scale + button and wires '
      'the tap', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsDivider.withButton(
        buttonLabel: 'Add item',
        onButtonPressed: () => tapped = true,
      ),
    );

    expect(find.byType(Divider), findsNWidgets(2));
    expect(find.text('Add item'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    final button = tester.widget<SldsButton>(find.byType(SldsButton));
    expect(button.variant, SldsButtonVariant.tertiary);
    expect(button.size, SldsButtonSize.small);

    await tester.tap(find.byType(SldsButton));
    expect(tapped, isTrue);
  });
}
