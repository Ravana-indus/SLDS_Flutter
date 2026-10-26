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

  testWidgets('default state renders the white card surface (#214)', (
    tester,
  ) async {
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
    expect(material.color, colors.surfaceCard);
  });

  testWidgets('forced selected state renders Figma #DDDDDD (#221)', (
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
    expect(material.color, const Color(0xFFDDDDDD));
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

  // Figma Service Card Default (533:2564).
  testWidgets('text, badge, caret and radius match Figma (#216-#220)', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsServiceCard(
        icon: icon,
        title: 'Service Name',
        description: 'Enter the description text',
        badgeText: 'Success',
      ),
    );
    TextStyle style(String text) => tester.widget<Text>(find.text(text)).style!;

    final title = style('Service Name');
    expect(title.fontSize, 14); // #216
    expect(title.fontSize! * title.height!, closeTo(18, 0.01));
    expect(title.color, const Color(0xFF17171A));
    final description = style('Enter the description text');
    expect(description.fontSize, 12); // #217
    expect(description.fontSize! * description.height!, closeTo(18, 0.01));
    expect(description.color, const Color(0xFF676767));
    final badge = style('Success');
    expect(badge.fontWeight, FontWeight.w500); // #218
    expect(badge.color, const Color(0xFF1FAA63));
    expect(
      tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Success'),
                  matching: find.byType(Container),
                )
                .first,
          )
          .height,
      22,
    );
    final caret = tester.widget<Icon>(find.byIcon(Icons.chevron_right));
    expect(caret.size, 16); // #219
    expect(caret.color, const Color(0xFF898989));
    expect(
      tester.widget<Material>(cardMaterial()).borderRadius,
      BorderRadius.circular(16),
    ); // #220
  });
}
