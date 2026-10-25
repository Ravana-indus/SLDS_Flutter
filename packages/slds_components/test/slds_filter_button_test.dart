import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: field),
    ),
  );

  testWidgets('renders the label and a chevron, no badge without a count', (
    tester,
  ) async {
    await pump(tester, const SldsFilterButton(label: 'Filter one'));
    expect(find.text('Filter one'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
  });

  testWidgets('a positive count shows a badge and flips to the active look', (
    tester,
  ) async {
    await pump(tester, const SldsFilterButton(label: 'Date posted', count: 3));

    expect(find.text('3'), findsOneWidget);
    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, SldsColorTokens.light().buttonPrimaryBackground);
  });

  testWidgets('count of 0 behaves like no count — no badge, inactive look', (
    tester,
  ) async {
    await pump(tester, const SldsFilterButton(label: 'Date posted', count: 0));

    expect(find.text('0'), findsNothing);
    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, SldsColorTokens.light().surfaceCard);
  });

  testWidgets('tapping invokes onTap', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsFilterButton(label: 'Filter one', onTap: () => tapped = true),
    );

    await tester.tap(find.byType(SldsFilterButton));
    expect(tapped, isTrue);
  });

  testWidgets('disabled does not respond to taps', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsFilterButton(
        label: 'Filter one',
        enabled: false,
        onTap: () => tapped = true,
      ),
    );

    await tester.tap(find.byType(SldsFilterButton));
    expect(tapped, isFalse);
  });

  testWidgets('null onTap is treated as non-interactive', (tester) async {
    await pump(tester, const SldsFilterButton(label: 'Filter one'));
    await tester.tap(find.byType(SldsFilterButton)); // must not throw
  });

  // Figma Filter Buttons Selected (1163:6044): the count is 14/400 #17171A
  // in a 20px white circle.
  testWidgets('count badge matches Figma (#150)', (tester) async {
    await pump(
      tester,
      SldsFilterButton(label: 'Date posted', count: 3, onTap: () {}),
    );

    final count = tester.widget<Text>(find.text('3')).style!;
    expect(count.fontSize, 14);
    expect(count.fontWeight, FontWeight.w400);
    expect(count.color, const Color(0xFF17171A));
    final badge = find
        .ancestor(of: find.text('3'), matching: find.byType(Container))
        .first;
    expect(tester.getSize(badge), const Size(20, 20));
  });

  // Sinhala at 2x text in a narrow slot: the label wraps inside the pill
  // and the count and caret stay inside it (#151).
  testWidgets('a long label wraps inside the pill at 2x text (#151)', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SldsTheme.light,
        localizationsDelegates: SldsLocalizations.localizationsDelegates,
        supportedLocales: SldsLocalizations.supportedLocales,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 260,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SldsFilterButton(
                    label: 'තැපැල් කළ දිනය',
                    count: 3,
                    onTap: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final pill = tester.getRect(find.byType(SldsFilterButton));
    for (final part in [
      find.text('3'),
      find.byIcon(Icons.keyboard_arrow_down),
      find.text('තැපැල් කළ දිනය'),
    ]) {
      final r = tester.getRect(part);
      expect(pill.left <= r.left && r.right <= pill.right, isTrue);
    }
    expect(
      tester.getRect(find.text('තැපැල් කළ දිනය')).right,
      lessThanOrEqualTo(tester.getRect(find.text('3')).left),
    );
  });

  // Figma Filter Buttons Deselected (1163:6043): 14/400/22 #17171A label;
  // Selected is 14/500 (#152).
  testWidgets('label typography matches Figma (#152)', (tester) async {
    await pump(tester, SldsFilterButton(label: 'Filter one', onTap: () {}));
    var style = tester.widget<Text>(find.text('Filter one')).style!;
    expect(style.fontSize, 14);
    expect(style.fontWeight, FontWeight.w400);
    expect(style.fontSize! * style.height!, closeTo(22, 0.01));
    expect(style.color, const Color(0xFF17171A));

    await pump(
      tester,
      SldsFilterButton(label: 'Date posted', count: 3, onTap: () {}),
    );
    style = tester.widget<Text>(find.text('Date posted')).style!;
    expect(style.fontSize, 14);
    expect(style.fontWeight, FontWeight.w500);
  });
}
