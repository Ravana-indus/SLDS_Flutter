import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// SLDS radio sizes.
enum SldsRadioSize {
  large(circle: 24, dot: 10),
  small(circle: 20, dot: 8)
  ;

  const SldsRadioSize({required this.circle, required this.dot});

  final double circle;
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
  const SldsRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
    this.size = SldsRadioSize.large,
    this.enabled = true,
    this.color,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final SldsRadioSize size;
  final bool enabled;

  /// Overrides the token-driven accent color for this instance only.
  final Color? color;

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
    final dimensions = context.slds.dimensions;
    final scheme = Theme.of(context).colorScheme;
    final accent = widget.color ?? scheme.primary;

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

    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        onTap: _select,
        child: Container(
          width: widget.size.circle,
          height: widget.size.circle,
          padding: _focused
              ? EdgeInsets.all(dimensions.controlBorderWidth * 2)
              : EdgeInsets.zero,
          // The focus stroke reads from focusRing, which is contrast-checked
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
                duration: const Duration(milliseconds: 120),
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
    );
  }
}
