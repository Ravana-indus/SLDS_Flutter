import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
      home: Scaffold(body: field),
    ),
  );

  testWidgets('starts obscured with the "show" icon', (tester) async {
    await pump(tester, const SldsPasswordField());

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('tapping the eye icon reveals the password', (tester) async {
    await pump(tester, const SldsPasswordField());

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isFalse);
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });

  testWidgets('tapping again re-obscures the password', (tester) async {
    await pump(tester, const SldsPasswordField());

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);
  });

  testWidgets('disabled field cannot toggle visibility', (tester) async {
    await pump(tester, const SldsPasswordField(enabled: false));

    final iconButton = tester.widget<IconButton>(find.byType(IconButton));
    expect(iconButton.onPressed, isNull);
  });

  testWidgets('error text shows and typing invokes onChanged', (tester) async {
    String? value;
    await pump(
      tester,
      SldsPasswordField(errorText: 'Error Text', onChanged: (v) => value = v),
    );

    expect(find.text('Error Text'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'DGH347847#');
    expect(value, 'DGH347847#');
  });

  testWidgets('the obscured dot renders smaller than revealed text', (
    tester,
  ) async {
    await pump(tester, const SldsPasswordField());

    final obscuredSize = tester
        .widget<TextField>(find.byType(TextField))
        .style
        ?.fontSize;

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    final revealedSize = tester
        .widget<TextField>(find.byType(TextField))
        .style
        ?.fontSize;

    expect(obscuredSize, lessThan(revealedSize!));
  });
}
