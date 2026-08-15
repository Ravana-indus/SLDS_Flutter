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

  const icon = Icon(Icons.description);

  testWidgets('renders title, description and badge', (tester) async {
    await pump(
      tester,
      const SldsServiceCard(
        icon: icon,
        title: 'Service Name',
        description: 'Enter the description text',
        badgeText: 'Success',
      ),
    );

    expect(find.text('Service Name'), findsOneWidget);
    expect(find.text('Enter the description text'), findsOneWidget);
    expect(find.text('Success'), findsOneWidget);
  });

  testWidgets('hides badge when badgeText is null', (tester) async {
    await pump(
      tester,
      const SldsServiceCard(
        icon: icon,
        title: 'Service Name',
        description: 'Description',
      ),
    );

    expect(find.byType(Icon), findsNWidgets(2)); // leading icon + chevron only
  });

  testWidgets('tapping invokes onTap', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsServiceCard(
        icon: icon,
        title: 'Service Name',
        description: 'Description',
        onTap: () => tapped = true,
      ),
    );

    await tester.tap(find.byType(SldsServiceCard));
    expect(tapped, isTrue);
  });

  Finder cardMaterial() => find.descendant(
    of: find.byType(SldsServiceCard),
    matching: find.byType(Material),
  );

  testWidgets('selected renders solid active background with black text', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsServiceCard(
        icon: icon,
        title: 'Service Name',
        description: 'Description',
        selected: true,
      ),
    );

    final colors = SldsColorTokens.light();
    final material = tester.widget<Material>(cardMaterial());
    expect(material.color, colors.buttonPrimaryBackground);

    final title = tester.widget<Text>(find.text('Service Name'));
    expect(title.style?.color, colors.textStaticBlack);
  });

  testWidgets('default state renders surface page background', (tester) async {
    await pump(
      tester,
      const SldsServiceCard(
        icon: icon,
        title: 'Service Name',
        description: 'Description',
      ),
    );

    final colors = SldsColorTokens.light();
    final material = tester.widget<Material>(cardMaterial());
    expect(material.color, colors.surfacePage);
  });

  testWidgets('forced selected state renders blue-100 background', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsServiceCard(
        icon: icon,
        title: 'Service Name',
        description: 'Description',
        state: SldsServiceCardState.selected,
      ),
    );

    final material = tester.widget<Material>(cardMaterial());
    expect(material.color, const Color(0xffE3EDFF));
  });

  testWidgets('exposes button and selected semantics', (tester) async {
    await pump(
      tester,
      SldsServiceCard(
        icon: icon,
        title: 'Service Name',
        description: 'Description',
        selected: true,
        onTap: () {},
      ),
    );

    final semantics = find.byWidgetPredicate(
      (w) => w is Semantics && w.properties.label == 'Service Name',
    );

    expect(
      tester.getSemantics(semantics),
      matchesSemantics(
        label: 'Service Name',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
      ),
    );
  });
}
