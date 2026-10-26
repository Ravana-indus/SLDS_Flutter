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

  testWidgets('renders the title, back chevron, and menu icon', (tester) async {
    await pump(
      tester,
      SldsTopNavBar(title: 'Page Title', onBack: () {}, onMenu: () {}),
    );

    expect(find.text('Page Title'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });

  testWidgets('tapping back invokes onBack', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsTopNavBar(title: 'Page Title', onBack: () => tapped = true),
    );

    await tester.tap(find.byIcon(Icons.chevron_left));
    expect(tapped, isTrue);
  });

  testWidgets('tapping menu invokes onMenu', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsTopNavBar(title: 'Page Title', onMenu: () => tapped = true),
    );

    await tester.tap(find.byIcon(Icons.menu));
    expect(tapped, isTrue);
  });

  testWidgets('onBack null hides the back icon entirely', (tester) async {
    await pump(tester, const SldsTopNavBar(title: 'Page Title'));
    expect(find.byIcon(Icons.chevron_left), findsNothing);
  });

  testWidgets('onMenu null hides the menu icon entirely', (tester) async {
    await pump(tester, const SldsTopNavBar(title: 'Page Title'));
    expect(find.byIcon(Icons.menu), findsNothing);
  });

  testWidgets('.progress renders totalSteps segments instead of a title', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsTopNavBar.progress(totalSteps: 6, currentStep: 3),
    );

    expect(find.text('Page Title'), findsNothing);
    final containers = tester.widgetList<Container>(
      find.descendant(
        of: find.byType(Row).last,
        matching: find.byType(Container),
      ),
    );
    expect(containers.length, greaterThanOrEqualTo(6));
  });

  testWidgets(
    '.progress: segments before currentStep are filled with the accent',
    (tester) async {
      await pump(
        tester,
        const SldsTopNavBar.progress(totalSteps: 4, currentStep: 2),
      );

      final segments = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(Row).last,
              matching: find.byType(Container),
            ),
          )
          .where((c) => c.decoration is BoxDecoration)
          .toList();

      final theme = SldsColorTokens.light();
      final filled = segments.where(
        (c) =>
            (c.decoration! as BoxDecoration).color ==
            theme.buttonPrimaryBackground,
      );
      expect(filled.length, 2);
    },
  );

  testWidgets('dark style renders Figma Tab Bar/Background #010102', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsTopNavBar(title: 'Page Title', style: SldsTopNavBarStyle.dark),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    expect(container.color, const Color(0xFF010102));
  });

  testWidgets('light style (default) renders a surface background', (
    tester,
  ) async {
    await pump(tester, const SldsTopNavBar(title: 'Page Title'));

    final container = tester.widget<Container>(find.byType(Container).first);
    expect(container.color, SldsColorTokens.light().surfacePage);
  });

  // Figma Top Navigation Bar (346:3816).
  testWidgets('bar, title and icons match Figma (#181-#186)', (tester) async {
    Future<void> show(Widget bar, {ThemeData? theme}) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme ?? SldsTheme.light,
          localizationsDelegates: SldsLocalizations.localizationsDelegates,
          supportedLocales: SldsLocalizations.supportedLocales,
          // A status-bar inset, as Widgetbook's device frames have.
          home: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.only(top: 47)),
            child: Scaffold(body: Center(child: bar)),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Color background() => tester
        .widget<Container>(
          find
              .descendant(
                of: find.byType(SldsTopNavBar),
                matching: find.byType(Container),
              )
              .first,
        )
        .color!;

    await show(
      SldsTopNavBar(title: 'Page Title', onBack: () {}, onMenu: () {}),
    );
    final bar = tester.getRect(find.byType(SldsTopNavBar));
    final title = tester.getRect(find.text('Page Title'));
    // #181: a 64px bar with the title centred in it, 60px in.
    expect(bar.height, 64);
    expect(title.center.dy, closeTo(bar.center.dy, 0.01));
    expect(title.left - bar.left, 8 + 48 + 4);
    final style = tester.widget<Text>(find.text('Page Title')).style!;
    expect(style.fontSize, 18);
    expect(style.fontWeight, FontWeight.w500);
    expect(style.color, const Color(0xFF17171A));
    // #182: back and menu icons #17171A.
    for (final icon in [Icons.chevron_left, Icons.menu]) {
      expect(
        tester.widget<Icon>(find.byIcon(icon)).color,
        const Color(0xFF17171A),
      );
    }
    // #183: #F7F7F7 background.
    expect(background(), const Color(0xFFF7F7F7));

    // #185, #186: progress keeps #17171A icons; pending steps #FFFFFF.
    await show(
      SldsTopNavBar.progress(
        totalSteps: 6,
        currentStep: 3,
        onBack: () {},
        onMenu: () {},
      ),
    );
    for (final icon in [Icons.chevron_left, Icons.menu]) {
      expect(
        tester.widget<Icon>(find.byIcon(icon)).color,
        const Color(0xFF17171A),
      );
    }
    final steps = tester
        .widgetList<Container>(
          find.descendant(
            of: find.byType(SldsTopNavBar),
            matching: find.byType(Container),
          ),
        )
        .map((c) => c.decoration)
        .whereType<BoxDecoration>()
        .map((d) => d.color)
        .toList();
    expect(steps.where((c) => c == const Color(0xFFFFC700)), hasLength(3));
    expect(steps.where((c) => c == const Color(0xFFFFFFFF)), hasLength(3));

    // #184: dark mode #010102.
    await show(
      SldsTopNavBar(title: 'Page Title', onBack: () {}, onMenu: () {}),
      theme: SldsTheme.dark,
    );
    expect(background(), const Color(0xFF010102));
  });
}
