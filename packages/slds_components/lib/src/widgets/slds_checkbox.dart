import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// SLDS checkbox sizes.
enum SldsCheckboxSize {
  large(box: 24, icon: 16),
  small(box: 20, icon: 14)
  ;

  const SldsCheckboxSize({required this.box, required this.icon});

  final double box;
  final double icon;
}

/// SLDS checkbox — a rounded-square box that fills with the accent color
/// (a white check, or a dash for [SldsTristate.indeterminate]) once
/// checked, plain outline while unchecked, a gold focus ring while focused
/// via keyboard/tap-down, and dimmed when [enabled] is false.
///
/// Tristate: pass [value] as `null` for the indeterminate ("some but not
/// all selected") state — matches [Checkbox.tristate] semantics. Colors
/// resolve from the ambient [Theme]'s [ColorScheme] (light/dark aware);
/// pass [color] to override the accent for one instance.
class SldsCheckbox extends StatefulWidget {
  const SldsCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.size = SldsCheckboxSize.large,
    this.enabled = true,
    this.color,
  });

  /// `true` checked, `false` unchecked, `null` indeterminate.
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final SldsCheckboxSize size;
  final bool enabled;

  /// Overrides the token-driven accent color for this instance only.
  final Color? color;

  @override
  State<SldsCheckbox> createState() => _SldsCheckboxState();
}

class _SldsCheckboxState extends State<SldsCheckbox> {
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
    // Tapping cycles false -> true -> false; indeterminate (null) only ever
    // arrives from the caller (e.g. a "select all" parent checkbox), never
    // from a direct tap here — matches Checkbox's own default tristate feel.
    widget.onChanged!.call(!(widget.value ?? false));
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = context.slds.dimensions;
    final scheme = Theme.of(context).colorScheme;
    final accent = widget.color ?? scheme.primary;
    final filled = (widget.value ?? false) || widget.value == null;

    final Color boxColor;
    final Color borderColor;
    final Color iconColor;
    if (!_enabled) {
      boxColor = filled
          ? context.slds.colors.disabledBackground
          : Colors.transparent;
      borderColor = context.slds.colors.disabledBorder;
      iconColor = context.slds.colors.disabledForeground;
    } else if (filled) {
      boxColor = accent;
      borderColor = accent;
      iconColor =
          ThemeData.estimateBrightnessForColor(accent) == Brightness.dark
          ? Colors.white
          : Colors.black;
    } else {
      boxColor = Colors.transparent;
      borderColor = scheme.outline;
      iconColor = Colors.transparent;
    }

    final radius = widget.size.box / 6;

    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          width: widget.size.box,
          height: widget.size.box,
          padding: _focused
              ? EdgeInsets.all(dimensions.controlBorderWidth * 2)
              : EdgeInsets.zero,
          // focusRing, not the accent: only the former is contrast-checked
          // against every surface the control can sit on (WCAG 1.4.11).
          decoration: _focused
              ? BoxDecoration(
                  border: Border.all(
                    color: context.slds.colors.focusRing,
                    width: dimensions.emphasizedBorderWidth,
                  ),
                  borderRadius: BorderRadius.circular(
                    radius + dimensions.controlBorderWidth * 2,
                  ),
                )
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: widget.value == null
                ? Center(
                    child: Container(
                      width: widget.size.icon * 0.7,
                      height: 2,
                      color: iconColor,
                    ),
                  )
                : (widget.value ?? false
                      ? Icon(
                          Icons.check,
                          size: widget.size.icon,
                          color: iconColor,
                        )
                      : null),
          ),
        ),
      ),
    );
  }
}
