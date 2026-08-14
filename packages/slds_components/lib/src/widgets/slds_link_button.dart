import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// SLDS inline text link — underlined, no button chrome/tap-target padding.
/// Use inside body copy or wherever an [SldsButton] would be visually too
/// heavy. Thin wrapper over [TextButton] so hover/focus/pressed/disabled
/// resolve natively via [WidgetStateProperty]. Colors resolve from the
/// ambient [Theme]'s [ColorScheme] (light/dark aware); pass [color] to
/// override for one instance.
class SldsLinkButton extends StatelessWidget {
  const SldsLinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Overrides the token-driven color for this instance only.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = color ?? Theme.of(context).colorScheme.primary;

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        minimumSize: const WidgetStatePropertyAll(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return context.slds.colors.disabledForeground;
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed)) {
            return Color.lerp(base, Colors.black, 0.16);
          }
          return base;
        }),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }
}
