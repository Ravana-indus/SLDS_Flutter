import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_focus.dart';

/// SLDS checkbox sizes.
enum SldsCheckboxSize {
  /// 24px box with a 16px check.
  large(box: 24, icon: 16),

  /// 20px box with a 14px check.
  small(box: 20, icon: 14)
  ;

  const SldsCheckboxSize({required this.box, required this.icon});

  /// Box edge length in logical pixels.
  final double box;

  /// Check glyph size in logical pixels.
  final double icon;
}

/// SLDS checkbox — a rounded-square box that fills once checked, shows a
/// dash while indeterminate, carries a focus ring while focused, and dims
/// when [enabled] is false.
///
/// Colours resolve from the ambient SLDS token set, so the control follows
/// light, dark and high-contrast themes.
///
/// Tristate: pass [value] as `null` for the indeterminate ("some but not all
/// selected") state, matching [Checkbox.tristate].
///
/// Pass [semanticLabel] naming what is being checked. A checkbox announced
/// as "checked" without saying what is checked tells a screen-reader user
/// nothing, so supply it unless a visible label already sits beside the
/// control inside the same [MergeSemantics] boundary.
class SldsCheckbox extends StatefulWidget {
  /// Creates a checkbox.
  const SldsCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.size = SldsCheckboxSize.large,
    this.enabled = true,
    this.semanticLabel,
  });

  /// `true` checked, `false` unchecked, `null` indeterminate.
  final bool? value;

  /// Called with the new value. Null disables the control.
  final ValueChanged<bool?>? onChanged;

  /// Box and glyph size.
  final SldsCheckboxSize size;

  /// Whether the control accepts input.
  final bool enabled;

  /// What this checkbox controls, for assistive technology.
  final String? semanticLabel;

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
    final tokens = context.slds;
    final dimensions = tokens.dimensions;
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
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

    // Role, state and name in one node. Without this a screen reader reaches
    // an unlabelled box with no indication that it is checkable at all.
    return Semantics(
      checked: widget.value ?? false,
      mixed: widget.value == null,
      enabled: _enabled,
      label: widget.semanticLabel,
      onTap: _enabled ? _toggle : null,
      // The inner GestureDetector would otherwise surface as a second,
      // unlabelled tappable node beside this one.
      excludeSemantics: true,
      child: Focus(
        focusNode: _focusNode,
        child: SldsTapTarget(
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
                duration: tokens.motion.fast,
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
        ),
      ),
    );
  }
}
