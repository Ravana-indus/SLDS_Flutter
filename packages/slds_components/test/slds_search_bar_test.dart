import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
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

  testWidgets('the suggestion matching the current query shows a checkmark', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'Driving License');
    await pump(
      tester,
      SldsSearchBar(
        controller: controller,
        suggestions: const ['Birth Certificate', 'Driving License'],
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(find.byIcon(Icons.check), findsOneWidget);
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
}
