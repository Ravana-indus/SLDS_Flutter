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

  testWidgets('is a fixed 150x158 tile at the small size', (tester) async {
    await pump(tester, const SldsIconCard(title: 'Fuel Pass', icon: icon));
    final size = tester.getSize(find.byType(SldsIconCard));
    expect(size, const Size(150, 158));
  });

  testWidgets('large size is 220 tall and fills a bounded parent width', (tester) async {
    await pump(
      tester,
      const SizedBox(
        width: 300,
        child: SldsIconCard(title: 'Apply for Passport', icon: icon, size: SldsIconCardSize.large),
      ),
    );
    final size = tester.getSize(find.byType(SldsIconCard));
    expect(size, const Size(300, 220));
  });

  testWidgets('large size does not crash with an unbounded parent width', (tester) async {
    await pump(
      tester,
      Row(
        children: [
          const SldsIconCard(title: 'Apply for Passport', icon: icon, size: SldsIconCardSize.large),
        ],
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('disabled when onTap is null: dims content and blocks taps', (tester) async {
    var tapped = false;
    await pump(tester, const SldsIconCard(title: 'Fuel Pass', icon: icon));

    await tester.tap(find.text('Fuel Pass'));
    expect(tapped, isFalse);

    expect(
      tester.getSemantics(find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'Fuel Pass')),
      matchesSemantics(label: 'Fuel Pass', isButton: false, hasEnabledState: true, isEnabled: false),
    );
  });

  testWidgets('forced hover state paints the hover background', (tester) async {
    await pump(
      tester,
      const SldsIconCard(title: 'Fuel Pass', icon: icon, state: SldsIconCardState.hover),
    );

    final colors = SldsColorTokens.light();
    final material = tester.widget<Material>(
      find.descendant(of: find.byType(SldsIconCard), matching: find.byType(Material)),
    );
    expect(material.color, colors.surfaceHover);
  });

  testWidgets('exposes button semantics when interactive', (tester) async {
    await pump(tester, SldsIconCard(title: 'Fuel Pass', icon: icon, onTap: () {}));

    expect(
      tester.getSemantics(find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'Fuel Pass')),
      matchesSemantics(label: 'Fuel Pass', isButton: true, hasEnabledState: true, isEnabled: true),
    );
  });
}
