import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
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
    await pump(tester, SldsToggle(value: false, onChanged: (_) {}));
    var box = tester.widget<Container>(find.byType(Container).first);
    expect(box.constraints?.maxWidth, 48);
    expect(box.constraints?.maxHeight, 28);

    await pump(
      tester,
      SldsToggle(value: false, onChanged: (_) {}, size: SldsToggleSize.small),
    );
    box = tester.widget<Container>(find.byType(Container).first);
    expect(box.constraints?.maxWidth, 40);
    expect(box.constraints?.maxHeight, 24);
  });
}
