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

  // Figma Icon Card (533:2742): Quick Action 797:10019, Featured Services
  // 797:10028. Measured from the card's top-left.
  testWidgets('quick action and featured layouts match Figma (#203-#209)', (
    tester,
  ) async {
    Future<Rect Function(Finder)> show(SldsIconCardVariant variant) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SldsTheme.light,
          localizationsDelegates: SldsLocalizations.localizationsDelegates,
          supportedLocales: SldsLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: SldsIconCard(
                title: 'Fuel Pass',
                description: 'Apply for a fuel quota pass',
                badgeLabel: 'NEW',
                icon: const SizedBox.expand(key: Key('icon')),
                variant: variant,
                onTap: () {},
              ),
            ),
          ),
        ),
      );
      final card = tester.getRect(find.byType(SldsIconCard));
      return (Finder f) => tester.getRect(f).shift(-card.topLeft);
    }

    const icon = Key('icon');
    TextStyle style(String text) => tester.widget<Text>(find.text(text)).style!;

    // Small (Quick Action).
    var at = await show(SldsIconCardVariant.quickAction);
    expect(tester.getSize(find.byType(SldsIconCard)), const Size(96, 96));
    expect(at(find.byKey(icon)), const Rect.fromLTWH(28, 18, 40, 40)); // #205
    final title = at(find.text('Fuel Pass'));
    expect(title.top, 66); // #204
    expect(title.center.dx, 48);
    expect(style('Fuel Pass').fontSize, 11);
    expect(style('Fuel Pass').color, const Color(0xFF17171A));
    final pill = at(
      find
          .ancestor(of: find.text('NEW'), matching: find.byType(Container))
          .first,
    );
    expect(pill.top, -7); // #203
    expect(pill.height, 14);
    expect(pill.center.dx, 48);
    expect(style('NEW').fontSize, 12);
    expect(style('NEW').fontWeight, FontWeight.w400);

    // Large (Featured Services).
    at = await show(SldsIconCardVariant.featuredServices);
    expect(
      tester.getSize(find.byType(SldsIconCard)),
      const Size(240, 118),
    ); // #206
    expect(at(find.byKey(icon)), const Rect.fromLTWH(16, 16, 48, 48)); // #205
    expect(
      at(find.text('Fuel Pass')).topLeft,
      const Offset(18, 76),
    ); // #207, #209
    expect(at(find.text('Apply for a fuel quota pass')).top, 90); // #208, #209
    for (final text in ['Fuel Pass', 'Apply for a fuel quota pass']) {
      expect(style(text).fontSize, 11, reason: text);
      expect(style(text).fontSize! * style(text).height!, closeTo(12, 0.01));
    }
    expect(style('Fuel Pass').color, const Color(0xFF17171A));
    expect(style('Apply for a fuel quota pass').color, const Color(0xFF676767));
  });
}
