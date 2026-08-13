import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget card) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(body: card)),
      );

  const icon = Icon(Icons.local_gas_station);

  testWidgets('renders title and description', (tester) async {
    await pump(
      tester,
      const SldsIconCard(title: 'Fuel Pass', description: 'Apply for a fuel quota pass', icon: icon),
    );

    expect(find.text('Fuel Pass'), findsOneWidget);
    expect(find.text('Apply for a fuel quota pass'), findsOneWidget);
  });

  testWidgets('hides description when null', (tester) async {
    await pump(tester, const SldsIconCard(title: 'Fuel Pass', icon: icon));
    expect(find.text('Fuel Pass'), findsOneWidget);
  });

  testWidgets('shows badge label only when set', (tester) async {
    await pump(tester, const SldsIconCard(title: 'Fuel Pass', icon: icon));
    expect(find.text('NEW'), findsNothing);

    await pump(tester, const SldsIconCard(title: 'Fuel Pass', icon: icon, badgeLabel: 'NEW'));
    expect(find.text('NEW'), findsOneWidget);
  });

  testWidgets('tapping invokes onTap', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsIconCard(title: 'Fuel Pass', icon: icon, onTap: () => tapped = true),
    );

    await tester.tap(find.text('Fuel Pass'));
    expect(tapped, isTrue);
  });

  testWidgets('is a fixed 150x158 tile', (tester) async {
    await pump(tester, const SldsIconCard(title: 'Fuel Pass', icon: icon));
    final size = tester.getSize(find.byType(SldsIconCard));
    expect(size, const Size(150, 158));
  });
}
