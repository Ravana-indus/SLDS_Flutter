import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget fab) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      home: Scaffold(body: fab),
    ),
  );

  testWidgets('primary and destructive variants render filled', (tester) async {
    await pump(tester, SldsFab(icon: Icons.add, onPressed: () {}));
    final primary = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(primary.backgroundColor, isNot(Colors.transparent));

    await pump(
      tester,
      SldsFab(
        icon: Icons.delete,
        variant: SldsButtonVariant.destructive,
        onPressed: () {},
      ),
    );
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('secondary variant renders outlined on surface', (tester) async {
    await pump(
      tester,
      SldsFab(
        icon: Icons.add,
        variant: SldsButtonVariant.secondary,
        onPressed: () {},
      ),
    );
    final fab = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(fab.backgroundColor, SldsTheme.light().colorScheme.surface);
  });

  testWidgets('badgeCount shows a numeric badge', (tester) async {
    await pump(
      tester,
      SldsFab(icon: Icons.add, badgeCount: 3, onPressed: () {}),
    );
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('loading state shows a spinner and blocks taps', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsFab(icon: Icons.add, isLoading: true, onPressed: () => tapped = true),
    );

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton), warnIfMissed: false);
    expect(tapped, isFalse);
  });

  testWidgets('null onPressed disables the button', (tester) async {
    await pump(tester, const SldsFab(icon: Icons.add, onPressed: null));
    final fab = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(fab.onPressed, isNull);
  });
}
