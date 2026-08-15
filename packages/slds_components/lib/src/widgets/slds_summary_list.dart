import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';

/// Visual tone for [SldsSummaryRow.badgeStatus] — maps 1:1 onto
/// [SldsColorTokens]'s dedicated status-badge pairs (e.g. [inReview] uses
/// `badgeInReviewText`/`Background`, matching the reference's blue
/// "In Review" pill).
enum SldsSummaryBadgeStatus {
  pending,
  error,
  submitted,
  inReview,
  approved,
  escalated,
  onHold,
  neutral,
}

/// One label/value row inside [SldsSummaryList]. Pass [badgeStatus] to
/// render [value] as a status pill instead of plain text.
class SldsSummaryRow {
  const SldsSummaryRow({
    required this.label,
    required this.value,
    this.badgeStatus,
  });

  final String label;
  final String value;

  /// Null renders [value] as plain text; set to render it as a badge.
  final SldsSummaryBadgeStatus? badgeStatus;
}

/// SLDS summary list — read-only label/value pairs for review screens
/// (e.g. "Application ID", "Submitted date", "Current status"). Rows stack
/// with 1px dividers inside a bordered card; a row's value can be plain
/// text or a status badge via [SldsSummaryRow.badgeStatus].
class SldsSummaryList extends StatelessWidget {
  const SldsSummaryList({required this.rows, super.key, this.width});

  final List<SldsSummaryRow> rows;

  /// Preferred width, clamped to the available parent width. Defaults to
  /// the Figma reference width (400) when the parent is unbounded.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return LayoutBuilder(
      builder: (context, constraints) {
        const figmaReferenceWidth = 400.0;
        final requestedWidth =
            width ??
            (constraints.hasBoundedWidth
                ? constraints.maxWidth
                : figmaReferenceWidth);
        final resolvedWidth = constraints.hasBoundedWidth
            ? requestedWidth.clamp(0.0, constraints.maxWidth)
            : requestedWidth;

        return Container(
          width: resolvedWidth,
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            border: Border.all(color: colors.borderDecorative),
            borderRadius: BorderRadius.circular(dimensions.radius2xl),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) Divider(height: 1, color: colors.borderDecorative),
                _SummaryRowTile(row: rows[i]),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SummaryRowTile extends StatelessWidget {
  const _SummaryRowTile({required this.row});

  final SldsSummaryRow row;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: context.sldsStrings.labelledValue(row.label, row.value),
      child: Container(
        width: double.infinity,
        color: colors.surfacePage,
        padding: EdgeInsets.symmetric(
          horizontal: dimensions.space16,
          vertical: dimensions.space8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              row.label,
              style: tokens.typography.body2.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: dimensions.space4),
            if (row.badgeStatus != null)
              _StatusBadge(text: row.value, status: row.badgeStatus!)
            else
              Text(
                row.value,
                style: tokens.typography.body1.copyWith(
                  color: colors.textPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.status});

  final String text;
  final SldsSummaryBadgeStatus status;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    final (Color background, Color foreground) = switch (status) {
      SldsSummaryBadgeStatus.pending => (
        colors.badgePendingBackground,
        colors.badgePendingText,
      ),
      SldsSummaryBadgeStatus.error => (
        colors.badgeErrorBackground,
        colors.badgeErrorText,
      ),
      SldsSummaryBadgeStatus.submitted => (
        colors.badgeSubmittedBackground,
        colors.badgeSubmittedText,
      ),
      SldsSummaryBadgeStatus.inReview => (
        colors.badgeInReviewBackground,
        colors.badgeInReviewText,
      ),
      SldsSummaryBadgeStatus.approved => (
        colors.badgeApprovedBackground,
        colors.badgeApprovedText,
      ),
      SldsSummaryBadgeStatus.escalated => (
        colors.badgeEscalatedBackground,
        colors.badgeEscalatedText,
      ),
      SldsSummaryBadgeStatus.onHold => (
        colors.badgeOnHoldBackground,
        colors.badgeOnHoldText,
      ),
      SldsSummaryBadgeStatus.neutral => (
        colors.badgeNeutralBackground,
        colors.badgeNeutralText,
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
        text,
        style: tokens.typography.caption1.copyWith(color: foreground),
      ),
    );
  }
}
