import 'package:flutter/material.dart';

import 'package:slds_components/slds_components.dart' show SldsAvatar;
import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_avatar.dart' show SldsAvatar;
import 'package:slds_components/src/widgets/slds_focus.dart';

/// SLDS chip — a pill-shaped label with an optional leading [avatar]/[icon]
/// and an optional trailing close button (shown when [onDeleted] is set).
/// Used for selected filters/tags (e.g. an assignee chip with a photo and
/// a remove action).
class SldsChip extends StatelessWidget {
  /// Creates a chip.
  const SldsChip({
    required this.label,
    super.key,
    this.avatar,
    this.icon,
    this.onDeleted,
    this.onTap,
  });

  /// The chip's visible text, and its accessible name.
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
    // Figma's chip (512:1016) reads badge/neutral/background explicitly —
    // the same hex as surfaceHover in light mode, but they diverge in dark
    // and high-contrast, where surfaceHover would have painted the wrong
    // colour.
    final background = colors.badgeNeutralBackground;

    Widget chip = Semantics(
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
            // Figma's chip is pl:4 pr:8 py:4 — tighter on the leading
            // edge, where the icon already carries some visual padding
            // inside its own 20px box, than on the trailing edge.
            padding: EdgeInsetsDirectional.fromSTEB(
              dimensions.space4,
              dimensions.space4,
              dimensions.space8,
              dimensions.space4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (avatar != null) ...[
                  avatar!,
                  SizedBox(width: dimensions.space4),
                ] else if (icon != null) ...[
                  Icon(
                    icon,
                    size: dimensions.iconSizeMedium,
                    color: colors.textPrimary,
                  ),
                  SizedBox(width: dimensions.space4),
                ],
                Text(
                  label,
                  style: tokens.typography.body1.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                if (onDeleted != null) ...[
                  SizedBox(width: dimensions.space8),
                  // Figma's × is 16px. SldsOverflowTapTarget grows the real
                  // *hit-test* area to the WCAG 2.5.8 48px floor without
                  // claiming layout space, which would otherwise stretch
                  // the pill past spec (the original bug this shape fixed).
                  // A tap genuinely anywhere in that 48x48 area reaches the
                  // button — see "tapping the close icon fires onDeleted"
                  // in slds_chip_test.dart.
                  //
                  // What it cannot do is make automated tooling *read* that
                  // 48x48 as the tappable rect: Semantics geometry always
                  // comes from a real RenderObject's own paint bounds, and
                  // MergeSemantics unions node *properties* (label, actions,
                  // flags), never geometry — confirmed by dumping this
                  // exact tree (see the chip exception recorded in
                  // slds_accessibility_coverage_test.dart). A visually tiny,
                  // truly-48px-tappable control cannot ever report a
                  // matching 16x16 accessibility rect in Flutter as it
                  // stands, so this fixture is a documented exception
                  // there, not a real gap.
                  Semantics(
                    button: true,
                    label: context.sldsStrings.removeItem(label),
                    child: SldsOverflowTapTarget(
                      onTap: onDeleted!,
                      child: Icon(
                        Icons.close,
                        size: dimensions.iconSizeSmall,
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

    // Figma's pill hugs its content (28-32px tall) at every variant. The
    // blanket SldsTapTarget this used to wrap *every* chip in stretched
    // even a purely informational, non-interactive one — with nothing to
    // tap — up to the 48dp WCAG 2.5.8 floor, which is what made an
    // icon-less, onDeleted-only chip visibly balloon next to its siblings.
    // Only a chip whose body is actually tappable needs that floor at all.
    if (onTap != null) {
      chip = SldsTapTarget(child: chip);
    }

    return chip;
  }
}
