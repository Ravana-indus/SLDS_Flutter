import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

import 'support/slds_test_harness.dart';

void main() {
  testWidgets('renders the message', (tester) async {
    await tester.pumpWidget(
      wrap(const SldsBanner(message: 'Your changes have been saved.')),
    );

    expect(find.text('Your changes have been saved.'), findsOneWidget);
  });

  testWidgets('action fires onAction', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        SldsBanner(
          message: 'Something went wrong.',
          severity: SldsBannerSeverity.error,
          actionLabel: 'Try again',
          onAction: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.text('Try again'));
    expect(tapped, isTrue);
  });

  testWidgets('dismiss fires onDismiss', (tester) async {
    var dismissed = false;
    await tester.pumpWidget(
      wrap(
        SldsBanner(
          message: 'New updates are available.',
          onDismiss: () => dismissed = true,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close));
    expect(dismissed, isTrue);
  });

  testWidgets('hides the action when the label has no callback', (
    tester,
  ) async {
    // An action that does nothing is worse than no action, so the label
    // alone must not paint a button.
    await tester.pumpWidget(
      wrap(const SldsBanner(message: 'Saved.', actionLabel: 'View details')),
    );

    expect(find.text('View details'), findsNothing);
  });

  testWidgets('hides the dismiss button when onDismiss is null', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const SldsBanner(message: 'Saved.')));

    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('announces itself as a live region', (tester) async {
    // The banner appears without focus moving to it, so a screen reader is
    // only told it arrived if the region is live (§5).
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(wrap(const SldsBanner(message: 'Saved.')));

    final data = tester
        .getSemantics(find.byType(SldsBanner))
        .getSemanticsData();
    expect(data.flagsCollection.isLiveRegion, isTrue);
    handle.dispose();
  });

  testWidgets('each severity paints its own border and background', (
    tester,
  ) async {
    // Guards the token mapping: a severity that resolved to the wrong pair
    // would still render, just wrongly, and no other test would catch it.
    final colors = SldsTokenSet.light().colors;
    final expected = <SldsBannerSeverity, (Color, Color)>{
      SldsBannerSeverity.success: (
        colors.success,
        colors.badgeSuccessBackground,
      ),
      SldsBannerSeverity.warning: (
        colors.warning,
        colors.badgePendingBackground,
      ),
      SldsBannerSeverity.error: (colors.error, colors.badgeErrorBackground),
      SldsBannerSeverity.info: (colors.info, colors.surfaceCard),
    };

    for (final entry in expected.entries) {
      await tester.pumpWidget(
        wrap(SldsBanner(message: 'Message', severity: entry.key)),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(SldsBanner),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      final (border, background) = entry.value;

      expect(decoration.color, background, reason: '${entry.key} background');
      expect(
        (decoration.border! as Border).top.color,
        border,
        reason: '${entry.key} border',
      );
    }
  });

  testWidgets('warning uses the darker title colour for AA on amber', (
    tester,
  ) async {
    // Every other severity puts textPrimary on its tint; warning is the one
    // that does not, and swapping it back would fail contrast silently.
    await tester.pumpWidget(
      wrap(
        const SldsBanner(
          message: 'Session expiring.',
          severity: SldsBannerSeverity.warning,
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Session expiring.'));
    expect(text.style?.color, SldsTokenSet.light().colors.bannerWarningTitle);
  });
}
