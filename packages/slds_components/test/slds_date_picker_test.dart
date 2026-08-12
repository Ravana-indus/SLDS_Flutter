import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget widget) => tester.pumpWidget(
        MaterialApp(
          theme: SldsTheme.light(),
          home: Scaffold(body: Center(child: widget)),
        ),
      );

  testWidgets('renders month navigator, year picker, weekdays, and action buttons', (tester) async {
    await pump(
      tester,
      SldsDatePicker(
        initialDate: DateTime(2026, 1, 15),
      ),
    );

    expect(find.text('January'), findsOneWidget);
    expect(find.text('2026'), findsOneWidget);
    expect(find.text('Mo'), findsOneWidget);
    expect(find.text('Tu'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Apply'), findsOneWidget);
  });

  testWidgets('month navigator chevrons update displayed month', (tester) async {
    await pump(
      tester,
      SldsDatePicker(
        initialDate: DateTime(2026, 1, 15),
      ),
    );

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

  testWidgets('range mode allows selecting start date and end date', (tester) async {
    DateTimeRange? selectedRange;
    await pump(
      tester,
      SldsDatePicker(
        mode: SldsDatePickerMode.range,
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
}
