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

  testWidgets('size controls track dimensions, defaulting to large (50x28)', (
    tester,
  ) async {
    // The track is the outer AnimatedContainer; the inner one is the thumb.
    final track = find.byType(AnimatedContainer).first;
    await pump(tester, SldsToggle(value: false, onChanged: (_) {}));
    expect(tester.getSize(track), const Size(50, 28)); // Figma (#158).

    await pump(
      tester,
      SldsToggle(value: false, onChanged: (_) {}, size: SldsToggleSize.small),
    );
    expect(tester.getSize(track), const Size(40, 24));
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

  // Figma Toggle (543:6036): 50x28 track, 22px thumb 4px from the ends;
  // off #DDDDDD, on #FFC700, thumb #F7F7F7; disabled thumb #BCBCBC
  // (#158-#160).
  testWidgets('size and colours match Figma (#158-#160)', (tester) async {
    List<BoxDecoration> layers() => tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .map((c) => c.decoration! as BoxDecoration)
        .toList();

    await pump(tester, SldsToggle(value: false, onChanged: (_) {}));
    final track = find.byType(AnimatedContainer).first;
    final thumb = find.byType(AnimatedContainer).last;
    expect(tester.getSize(track), const Size(50, 28));
    expect(tester.getSize(thumb), const Size(22, 22));
    expect(tester.getTopLeft(thumb).dx - tester.getTopLeft(track).dx, 4);
    expect(layers()[0].color, const Color(0xFFDDDDDD));
    expect(layers()[1].color, const Color(0xFFF7F7F7));

    await pump(tester, SldsToggle(value: true, onChanged: (_) {}));
    await tester.pumpAndSettle();
    expect(layers()[0].color, const Color(0xFFFFC700));
    expect(layers()[1].color, const Color(0xFFF7F7F7));
    expect(
      tester.getTopRight(track).dx - tester.getTopRight(thumb).dx,
      4,
    );

    await pump(tester, const SldsToggle(value: false, onChanged: null));
    await tester.pumpAndSettle();
    expect(layers()[0].color, const Color(0xFFDDDDDD));
    expect(layers()[1].color, const Color(0xFFBCBCBC));
  });

  // Figma Default/Checked - Focus: the shared Focus/Default gold ring round
  // the track, which keeps its 50x28 size (#163).
  testWidgets('focus draws the Focus/Default ring round the track (#163)', (
    tester,
  ) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    await pump(
      tester,
      SldsToggle(value: false, onChanged: (_) {}, focusNode: node),
    );
    DecoratedBox ring() => tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(SldsFocusRing),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect((ring().decoration as BoxDecoration).boxShadow, isNull);

    node.requestFocus();
    await tester.pumpAndSettle();
    expect((ring().decoration as BoxDecoration).boxShadow, isNotEmpty);
    expect(
      tester.getSize(find.byType(AnimatedContainer).first),
      const Size(50, 28),
    );
  });
}
