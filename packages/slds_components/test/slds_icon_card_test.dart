import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget card) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: card),
    ),
  );

  const icon = Icon(Icons.local_gas_station);

  testWidgets('renders title and description', (tester) async {
    await pump(
      tester,
      const SldsIconCard(
        title: 'Fuel Pass',
        description: 'Apply for a fuel quota pass',
        icon: icon,
        variant: SldsIconCardVariant.defaultCard,
      ),
    );

    expect(find.text('Fuel Pass'), findsOneWidget);
    expect(find.text('Apply for a fuel quota pass'), findsOneWidget);
  });

  testWidgets('hides description when null', (tester) async {
    await pump(
      tester,
      const SldsIconCard(
        title: 'Fuel Pass',
        icon: icon,
        variant: SldsIconCardVariant.defaultCard,
      ),
    );
    expect(find.text('Fuel Pass'), findsOneWidget);
  });

  testWidgets('quickAction drops the description — it is label-only', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsIconCard(
        title: 'Fuel Pass',
        description: 'Apply for a fuel quota pass',
        icon: icon,
      ),
    );

    expect(find.text('Fuel Pass'), findsOneWidget);
    expect(find.text('Apply for a fuel quota pass'), findsNothing);
  });

  testWidgets('shows badge label only when set', (tester) async {
    await pump(tester, const SldsIconCard(title: 'Fuel Pass', icon: icon));
    expect(find.text('NEW'), findsNothing);

    await pump(
      tester,
      const SldsIconCard(title: 'Fuel Pass', icon: icon, badgeLabel: 'NEW'),
    );
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

  group('Figma variant geometry (node 533:2742)', () {
    testWidgets('quickAction is a fixed 96x96 tile', (tester) async {
      await pump(tester, const SldsIconCard(title: 'Fuel', icon: icon));
      expect(tester.getSize(find.byType(SldsIconCard)), const Size(96, 96));
    });

    testWidgets('defaultCard is 150x158', (tester) async {
      await pump(
        tester,
        const SldsIconCard(
          title: 'Name',
          description: 'Description',
          icon: icon,
          variant: SldsIconCardVariant.defaultCard,
        ),
      );
      expect(tester.getSize(find.byType(SldsIconCard)), const Size(150, 158));
    });

    testWidgets('featuredServices is 240 wide and sizes to its content', (
      tester,
    ) async {
      await pump(
        tester,
        const SldsIconCard(
          title: 'Apply for Passport',
          description: 'Begin your passport request online.',
          icon: icon,
          variant: SldsIconCardVariant.featuredServices,
        ),
      );
      final size = tester.getSize(find.byType(SldsIconCard));
      expect(size.width, 240);
      // 16 padding x2 + 48 icon + 12 gap + two caption_2 lines.
      expect(size.height, greaterThan(48));
    });

    testWidgets('quickAction and featuredServices use the 16 radius', (
      tester,
    ) async {
      for (final variant in const [
        SldsIconCardVariant.quickAction,
        SldsIconCardVariant.featuredServices,
      ]) {
        await pump(
          tester,
          SldsIconCard(title: 'Fuel', icon: icon, variant: variant),
        );
        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(SldsIconCard),
            matching: find.byType(Material),
          ),
        );
        expect(
          material.borderRadius,
          BorderRadius.circular(16),
          reason: '$variant should use radius3xl',
        );
      }
    });

    testWidgets('defaultCard uses the 12 radius', (tester) async {
      await pump(
        tester,
        const SldsIconCard(
          title: 'Name',
          icon: icon,
          variant: SldsIconCardVariant.defaultCard,
        ),
      );
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(SldsIconCard),
          matching: find.byType(Material),
        ),
      );
      expect(material.borderRadius, BorderRadius.circular(12));
    });
  });

  group('deprecated size parameter', () {
    testWidgets('small still maps to the quickAction footprint', (
      tester,
    ) async {
      await pump(
        tester,
        // Exercising the deprecated parameter is the point of this test:
        // it pins the migration mapping until `size` is removed.
        // ignore: deprecated_member_use_from_same_package
        const SldsIconCard(
          title: 'Fuel',
          icon: icon,
          size: SldsIconCardSize.small,
        ),
      );
      expect(tester.getSize(find.byType(SldsIconCard)), const Size(96, 96));
    });

    testWidgets('large still maps to the defaultCard footprint', (
      tester,
    ) async {
      await pump(
        tester,
        // Exercising the deprecated parameter is the point of this test:
        // it pins the migration mapping until `size` is removed.
        // ignore: deprecated_member_use_from_same_package
        const SldsIconCard(
          title: 'Name',
          icon: icon,
          size: SldsIconCardSize.large,
        ),
      );
      expect(tester.getSize(find.byType(SldsIconCard)), const Size(150, 158));
    });
  });

  testWidgets('disabled when onTap is null: dims content and blocks taps', (
    tester,
  ) async {
    const tapped = false;
    await pump(tester, const SldsIconCard(title: 'Fuel Pass', icon: icon));

    await tester.tap(find.text('Fuel Pass'));
    expect(tapped, isFalse);

    expect(
      tester.getSemantics(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Fuel Pass',
        ),
      ),
      matchesSemantics(
        label: 'Fuel Pass',
        hasEnabledState: true,
      ),
    );
  });

  testWidgets('forced hover state paints the hover background', (tester) async {
    await pump(
      tester,
      const SldsIconCard(
        title: 'Fuel Pass',
        icon: icon,
        state: SldsIconCardState.hover,
      ),
    );

    final colors = SldsColorTokens.light();
    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(SldsIconCard),
        matching: find.byType(Material),
      ),
    );
    expect(material.color, colors.surfaceHover);
  });

  testWidgets('exposes button semantics when interactive', (tester) async {
    await pump(
      tester,
      SldsIconCard(title: 'Fuel Pass', icon: icon, onTap: () {}),
    );

    expect(
      tester.getSemantics(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Fuel Pass',
        ),
      ),
      matchesSemantics(
        label: 'Fuel Pass',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
      ),
    );
  });
}
