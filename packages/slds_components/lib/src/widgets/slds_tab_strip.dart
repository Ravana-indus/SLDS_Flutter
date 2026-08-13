import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// One tab in an [SldsTabStrip].
class SldsTabStripItem {
  const SldsTabStripItem({required this.label, this.count});

  final String label;

  /// Shown as a small numeric badge beside the label (e.g. an item count
  /// for that tab). Null hides the badge.
  final int? count;
}

/// Visual container styles for [SldsTabStrip] — mirrors [SldsBottomNav]'s
/// light/dark choice; independent of the app's own light/dark theme.
enum SldsTabStripStyle { light, dark }

/// SLDS tab strip / segmented control — a row of [items], the selected one
/// shown as a raised pill over a track background. Responsive: tabs share
/// the strip's width equally via [Expanded] and each label ellipsizes, so
/// it reflows to any width without a fixed per-tab size; wrap in a
/// horizontally scrolling parent yourself if you need un-shrunk labels on
/// narrow screens instead.
class SldsTabStrip extends StatelessWidget {
  const SldsTabStrip({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.style = SldsTabStripStyle.light,
    this.color,
  });

  final List<SldsTabStripItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final SldsTabStripStyle style;

  /// Overrides the token-driven track background for this instance only.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final dark = style == SldsTabStripStyle.dark;
    final track = color ?? (dark ? Colors.black : colors.surfaceCard);
    final pill = dark ? colors.surfaceHover.withValues(alpha: 0.16) : colors.surfaceHover;
    final unselectedText = dark ? Colors.white : colors.textPrimary;

    return Container(
      padding: EdgeInsets.all(dimensions.space4),
      decoration: BoxDecoration(color: track, borderRadius: BorderRadius.circular(dimensions.radiusFull)),
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
          padding: EdgeInsets.symmetric(horizontal: dimensions.space12, vertical: dimensions.space8),
          decoration: BoxDecoration(
            color: selected ? pillColor : Colors.transparent,
            borderRadius: BorderRadius.circular(dimensions.radiusFull),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              if (item.count != null) ...[
                SizedBox(width: dimensions.space8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(
                    color: colors.badgeInfoBackground,
                    borderRadius: BorderRadius.circular(dimensions.radiusFull),
                  ),
                  child: Text(
                    '${item.count}',
                    style: TextStyle(color: colors.badgeInfoText, fontSize: 12, fontWeight: FontWeight.w600),
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
