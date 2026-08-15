import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget button, {
    ThemeData? theme,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: theme ?? SldsTheme.light,
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: button)),
    ),
  );

  Future<void> setViewSize(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  ButtonStyle styleOf(WidgetTester tester) =>
      tester.widget<IconButton>(find.byType(IconButton)).style!;

  testWidgets('each size renders its Figma box, radius and icon size', (
    tester,
  ) async {
    // Pinned against the Figma Icon Button spec (node 217:9203). Note Large
    // keeps a 24px icon, unlike SldsButton's Large which drops to 20.
    const d = SldsDimensionTokens.standard;
    final expected = {
      SldsButtonSize.small: (d.buttonHeightSmall, d.radiusXl, d.iconSizeSmall),
      SldsButtonSize.medium: (
        d.buttonHeightMedium,
        d.radiusXl,
        d.iconSizeMedium,
      ),
      SldsButtonSize.large: (d.buttonHeightLarge, d.radius2xl, d.iconSizeLarge),
      SldsButtonSize.extraLarge: (
        d.buttonHeightExtraLarge,
        d.radius2xl,
        d.iconSizeLarge,
      ),
    };

    for (final entry in expected.entries) {
      final (box, radius, iconSize) = entry.value;
      await pump(
        tester,
        SldsIconButton(icon: Icons.add, onPressed: () {}, size: entry.key),
      );

      // The painted box is square and exactly the Figma size.
      expect(
        tester.getSize(find.byType(IconButton)),
        Size(box, box),
        reason: '${entry.key} box',
      );

      final shape =
          styleOf(tester).shape!.resolve({})! as RoundedRectangleBorder;
      expect(
        shape.borderRadius,
        BorderRadius.circular(radius),
        reason: '${entry.key} radius',
      );

      expect(
        tester.widget<Icon>(find.byIcon(Icons.add)).size,
        iconSize,
        reason: '${entry.key} icon size',
      );
    }
  });

  testWidgets('small and medium keep a 48px touch target', (tester) async {
    // WCAG 2.5.5: the box paints below 48px by design, so the shortfall is
    // reclaimed as an invisible tap area rather than by inflating the box.
    const d = SldsDimensionTokens.standard;
    for (final size in [SldsButtonSize.small, SldsButtonSize.medium]) {
      await pump(
        tester,
        SldsIconButton(icon: Icons.add, onPressed: () {}, size: size),
      );
      expect(
        tester.getSize(find.byType(SldsIconButton)).height,
        d.tapTargetMin,
        reason: '$size tap target',
      );
    }
  });

  testWidgets('defaults to the responsive size pair', (tester) async {
    const d = SldsDimensionTokens.standard;

    await setViewSize(tester, const Size(360, 800));
    await pump(tester, SldsIconButton(icon: Icons.add, onPressed: () {}));
    expect(
      tester.getSize(find.byType(IconButton)).height,
      d.buttonHeightExtraLarge,
    );

    await setViewSize(tester, const Size(1024, 800));
    await pump(tester, SldsIconButton(icon: Icons.add, onPressed: () {}));
    expect(tester.getSize(find.byType(IconButton)).height, d.buttonHeightLarge);
  });

  testWidgets('resting background resolves from the variant token', (
    tester,
  ) async {
    final colors = SldsColorTokens.light();
    final expected = {
      SldsButtonVariant.primary: colors.buttonPrimaryBackground,
      SldsButtonVariant.destructive: colors.buttonDestructiveBackground,
      SldsButtonVariant.secondary: colors.buttonSecondaryBackground,
      // Ghost variants are transparent at rest.
      SldsButtonVariant.tertiary: null,
      SldsButtonVariant.text: null,
    };

    for (final entry in expected.entries) {
      await pump(
        tester,
        SldsIconButton(
          icon: Icons.add,
          onPressed: () {},
          variant: entry.key,
        ),
      );
      expect(
        styleOf(tester).backgroundColor!.resolve({}),
        entry.value,
        reason: '${entry.key} resting background',
      );
    }
  });

  testWidgets('hover and pressed read their designed tokens, not a tint', (
    tester,
  ) async {
    final colors = SldsColorTokens.light();
    await pump(tester, SldsIconButton(icon: Icons.add, onPressed: () {}));

    final background = styleOf(tester).backgroundColor!;
    expect(
      background.resolve({WidgetState.hovered}),
      colors.buttonPrimaryHover,
    );
    expect(
      background.resolve({WidgetState.pressed}),
      colors.buttonPrimaryPressed,
    );
    // Material's own state layer is suppressed so it cannot tint over them.
    expect(styleOf(tester).overlayColor!.resolve({}), Colors.transparent);
  });

  testWidgets('ghost variants get their feedback from the ghost tokens', (
    tester,
  ) async {
    final colors = SldsColorTokens.light();
    await pump(
      tester,
      SldsIconButton(
        icon: Icons.add,
        onPressed: () {},
        variant: SldsButtonVariant.text,
      ),
    );

    final background = styleOf(tester).backgroundColor!;
    expect(background.resolve({WidgetState.hovered}), colors.buttonGhostHover);
    expect(
      background.resolve({WidgetState.pressed}),
      colors.buttonGhostPressed,
    );
  });

  testWidgets('only the secondary variant is outlined', (tester) async {
    // Figma's Ghost has no border; tertiary previously drew one.
    for (final variant in SldsButtonVariant.values) {
      await pump(
        tester,
        SldsIconButton(icon: Icons.add, onPressed: () {}, variant: variant),
      );
      expect(
        styleOf(tester).side!.resolve({}),
        variant == SldsButtonVariant.secondary ? isNotNull : isNull,
        reason: '$variant border',
      );
    }
  });

  testWidgets('disabled resolves the disabled tokens', (tester) async {
    final colors = SldsColorTokens.light();
    await pump(
      tester,
      const SldsIconButton(icon: Icons.add, onPressed: null),
    );

    const disabled = {WidgetState.disabled};
    final style = styleOf(tester);
    expect(style.backgroundColor!.resolve(disabled), colors.disabledBackground);
    expect(style.foregroundColor!.resolve(disabled), colors.disabledForeground);
  });

  testWidgets('loading shows a spinner, blocks taps, and announces itself', (
    tester,
  ) async {
    var tapped = false;
    await pump(
      tester,
      SldsIconButton(
        icon: Icons.add,
        isLoading: true,
        onPressed: () => tapped = true,
        tooltip: 'Add',
      ),
    );

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);

    await tester.tap(find.byType(IconButton), warnIfMissed: false);
    expect(tapped, isFalse);

    // The tooltip is the accessible name, so while loading it must say so
    // rather than keep announcing the idle action.
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).tooltip,
      isNot('Add'),
    );
  });

  testWidgets('resolves against the dark palette in dark mode', (tester) async {
    await pump(
      tester,
      SldsIconButton(icon: Icons.add, onPressed: () {}),
      theme: SldsTheme.dark,
    );

    expect(
      styleOf(tester).foregroundColor!.resolve({}),
      SldsColorTokens.dark().buttonPrimaryLabel,
    );
  });
}
