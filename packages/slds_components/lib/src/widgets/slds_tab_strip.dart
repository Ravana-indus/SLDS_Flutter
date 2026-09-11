import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_bottom_nav.dart'
    show SldsBottomNav;
import 'package:slds_components/src/widgets/slds_focus.dart';

/// One tab in an [SldsTabStrip].
class SldsTabStripItem {
  /// Creates a tab.
  const SldsTabStripItem({
    required this.label,
    this.count,
    this.leadingIcon = false,
    this.trailingIcon = false,
  });

  /// The tab's visible text, and its accessible name.
  final String label;

  /// Shown as a small numeric badge trailing the label (e.g. an item count
  /// for that tab). Null hides the badge.
  final int? count;

  /// Shows the circle glyph before the label. Decorative and independent of
  /// selection — Figma draws it on active and default tabs alike.
  final bool leadingIcon;

  /// Shows the circle glyph after the label. See [leadingIcon].
  final bool trailingIcon;
}

/// Visual container styles for [SldsTabStrip] — mirrors [SldsBottomNav]'s
/// light/dark choice; independent of the app's own light/dark theme.
enum SldsTabStripStyle {
  /// Dark text on a light strip.
  light,

  /// Light text on a dark strip.
  dark,
}

/// SLDS tab strip / segmented control — a row of [items], the selected one
/// shown as a raised pill over a sunken track. Each tab is sized to its own
/// content, as in the Figma spec, rather than to an equal share of the
/// strip: equal shares squeezed long labels down to an ellipsis on narrow
/// viewports. Labels still ellipsize if the strip itself is too narrow, so
/// wrap it in a horizontally scrolling parent when the tabs cannot fit.
class SldsTabStrip extends StatelessWidget {
  /// Creates a tab strip.
  const SldsTabStrip({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
    this.style = SldsTabStripStyle.light,
  });

  /// The tabs, in display order.
  final List<SldsTabStripItem> items;

  /// Index into [items] of the selected tab.
  final int currentIndex;

  /// Called with the tapped tab's index. Null makes the strip read-only.
  final ValueChanged<int>? onTap;

  /// Which of the two token palettes the strip is drawn in.
  final SldsTabStripStyle style;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final dark = style == SldsTabStripStyle.dark;
    final track = dark ? colors.surfaceInverse : colors.surfaceSunken;
    // ponytail: dark pill approximates Figma #010102 with pure black; a
    // dedicated tab-bar/background token would carry the exact 1-unit delta.
    final pill = dark ? colors.surfaceInverse : colors.surfacePage;
    final labelColor = dark ? colors.textInverse : colors.textPrimary;

    return Container(
      padding: EdgeInsets.all(dimensions.space4),
      decoration: BoxDecoration(
        color: track,
        borderRadius: BorderRadius.circular(dimensions.radius3xl),
      ),
      // The strip hugs its content vertically: a decorated Container in a
      // height-unbounded parent (a Center, a Column) would otherwise stretch
      // to the full available height and drag every tab with it.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) SizedBox(width: dimensions.space8),
                Flexible(
                  child: _Tab(
                    item: items[i],
                    selected: i == currentIndex,
                    pillColor: pill,
                    textColor: labelColor,
                    onTap: onTap == null ? null : () => onTap!(i),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Figma's inner gap between a tab's icon, label and badge. Off the
/// spacing scale (3px), so it is not a spacing token.
const double _gap = 3;

class _Tab extends StatelessWidget {
  const _Tab({
    required this.item,
    required this.selected,
    required this.pillColor,
    required this.textColor,
    required this.onTap,
  });

  final SldsTabStripItem item;
  final bool selected;
  final Color pillColor;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    // Semantics outside SldsTapTarget: nested the other way the node is the
    // inner pill (38dp tall) rather than the expanded hit area, so the target
    // a screen-reader user must hit stays under the 48dp floor (WCAG 2.5.8).
    return Semantics(
      container: true,
      explicitChildNodes: true,
      button: true,
      selected: selected,
      label: item.label,
      child: SldsTapTarget(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(dimensions.radiusFull),
          child: Container(
            // The pill is the tap target, so it carries the 48dp floor
            // itself: Expanded above constrains width only (WCAG 2.5.8).
            constraints: BoxConstraints(minHeight: dimensions.tapTargetMin),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.space12,
              vertical: dimensions.space4,
            ),
            decoration: BoxDecoration(
              color: selected ? pillColor : Colors.transparent,
              borderRadius: BorderRadius.circular(dimensions.radius2xl),
              // Figma Elevation/1 - Raised, on the selected tab only.
              boxShadow: selected
                  ? const [
                      BoxShadow(
                        color: Color(0x0d000000),
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (item.leadingIcon) ...[
                  Icon(
                    Icons.circle_outlined,
                    size: dimensions.iconSizeMedium,
                    color: textColor,
                  ),
                  const SizedBox(width: _gap),
                ],
                Flexible(
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.typography.body2.copyWith(color: textColor),
                  ),
                ),
                if (item.trailingIcon) ...[
                  const SizedBox(width: _gap),
                  Icon(
                    Icons.circle_outlined,
                    size: dimensions.iconSizeMedium,
                    color: textColor,
                  ),
                ],
                if (item.count != null) ...[
                  const SizedBox(width: _gap),
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      maxWidth: 34,
                    ),
                    alignment: Alignment.center,
                    height: 16,
                    padding: EdgeInsets.symmetric(
                      horizontal: dimensions.space8,
                    ),
                    decoration: BoxDecoration(
                      color: colors.badgeInReviewBackground,
                      borderRadius: BorderRadius.circular(
                        dimensions.radiusFull,
                      ),
                    ),
                    child: Text(
                      '${item.count}',
                      textAlign: TextAlign.center,
                      style: tokens.typography.caption2.copyWith(
                        color: colors.badgeInReviewText,
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
