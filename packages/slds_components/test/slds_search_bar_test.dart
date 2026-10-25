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

  testWidgets('shows the hint and a search icon, no clear button when empty', (
    tester,
  ) async {
    await pump(tester, const SldsSearchBar());

    expect(find.text('Search'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('typing shows the clear button and invokes onChanged', (
    tester,
  ) async {
    String? value;
    await pump(tester, SldsSearchBar(onChanged: (v) => value = v));

    await tester.enterText(find.byType(TextField), 'Driving Licen');
    await tester.pump();

    expect(value, 'Driving Licen');
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('tapping clear empties the field and fires onChanged("")', (
    tester,
  ) async {
    String? value;
    await pump(tester, SldsSearchBar(onChanged: (v) => value = v));

    await tester.enterText(find.byType(TextField), 'Driving License');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(value, '');
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, isEmpty);
  });

  testWidgets('panel is closed when unfocused even with suggestions set', (
    tester,
  ) async {
    await pump(tester, const SldsSearchBar(suggestions: ['Driving License']));
    expect(find.text('Driving License'), findsNothing);
  });

  testWidgets('focusing opens the panel and shows suggestions', (tester) async {
    await pump(
      tester,
      const SldsSearchBar(
        suggestions: ['Birth Certificate', 'Driving License'],
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(find.text('Birth Certificate'), findsOneWidget);
    expect(find.text('Driving License'), findsOneWidget);
  });

  testWidgets(
    'recent searches render under a heading with a history icon each',
    (tester) async {
      await pump(
        tester,
        const SldsSearchBar(
          recentSearches: ['National Identity Card', 'Birth Certificate'],
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();

      expect(find.text('RECENT SEARCHES'), findsOneWidget);
      expect(find.text('National Identity Card'), findsOneWidget);
      expect(find.text('Birth Certificate'), findsOneWidget);
      expect(find.byIcon(Icons.history), findsNWidgets(2));
    },
  );

  testWidgets(
    'tapping a suggestion fills the field and calls onSuggestionSelected',
    (tester) async {
      String? selected;
      await pump(
        tester,
        SldsSearchBar(
          suggestions: const ['Driving License'],
          onSuggestionSelected: (s) => selected = s,
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.tap(find.text('Driving License'));
      await tester.pump();

      expect(selected, 'Driving License');
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, 'Driving License');
    },
  );

  testWidgets('tapping a recent search also calls onSuggestionSelected', (
    tester,
  ) async {
    String? selected;
    await pump(
      tester,
      SldsSearchBar(
        recentSearches: const ['Birth Certificate'],
        onSuggestionSelected: (s) => selected = s,
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.tap(find.text('Birth Certificate'));
    await tester.pump();

    expect(selected, 'Birth Certificate');
  });

  testWidgets('disabled search bar disables the text field', (tester) async {
    await pump(tester, const SldsSearchBar(enabled: false));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enabled, isFalse);
  });

  // Figma Search Suggestion / Filled (#113): the matching row is filled
  // #EEEEEE with radius 8 and carries no check mark; rows are 38px, 4px
  // apart; recent rows lead with a 16px #17171A clock.
  testWidgets('the matching suggestion is highlighted, with no check mark '
      '(#113)', (tester) async {
    final controller = TextEditingController(text: 'Driving License');
    await pump(
      tester,
      SldsSearchBar(
        controller: controller,
        suggestions: const ['Birth Certificate', 'Driving License'],
        recentSearches: const ['National Identity Card'],
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(find.byIcon(Icons.check), findsNothing);
    Rect row(String text) => tester.getRect(
      find.ancestor(of: find.text(text).last, matching: find.byType(InkWell)),
    );
    expect(row('Birth Certificate').height, 38);
    expect(row('Driving License').top - row('Birth Certificate').bottom, 4);

    final fill =
        tester
                .widget<Ink>(
                  find.ancestor(
                    of: find.text('Driving License').last,
                    matching: find.byType(Ink),
                  ),
                )
                .decoration!
            as BoxDecoration;
    expect(fill.color, const Color(0xFFEEEEEE));
    expect(fill.borderRadius, BorderRadius.circular(8));

    final clock = tester.widget<Icon>(find.byIcon(Icons.history));
    expect(clock.size, 16);
    expect(clock.color, const Color(0xFF17171A));
    expect(
      tester.getRect(find.text('National Identity Card')).left -
          tester.getRect(find.byIcon(Icons.history)).right,
      8,
    );
  });

  testWidgets('recent-search rows never show a checkmark', (tester) async {
    final controller = TextEditingController(text: 'Birth Certificate');
    await pump(
      tester,
      SldsSearchBar(
        controller: controller,
        recentSearches: const ['Birth Certificate'],
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(find.byIcon(Icons.check), findsNothing);
  });

  // Figma Search Bar, Device=Web, State=Default (543:5292): 52px bar, 20px
  // magnifier, 8px gap, "Search" 14/18 #BCBCBC, all on one centre line.
  testWidgets('icon and hint line up as in Figma (#109)', (tester) async {
    await pump(tester, const SldsSearchBar());

    final bar = tester.getRect(find.byType(SldsSearchBar));
    final icon = tester.getRect(find.byIcon(Icons.search));
    final hint = tester.getRect(find.text('Search'));
    expect(bar.height, 52);
    expect(icon.size, const Size(20, 20));
    expect(hint.left - icon.right, 8);
    expect(hint.center.dy, icon.center.dy);
    expect(icon.center.dy, bar.center.dy);

    final style = tester
        .widget<TextField>(find.byType(TextField))
        .decoration!
        .hintStyle!;
    expect(style.fontSize, 14);
    expect(style.fontSize! * style.height!, closeTo(18, 0.01));
    expect(style.color, const Color(0xFFBCBCBC));
  });

  // Figma Search Bar fill is Surface/Page #F7F7F7 (#110); typed text is
  // 14px/400 #17171A (#111).
  testWidgets('surface and typed text match Figma (#110, #111)', (
    tester,
  ) async {
    await pump(tester, const SldsSearchBar());

    final bar = tester
        .widgetList<Container>(
          find.descendant(
            of: find.byType(SldsSearchBar),
            matching: find.byType(Container),
          ),
        )
        .map((c) => c.decoration)
        .whereType<BoxDecoration>()
        .first;
    expect(bar.color, const Color(0xFFF7F7F7));

    final style = tester.widget<TextField>(find.byType(TextField)).style!;
    expect(style.fontSize, 14);
    expect(style.fontWeight, FontWeight.w400);
    expect(style.color, const Color(0xFF17171A));
  });

  // Figma Mobile Default shows a microphone while idle and empty (#112);
  // Typing and Filled swap the magnifier for a back arrow (#113).
  testWidgets('mic while idle, back arrow while searching (#112, #113)', (
    tester,
  ) async {
    var voice = 0;
    final changes = <String>[];
    await pump(
      tester,
      SldsSearchBar(onVoiceSearch: () => voice++, onChanged: changes.add),
    );

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    final mic = tester.widget<Icon>(find.byIcon(Icons.mic_none));
    expect(mic.size, 20);
    expect(mic.color, const Color(0xFF898989));
    expect(find.bySemanticsLabel('Voice search'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.mic_none));
    expect(voice, 1);

    // Typing: back arrow, no mic.
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.search), findsNothing);
    expect(find.byIcon(Icons.mic_none), findsNothing);

    // Filled, then back: the query empties and the bar returns to default.
    await tester.enterText(find.byType(TextField), 'Driving');
    await tester.pump();
    expect(find.bySemanticsLabel('Back'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    expect(changes.last, '');
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.mic_none), findsOneWidget);
  });

  testWidgets('no mic without onVoiceSearch', (tester) async {
    await pump(tester, const SldsSearchBar());
    expect(find.byIcon(Icons.mic_none), findsNothing);
  });
}
