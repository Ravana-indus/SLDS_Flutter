import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget button) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      home: Scaffold(body: button),
    ),
  );

  testWidgets('primary and destructive variants render as filled buttons', (
    tester,
  ) async {
    await pump(tester, SldsButton(label: 'Continue', onPressed: () {}));
    expect(find.byType(FilledButton), findsOneWidget);

    await pump(
      tester,
      SldsButton(
        label: 'Delete',
        variant: SldsButtonVariant.destructive,
        onPressed: () {},
      ),
    );
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('secondary and tertiary variants render as outlined buttons', (
    tester,
  ) async {
    await pump(
      tester,
      SldsButton(
        label: 'Continue',
        variant: SldsButtonVariant.secondary,
        onPressed: () {},
      ),
    );
    expect(find.byType(OutlinedButton), findsOneWidget);
  });

  testWidgets('text variant renders as a text button', (tester) async {
    await pump(
      tester,
      SldsButton(
        label: 'Continue',
        variant: SldsButtonVariant.text,
        onPressed: () {},
      ),
    );
    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets('loading state shows a spinner and blocks taps', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsButton(
        label: 'Continue',
        isLoading: true,
        onPressed: () => tapped = true,
      ),
    );

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    expect(find.text('Continue'), findsNothing);

    await tester.tap(find.byType(FilledButton), warnIfMissed: false);
    expect(tapped, isFalse);
  });

  testWidgets('null onPressed disables the button', (tester) async {
    await pump(tester, const SldsButton(label: 'Continue', onPressed: null));
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.enabled, isFalse);
  });

  testWidgets('picks up SldsTheme.dark colors from the ambient Theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SldsTheme.dark,
        localizationsDelegates: SldsLocalizations.localizationsDelegates,
        supportedLocales: SldsLocalizations.supportedLocales,
        home: Scaffold(
          body: SldsButton(label: 'Continue', onPressed: () {}),
        ),
      ),
    );

    final context = tester.element(find.byType(SldsButton));
    final scheme = Theme.of(context).colorScheme;
    final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;
    final resolvedBackground = style.backgroundColor!.resolve({});

    expect(resolvedBackground, scheme.primary);
    // The gold accent is deliberately the same in every palette; what the
    // dark theme changes is the label that sits on it.
    expect(resolvedBackground, SldsColorTokens.dark().buttonPrimaryBackground);
    expect(
      style.foregroundColor!.resolve({}),
      SldsColorTokens.dark().buttonPrimaryLabel,
    );
    expect(
      SldsColorTokens.dark().buttonPrimaryLabel,
      isNot(SldsColorTokens.light().buttonPrimaryLabel),
    );
  });

  for (final variant in [
    SldsButtonVariant.secondary,
    SldsButtonVariant.tertiary,
  ]) {
    testWidgets('$variant resting background comes from its token', (
      tester,
    ) async {
      await pump(
        tester,
        SldsButton(label: 'Continue', variant: variant, onPressed: () {}),
      );
      final style = tester
          .widget<OutlinedButton>(find.byType(OutlinedButton))
          .style!;
      // Tertiary is a ghost variant — transparent at rest. Secondary carries
      // its own designed fill rather than borrowing a surface tone.
      expect(
        style.backgroundColor!.resolve({}),
        variant == SldsButtonVariant.tertiary
            ? isNull
            : SldsColorTokens.light().buttonSecondaryBackground,
      );
    });

    testWidgets('$variant resolves against the dark palette in dark mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SldsTheme.dark,
          localizationsDelegates: SldsLocalizations.localizationsDelegates,
          supportedLocales: SldsLocalizations.supportedLocales,
          home: Scaffold(
            body: SldsButton(
              label: 'Continue',
              variant: variant,
              onPressed: () {},
            ),
          ),
        ),
      );
      final style = tester
          .widget<OutlinedButton>(find.byType(OutlinedButton))
          .style!;
      expect(
        style.foregroundColor!.resolve({}),
        variant == SldsButtonVariant.tertiary
            ? SldsColorTokens.dark().buttonGhostLabel
            : SldsColorTokens.dark().buttonSecondaryLabel,
      );
    });
  }

  testWidgets('background resolves from the variant token, not a literal', (
    tester,
  ) async {
    await pump(tester, SldsButton(label: 'Continue', onPressed: () {}));

    final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;
    expect(
      style.backgroundColor!.resolve({}),
      SldsColorTokens.light().buttonPrimaryBackground,
    );
  });

  testWidgets('destructive variant reads the destructive token', (
    tester,
  ) async {
    await pump(
      tester,
      SldsButton(
        label: 'Delete',
        onPressed: () {},
        variant: SldsButtonVariant.destructive,
      ),
    );

    final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;
    expect(
      style.backgroundColor!.resolve({}),
      SldsColorTokens.light().buttonDestructiveBackground,
    );
  });

  Future<void> setViewSize(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('is full-width below the mobile breakpoint', (tester) async {
    await setViewSize(tester, const Size(360, 800));

    await pump(tester, SldsButton(label: 'Continue', onPressed: () {}));

    final size = tester.getSize(find.byType(SldsButton));
    expect(size.width, 360);
    expect(size.height, SldsDimensionTokens.standard.buttonHeightExtraLarge);
  });

  testWidgets('is intrinsic-width at/above the mobile breakpoint', (
    tester,
  ) async {
    await setViewSize(tester, const Size(1024, 800));

    await pump(tester, SldsButton(label: 'Continue', onPressed: () {}));

    final size = tester.getSize(find.byType(SldsButton));
    expect(size.width, lessThan(1024));
    expect(size.height, SldsDimensionTokens.standard.buttonHeightLarge);
  });

  testWidgets('clears the 48px minimum touch target at every breakpoint', (
    tester,
  ) async {
    // WCAG 2.5.5 / the SLDS 48px floor. The button previously shrink-wrapped
    // to 44px on desktop, defeating Material's own minimum.
    for (final viewport in [const Size(360, 800), const Size(1024, 800)]) {
      await setViewSize(tester, viewport);
      await pump(tester, SldsButton(label: 'Continue', onPressed: () {}));

      final size = tester.getSize(find.byType(SldsButton));
      expect(
        size.height,
        greaterThanOrEqualTo(SldsDimensionTokens.standard.tapTargetMin),
        reason: 'button too short to tap at ${viewport.width}px wide',
      );
    }
  });

  testWidgets(
    'a long label ellipsizes instead of overflowing on a narrow phone',
    (tester) async {
      await setViewSize(
        tester,
        const Size(320, 640),
      ); // iPhone SE (1st gen) width

      await pump(
        tester,
        SldsButton(
          label: 'Continue to the next step of the application process',
          trailingIcon: Icons.chevron_right,
          onPressed: () {},
        ),
      );

      expect(tester.takeException(), isNull); // no RenderFlex overflow error
      final text = tester.widget<Text>(
        find.text('Continue to the next step of the application process'),
      );
      expect(text.overflow, TextOverflow.ellipsis);
    },
  );

  testWidgets('does not crash inside a Row on mobile (unbounded width)', (
    tester,
  ) async {
    // Regression: the mobile full-width minimumSize/SizedBox used to force
    // `double.infinity` unconditionally, which crashes when the parent
    // gives unbounded width — e.g. a Cancel/Apply footer Row.
    await setViewSize(tester, const Size(360, 800));

    await pump(
      tester,
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SldsButton(
            label: 'Cancel',
            onPressed: () {},
            variant: SldsButtonVariant.text,
          ),
          const SizedBox(width: 8),
          SldsButton(label: 'Apply', onPressed: () {}),
        ],
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
