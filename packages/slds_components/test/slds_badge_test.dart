import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget badge) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: Center(child: badge)),
    ),
  );

  Color backgroundOf(WidgetTester tester) {
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(SldsBadge),
        matching: find.byType(Container),
      ),
    );
    return (container.decoration! as BoxDecoration).color!;
  }

  testWidgets('renders its label', (tester) async {
    await pump(
      tester,
      const SldsBadge(label: 'In Review', status: SldsBadgeStatus.inReview),
    );
    expect(find.text('In Review'), findsOneWidget);
  });

  testWidgets('SldsBadge.status uses the status default label', (tester) async {
    await pump(tester, SldsBadge.status(SldsBadgeStatus.onHold));
    expect(find.text('On Hold'), findsOneWidget);
  });

  testWidgets('each status resolves to its own token pair', (tester) async {
    final colors = SldsColorTokens.light();

    for (final (status, background, foreground) in [
      (
        SldsBadgeStatus.success,
        colors.badgeSuccessBackground,
        colors.badgeSuccessText,
      ),
      (
        SldsBadgeStatus.pending,
        colors.badgePendingBackground,
        colors.badgePendingText,
      ),
      (
        SldsBadgeStatus.error,
        colors.badgeErrorBackground,
        colors.badgeErrorText,
      ),
      (SldsBadgeStatus.info, colors.badgeInfoBackground, colors.badgeInfoText),
      (
        SldsBadgeStatus.neutral,
        colors.badgeNeutralBackground,
        colors.badgeNeutralText,
      ),
      (
        SldsBadgeStatus.submitted,
        colors.badgeSubmittedBackground,
        colors.badgeSubmittedText,
      ),
      (
        SldsBadgeStatus.inReview,
        colors.badgeInReviewBackground,
        colors.badgeInReviewText,
      ),
      (
        SldsBadgeStatus.approved,
        colors.badgeApprovedBackground,
        colors.badgeApprovedText,
      ),
      (
        SldsBadgeStatus.escalated,
        colors.badgeEscalatedBackground,
        colors.badgeEscalatedText,
      ),
      (
        SldsBadgeStatus.onHold,
        colors.badgeOnHoldBackground,
        colors.badgeOnHoldText,
      ),
    ]) {
      await pump(tester, SldsBadge.status(status));
      expect(
        backgroundOf(tester),
        background,
        reason: 'background for $status',
      );
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byType(SldsBadge),
          matching: find.byType(Text),
        ),
      );
      expect(text.style?.color, foreground, reason: 'text color for $status');
    }
  });

  testWidgets('draft shares the neutral pair', (tester) async {
    final colors = SldsColorTokens.light();
    await pump(tester, SldsBadge.status(SldsBadgeStatus.draft));

    expect(find.text('Draft'), findsOneWidget);
    expect(backgroundOf(tester), colors.badgeNeutralBackground);
  });

  testWidgets(
    'archived uses the lighter archived text on the neutral background',
    (tester) async {
      final colors = SldsColorTokens.light();
      await pump(tester, SldsBadge.status(SldsBadgeStatus.archived));

      expect(backgroundOf(tester), colors.badgeNeutralBackground);
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byType(SldsBadge),
          matching: find.byType(Text),
        ),
      );
      expect(text.style?.color, colors.badgeArchivedText);
      expect(text.style?.color, isNot(colors.badgeNeutralText));
    },
  );

  testWidgets('rejected reuses the error pair but keeps its own label', (
    tester,
  ) async {
    final colors = SldsColorTokens.light();
    await pump(tester, SldsBadge.status(SldsBadgeStatus.rejected));

    expect(find.text('Rejected'), findsOneWidget);
    expect(backgroundOf(tester), colors.badgeErrorBackground);
  });

  testWidgets('a custom label overrides the status default', (tester) async {
    await pump(
      tester,
      const SldsBadge(
        label: 'Awaiting payment',
        status: SldsBadgeStatus.pending,
      ),
    );

    expect(find.text('Awaiting payment'), findsOneWidget);
    expect(find.text('Pending'), findsNothing);
  });

  testWidgets('text matches Figma: weight 500, Success label #1FAA63', (
    tester,
  ) async {
    for (final status in SldsBadgeStatus.values) {
      await pump(tester, SldsBadge(label: 'Label', status: status));
      final text = tester.widget<Text>(find.text('Label'));
      expect(text.style!.fontWeight, FontWeight.w500, reason: '$status');
    }

    await pump(
      tester,
      const SldsBadge(label: 'Success', status: SldsBadgeStatus.success),
    );
    expect(
      tester.widget<Text>(find.text('Success')).style!.color,
      const Color(0xFF1FAA63),
    );
  });

  testWidgets('Pending label matches Figma #503D00', (tester) async {
    await pump(
      tester,
      const SldsBadge(label: 'Pending', status: SldsBadgeStatus.pending),
    );
    expect(
      tester.widget<Text>(find.text('Pending')).style!.color,
      const Color(0xFF503D00),
    );
  });

  testWidgets('label and background colours match Figma (#21-#27)', (
    tester,
  ) async {
    // (status, Figma label, Figma background) from Badge set 459:1448.
    const figma = [
      (SldsBadgeStatus.error, 0xFFD32F2F, 0xFFFDECEA),
      (SldsBadgeStatus.info, 0xFF0D6B7B, 0xFFFFFFFF),
      (SldsBadgeStatus.neutral, 0xFF676767, 0xFFEEEEEE),
      (SldsBadgeStatus.draft, 0xFF898989, 0xFFEEEEEE),
      (SldsBadgeStatus.submitted, 0xFF0E9DB0, 0xFFD0F0F5),
      (SldsBadgeStatus.approved, 0xFF059669, 0xFFE0F2EC),
    ];
    for (final (status, label, background) in figma) {
      await pump(tester, SldsBadge(label: 'Label', status: status));
      expect(
        tester.widget<Text>(find.text('Label')).style!.color,
        Color(label),
        reason: '$status label',
      );
      expect(backgroundOf(tester), Color(background), reason: '$status bg');
    }
  });
}
