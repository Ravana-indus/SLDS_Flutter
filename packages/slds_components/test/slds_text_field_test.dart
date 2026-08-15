import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: field),
    ),
  );

  testWidgets('renders label, required marker, and hint', (tester) async {
    await pump(
      tester,
      const SldsTextField(
        label: 'Email',
        isRequired: true,
        hintText: 'info@example.com',
      ),
    );

    expect(find.textContaining('Email'), findsOneWidget);
    expect(find.textContaining('*'), findsOneWidget);
    expect(find.text('info@example.com'), findsOneWidget);
  });

  testWidgets('shows help text when there is no error', (tester) async {
    await pump(
      tester,
      const SldsTextField(label: 'Email', helpText: 'Help Text'),
    );
    expect(find.text('Help Text'), findsOneWidget);
  });

  testWidgets('error text replaces help text and colors the border red', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsTextField(
        label: 'Email',
        helpText: 'Help Text',
        errorText: 'Error Text',
      ),
    );

    expect(find.text('Error Text'), findsOneWidget);
    expect(find.text('Help Text'), findsNothing);

    final field = tester.widget<TextField>(find.byType(TextField));
    final border = field.decoration!.enabledBorder! as OutlineInputBorder;
    expect(border.borderSide.color, SldsColorTokens.light().inputBorderError);
  });

  testWidgets('disabled field is not enabled', (tester) async {
    await pump(tester, const SldsTextField(label: 'Email', enabled: false));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enabled, isFalse);
  });

  testWidgets('typing invokes onChanged', (tester) async {
    String? value;
    await pump(
      tester,
      SldsTextField(label: 'Email', onChanged: (v) => value = v),
    );

    await tester.enterText(find.byType(TextFormField), 'hello@slds.lk');
    expect(value, 'hello@slds.lk');
  });

  testWidgets('leading/trailing icons render when provided', (tester) async {
    await pump(
      tester,
      const SldsTextField(
        label: 'Email',
        leadingIcon: Icons.star_border,
        trailingIcon: Icons.info_outline,
      ),
    );

    expect(find.byIcon(Icons.star_border), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
  });
}
