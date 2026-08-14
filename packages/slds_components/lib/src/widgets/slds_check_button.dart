import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// SLDS check button — a full-width, filled-pill toggle (not a checkbox
/// glyph): selected renders as a solid accent-color block, unselected as a
/// plain outlined block. Used for single choices presented as a stack of
/// tappable blocks (e.g. a settings toggle list) rather than inline
/// checkboxes.
class SldsCheckButton extends StatelessWidget {
  const SldsCheckButton({
    required this.label,
    required this.selected,
    super.key,
    this.onChanged,
    this.enabled = true,
    this.color,
  });

  final String label;
  final bool selected;

  /// Invoked with the new selected value on tap. Null (or [enabled] false)
  /// makes the button non-interactive.
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  /// Overrides the token-driven accent color for this instance only.
  final Color? color;

  bool get _interactive => enabled && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final accent = color ?? colors.buttonPrimaryBackground;

    final Color background;
    final Color foreground;
    final Color borderColor;
    if (!enabled) {
      background = selected ? colors.disabledBackground : colors.surfaceCard;
      foreground = colors.disabledForeground;
      borderColor = colors.disabledBorder;
    } else if (selected) {
      background = accent;
      foreground = colors.buttonPrimaryLabel;
      borderColor = accent;
    } else {
      background = colors.surfaceCard;
      foreground = colors.textPrimary;
      borderColor = colors.borderDefault;
    }

    return InkWell(
      onTap: _interactive ? () => onChanged!.call(!selected) : null,
      borderRadius: BorderRadius.circular(dimensions.radiusLg),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: dimensions.space16,
          vertical: dimensions.space12,
        ),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(dimensions.radiusLg),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: tokens.typography.compactLabel.copyWith(
            color: foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
