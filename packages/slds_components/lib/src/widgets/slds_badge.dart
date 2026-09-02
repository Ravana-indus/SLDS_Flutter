import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart' show SldsChip;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_chip.dart' show SldsChip;

/// Status conveyed by an [SldsBadge] — each maps to a dedicated
/// [SldsColorTokens] text/background pair.
///
/// [draft] shares the Neutral pair, and [archived] is that same neutral
/// background with the lighter `badgeArchivedText` on top (per the Figma
/// token notes) — the two are distinct statuses, not aliases.
enum SldsBadgeStatus {
  /// Completed successfully.
  success,

  /// Awaiting action, without implying a problem.
  pending,

  /// Failed, or blocked by a problem.
  error,

  /// Neutral informational note.
  info,

  /// No particular status — the default.
  neutral,

  /// Saved but not yet submitted. Renders as [neutral].
  draft,

  /// Submitted and awaiting processing.
  submitted,

  /// Being assessed by a reviewer.
  inReview,

  /// Accepted.
  approved,

  /// Declined. Drawn identically to [error]; only the label differs.
  rejected,

  /// Raised to a higher authority.
  escalated,

  /// Paused, pending something external.
  onHold,

  /// Closed and retained for record only.
  archived,
}

/// SLDS status badge — a small pill showing an application/record status
/// (e.g. "In Review", "Approved"). Subtle tinted background with matching
/// text color, sized to its label.
///
/// For a filter/selection pill with an icon or a remove button, use
/// [SldsChip] instead; this one is read-only status, no interaction.
class SldsBadge extends StatelessWidget {
  /// Creates a badge showing [label], tinted by [status].
  const SldsBadge({
    required this.label,
    super.key,
    this.status = SldsBadgeStatus.neutral,
  });

  /// Convenience constructor using the status's own default label
  /// (e.g. [SldsBadgeStatus.inReview] renders "In Review").
  SldsBadge.status(SldsBadgeStatus status, {Key? key})
    : this(key: key, label: _defaultLabel(status), status: status);

  /// The text shown in the pill.
  ///
  /// Carries the meaning for a screen reader — the colour alone does not —
  /// so it should name the status, not abbreviate it.
  final String label;

  /// Which token colour pair the pill is drawn in.
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
      SldsBadgeStatus.success => (
        colors.badgeSuccessBackground,
        colors.badgeSuccessText,
      ),
      SldsBadgeStatus.pending => (
        colors.badgePendingBackground,
        colors.badgePendingText,
      ),
      SldsBadgeStatus.error => (
        colors.badgeErrorBackground,
        colors.badgeErrorText,
      ),
      SldsBadgeStatus.info => (
        colors.badgeInfoBackground,
        colors.badgeInfoText,
      ),
      SldsBadgeStatus.neutral => (
        colors.badgeNeutralBackground,
        colors.badgeNeutralText,
      ),
      SldsBadgeStatus.draft => (
        colors.badgeNeutralBackground,
        colors.badgeNeutralText,
      ),
      SldsBadgeStatus.submitted => (
        colors.badgeSubmittedBackground,
        colors.badgeSubmittedText,
      ),
      SldsBadgeStatus.inReview => (
        colors.badgeInReviewBackground,
        colors.badgeInReviewText,
      ),
      SldsBadgeStatus.approved => (
        colors.badgeApprovedBackground,
        colors.badgeApprovedText,
      ),
      // Rejected reuses the Error pair — the Figma badge set draws them
      // identically, only the label differs.
      SldsBadgeStatus.rejected => (
        colors.badgeErrorBackground,
        colors.badgeErrorText,
      ),
      SldsBadgeStatus.escalated => (
        colors.badgeEscalatedBackground,
        colors.badgeEscalatedText,
      ),
      SldsBadgeStatus.onHold => (
        colors.badgeOnHoldBackground,
        colors.badgeOnHoldText,
      ),
      SldsBadgeStatus.archived => (
        colors.badgeNeutralBackground,
        colors.badgeArchivedText,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.space12,
        vertical: dimensions.space4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(dimensions.radiusFull),
      ),
      child: Text(
        label,
        style: tokens.typography.caption1.copyWith(color: foreground),
      ),
    );
  }
}
