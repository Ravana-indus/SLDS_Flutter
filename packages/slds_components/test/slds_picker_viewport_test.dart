import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

/// Both pickers are fixed-height columns — the time picker's 210px dial and
/// the date picker's 6-week grid put each at roughly 500px tall. On a
/// viewport shorter than that the RenderFlex overflowed and threw, which is
/// what a Widgetbook landscape/desktop preset (or a landscape phone) hits.
/// The content cannot shrink to fit without making the dial and the day
/// cells too small to tap, so both scroll instead.
///
/// These sizes are short-and-wide on purpose: the default test surface is
/// 800x600, which is tall enough to hide the bug entirely.
void main() {
  const shortViewports = [
    Size(800, 400),
    Size(1024, 380),
    Size(1280, 320),
    Size(640, 360),
  ];

  Widget host(Widget child) => MaterialApp(
    localizationsDelegates: SldsLocalizations.localizationsDelegates,
    supportedLocales: SldsLocalizations.supportedLocales,
    theme: SldsTheme.light,
    home: Scaffold(body: Center(child: child)),
  );

  for (final size in shortViewports) {
    testWidgets('SldsTimePicker dialog does not overflow at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const SldsTimePicker(label: 'Time')));
      await tester.tap(find.byType(SldsTimePicker));
      await tester.pumpAndSettle();

      expect(find.byType(SldsTimePickerDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('SldsDatePicker does not overflow at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const SldsDatePicker()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  }
}
