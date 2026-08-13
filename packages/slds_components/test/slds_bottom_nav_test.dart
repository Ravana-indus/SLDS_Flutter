import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const items = [
    SldsBottomNavItem(icon: Icons.home, label: 'Home'),
    SldsBottomNavItem(icon: Icons.search, label: 'Search'),
    SldsBottomNavItem(icon: Icons.notifications, label: 'Alerts', badgeCount: 2),
    SldsBottomNavItem(icon: Icons.person, label: 'Profile'),
  ];

  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(bottomNavigationBar: field)),
      );

  testWidgets('renders every item icon and label', (tester) async {
    await pump(
      tester,
      SldsBottomNav(items: items, currentIndex: 0, onTap: (_) {}),
    );

    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.notifications), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('shows a count badge only for items with badgeCount > 0', (
    tester,
  ) async {
    await pump(
      tester,
      SldsBottomNav(items: items, currentIndex: 0, onTap: (_) {}),
    );
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('badgeCount over 99 renders as "99+"', (tester) async {
    const overflowItems = [
      SldsBottomNavItem(icon: Icons.home, label: 'Home', badgeCount: 150),
    ];
    await pump(
      tester,
      SldsBottomNav(items: overflowItems, currentIndex: 0, onTap: (_) {}),
    );
    expect(find.text('99+'), findsOneWidget);
  });

  testWidgets('tapping an item invokes onTap with its index', (tester) async {
    int? tapped;
    await pump(
      tester,
      SldsBottomNav(items: items, currentIndex: 0, onTap: (i) => tapped = i),
    );

    await tester.tap(find.byIcon(Icons.search));
    expect(tapped, 1);
  });

  testWidgets('null onTap makes items non-interactive', (tester) async {
    await pump(tester, const SldsBottomNav(items: items, currentIndex: 0, onTap: null));
    await tester.tap(find.byIcon(Icons.home)); // must not throw
  });

  testWidgets('the selected item is marked selected for accessibility', (
    tester,
  ) async {
    await pump(
      tester,
      SldsBottomNav(items: items, currentIndex: 1, onTap: (_) {}),
    );

    final navItemSemantics = find.byWidgetPredicate(
      (w) => w is Semantics && w.properties.label == 'Search',
    );
    expect(
      tester.getSemantics(navItemSemantics),
      matchesSemantics(
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        isEnabled: true,
        hasEnabledState: true,
        label: 'Search',
      ),
    );
  });

  testWidgets('dark style renders a solid black background', (tester) async {
    await pump(
      tester,
      SldsBottomNav(
        items: items,
        currentIndex: 0,
        style: SldsBottomNavStyle.dark,
        onTap: (_) {},
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, Colors.black);
  });

  testWidgets('dark style: the selected label stays white, not black-on-black', (
    tester,
  ) async {
    await pump(
      tester,
      SldsBottomNav(
        items: items,
        currentIndex: 0, // "Home" is selected
        style: SldsBottomNavStyle.dark,
        onTap: (_) {},
      ),
    );

    final label = tester.widget<Text>(find.text('Home'));
    expect(label.style?.color, Colors.white);
  });

  testWidgets('light style (default) renders a surface background', (
    tester,
  ) async {
    await pump(
      tester,
      SldsBottomNav(items: items, currentIndex: 0, onTap: (_) {}),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, SldsColorTokens.light().surfaceCard);
  });

  testWidgets('light style: the selected item gets a solid gold pill, not a soft tint', (
    tester,
  ) async {
    await pump(
      tester,
      SldsBottomNav(items: items, currentIndex: 0, onTap: (_) {}),
    );

    final colors = tester
        .widgetList<Container>(find.byType(Container))
        .map((c) => c.decoration)
        .whereType<BoxDecoration>()
        .map((d) => d.color)
        .whereType<Color>();
    expect(colors, contains(SldsColorTokens.light().buttonPrimaryBackground));
  });

  testWidgets('a disabled item renders a white pill and a muted label', (
    tester,
  ) async {
    const withDisabled = [
      SldsBottomNavItem(icon: Icons.home, label: 'Home'),
      SldsBottomNavItem(icon: Icons.search, label: 'Search'),
      SldsBottomNavItem(icon: Icons.person, label: 'Profile', enabled: false),
    ];
    await pump(
      tester,
      SldsBottomNav(items: withDisabled, currentIndex: 0, onTap: (_) {}),
    );

    final label = tester.widget<Text>(find.text('Profile'));
    expect(label.style?.color, SldsColorTokens.light().disabledForeground);
  });

  testWidgets('a disabled item does not respond to taps', (tester) async {
    const withDisabled = [
      SldsBottomNavItem(icon: Icons.home, label: 'Home'),
      SldsBottomNavItem(icon: Icons.person, label: 'Profile', enabled: false),
    ];
    int? tapped;
    await pump(
      tester,
      SldsBottomNav(items: withDisabled, currentIndex: 0, onTap: (i) => tapped = i),
    );

    await tester.tap(find.byIcon(Icons.person));
    expect(tapped, isNull);
  });

  testWidgets('a disabled item is exposed as disabled for accessibility', (
    tester,
  ) async {
    const withDisabled = [
      SldsBottomNavItem(icon: Icons.home, label: 'Home'),
      SldsBottomNavItem(icon: Icons.person, label: 'Profile', enabled: false),
    ];
    await pump(
      tester,
      SldsBottomNav(items: withDisabled, currentIndex: 0, onTap: (_) {}),
    );

    final navItemSemantics = find.byWidgetPredicate(
      (w) => w is Semantics && w.properties.label == 'Profile',
    );
    expect(
      tester.getSemantics(navItemSemantics),
      matchesSemantics(
        isButton: true,
        isEnabled: false,
        hasEnabledState: true,
        hasSelectedState: true,
        label: 'Profile',
      ),
    );
  });
}
