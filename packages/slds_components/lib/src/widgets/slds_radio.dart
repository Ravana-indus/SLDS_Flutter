import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_focus.dart';

/// SLDS radio sizes.
enum SldsRadioSize {
  /// 24px circle with a 10px dot.
  large(circle: 24, dot: 10),

  /// 20px circle with an 8px dot.
  small(circle: 20, dot: 8)
  ;

  const SldsRadioSize({required this.circle, required this.dot});

  /// Outer circle diameter in logical pixels.
  final double circle;

  /// Selected dot diameter in logical pixels.
  final double dot;
}

/// SLDS radio button — a ring that fills with a solid accent-color dot when
/// [value] == [groupValue], a gold focus ring while focused via
/// keyboard/tap-down, and dimmed when [enabled] is false. Group several
/// under the same [groupValue]/[onChanged] pair, one per [value], exactly
/// like Flutter's own [Radio].
///
/// Colors resolve from the ambient [Theme]'s [ColorScheme] (light/dark
/// aware); pass [color] to override the accent for one instance.
class SldsRadio<T> extends StatefulWidget {
  /// Creates a radio button.
  const SldsRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
    this.size = SldsRadioSize.large,
    this.enabled = true,
    this.semanticLabel,
  });

  /// The value this button represents within its group.
  final T value;

  /// The group's currently selected value.
  final T? groupValue;

  /// Called with [value] when this button is selected. Null disables it.
  final ValueChanged<T>? onChanged;

  /// Circle and dot size.
  final SldsRadioSize size;

  /// Whether the control accepts input.
  final bool enabled;

  /// What this option means, for assistive technology.
  ///
  /// A radio announced as "selected" without naming the option tells a
  /// screen-reader user nothing.
  final String? semanticLabel;

  @override
  State<SldsRadio<T>> createState() => _SldsRadioState<T>();
}

class _SldsRadioState<T> extends State<SldsRadio<T>> {
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
  bool get _selected => widget.value == widget.groupValue;

  void _select() {
    if (!_enabled || _selected) return;
    widget.onChanged!.call(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final dimensions = tokens.dimensions;
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;

    final Color ringColor;
    final Color dotColor;
    if (!_enabled) {
      ringColor = scheme.outline.withValues(
        alpha: context.slds.opacities.disabled,
      );
      dotColor = scheme.onSurface.withValues(
        alpha: context.slds.opacities.disabled,
      );
    } else if (_selected) {
      ringColor = accent;
      dotColor = accent;
    } else {
      ringColor = scheme.outline;
      dotColor = Colors.transparent;
    }

    // inMutuallyExclusiveGroup is what tells a screen reader this is a radio
    // rather than a checkbox — that one flag changes how the whole group is
    // announced and navigated.
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: _selected,
      enabled: _enabled,
      label: widget.semanticLabel,
      onTap: _enabled ? _select : null,
      // The inner GestureDetector would otherwise surface as a second,
      // unlabelled tappable node beside this one.
      excludeSemantics: true,
      child: Focus(
        focusNode: _focusNode,
        child: SldsTapTarget(
          child: GestureDetector(
            onTap: _select,
            child: Container(
              width: widget.size.circle,
              height: widget.size.circle,
              padding: _focused
                  ? EdgeInsets.all(dimensions.controlBorderWidth * 2)
                  : EdgeInsets.zero,
              // The focus stroke reads from focusRing, which is
              // contrast-checked
              // against every surface; the accent gold is not (1.4.11).
              decoration: _focused
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.slds.colors.focusRing,
                        width: dimensions.emphasizedBorderWidth,
                      ),
                    )
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ringColor, width: 1.5),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: tokens.motion.fast,
                    width: _selected ? widget.size.dot : 0,
                    height: _selected ? widget.size.dot : 0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
