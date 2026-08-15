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

  testWidgets('renders the label', (tester) async {
    await pump(tester, const SldsChip(label: 'Label'));
    expect(find.text('Label'), findsOneWidget);
  });

  testWidgets('shows the close icon only when onDeleted is set', (
    tester,
  ) async {
    await pump(tester, const SldsChip(label: 'Label'));
    expect(find.byIcon(Icons.close), findsNothing);

    await pump(tester, SldsChip(label: 'Label', onDeleted: () {}));
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('tapping the close icon fires onDeleted, not onTap', (
    tester,
  ) async {
    var deleted = false;
    var tapped = false;
    await pump(
      tester,
      SldsChip(
        label: 'Label',
        onDeleted: () => deleted = true,
        onTap: () => tapped = true,
      ),
    );

    await tester.tap(find.byIcon(Icons.close));
    expect(deleted, isTrue);
    expect(tapped, isFalse);
  });

  testWidgets('avatar takes precedence over icon', (tester) async {
    await pump(
      tester,
      const SldsChip(
        label: 'Label',
        avatar: SldsAvatar(initials: 'LK'),
        icon: Icons.add,
      ),
    );
    expect(find.byType(SldsAvatar), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
  });
}
