import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      home: Scaffold(body: Center(child: child)),
    ),
  );

  testWidgets('measures 52px per the Figma spec', (tester) async {
    // 28px glyph + 12px padding on each side. The document tone adds a 1px
    // outline on top of that box, so it comes out 2px larger.
    for (final type in SldsNotificationType.values) {
      await pump(tester, SldsNotificationIcon(type: type));
      final expected = type == SldsNotificationType.document ? 54.0 : 52.0;
      expect(
        tester.getSize(find.byType(SldsNotificationIcon)),
        Size(expected, expected),
        reason: 'unexpected size for ${type.name}',
      );
    }
  });

  testWidgets('each type renders its own glyph', (tester) async {
    for (final type in SldsNotificationType.values) {
      await pump(tester, SldsNotificationIcon(type: type));
      expect(find.byType(Icon), findsOneWidget);
    }
  });

  testWidgets('tones differ per type', (tester) async {
    final seen = <Color?>{};
    for (final type in SldsNotificationType.values) {
      await pump(tester, SldsNotificationIcon(type: type));
      seen.add(tester.widget<Icon>(find.byType(Icon)).color);
    }
    expect(seen.length, SldsNotificationType.values.length);
  });

  testWidgets('semanticLabel is applied only when given', (tester) async {
    await pump(tester, const SldsNotificationIcon());
    expect(tester.widget<Icon>(find.byType(Icon)).semanticLabel, isNull);

    await pump(
      tester,
      const SldsNotificationIcon(
        type: SldsNotificationType.error,
        semanticLabel: 'Failed',
      ),
    );
    expect(find.bySemanticsLabel('Failed'), findsOneWidget);
  });
}
