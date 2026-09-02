import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart' show SldsBottomNav;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_bottom_nav.dart'
    show SldsBottomNav;

/// One tab in an [SldsTabStrip].
class SldsTabStripItem {
  /// Creates a tab.
  const SldsTabStripItem({
    required this.label,
    this.count,
    this.indicatorLeading = true,
  });

  /// The tab's visible text, and its accessible name.
  final String label;

  /// Shown as a small numeric badge trailing the label (e.g. an item count
  /// for that tab). Null hides the badge.
  final int? count;

  /// While unselected, an empty radio-outline indicator is shown beside the
  /// label — before it when true, after it when false. Purely a layout
  /// choice (the Figma spec alternates it per tab); it carries no
  /// selection state itself, [SldsTabStrip.currentIndex] does.
  final bool indicatorLeading;
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
/// shown as a raised pill over a track background. Responsive: tabs share
/// the strip's width equally via [Expanded] and each label ellipsizes, so
/// it reflows to any width without a fixed per-tab size; wrap in a
/// horizontally scrolling parent yourself if you need un-shrunk labels on
/// narrow screens instead.
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
    final track = (dark ? Colors.black : colors.surfaceCard);
    final pill = dark
        ? colors.surfaceHover.withValues(alpha: 0.16)
        : colors.surfaceHover;
    final unselectedText = dark ? Colors.white : colors.textPrimary;

    return Container(
      padding: EdgeInsets.all(dimensions.space4),
      decoration: BoxDecoration(
        color: track,
        borderRadius: BorderRadius.circular(dimensions.radiusFull),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: _Tab(
                item: items[i],
                selected: i == currentIndex,
                pillColor: pill,
                textColor: unselectedText,
                onTap: onTap == null ? null : () => onTap!(i),
              ),
            ),
        ],
      ),
    );
  }
}

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

    return Semantics(
      container: true,
      explicitChildNodes: true,
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(dimensions.radiusFull),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: dimensions.space12,
            vertical: dimensions.space8,
          ),
          decoration: BoxDecoration(
            color: selected ? pillColor : Colors.transparent,
            borderRadius: BorderRadius.circular(dimensions.radiusFull),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!selected && item.indicatorLeading) ...[
                Icon(
                  Icons.radio_button_unchecked,
                  size: dimensions.iconSizeMedium,
                  color: textColor,
                ),
                SizedBox(width: dimensions.space8),
              ],
              Flexible(
                child: Text(
                  item.label,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.body2.copyWith(
                    color: textColor,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (!selected && !item.indicatorLeading) ...[
                SizedBox(width: dimensions.space8),
                Icon(
                  Icons.radio_button_unchecked,
                  size: dimensions.iconSizeMedium,
                  color: textColor,
                ),
              ],
              if (item.count != null) ...[
                SizedBox(width: dimensions.space8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: colors.badgeInfoBackground,
                    borderRadius: BorderRadius.circular(dimensions.radiusFull),
                  ),
                  child: Text(
                    '${item.count}',
                    style: TextStyle(
                      color: colors.badgeInfoText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
