import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/slds_components.dart' show SldsAvatar;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_avatar.dart' show SldsAvatar;

/// SLDS chip — a pill-shaped label with an optional leading [avatar]/[icon]
/// and an optional trailing close button (shown when [onDeleted] is set).
/// Used for selected filters/tags (e.g. an assignee chip with a photo and
/// a remove action).
class SldsChip extends StatelessWidget {
  const SldsChip({
    required this.label,
    super.key,
    this.avatar,
    this.icon,
    this.onDeleted,
    this.onTap,
  });

  final String label;

  /// A leading [SldsAvatar] (or any small widget) — takes precedence over
  /// [icon] when both are given.
  final Widget? avatar;

  /// A leading icon glyph, used when there's no [avatar].
  final IconData? icon;

  /// Shows a trailing close (×) button and fires this when tapped. Null
  /// hides the button — an un-deletable, informational chip.
  final VoidCallback? onDeleted;

  /// Fires when the chip body (not the close button) is tapped. Null makes
  /// the label non-interactive.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final background = colors.surfaceHover;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      button: onTap != null,
      label: label,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(dimensions.radiusFull),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(dimensions.radiusFull),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.space12,
              vertical: dimensions.space8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (avatar != null) ...[
                  avatar!,
                  SizedBox(width: dimensions.space8),
                ] else if (icon != null) ...[
                  Icon(
                    icon,
                    size: dimensions.iconSizeMedium,
                    color: colors.textPrimary,
                  ),
                  SizedBox(width: dimensions.space8),
                ],
                Text(
                  label,
                  style: tokens.typography.body1.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                if (onDeleted != null) ...[
                  SizedBox(width: dimensions.space8),
                  Semantics(
                    button: true,
                    label: context.sldsStrings.removeItem(label),
                    child: InkWell(
                      onTap: onDeleted,
                      borderRadius: BorderRadius.circular(
                        dimensions.radiusFull,
                      ),
                      child: Icon(
                        Icons.close,
                        size: dimensions.iconSizeMedium,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
