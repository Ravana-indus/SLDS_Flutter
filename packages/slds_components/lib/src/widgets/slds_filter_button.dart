import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart' show SldsFilterDropdown;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_filter_dropdown.dart'
    show SldsFilterDropdown;

/// SLDS filter button — a pill-shaped trigger for opening a filter panel
/// (typically an [SldsFilterDropdown]), with a trailing chevron and an
/// optional [count] badge. Renders as a solid accent pill once [count] is
/// set (an active filter has selections), otherwise a plain outlined pill.
///
/// This is just the trigger — wire [onTap] to show your own panel/dropdown
/// (e.g. via [showModalBottomSheet] or an [OverlayEntry] wrapping
/// [SldsFilterDropdown]); no popover behavior is baked in.
class SldsFilterButton extends StatelessWidget {
  const SldsFilterButton({
    required this.label,
    super.key,
    this.count,
    this.onTap,
    this.enabled = true,
    this.color,
  });

  final String label;

  /// Number of active selections for this filter — shown as a badge and
  /// switches the pill to its filled/active look. Null or 0 renders the
  /// plain outlined look with no badge.
  final int? count;

  final VoidCallback? onTap;
  final bool enabled;

  /// Overrides the token-driven accent color for this instance only.
  final Color? color;

  bool get _active => count != null && count! > 0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final accent = color ?? colors.buttonPrimaryBackground;
    final interactive = enabled && onTap != null;

    final Color background;
    final Color foreground;
    final Color borderColor;
    if (!enabled) {
      background = colors.disabledBackground;
      foreground = colors.disabledForeground;
      borderColor = colors.disabledBorder;
    } else if (_active) {
      background = accent;
      foreground = colors.buttonPrimaryLabel;
      borderColor = accent;
    } else {
      background = colors.surfaceCard;
      foreground = colors.textPrimary;
      borderColor = colors.borderDefault;
    }

    return InkWell(
      onTap: interactive ? onTap : null,
      borderRadius: BorderRadius.circular(dimensions.radiusFull),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dimensions.space16,
          vertical: dimensions.space8,
        ),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(dimensions.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: tokens.typography.compactLabel.copyWith(color: foreground),
            ),
            if (_active) ...[
              SizedBox(width: dimensions.space8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: dimensions.space6),
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: tokens.typography.caption2.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            SizedBox(width: dimensions.space4),
            Icon(
              Icons.keyboard_arrow_down,
              size: dimensions.iconSizeMedium,
              color: foreground,
            ),
          ],
        ),
      ),
    );
  }
}
