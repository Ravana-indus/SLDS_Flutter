// Reduced motion (§5, WCAG 2.3.3).
//
// A citizen who needs reduced motion has already switched it on before the
// app opens, so honouring it is one platform check rather than a feature.
// These assert the animation is actually skipped, not merely that the flag
// is readable.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

/// Pumps [child] with `MediaQuery.disableAnimations` set to [reduced].
Future<void> pumpWithMotion(
  WidgetTester tester,
  Widget child, {
  required bool reduced,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    ),
  );
}

void main() {
  group('motion tokens', () {
    test('collapse to zero when reduced motion is requested', () {
      const normal = SldsMotionTokens(reducedMotion: false);
      const reduced = SldsMotionTokens(reducedMotion: true);

      expect(normal.fast, isNot(Duration.zero));
      expect(normal.normal, isNot(Duration.zero));
      expect(reduced.fast, Duration.zero);
      expect(reduced.normal, Duration.zero);
    });
  });

  group('context.slds', () {
    testWidgets('reads disableAnimations from the ambient MediaQuery', (
      tester,
    ) async {
      late SldsTokenSet withMotion;
      late SldsTokenSet withoutMotion;

      await pumpWithMotion(
        tester,
        Builder(
          builder: (context) {
            withMotion = context.slds;
            return const SizedBox.shrink();
          },
        ),
        reduced: false,
      );
      await pumpWithMotion(
        tester,
        Builder(
          builder: (context) {
            withoutMotion = context.slds;
            return const SizedBox.shrink();
          },
        ),
        reduced: true,
      );

      expect(withMotion.motion.fast, isNot(Duration.zero));
      expect(withoutMotion.motion.fast, Duration.zero);
    });
  });

  group('widgets skip animation', () {
    // Each of these drives an AnimatedContainer from a token duration. With
    // reduced motion the container reaches its end state on the first frame,
    // so a single pump is enough to settle it.
    testWidgets('SldsToggle settles immediately', (tester) async {
      await pumpWithMotion(
        tester,
        SldsToggle(value: false, onChanged: (_) {}),
        reduced: true,
      );

      final animated = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      expect(animated.duration, Duration.zero);
    });

    testWidgets('SldsCheckbox settles immediately', (tester) async {
      await pumpWithMotion(
        tester,
        SldsCheckbox(value: false, onChanged: (_) {}),
        reduced: true,
      );

      final animated = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      expect(animated.duration, Duration.zero);
    });

    testWidgets('SldsRadio settles immediately', (tester) async {
      await pumpWithMotion(
        tester,
        SldsRadio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
        reduced: true,
      );

      final animated = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      expect(animated.duration, Duration.zero);
    });

    testWidgets('the same widgets do animate when motion is allowed', (
      tester,
    ) async {
      // The mirror case: without it, a widget that never animates at all
      // would pass the tests above.
      await pumpWithMotion(
        tester,
        SldsToggle(value: false, onChanged: (_) {}),
        reduced: false,
      );

      final animated = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      expect(animated.duration, isNot(Duration.zero));
    });
  });
}
