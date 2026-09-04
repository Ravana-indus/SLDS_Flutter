import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';

/// Visual tone for [SldsSummaryRow.badgeStatus] — maps 1:1 onto
/// [SldsColorTokens]'s dedicated status-badge pairs (e.g. [inReview] uses
/// `badgeInReviewText`/`Background`, matching the reference's blue
/// "In Review" pill).
enum SldsSummaryBadgeStatus {
  /// Awaiting action.
  pending,

  /// Failed, or blocked by a problem.
  error,

  /// Submitted and awaiting processing.
  submitted,

  /// Being assessed by a reviewer.
  inReview,

  /// Accepted.
  approved,

  /// Raised to a higher authority.
  escalated,

  /// Paused, pending something external.
  onHold,

  /// No particular status.
  neutral,
}

/// One label/value row inside [SldsSummaryList]. Pass [badgeStatus] to
/// render [value] as a status pill instead of plain text.
class SldsSummaryRow {
  /// Creates a label/value row.
  const SldsSummaryRow({
    required this.label,
    required this.value,
    this.badgeStatus,
    this.isSensitive = false,
  });

  /// What the row describes, e.g. "Application ID".
  final String label;

  /// The value shown against [label]. Rendered as a status pill when
  /// [badgeStatus] is set, otherwise as plain text.
  final String value;

  /// Null renders [value] as plain text; set to render it as a badge.
  final SldsSummaryBadgeStatus? badgeStatus;

  /// Whether [value] is a credential or personal identifier — an NIC, a
  /// licence or passport number, an account number, a date of birth.
  ///
  /// A summary row normally announces label and value as one phrase, so a
  /// screen reader reading a review screen speaks the identifier in full.
  /// That is the right default for ordinary values and the wrong one for a
  /// credential: assistive technology routes to a speaker as readily as to
  /// an earpiece, and a review screen is exactly where these values cluster.
  ///
  /// When true the value is masked on screen and withheld from the
  /// announcement until the citizen reveals it by activating the row, at
  /// which point it is both shown and announced. Nothing is hidden from the
  /// user who wants it — the reveal is one tap, and reachable by keyboard
  /// and screen reader alike — only from a bystander who happens to be in
  /// earshot or in view.
  ///
  /// This masks presentation only. It is not encryption and not a control on
  /// where the value travels; a host app is still responsible for how it
  /// stores, logs and transmits the underlying data.
  final bool isSensitive;
}

/// SLDS summary list — read-only label/value pairs for review screens
/// (e.g. "Application ID", "Submitted date", "Current status"). Rows stack
/// with 1px dividers inside a bordered card; a row's value can be plain
/// text or a status badge via [SldsSummaryRow.badgeStatus].
class SldsSummaryList extends StatelessWidget {
  /// Creates a summary list of [rows].
  const SldsSummaryList({
    required this.rows,
    super.key,
    this.width,
    this.isCredential = false,
  });

  /// The label/value pairs, rendered top to bottom in the order given.
  final List<SldsSummaryRow> rows;

  /// Preferred width, clamped to the available parent width. Defaults to
  /// the Figma reference width (400) when the parent is unbounded.
  final double? width;

  /// Whether this list presents an identity or credential document (a
  /// Driving Licence, Revenue Licence, Emission Certificate or Motor
  /// Insurance record) rather than an ordinary review screen.
  ///
  /// This is a marker only — the library does not itself restrict
  /// screenshots or screen recording, since that is a platform API the host
  /// app must call (e.g. `FLAG_SECURE` on Android, `UIScreen` capture
  /// notifications on iOS). A route rendering a credential-bearing list
  /// should read this flag and apply that restriction, and obscure the
  /// content in the OS app switcher, before the list is shown.
  final bool isCredential;

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

class _SummaryRowTile extends StatefulWidget {
  const _SummaryRowTile({required this.row});

  final SldsSummaryRow row;

  @override
  State<_SummaryRowTile> createState() => _SummaryRowTileState();
}

class _SummaryRowTileState extends State<_SummaryRowTile> {
  /// Whether a sensitive value is currently shown. Always false for an
  /// ordinary row, and reset whenever the row it renders changes so a
  /// recycled tile cannot carry one row's reveal over to the next.
  bool _revealed = false;

  @override
  void didUpdateWidget(_SummaryRowTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.row.value != oldWidget.row.value ||
        widget.row.label != oldWidget.row.label) {
      _revealed = false;
    }
  }

  /// Mask of the same length as the value, so the row keeps its height and
  /// the layout does not jump when the value is revealed.
  String get _masked =>
      '\u2022' * widget.row.value.characters.length.clamp(4, 12);

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final strings = context.sldsStrings;
    final row = widget.row;

    // A sensitive value is withheld from the announcement until revealed;
    // an ordinary row announces label and value together as before.
    final hidden = row.isSensitive && !_revealed;
    final semanticLabel = !row.isSensitive
        ? strings.labelledValue(row.label, row.value)
        : hidden
        ? strings.sensitiveValue(row.label)
        : strings.sensitiveValueRevealed(row.label, row.value);

    Widget tile = Container(
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
            Row(
              children: [
                Flexible(
                  child: Text(
                    hidden ? _masked : row.value,
                    style: tokens.typography.body1.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                if (row.isSensitive) ...[
                  SizedBox(width: dimensions.space8),
                  // Decorative: the whole row is the control, and it already
                  // announces its own reveal/hide affordance.
                  ExcludeSemantics(
                    child: Icon(
                      hidden ? Icons.visibility_off : Icons.visibility,
                      size: dimensions.space16,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );

    if (row.isSensitive) {
      // The whole row is the target rather than the icon alone: at the 320dp
      // floor a 16px icon is well under the 48px minimum, and the row is not
      // otherwise interactive so there is nothing to compete with.
      tile = InkWell(
        onTap: () => setState(() => _revealed = !_revealed),
        child: tile,
      );
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      button: row.isSensitive,
      label: semanticLabel,
      onTap: row.isSensitive
          ? () => setState(() => _revealed = !_revealed)
          : null,
      child: tile,
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
