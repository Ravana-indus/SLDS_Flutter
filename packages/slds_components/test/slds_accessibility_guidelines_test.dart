// Rendered-tree accessibility checks (§8).
//
// The pure-Dart contrast test in slds_tokens proves the *declared* token
// pairs meet WCAG. It cannot see what a widget actually composites — an
// opacity applied at paint time, a label too small to hit, an icon button
// with no name. Flutter's own meetsGuideline matchers walk the rendered
// semantics tree, so they catch what the token test structurally cannot.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

/// Builds [child] inside a themed, localized app, matching how a consuming
/// app installs the library.
Widget host(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? SldsTheme.light,
  localizationsDelegates: SldsLocalizations.localizationsDelegates,
  supportedLocales: SldsLocalizations.supportedLocales,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('tap target size', () {
    // Both platform guidelines are checked: Android asks for 48x48, iOS for
    // 44x44, and SLDS holds the stricter 48.
    testWidgets('SldsButton', (tester) async {
      await tester.pumpWidget(
        host(SldsButton(label: 'Continue', onPressed: () {})),
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    });

    testWidgets('SldsLinkButton', (tester) async {
      // Previously minimumSize: Size.zero + shrinkWrap, collapsing the
      // target to the text glyph box.
      await tester.pumpWidget(
        host(SldsLinkButton(label: 'Terms of service', onPressed: () {})),
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    });

    testWidgets('SldsToggle at both sizes', (tester) async {
      for (final size in SldsToggleSize.values) {
        await tester.pumpWidget(
          host(SldsToggle(value: false, onChanged: (_) {}, size: size)),
        );
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      }
    });

    testWidgets('SldsFab', (tester) async {
      await tester.pumpWidget(host(SldsFab(icon: Icons.add, onPressed: () {})));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    });
  });

  group('text contrast', () {
    // Catches composited-opacity problems the token test cannot see: these
    // measure the pixels as painted, including any alpha applied on top.
    testWidgets('SldsButton in every variant', (tester) async {
      for (final variant in SldsButtonVariant.values) {
        await tester.pumpWidget(
          host(
            SldsButton(label: 'Continue', variant: variant, onPressed: () {}),
          ),
        );
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
    });

    testWidgets('SldsButton in dark and high contrast', (tester) async {
      for (final theme in [SldsTheme.dark, SldsTheme.highContrast]) {
        await tester.pumpWidget(
          host(
            SldsButton(label: 'Continue', onPressed: () {}),
            theme: theme,
          ),
        );
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
    });

    testWidgets('SldsTextField label and helper text', (tester) async {
      await tester.pumpWidget(
        host(
          const SldsTextField(
            label: 'Licence number',
            helpText: 'As printed on your licence',
          ),
        ),
      );
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    });
  });

  group('labelled tap targets', () {
    // Every tappable node needs a name a screen reader can announce.
    testWidgets('SldsButton', (tester) async {
      await tester.pumpWidget(
        host(SldsButton(label: 'Continue', onPressed: () {})),
      );
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    });

    testWidgets('SldsFab carries its tooltip as a label', (tester) async {
      await tester.pumpWidget(
        host(
          SldsFab(icon: Icons.add, tooltip: 'Add vehicle', onPressed: () {}),
        ),
      );
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    });
  });

  group('loading state announcements', () {
    testWidgets('SldsButton announces loading as a live region', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(SldsButton(label: 'Continue', isLoading: true, onPressed: () {})),
      );

      expect(
        find.bySemanticsLabel('Loading'),
        findsOneWidget,
        reason: 'the spinner must carry a localized label',
      );
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Loading'))
            .flagsCollection
            .isLiveRegion,
        isTrue,
        reason: 'entering the loading state must be announced as it happens',
      );
      handle.dispose();
    });

    testWidgets('the localized label is used, not a hardcoded string', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          theme: SldsTheme.light,
          locale: const Locale('si'),
          localizationsDelegates: SldsLocalizations.localizationsDelegates,
          supportedLocales: SldsLocalizations.supportedLocales,
          home: Scaffold(
            body: SldsButton(
              label: 'Continue',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Loading'), findsNothing);
      expect(find.bySemanticsLabel('පූරණය වෙමින්'), findsOneWidget);
      handle.dispose();
    });
  });

  group('badge meaning', () {
    testWidgets('SldsFab badge announces meaning, not a bare number', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(SldsFab(icon: Icons.mail, badgeCount: 3, onPressed: () {})),
      );

      // "3" alone tells a screen-reader user nothing — §5 uses exactly this
      // as its counter-example. The meaning rides on the FloatingActionButton
      // node, which is where a screen reader reads an icon button's name.
      final node = tester.getSemantics(find.byType(FloatingActionButton));
      expect(node.tooltip, contains('3 unread notifications'));
      // And the bare digits must not leak through as the node's own label.
      expect(node.label, isNot('3'));
      handle.dispose();
    });
  });
}
