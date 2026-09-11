import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

/// The Quick Action tile is a hard 96x96 in Figma (node 533:2742) — these
/// tiles sit in a fixed grid, so the tile may not grow with the text scale
/// the way the other variants do. Its budget is tight: 20 padding each side
/// leaves 56, and a 40 icon plus the gap plus a 12 label line fills it
/// exactly. That went through four rounds of off-by-a-few overflow, so pin
/// it: the footprint stays 96x96 and the label ellipsizes inside it.
void main() {
  Future<void> pumpAt(WidgetTester tester, double scale, Widget card) =>
      tester.pumpWidget(
        MaterialApp(
          theme: SldsTheme.light,
          localizationsDelegates: SldsLocalizations.localizationsDelegates,
          supportedLocales: SldsLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: Scaffold(body: Center(child: card)),
            ),
          ),
        ),
      );

  for (final scale in const [1.0, 1.5, 2.0]) {
    testWidgets('quickAction stays 96x96 and does not overflow at ${scale}x', (
      tester,
    ) async {
      await pumpAt(
        tester,
        scale,
        const SldsIconCard(
          title: 'Fuel Pass',
          icon: Icon(Icons.local_gas_station),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(SldsIconCard)), const Size(96, 96));
    });

    testWidgets('quickAction absorbs a long label at ${scale}x', (
      tester,
    ) async {
      await pumpAt(
        tester,
        scale,
        const SldsIconCard(
          title: 'Vehicle registration renewal and transfers',
          icon: Icon(Icons.directions_car),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(SldsIconCard)), const Size(96, 96));
    });
  }

  testWidgets('defaultCard, unlike quickAction, grows with the text scale', (
    tester,
  ) async {
    await pumpAt(
      tester,
      2,
      const SldsIconCard(
        title: 'Name',
        description: 'Description',
        icon: Icon(Icons.description_outlined),
        variant: SldsIconCardVariant.defaultCard,
      ),
    );

    expect(tester.takeException(), isNull);
    final size = tester.getSize(find.byType(SldsIconCard));
    expect(size.width, 150);
    expect(size.height, greaterThan(158));
  });
}
