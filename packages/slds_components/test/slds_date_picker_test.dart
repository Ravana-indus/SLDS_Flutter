import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget widget) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: Center(child: widget)),
    ),
  );

  testWidgets(
    'renders month navigator, year picker, weekdays, and action buttons',
    (tester) async {
      await pump(tester, SldsDatePicker(initialDate: DateTime(2026, 1, 15)));

      expect(find.text('January'), findsOneWidget);
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('Mo'), findsOneWidget);
      expect(find.text('Tu'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);
    },
  );

  testWidgets('month navigator chevrons update displayed month', (
    tester,
  ) async {
    await pump(tester, SldsDatePicker(initialDate: DateTime(2026, 1, 15)));

    expect(find.text('January'), findsOneWidget);

    // Tap next month chevron
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    expect(find.text('February'), findsOneWidget);

    // Tap previous month chevron
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();

    expect(find.text('January'), findsOneWidget);
  });

  testWidgets('range mode allows selecting start date and end date', (
    tester,
  ) async {
    DateTimeRange? selectedRange;
    await pump(
      tester,
      SldsDatePicker(
        initialRange: DateTimeRange(
          start: DateTime(2026, 1, 10),
          end: DateTime(2026, 1, 20),
        ),
        onRangeSelected: (range) => selectedRange = range,
      ),
    );

    // Tap 12th day
    await tester.tap(find.text('12'));
    await tester.pumpAndSettle();

    // Tap 15th day
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    expect(selectedRange, isNotNull);
    expect(selectedRange?.start.day, equals(12));
    expect(selectedRange?.end.day, equals(15));
  });

  testWidgets('tapping Cancel and Apply triggers callbacks', (tester) async {
    var canceled = false;
    dynamic appliedResult;

    await pump(
      tester,
      SldsDatePicker(
        mode: SldsDatePickerMode.single,
        initialDate: DateTime(2026, 1, 15),
        onCancel: () => canceled = true,
        onApply: (res) => appliedResult = res,
      ),
    );

    await tester.tap(find.text('Cancel'));
    expect(canceled, isTrue);

    await tester.tap(find.text('Apply'));
    expect(appliedResult, isNotNull);
  });

  // Figma Month and Year (1090:7421): month and year pills are both 36px.
  testWidgets('month and year pills are both 36px tall (#123)', (
    tester,
  ) async {
    await pump(tester, SldsDatePicker(initialDate: DateTime(2026, 1, 15)));

    // The pill is the bordered Container around each label.
    double pillHeight(String text) {
      final pill = find
          .ancestor(of: find.text(text), matching: find.byType(Container))
          .evaluate()
          .firstWhere((e) {
            final d = (e.widget as Container).decoration;
            return d is BoxDecoration && d.border != null;
          });
      return pill.size!.height;
    }

    expect(pillHeight('January'), 36);
    expect(pillHeight('2026'), 36);
  });

  // Figma Date Pickers (1091:8107): month, year, weekday and date text are
  // 14/400 #17171A; Cancel is a white Small Secondary and Apply a Small
  // Primary, both labelled 14/400 #17171A; the range band is #FFF8D6.
  testWidgets('typography and colours match Figma (#124-#130)', (
    tester,
  ) async {
    await pump(
      tester,
      SldsDatePicker(initialDate: DateTime(2026, 1, 15), onCancel: () {}),
    );

    const ink = Color(0xFF17171A);
    TextStyle style(String text) =>
        tester.widget<Text>(find.text(text).first).style!;

    for (final text in ['January', '2026', 'Mo', '20']) {
      expect(style(text).fontSize, 14, reason: text);
      expect(style(text).fontWeight, FontWeight.w400, reason: text);
      expect(style(text).color, ink, reason: text);
    }

    for (final label in ['Cancel', 'Apply']) {
      final painted = tester
          .renderObject<RenderParagraph>(
            find
                .descendant(
                  of: find.text(label),
                  matching: find.byType(RichText),
                )
                .first,
          )
          .text
          .style!;
      expect(painted.fontSize, 14, reason: label);
      expect(painted.fontWeight, FontWeight.w400, reason: label);
      expect(painted.color, ink, reason: label);
    }
    final cancel = tester
        .widget<OutlinedButton>(find.byType(OutlinedButton))
        .style!
        .backgroundColor!
        .resolve({});
    expect(cancel, const Color(0xFFFFFFFF));

    expect(
      SldsColorTokens.light().datePickerRangeHighlight,
      const Color(0xFFFFF8D6),
    );
  });
}
