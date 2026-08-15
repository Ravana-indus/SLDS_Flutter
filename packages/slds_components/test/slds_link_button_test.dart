import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: child),
    ),
  );

  testWidgets('renders the label underlined', (tester) async {
    await pump(tester, SldsLinkButton(label: 'Link button', onPressed: () {}));
    expect(find.text('Link button'), findsOneWidget);

    final text = tester.widget<Text>(find.text('Link button'));
    expect(text.style?.decoration, TextDecoration.underline);
  });

  testWidgets('taps invoke onPressed', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsLinkButton(label: 'Link button', onPressed: () => tapped = true),
    );

    await tester.tap(find.byType(SldsLinkButton));
    expect(tapped, isTrue);
  });

  testWidgets('null onPressed disables the button', (tester) async {
    await pump(
      tester,
      const SldsLinkButton(label: 'Link button', onPressed: null),
    );
    final button = tester.widget<TextButton>(find.byType(TextButton));
    expect(button.enabled, isFalse);
  });

  ButtonStyle styleOf(WidgetTester tester) =>
      tester.widget<TextButton>(find.byType(TextButton)).style!;

  testWidgets('each variant darkens its label on hover', (tester) async {
    // Pinned against the Figma Link button spec (node 248:2291), which
    // defines colour-only feedback: the label shifts, the surface does not.
    final colors = SldsColorTokens.light();
    final expected = {
      SldsLinkButtonVariant.primary: (colors.linkLabel, colors.linkLabelHover),
      SldsLinkButtonVariant.destructive: (
        colors.linkDestructiveLabel,
        colors.linkDestructiveLabelHover,
      ),
    };

    for (final entry in expected.entries) {
      final (rest, hover) = entry.value;
      await pump(
        tester,
        SldsLinkButton(
          label: 'Link button',
          variant: entry.key,
          onPressed: () {},
        ),
      );

      final foreground = styleOf(tester).foregroundColor!;
      expect(foreground.resolve({}), rest, reason: '${entry.key} rest');
      expect(
        foreground.resolve({WidgetState.hovered}),
        hover,
        reason: '${entry.key} hover',
      );
      // Rest and hover must actually differ, or the state is invisible.
      expect(rest, isNot(hover), reason: '${entry.key} states are distinct');
    }
  });

  testWidgets('no surface is painted in any state', (tester) async {
    // A link has no box of its own in Figma, so Material's state layer stays
    // suppressed rather than washing a tint behind the text.
    await pump(tester, SldsLinkButton(label: 'Link button', onPressed: () {}));

    final overlay = styleOf(tester).overlayColor!;
    for (final state in [
      WidgetState.hovered,
      WidgetState.pressed,
      WidgetState.focused,
    ]) {
      expect(overlay.resolve({state}), Colors.transparent, reason: '$state');
    }
  });

  testWidgets('disabled resolves the disabled token', (tester) async {
    await pump(
      tester,
      const SldsLinkButton(label: 'Link button', onPressed: null),
    );
    expect(
      styleOf(tester).foregroundColor!.resolve({WidgetState.disabled}),
      SldsColorTokens.light().disabledForeground,
    );
  });

  testWidgets('keeps the 48px minimum touch target', (tester) async {
    // WCAG 2.5.5. Figma's 24px-tall frame is the text box, not the target.
    await pump(tester, SldsLinkButton(label: 'Link button', onPressed: () {}));
    expect(
      tester.getSize(find.byType(TextButton)).height,
      greaterThanOrEqualTo(SldsDimensionTokens.standard.tapTargetMin),
    );
  });

  testWidgets('resolves against the dark palette in dark mode', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: SldsLocalizations.localizationsDelegates,
        supportedLocales: SldsLocalizations.supportedLocales,
        theme: SldsTheme.dark,
        home: Scaffold(
          body: SldsLinkButton(label: 'Link button', onPressed: () {}),
        ),
      ),
    );
    expect(
      styleOf(tester).foregroundColor!.resolve({}),
      SldsColorTokens.dark().linkLabel,
    );
  });
}
