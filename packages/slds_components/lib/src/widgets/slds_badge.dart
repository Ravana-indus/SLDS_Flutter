import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// Status conveyed by an [SldsBadge] — each maps to a dedicated
/// [SldsColorTokens] text/background pair.
///
/// [draft] shares the Neutral pair, and [archived] is that same neutral
/// background with the lighter `badgeArchivedText` on top (per the Figma
/// token notes) — the two are distinct statuses, not aliases.
enum SldsBadgeStatus {
  success,
  pending,
  error,
  info,
  neutral,
  draft,
  submitted,
  inReview,
  approved,
  rejected,
  escalated,
  onHold,
  archived,
}

/// SLDS status badge — a small pill showing an application/record status
/// (e.g. "In Review", "Approved"). Subtle tinted background with matching
/// text color, sized to its label.
///
/// For a filter/selection pill with an icon or a remove button, use
/// [SldsChip] instead; this one is read-only status, no interaction.
class SldsBadge extends StatelessWidget {
  const SldsBadge({super.key, required this.label, this.status = SldsBadgeStatus.neutral});

  /// Convenience constructor using the status's own default label
  /// (e.g. [SldsBadgeStatus.inReview] renders "In Review").
  SldsBadge.status(SldsBadgeStatus status, {Key? key}) : this(key: key, label: _defaultLabel(status), status: status);

  final String label;
  final SldsBadgeStatus status;

  static String _defaultLabel(SldsBadgeStatus status) => switch (status) {
        SldsBadgeStatus.success => 'Success',
        SldsBadgeStatus.pending => 'Pending',
        SldsBadgeStatus.error => 'Error',
        SldsBadgeStatus.info => 'Info',
        SldsBadgeStatus.neutral => 'Neutral',
        SldsBadgeStatus.draft => 'Draft',
        SldsBadgeStatus.submitted => 'Submitted',
        SldsBadgeStatus.inReview => 'In Review',
        SldsBadgeStatus.approved => 'Approved',
        SldsBadgeStatus.rejected => 'Rejected',
        SldsBadgeStatus.escalated => 'Escalated',
        SldsBadgeStatus.onHold => 'On Hold',
        SldsBadgeStatus.archived => 'Archived',
      };

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    final (Color background, Color foreground) = switch (status) {
      SldsBadgeStatus.success => (colors.badgeSuccessBackground, colors.badgeSuccessText),
      SldsBadgeStatus.pending => (colors.badgePendingBackground, colors.badgePendingText),
      SldsBadgeStatus.error => (colors.badgeErrorBackground, colors.badgeErrorText),
      SldsBadgeStatus.info => (colors.badgeInfoBackground, colors.badgeInfoText),
      SldsBadgeStatus.neutral => (colors.badgeNeutralBackground, colors.badgeNeutralText),
      SldsBadgeStatus.draft => (colors.badgeNeutralBackground, colors.badgeNeutralText),
      SldsBadgeStatus.submitted => (colors.badgeSubmittedBackground, colors.badgeSubmittedText),
      SldsBadgeStatus.inReview => (colors.badgeInReviewBackground, colors.badgeInReviewText),
      SldsBadgeStatus.approved => (colors.badgeApprovedBackground, colors.badgeApprovedText),
      // Rejected reuses the Error pair — the Figma badge set draws them
      // identically, only the label differs.
      SldsBadgeStatus.rejected => (colors.badgeErrorBackground, colors.badgeErrorText),
      SldsBadgeStatus.escalated => (colors.badgeEscalatedBackground, colors.badgeEscalatedText),
      SldsBadgeStatus.onHold => (colors.badgeOnHoldBackground, colors.badgeOnHoldText),
      SldsBadgeStatus.archived => (colors.badgeNeutralBackground, colors.badgeArchivedText),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: dimensions.space12, vertical: dimensions.space4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(dimensions.radiusFull),
      ),
      child: Text(label, style: tokens.typography.caption1.copyWith(color: foreground)),
    );
  }
}
