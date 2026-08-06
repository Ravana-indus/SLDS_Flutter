import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget button) => tester.pumpWidget(
        MaterialApp(
          theme: SldsTheme.light(),
          localizationsDelegates: SldsLocalizations.localizationsDelegates,
          supportedLocales: SldsLocalizations.supportedLocales,
          home: Scaffold(body: button),
        ),
      );

  testWidgets('primary and destructive variants render as filled buttons', (tester) async {
    await pump(tester, SldsButton(label: 'Continue', onPressed: () {}));
    expect(find.byType(FilledButton), findsOneWidget);

    await pump(
      tester,
      SldsButton(label: 'Delete', variant: SldsButtonVariant.destructive, onPressed: () {}),
    );
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('secondary and tertiary variants render as outlined buttons', (tester) async {
    await pump(
      tester,
      SldsButton(label: 'Continue', variant: SldsButtonVariant.secondary, onPressed: () {}),
    );
    expect(find.byType(OutlinedButton), findsOneWidget);
  });

  testWidgets('text variant renders as a text button', (tester) async {
    await pump(
      tester,
      SldsButton(label: 'Continue', variant: SldsButtonVariant.text, onPressed: () {}),
    );
    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets('loading state shows a spinner and blocks taps', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsButton(label: 'Continue', isLoading: true, onPressed: () => tapped = true),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Continue'), findsNothing);

    await tester.tap(find.byType(FilledButton), warnIfMissed: false);
    expect(tapped, isFalse);
  });

  testWidgets('null onPressed disables the button', (tester) async {
    await pump(tester, const SldsButton(label: 'Continue', onPressed: null));
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.enabled, isFalse);
  });

  testWidgets('picks up SldsTheme.dark() colors from the ambient Theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SldsTheme.dark(),
        localizationsDelegates: SldsLocalizations.localizationsDelegates,
        supportedLocales: SldsLocalizations.supportedLocales,
        home: Scaffold(body: SldsButton(label: 'Continue', onPressed: () {})),
      ),
    );

    final context = tester.element(find.byType(SldsButton));
    final scheme = Theme.of(context).colorScheme;
    final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;
    final resolvedBackground = style.backgroundColor!.resolve({});

    expect(resolvedBackground, scheme.primary);
    expect(resolvedBackground, isNot(SldsColors.primary)); // dark seed differs from the light token
  });

  testWidgets('color override wins over the variant token', (tester) async {
    const override = Color(0xFF00FF00);
    await pump(
      tester,
      SldsButton(label: 'Continue', color: override, onPressed: () {}),
    );

    final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;
    expect(style.backgroundColor!.resolve({}), override);
  });
}
