import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_bottom_nav.dart'
    show SldsBottomNav;

/// Visual container styles for [SldsTopNavBar] — mirrors [SldsBottomNav]'s
/// light/dark choice. Under a dark theme the bar is always drawn [dark],
/// as Figma's dark mode draws it, whichever style is passed.
enum SldsTopNavBarStyle {
  /// Dark content on a light bar.
  light,

  /// Light content on a dark bar.
  dark,
}

/// SLDS top navigation bar — a back chevron, a center content area (a
/// [title] string, or an [SldsTopNavBar.progress] constructor's segmented
/// step indicator), and a trailing hamburger menu icon. Responsive: the
/// title/progress area expands to fill whatever width remains between the
/// two fixed icon buttons.
///
/// The bar is Figma's 64px and carries no status-bar inset: place it inside
/// a [SafeArea] (or below an [AppBar]) at the top of the screen.
class SldsTopNavBar extends StatelessWidget {
  /// A bar showing a plain [title] between the back and menu icons.
  const SldsTopNavBar({
    required this.title,
    super.key,
    this.onBack,
    this.onMenu,
    this.style = SldsTopNavBarStyle.light,
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
  }) : title = null;

  /// The page heading, beside the back button and centred vertically.
  /// Null in the progress variant, which shows a step indicator instead.
  final String? title;

  /// Total steps in the flow, for the progress variant.
  final int? totalSteps;

  /// How many steps are complete, for the progress variant.
  final int? currentStep;

  /// Null hides the back button.
  final VoidCallback? onBack;

  /// Null hides the menu button.
  final VoidCallback? onMenu;

  /// Which of the two token palettes the bar is drawn in.
  final SldsTopNavBarStyle style;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    // As with SldsTabStrip, a dark theme draws the dark bar, as Figma's
    // dark mode does (#184).
    final dark =
        style == SldsTopNavBarStyle.dark ||
        Theme.of(context).brightness == Brightness.dark;
    final accent = colors.buttonPrimaryBackground;
    final foreground = dark ? colors.textInverse : colors.textPrimary;

    // Figma Top Navigation Bar (346:2950): a 64px bar, 8px padding, on
    // Tab Bar/Background — #F7F7F7 light (#183), #010102 dark (#184) — with
    // no divider. The content is centred in it; the bar carries no
    // status-bar inset of its own, which pushed the row to the bottom of a
    // taller bar wherever it was not at the very top of the screen (#181).
    // Wrap the screen in a SafeArea to keep the bar below the status bar.
    return Container(
      padding: EdgeInsets.all(dimensions.space8),
      color: dark ? colors.barBackgroundDark : colors.surfacePage,
      child: Row(
        children: [
          _IconSlot(
            icon: Icons.chevron_left,
            onTap: onBack,
            color: foreground,
            semanticLabel: context.sldsStrings.back,
          ),
          SizedBox(width: dimensions.space4),
          Expanded(
            child: totalSteps != null
                // Figma's Stepper insets the steps 16px inside the title slot.
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: dimensions.space16,
                    ),
                    child: _StepProgress(
                      total: totalSteps!,
                      current: currentStep!,
                      accent: accent,
                      // Figma Progress/Track: #FFFFFF pending steps (#186).
                      inactiveColor: dark
                          ? colors.textInverse
                          : colors.headerProgressTrack,
                    ),
                  )
                // Figma Mobile/Title 1: 18/500/24, Text/Primary (#181).
                : Text(
                    title!,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.typography.title1.copyWith(
                      color: foreground,
                    ),
                  ),
          ),
          SizedBox(width: dimensions.space4),
          _IconSlot(
            icon: Icons.menu,
            onTap: onMenu,
            color: foreground,
            semanticLabel: context.sldsStrings.menu,
          ),
        ],
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
