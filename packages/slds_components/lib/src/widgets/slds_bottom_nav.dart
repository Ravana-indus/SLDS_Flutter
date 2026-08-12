import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// One destination in an [SldsBottomNav].
class SldsBottomNavItem {
  const SldsBottomNavItem({required this.icon, required this.label, this.badgeCount});

  final IconData icon;
  final String label;

  /// Shown as a small red count badge over the icon; values over 99 render
  /// as "99+". Null/0 hides the badge.
  final int? badgeCount;
}

/// Visual container styles for [SldsBottomNav].
enum SldsBottomNavStyle {
  /// A light card/page background with a top divider — Figma "Bottom tab bar".
  light,

  /// A solid dark (near-black) bar — Figma "Bottom Navigation" dark variant.
  /// Independent of the app's light/dark theme; this is a deliberate style
  /// choice for the bar itself (e.g. an always-dark app chrome element).
  dark,
}

/// SLDS bottom navigation — 2-5 [items], each an icon + label, with the
/// selected item shown as a gold filled pill (or a plain gold icon/label
/// tint in [SldsBottomNavStyle.light]'s flatter "tab bar" look) and an
/// optional red count badge per item. Responsive: items share the bar's
/// width equally via [Expanded], so it reflows to any phone width without a
/// fixed per-item size.
class SldsBottomNav extends StatelessWidget {
  const SldsBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.style = SldsBottomNavStyle.light,
    this.color,
  });

  final List<SldsBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final SldsBottomNavStyle style;

  /// Overrides the token-driven accent color for the selected item.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final dark = style == SldsBottomNavStyle.dark;
    final accent = color ?? colors.buttonPrimaryBackground;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: dimensions.space8, vertical: dimensions.space8),
      decoration: BoxDecoration(
        color: dark ? Colors.black : colors.surfaceCard,
        border: dark ? null : Border(top: BorderSide(color: colors.borderDefault)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: _NavItem(
                  item: items[i],
                  selected: i == currentIndex,
                  dark: dark,
                  accent: accent,
                  onTap: onTap == null ? null : () => onTap!(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.dark,
    required this.accent,
    required this.onTap,
  });

  final SldsBottomNavItem item;
  final bool selected;
  final bool dark;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    // Dark bar: selected pill is solid gold with a dark icon *inside* it for
    // contrast — but the label sits below the pill on the black background,
    // so it stays white regardless of selection (dark-on-black would be
    // invisible). Unselected items are plain white throughout. Light bar:
    // selected is a soft gold tint with a gold icon/label; unselected is
    // plain gray — no pill background at all, matching the flatter tab-bar look.
    final Color iconColor;
    final Color labelColor;
    final Color? pillColor;
    if (dark) {
      iconColor = selected ? colors.textStaticBlack : Colors.white;
      labelColor = Colors.white;
      pillColor = selected ? accent : null;
    } else {
      iconColor = selected ? accent : colors.textTertiary;
      labelColor = selected ? colors.textPrimary : colors.textTertiary;
      pillColor = selected ? accent.withValues(alpha: 0.16) : null;
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(dimensions.radiusFull),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: dimensions.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: dimensions.space20, vertical: dimensions.space8),
                decoration: BoxDecoration(color: pillColor, borderRadius: BorderRadius.circular(dimensions.radiusFull)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(item.icon, size: dimensions.iconSizeMedium, color: iconColor),
                    if (item.badgeCount != null && item.badgeCount! > 0)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: _CountBadge(count: item.badgeCount!, background: colors.notificationBadgeBackground),
                      ),
                  ],
                ),
              ),
              SizedBox(height: dimensions.space4),
              Text(
                item.label,
                style: tokens.typography.caption1.copyWith(color: labelColor, fontWeight: selected ? FontWeight.w600 : FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.background});

  final int count;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(9)),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }
}
