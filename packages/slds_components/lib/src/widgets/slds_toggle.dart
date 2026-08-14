import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// SLDS toggle sizes.
enum SldsToggleSize {
  large(width: 48, height: 28, thumb: 22),
  small(width: 40, height: 24, thumb: 18)
  ;

  const SldsToggleSize({
    required this.width,
    required this.height,
    required this.thumb,
  });

  final double width;
  final double height;
  final double thumb;
}

/// SLDS toggle/switch — a pill track that fills gold when [value] is true
/// (gray track otherwise), a white thumb that slides to the active side, a
/// gold focus ring while focused via keyboard/tap-down, and dimmed when
/// [enabled] is false.
///
/// Colors resolve from the ambient [Theme]'s [ColorScheme] (light/dark
/// aware); pass [color] to override the accent for one instance.
class SldsToggle extends StatefulWidget {
  const SldsToggle({
    required this.value,
    required this.onChanged,
    super.key,
    this.size = SldsToggleSize.large,
    this.enabled = true,
    this.color,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final SldsToggleSize size;
  final bool enabled;

  /// Overrides the token-driven accent color for this instance only.
  final Color? color;

  @override
  State<SldsToggle> createState() => _SldsToggleState();
}

class _SldsToggleState extends State<SldsToggle> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(
      () => setState(() => _focused = _focusNode.hasFocus),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _enabled => widget.enabled && widget.onChanged != null;

  void _toggle() {
    if (!_enabled) return;
    widget.onChanged!.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = context.slds.dimensions;
    final scheme = Theme.of(context).colorScheme;
    final accent = widget.color ?? scheme.primary;

    final Color trackColor;
    final Color thumbColor;
    if (!_enabled) {
      trackColor = widget.value
          ? accent.withValues(alpha: context.slds.opacities.disabled)
          : scheme.onSurface.withValues(alpha: 0.12);
      thumbColor = widget.value
          ? scheme.surface
          : scheme.onSurface.withValues(alpha: context.slds.opacities.disabled);
    } else if (widget.value) {
      trackColor = accent;
      thumbColor = scheme.surface;
    } else {
      trackColor = scheme.onSurface.withValues(alpha: 0.16);
      thumbColor = scheme.surface;
    }

    final trackPadding = (widget.size.height - widget.size.thumb) / 2;

    // The track keeps its designed size; the tappable area around it is
    // expanded to the 48x48 minimum instead. Shrinking the visual switch to
    // fit, or leaving a 28px-tall tap target, would each fail one of the two
    // requirements — this satisfies both.
    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        onTap: _toggle,
        behavior: HitTestBehavior.opaque,
        child: Container(
          constraints: BoxConstraints(
            minWidth: dimensions.tapTargetMin,
            minHeight: dimensions.tapTargetMin,
          ),
          alignment: Alignment.center,
          child: Container(
            width: widget.size.width,
            height: widget.size.height,
            padding: _focused
                ? EdgeInsets.all(dimensions.controlBorderWidth * 2)
                : EdgeInsets.zero,
            // focusRing, not the accent: only the former is contrast-checked
            // against every surface the control can sit on (WCAG 1.4.11).
            decoration: _focused
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      (widget.size.height + dimensions.controlBorderWidth * 4) /
                          2,
                    ),
                    border: Border.all(
                      color: context.slds.colors.focusRing,
                      width: dimensions.emphasizedBorderWidth,
                    ),
                  )
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(horizontal: trackPadding),
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: BorderRadius.circular(widget.size.height / 2),
              ),
              alignment: widget.value
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                width: widget.size.thumb,
                height: widget.size.thumb,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: thumbColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
