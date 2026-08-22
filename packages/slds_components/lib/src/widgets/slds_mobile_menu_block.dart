import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_badge.dart';

/// The optional control at the end of an [SldsMobileMenuBlock].
///
/// Figma exposes these as independent booleans, but a row that showed more
/// than one at a time has no meaning — a toggle and a chevron promise
/// different things about what tapping does. Modelling them as one sealed
/// choice makes the invalid combinations unrepresentable.
sealed class SldsMobileMenuTrailing {
  const SldsMobileMenuTrailing();

  /// A chevron, for a row that opens another screen.
  const factory SldsMobileMenuTrailing.navigate() = SldsMobileMenuNavigate;

  /// A status badge (Figma's "state chip").
  const factory SldsMobileMenuTrailing.badge({
    required String label,
    SldsBadgeStatus status,
  }) = SldsMobileMenuBadge;

  /// A check mark, for a row that has been validated.
  const factory SldsMobileMenuTrailing.validated() = SldsMobileMenuValidated;

  /// An arbitrary control — pass an [SldsToggle] or [SldsRadio] here.
  ///
  /// Those own their state and callbacks, so the block does not wrap them:
  /// it only reserves the slot and lays them out.
  const factory SldsMobileMenuTrailing.control(Widget child) =
      SldsMobileMenuControl;
}

/// See [SldsMobileMenuTrailing.navigate].
class SldsMobileMenuNavigate extends SldsMobileMenuTrailing {
  /// Creates a chevron trailing affordance.
  const SldsMobileMenuNavigate();
}

/// See [SldsMobileMenuTrailing.badge].
class SldsMobileMenuBadge extends SldsMobileMenuTrailing {
  /// Creates a status-badge trailing affordance.
  const SldsMobileMenuBadge({
    required this.label,
    this.status = SldsBadgeStatus.approved,
  });

  /// The badge's text.
  final String label;

  /// Which badge palette to use.
  final SldsBadgeStatus status;
}

/// See [SldsMobileMenuTrailing.validated].
class SldsMobileMenuValidated extends SldsMobileMenuTrailing {
  /// Creates a validated-check trailing affordance.
  const SldsMobileMenuValidated();
}

/// See [SldsMobileMenuTrailing.control].
class SldsMobileMenuControl extends SldsMobileMenuTrailing {
  /// Wraps [child] as the trailing affordance.
  const SldsMobileMenuControl(this.child);

  /// The control to render.
  final Widget child;
}

/// SLDS mobile menu block — one row of a settings or account list.
///
/// A leading icon, a title with optional supporting line, an optional count
/// bubble, and one optional [trailing] affordance, over a full-width divider.
///
/// The row is a single tap target when [onTap] is set: the title, subtitle
/// and chevron are one control to a screen reader rather than three stops.
/// A row whose trailing affordance is itself interactive (a toggle, a radio)
/// should leave [onTap] null and let that control own the interaction, so
/// there are not two competing tap targets in one row.
class SldsMobileMenuBlock extends StatelessWidget {
  /// Creates a mobile menu row.
  const SldsMobileMenuBlock({
    required this.title,
    super.key,
    this.subtitle,
    this.leadingIcon,
    this.count,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.showDivider = true,
    this.semanticLabel,
  });

  /// The row's primary label.
  final String title;

  /// Optional supporting line beneath [title].
  final String? subtitle;

  /// Optional glyph shown before the text.
  final IconData? leadingIcon;

  /// Optional count shown in a gold bubble (Figma's "feedback number").
  ///
  /// Rendered as given, so a caller that wants "99+" passes that string.
  final String? count;

  /// Optional affordance at the end of the row.
  final SldsMobileMenuTrailing? trailing;

  /// Called when the row is tapped. Null makes the row non-interactive.
  final VoidCallback? onTap;

  /// Whether the row is interactive.
  final bool enabled;

  /// Whether to draw the divider beneath the row.
  ///
  /// Figma draws one on every block; set false on the last row of a list
  /// where the container already provides an edge.
  final bool showDivider;

  /// Overrides the row's accessible name, which otherwise combines [title]
  /// and [subtitle].
  final String? semanticLabel;

  bool get _interactive => enabled && onTap != null;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final foreground = enabled ? colors.textPrimary : colors.disabledForeground;

    final row = Padding(
      padding: EdgeInsets.all(dimensions.space16),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            Icon(
              leadingIcon,
              size: dimensions.iconSizeXLarge,
              color: foreground,
            ),
            SizedBox(width: dimensions.space16),
          ],
          Expanded(
            // Title and subtitle read as one phrase. Only the text is merged:
            // wrapping the whole row would swallow an interactive trailing
            // control's own node and make it unreachable.
            child: Semantics(
              label: semanticLabel ?? _defaultSemanticLabel,
              button: _interactive,
              enabled: enabled,
              excludeSemantics: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.typography.body2.copyWith(color: foreground),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: dimensions.space4),
                    Text(
                      subtitle!,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.typography.overline.copyWith(
                        color: enabled
                            ? colors.textSecondary
                            : colors.disabledForeground,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          ..._trailingChildren(context),
        ],
      ),
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_interactive) InkWell(onTap: onTap, child: row) else row,
        if (showDivider)
          Divider(
            height: dimensions.controlBorderWidth,
            thickness: dimensions.controlBorderWidth,
            color: colors.borderDecorative,
          ),
      ],
    );

    return ColoredBox(color: colors.surfaceSunken, child: content);
  }

  /// Title and subtitle read as one phrase; a screen reader should not stop
  /// twice inside a single row.
  String get _defaultSemanticLabel =>
      subtitle == null ? title : '$title, $subtitle';

  List<Widget> _trailingChildren(BuildContext context) {
    final tokens = context.slds;
    final dimensions = tokens.dimensions;
    final children = <Widget>[];

    if (count != null) {
      children.add(_CountBubble(count: count!, enabled: enabled));
    }

    final affordance = _buildTrailing(context);
    if (affordance != null) children.add(affordance);

    // Figma spaces the trailing cluster by 16; nothing precedes the first
    // item, so the gap goes before each child rather than after.
    return [
      for (final child in children) ...[
        SizedBox(width: dimensions.space16),
        child,
      ],
    ];
  }

  Widget? _buildTrailing(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    return switch (trailing) {
      null => null,
      SldsMobileMenuNavigate() => Icon(
        Icons.chevron_right,
        size: tokens.dimensions.iconSizeSmall,
        color: enabled ? colors.textPrimary : colors.disabledForeground,
      ),
      SldsMobileMenuValidated() => Icon(
        Icons.check_circle_outline,
        size: tokens.dimensions.iconSizeMedium,
        color: enabled ? colors.success : colors.disabledForeground,
      ),
      final SldsMobileMenuBadge badge => SldsBadge(
        label: badge.label,
        status: badge.status,
      ),
      final SldsMobileMenuControl control => control.child,
    };
  }
}

/// The gold count bubble at the end of a row.
class _CountBubble extends StatelessWidget {
  const _CountBubble({required this.count, required this.enabled});

  final String count;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final size = tokens.dimensions.countBubbleSize;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: enabled
            ? colors.buttonPrimaryBackground
            : colors.disabledBackground,
        shape: BoxShape.circle,
      ),
      child: Text(
        count,
        style: tokens.typography.caption1.copyWith(
          color: enabled ? colors.textStaticBlack : colors.disabledForeground,
        ),
      ),
    );
  }
}
