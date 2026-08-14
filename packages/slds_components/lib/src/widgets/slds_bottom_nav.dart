import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// One destination in an [SldsBottomNav].
class SldsBottomNavItem {
  const SldsBottomNavItem({
    required this.icon,
    required this.label,
    this.badgeCount,
    this.enabled = true,
  });

  final IconData icon;
  final String label;

  /// Shown as a small red count badge over the icon; values over 99 render
  /// as "99+". Null/0 hides the badge — a disabled item can still show one
  /// (e.g. a pending count on a destination the user can't open yet).
  final int? badgeCount;

  /// A disabled item renders a neutral (white/near-black) pill with a muted
  /// label and does not respond to taps, regardless of [SldsBottomNav.onTap].
  final bool enabled;
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
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
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
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.space8,
        vertical: dimensions.space8,
      ),
      decoration: BoxDecoration(
        color: dark ? Colors.black : colors.surfaceCard,
        border: dark
            ? null
            : Border(top: BorderSide(color: colors.borderDefault)),
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

    // Disabled: a neutral (white on light, near-black on dark) pill with a
    // dark/light-but-muted icon and a gray label — never selected-looking,
    // never interactive, regardless of style. Dark bar: selected pill is
    // solid gold with a dark icon *inside* it for contrast — but the label
    // sits below the pill on the black background, so it stays white
    // regardless of selection (dark-on-black would be invisible). Light
    // bar: selected pill is solid gold too (matches the Figma "Bottom
    // Navigation element" spec, not a soft tint); unselected is plain gray
    // with no pill.
    final Color iconColor;
    final Color labelColor;
    final Color pillColor;
    if (!item.enabled) {
      iconColor = colors.disabledForeground;
      labelColor = colors.disabledForeground;
      pillColor = dark ? colors.disabledBackground : Colors.white;
    } else if (dark) {
      iconColor = selected ? colors.textStaticBlack : Colors.white;
      labelColor = Colors.white;
      pillColor = selected ? accent : Colors.transparent;
    } else {
      iconColor = selected ? colors.textStaticBlack : colors.textTertiary;
      labelColor = selected ? colors.textPrimary : colors.textTertiary;
      pillColor = selected ? accent : Colors.transparent;
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      button: true,
      enabled: item.enabled,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: item.enabled ? onTap : null,
        borderRadius: BorderRadius.circular(dimensions.radiusFull),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: dimensions.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: dimensions.space20,
                  vertical: dimensions.space8,
                ),
                decoration: BoxDecoration(
                  color: pillColor,
                  borderRadius: BorderRadius.circular(dimensions.radiusFull),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      item.icon,
                      size: dimensions.iconSizeMedium,
                      color: iconColor,
                    ),
                    if (item.badgeCount != null && item.badgeCount! > 0)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: _CountBadge(
                          count: item.badgeCount!,
                          background: colors.notificationBadgeBackground,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: dimensions.space4),
              Text(
                item.label,
                style: tokens.typography.caption1.copyWith(
                  color: labelColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
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
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
