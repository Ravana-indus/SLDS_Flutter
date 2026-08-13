import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget button) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
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

  testWidgets('picks up SldsTheme.dark() colors from the ambient Theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SldsTheme.dark(),
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
    expect(
      resolvedBackground,
      isNot(SldsColors.primary),
    ); // dark seed differs from the light token
  });

  for (final variant in [
    SldsButtonVariant.secondary,
    SldsButtonVariant.tertiary,
  ]) {
    testWidgets('$variant is transparent in light mode', (tester) async {
      await pump(
        tester,
        SldsButton(label: 'Continue', variant: variant, onPressed: () {}),
      );
      final style = tester
          .widget<OutlinedButton>(find.byType(OutlinedButton))
          .style!;
      expect(style.backgroundColor!.resolve({}), isNull);
    });

    testWidgets('$variant is filled with a surface tone in dark mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SldsTheme.dark(),
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
      expect(style.backgroundColor!.resolve({}), isNotNull);
    });
  }

  testWidgets('color override wins over the variant token', (tester) async {
    const override = Color(0xFF00FF00);
    await pump(
      tester,
      SldsButton(label: 'Continue', color: override, onPressed: () {}),
    );

    final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;
    expect(style.backgroundColor!.resolve({}), override);
  });

  Future<void> setViewSize(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('is full-width and 52px tall below the mobile breakpoint', (
    tester,
  ) async {
    await setViewSize(tester, const Size(360, 800));

    await pump(tester, SldsButton(label: 'Continue', onPressed: () {}));

    final size = tester.getSize(find.byType(SldsButton));
    expect(size.width, 360);
    expect(size.height, 52);
  });

  testWidgets(
    'is intrinsic-width and 44px tall at/above the mobile breakpoint',
    (tester) async {
      await setViewSize(tester, const Size(1024, 800));

      await pump(tester, SldsButton(label: 'Continue', onPressed: () {}));

      final size = tester.getSize(find.byType(SldsButton));
      expect(size.width, lessThan(1024));
      expect(size.height, 44);
    },
  );

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
