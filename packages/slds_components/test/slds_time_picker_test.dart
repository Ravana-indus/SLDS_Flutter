import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget widget) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      home: Scaffold(body: Center(child: widget)),
    ),
  );

  testWidgets(
    'renders title, digital hour/minute boxes, AM/PM, and action buttons',
    (tester) async {
      await pump(
        tester,
        const SldsTimePickerDialog(),
      );

      expect(find.text('Set Your Time'), findsOneWidget);
      expect(find.text('07'), findsOneWidget);
      expect(find.text('00'), findsOneWidget);
      expect(find.text('AM'), findsOneWidget);
      expect(find.text('PM'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);
    },
  );

  testWidgets('toggling AM/PM updates period', (tester) async {
    TimeOfDay? changedTime;
    await pump(
      tester,
      SldsTimePickerDialog(
        onTimeChanged: (t) => changedTime = t,
      ),
    );

    await tester.tap(find.text('PM'));
    await tester.pumpAndSettle();

    expect(changedTime?.hour, equals(19));
  });

  testWidgets('tapping Cancel and Apply triggers callbacks', (tester) async {
    var canceled = false;
    TimeOfDay? appliedTime;

    await pump(
      tester,
      SldsTimePickerDialog(
        initialTime: const TimeOfDay(hour: 7, minute: 30),
        onCancel: () => canceled = true,
        onApply: (t) => appliedTime = t,
      ),
    );

    await tester.tap(find.text('Cancel'));
    expect(canceled, isTrue);

    await tester.tap(find.text('Apply'));
    expect(appliedTime?.hour, equals(7));
    expect(appliedTime?.minute, equals(30));
  });

  testWidgets('SldsTimePicker renders as text field and opens dialog', (
    tester,
  ) async {
    TimeOfDay? changedTime;
    await pump(
      tester,
      SldsTimePicker(
        label: 'Select Time',
        initialTime: const TimeOfDay(hour: 7, minute: 30),
        onTimeChanged: (t) => changedTime = t,
      ),
    );

    // Initial value
    expect(find.text('Select Time'), findsOneWidget);
    expect(find.text('7:30 AM'), findsOneWidget);

    // Tap to open
    await tester.tap(find.byType(SldsTimePicker));
    await tester.pumpAndSettle();

    expect(find.byType(SldsTimePickerDialog), findsOneWidget);

    // Tap PM before applying so the value changes
    await tester.tap(find.text('PM'));
    await tester.pumpAndSettle();

    // Tap apply
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(find.byType(SldsTimePickerDialog), findsNothing);
    expect(changedTime, isNotNull);
  });
}
