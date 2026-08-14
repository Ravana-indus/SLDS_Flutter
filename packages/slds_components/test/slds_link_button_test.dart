import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
      home: Scaffold(body: child),
    ),
  );

  testWidgets('renders the label underlined', (tester) async {
    await pump(tester, SldsLinkButton(label: 'Link button', onPressed: () {}));
    expect(find.text('Link button'), findsOneWidget);

    final text = tester.widget<Text>(find.text('Link button'));
    expect(text.style?.decoration, TextDecoration.underline);
  });

  testWidgets('taps invoke onPressed', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsLinkButton(label: 'Link button', onPressed: () => tapped = true),
    );

    await tester.tap(find.byType(SldsLinkButton));
    expect(tapped, isTrue);
  });

  testWidgets('null onPressed disables the button', (tester) async {
    await pump(
      tester,
      const SldsLinkButton(label: 'Link button', onPressed: null),
    );
    final button = tester.widget<TextButton>(find.byType(TextButton));
    expect(button.enabled, isFalse);
  });
}
