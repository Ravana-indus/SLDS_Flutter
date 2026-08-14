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

  testWidgets('renders a Slider with the given value/min/max', (tester) async {
    await pump(
      tester,
      SldsRangeSlider(value: 40, min: 0, max: 100, onChanged: (_) {}),
    );

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.value, 40);
    expect(slider.min, 0);
    expect(slider.max, 100);
  });

  testWidgets('dragging the thumb invokes onChanged', (tester) async {
    double? result;
    await pump(
      tester,
      SldsRangeSlider(value: 0, min: 0, max: 100, onChanged: (v) => result = v),
    );

    await tester.tap(find.byType(Slider));
    await tester.pump();

    expect(result, isNotNull);
  });

  testWidgets('enabled=false disables the underlying Slider', (tester) async {
    await pump(
      tester,
      const SldsRangeSlider(value: 40, enabled: false, onChanged: null),
    );

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.onChanged, isNull);
  });

  testWidgets('null onChanged is treated as disabled even if enabled=true', (
    tester,
  ) async {
    await pump(tester, const SldsRangeSlider(value: 40, onChanged: null));

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.onChanged, isNull);
  });

  testWidgets('disabled tap does not invoke onChanged', (tester) async {
    var called = false;
    await pump(
      tester,
      SldsRangeSlider(
        value: 0,
        enabled: false,
        onChanged: (_) => called = true,
      ),
    );

    await tester.tap(find.byType(Slider));
    await tester.pump();

    expect(called, isFalse);
  });

  testWidgets('divisions is forwarded to the underlying Slider', (
    tester,
  ) async {
    await pump(
      tester,
      SldsRangeSlider(value: 40, divisions: 4, onChanged: (_) {}),
    );

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.divisions, 4);
  });

  testWidgets('value is clamped into [min, max]', (tester) async {
    await pump(
      tester,
      SldsRangeSlider(value: 150, min: 0, max: 100, onChanged: (_) {}),
    );

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.value, 100);
  });

  testWidgets('fills the available width of its parent', (tester) async {
    await pump(
      tester,
      SizedBox(
        width: 250,
        child: SldsRangeSlider(value: 40, onChanged: (_) {}),
      ),
    );

    final sliderSize = tester.getSize(find.byType(Slider));
    expect(sliderSize.width, 250);
  });
}
