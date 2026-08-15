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

  testWidgets('tapping off calls onChanged(true)', (tester) async {
    bool? result;
    await pump(tester, SldsToggle(value: false, onChanged: (v) => result = v));

    await tester.tap(find.byType(SldsToggle));
    expect(result, isTrue);
  });

  testWidgets('tapping on calls onChanged(false)', (tester) async {
    bool? result;
    await pump(tester, SldsToggle(value: true, onChanged: (v) => result = v));

    await tester.tap(find.byType(SldsToggle));
    expect(result, isFalse);
  });

  testWidgets('disabled toggle does not respond to taps', (tester) async {
    var called = false;
    await pump(
      tester,
      SldsToggle(value: false, enabled: false, onChanged: (_) => called = true),
    );

    await tester.tap(find.byType(SldsToggle));
    expect(called, isFalse);
  });

  testWidgets('null onChanged is treated as disabled', (tester) async {
    await pump(tester, const SldsToggle(value: false, onChanged: null));
    await tester.tap(find.byType(SldsToggle)); // must not throw
  });

  testWidgets('size controls track dimensions, defaulting to large (48x28)', (
    tester,
  ) async {
    // `.at(1)` is the track: the outermost Container is the tap-target
    // wrapper, which is deliberately larger than the switch it centres.
    await pump(tester, SldsToggle(value: false, onChanged: (_) {}));
    var box = tester.widget<Container>(find.byType(Container).at(1));
    expect(box.constraints?.maxWidth, 48);
    expect(box.constraints?.maxHeight, 28);

    await pump(
      tester,
      SldsToggle(value: false, onChanged: (_) {}, size: SldsToggleSize.small),
    );
    box = tester.widget<Container>(find.byType(Container).at(1));
    expect(box.constraints?.maxWidth, 40);
    expect(box.constraints?.maxHeight, 24);
  });

  testWidgets('tap target clears 48x48 at every size', (tester) async {
    // The track is 28px (large) and 24px (small) tall by design, so without
    // the wrapper both would fall short of the WCAG 2.5.5 / SLDS floor.
    for (final size in SldsToggleSize.values) {
      await pump(
        tester,
        SldsToggle(value: false, onChanged: (_) {}, size: size),
      );

      final rendered = tester.getSize(find.byType(SldsToggle));
      expect(
        rendered.width,
        greaterThanOrEqualTo(SldsDimensionTokens.standard.tapTargetMin),
        reason: '$size is too narrow to tap',
      );
      expect(
        rendered.height,
        greaterThanOrEqualTo(SldsDimensionTokens.standard.tapTargetMin),
        reason: '$size is too short to tap',
      );
    }
  });
}
