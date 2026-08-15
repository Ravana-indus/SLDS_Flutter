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

  testWidgets('renders the rounded percentage label by default', (
    tester,
  ) async {
    await pump(tester, const SldsProgressBar(value: 0.4));
    expect(find.text('40%'), findsOneWidget);
  });

  testWidgets('hides the label when showLabel is false', (tester) async {
    await pump(tester, const SldsProgressBar(value: 0.4, showLabel: false));
    expect(find.text('40%'), findsNothing);
  });

  testWidgets('clamps out-of-range values', (tester) async {
    await pump(tester, const SldsProgressBar(value: 1.5));
    expect(find.text('100%'), findsOneWidget);

    await pump(tester, const SldsProgressBar(value: -0.5));
    expect(find.text('0%'), findsOneWidget);
  });

  testWidgets('fill width scales with value', (tester) async {
    await pump(
      tester,
      const SizedBox(
        width: 200,
        child: SldsProgressBar(value: 0.5, showLabel: false),
      ),
    );
    await tester.pumpAndSettle();
    final fillWidth = tester.getSize(find.byType(AnimatedContainer)).width;
    expect(fillWidth, closeTo(100, 0.01)); // 200 * 0.5
  });

  testWidgets('exposes progressbar semantics with the current value', (
    tester,
  ) async {
    await pump(tester, const SldsProgressBar(value: 0.4));
    final semantics = tester.getSemantics(find.byType(SldsProgressBar));
    expect(semantics.value, '40%');
  });
}
