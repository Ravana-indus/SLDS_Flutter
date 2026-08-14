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

  testWidgets('unchecked shows no icon', (tester) async {
    await pump(tester, SldsCheckbox(value: false, onChanged: (_) {}));
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('checked shows a check icon', (tester) async {
    await pump(tester, SldsCheckbox(value: true, onChanged: (_) {}));
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('indeterminate shows a dash, not a check', (tester) async {
    await pump(tester, SldsCheckbox(value: null, onChanged: (_) {}));
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('tapping unchecked calls onChanged(true)', (tester) async {
    bool? result;
    await pump(
      tester,
      SldsCheckbox(value: false, onChanged: (v) => result = v),
    );

    await tester.tap(find.byType(SldsCheckbox));
    expect(result, isTrue);
  });

  testWidgets('tapping checked calls onChanged(false)', (tester) async {
    bool? result;
    await pump(tester, SldsCheckbox(value: true, onChanged: (v) => result = v));

    await tester.tap(find.byType(SldsCheckbox));
    expect(result, isFalse);
  });

  testWidgets('disabled checkbox does not respond to taps', (tester) async {
    var called = false;
    await pump(
      tester,
      SldsCheckbox(
        value: false,
        enabled: false,
        onChanged: (_) => called = true,
      ),
    );

    await tester.tap(find.byType(SldsCheckbox));
    expect(called, isFalse);
  });

  testWidgets('null onChanged is treated as disabled', (tester) async {
    await pump(tester, const SldsCheckbox(value: false, onChanged: null));
    await tester.tap(find.byType(SldsCheckbox)); // must not throw
  });

  testWidgets('size controls box dimensions, defaulting to large (24x24)', (
    tester,
  ) async {
    await pump(tester, SldsCheckbox(value: false, onChanged: (_) {}));
    var box = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(SldsCheckbox),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(box.constraints?.maxWidth, 24);

    await pump(
      tester,
      SldsCheckbox(
        value: false,
        onChanged: (_) {},
        size: SldsCheckboxSize.small,
      ),
    );
    box = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(SldsCheckbox),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(box.constraints?.maxWidth, 20);
  });
}
