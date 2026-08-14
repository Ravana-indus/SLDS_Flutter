import 'package:flutter/material.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_bottom_nav.dart'
    show SldsBottomNav;

/// Visual container styles for [SldsTopNavBar] — mirrors [SldsBottomNav]'s
/// light/dark choice; independent of the app's own light/dark theme.
enum SldsTopNavBarStyle { light, dark }

/// SLDS top navigation bar — a back chevron, a center content area (a
/// [title] string, or an [SldsTopNavBar.progress] constructor's segmented
/// step indicator), and a trailing hamburger menu icon. Responsive: the
/// title/progress area expands to fill whatever width remains between the
/// two fixed icon buttons.
class SldsTopNavBar extends StatelessWidget {
  /// A bar showing a plain [title] between the back and menu icons.
  const SldsTopNavBar({
    required this.title,
    super.key,
    this.onBack,
    this.onMenu,
    this.style = SldsTopNavBarStyle.light,
    this.color,
  }) : totalSteps = null,
       currentStep = null;

  /// A bar showing a segmented step-progress indicator instead of a title
  /// (e.g. a multi-page form's position) between the back and menu icons.
  /// [currentStep] (0-based) segments render filled with the accent color,
  /// the rest render as plain pills.
  const SldsTopNavBar.progress({
    required int this.totalSteps,
    required int this.currentStep,
    super.key,
    this.onBack,
    this.onMenu,
    this.style = SldsTopNavBarStyle.light,
    this.color,
  }) : title = null;

  final String? title;
  final int? totalSteps;
  final int? currentStep;

  /// Null hides the back button.
  final VoidCallback? onBack;

  /// Null hides the menu button.
  final VoidCallback? onMenu;

  final SldsTopNavBarStyle style;

  /// Overrides the token-driven accent color for filled progress segments.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final dark = style == SldsTopNavBarStyle.dark;
    final accent = color ?? colors.buttonPrimaryBackground;
    final foreground = dark ? Colors.white : colors.textPrimary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.space16,
        vertical: dimensions.space12,
      ),
      decoration: BoxDecoration(
        color: dark ? Colors.black : colors.surfaceCard,
        border: dark
            ? null
            : Border(bottom: BorderSide(color: colors.borderDefault)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            _IconSlot(
              icon: Icons.chevron_left,
              onTap: onBack,
              color: foreground,
              semanticLabel: 'Back',
            ),
            SizedBox(width: dimensions.space12),
            Expanded(
              child: totalSteps != null
                  ? _StepProgress(
                      total: totalSteps!,
                      current: currentStep!,
                      accent: accent,
                      inactiveColor: dark ? Colors.white : colors.borderDefault,
                    )
                  : Text(
                      title!,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.typography.desktopTitle1.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
            SizedBox(width: dimensions.space12),
            _IconSlot(
              icon: Icons.menu,
              onTap: onMenu,
              color: foreground,
              semanticLabel: 'Menu',
            ),
          ],
        ),
      ),
    );
  }
}

class _IconSlot extends StatelessWidget {
  const _IconSlot({
    required this.icon,
    required this.onTap,
    required this.color,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.slds.dimensions;
    // Both branches reserve the same box, so enabling or disabling an action
    // does not shift the rest of the row sideways.
    final box = BoxConstraints(
      minWidth: dimensions.tapTargetMin,
      minHeight: dimensions.tapTargetMin,
    );

    if (onTap == null) {
      return ConstrainedBox(constraints: box, child: const SizedBox.shrink());
    }
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: ConstrainedBox(
          constraints: box,
          child: Icon(icon, size: dimensions.avatarSize24, color: color),
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({
    required this.total,
    required this.current,
    required this.accent,
    required this.inactiveColor,
  });

  final int total;
  final int current;
  final Color accent;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: i < current ? accent : inactiveColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
