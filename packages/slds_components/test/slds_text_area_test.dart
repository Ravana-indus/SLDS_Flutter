import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(body: field)),
      );

  testWidgets('renders label, required marker, hint, and 0/max counter', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsTextArea(
        label: 'Description',
        isRequired: true,
        hintText: 'Description placeholder',
      ),
    );

    expect(find.textContaining('Description'), findsWidgets);
    expect(find.textContaining('*'), findsOneWidget);
    expect(find.text('Description placeholder'), findsOneWidget);
    expect(find.text('0/300'), findsOneWidget);
  });

  testWidgets('counter updates as the user types', (tester) async {
    await pump(tester, const SldsTextArea(label: 'Description'));

    await tester.enterText(find.byType(TextFormField), 'Hello');
    await tester.pump();

    expect(find.text('5/300'), findsOneWidget);
  });

  testWidgets('input is capped at maxLength', (tester) async {
    await pump(tester, const SldsTextArea(label: 'Description', maxLength: 5));

    await tester.enterText(find.byType(TextFormField), 'abcdefgh');
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, 'abcde');
    expect(find.text('5/5'), findsOneWidget);
  });

  testWidgets('counter is hidden when maxLength is null', (tester) async {
    await pump(tester, const SldsTextArea(label: 'Description', maxLength: null));
    expect(find.textContaining('/'), findsNothing);
  });

  testWidgets('shows help text when there is no error', (tester) async {
    await pump(tester, const SldsTextArea(label: 'Description', helpText: 'Help Text'));
    expect(find.text('Help Text'), findsOneWidget);
  });

  testWidgets('error text replaces help text and colors the border red', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsTextArea(
        label: 'Description',
        helpText: 'Help Text',
        errorText: 'Error Text',
      ),
    );

    expect(find.text('Error Text'), findsOneWidget);
    expect(find.text('Help Text'), findsNothing);

    final field = tester.widget<TextField>(find.byType(TextField));
    final border = field.decoration!.enabledBorder as OutlineInputBorder;
    expect(border.borderSide.color, SldsColors.error);
  });

  testWidgets('disabled field is not enabled', (tester) async {
    await pump(tester, const SldsTextArea(label: 'Description', enabled: false));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enabled, isFalse);
  });

  testWidgets('typing invokes onChanged', (tester) async {
    String? value;
    await pump(tester, SldsTextArea(label: 'Description', onChanged: (v) => value = v));

    await tester.enterText(find.byType(TextFormField), 'hello world');
    expect(value, 'hello world');
  });

  testWidgets('accepts multiple lines of input', (tester) async {
    await pump(tester, const SldsTextArea(label: 'Description'));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.maxLines, greaterThan(1));
  });
}
