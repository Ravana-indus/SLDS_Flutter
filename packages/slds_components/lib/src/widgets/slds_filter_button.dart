import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart' show SldsFilterDropdown;
import 'package:slds_components/src/l10n/slds_strings.dart';
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
  /// Creates a filter button.
  const SldsFilterButton({
    required this.label,
    super.key,
    this.count,
    this.onTap,
    this.enabled = true,
  });

  /// The button's visible text, and its accessible name.
  final String label;

  /// Number of active selections for this filter — shown as a badge and
  /// switches the pill to its filled/active look. Null or 0 renders the
  /// plain outlined look with no badge.
  final int? count;

  /// Called when the button is tapped.
  final VoidCallback? onTap;

  /// Whether the button responds to taps.
  final bool enabled;

  bool get _active => count != null && count! > 0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final accent = colors.buttonPrimaryBackground;
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

    return Semantics(
      // The badge count is the filter's state and reads as a bare numeral
      // next to the label; spelling it into the name is what tells a reader
      // the filter is active and by how much.
      button: true,
      enabled: interactive,
      label: _active
          ? context.sldsStrings.labelledValue(label, '$count')
          : label,
      excludeSemantics: true,
      child: InkWell(
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
              // Flexible so a long label (Sinhala or Tamil at 2x text) wraps
              // inside the pill instead of pushing the count and caret out
              // of it (#151). Figma: 14/22, 400 deselected (#152) and 500
              // selected.
              Flexible(
                child: Text(
                  label,
                  style: tokens.typography.body2.copyWith(
                    color: foreground,
                    fontWeight: _active ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
              if (_active) ...[
                SizedBox(width: dimensions.space8),
                // Figma: a 20px white circle round a 14/400 #17171A count
                // (#150). The line is held to the circle's 20px so the
                // badge stays round; a pill once the count needs more room.
                Container(
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: dimensions.space4),
                  decoration: BoxDecoration(
                    color: colors.surfaceCard,
                    borderRadius: BorderRadius.circular(dimensions.radiusFull),
                  ),
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: tokens.typography.body2.copyWith(
                      height: 20 / 14,
                      color: colors.textPrimary,
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
      ),
    );
  }
}
