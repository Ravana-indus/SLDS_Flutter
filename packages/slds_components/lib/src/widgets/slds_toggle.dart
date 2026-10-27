import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_focus.dart';

/// SLDS toggle sizes.
enum SldsToggleSize {
  /// 50x28 track with a 22px thumb — Figma's Toggle (#158).
  large(width: 50, height: 28, thumb: 22),

  /// 40x24 track with an 18px thumb.
  small(width: 40, height: 24, thumb: 18)
  ;

  const SldsToggleSize({
    required this.width,
    required this.height,
    required this.thumb,
  });

  /// Track width in logical pixels.
  final double width;

  /// Track height in logical pixels.
  final double height;

  /// Thumb diameter in logical pixels.
  final double thumb;
}

/// SLDS toggle/switch — a pill track that fills gold when [value] is true
/// (gray track otherwise), a white thumb that slides to the active side, a
/// gold focus ring while focused via keyboard/tap-down, and dimmed when
/// [enabled] is false.
///
/// Colors resolve from the ambient `Theme`'s `ColorScheme` (light/dark
/// aware). There is no per-instance color override; theming a single
/// instance goes through a `ThemeExtension` instead.
class SldsToggle extends StatefulWidget {
  /// Creates a toggle switch.
  const SldsToggle({
    required this.value,
    required this.onChanged,
    super.key,
    this.size = SldsToggleSize.large,
    this.enabled = true,
    this.semanticLabel,
    this.focusNode,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called with the new value. Null disables the control.
  final ValueChanged<bool>? onChanged;

  /// Track and thumb size.
  final SldsToggleSize size;

  /// Whether the control accepts input.
  final bool enabled;

  /// What this switch controls, for assistive technology.
  ///
  /// A switch announced as "on" without naming what is on tells a
  /// screen-reader user nothing.
  final String? semanticLabel;

  /// Optional focus node, to move keyboard focus to the switch
  /// programmatically. When null the switch owns an internal node.
  final FocusNode? focusNode;

  @override
  State<SldsToggle> createState() => _SldsToggleState();
}

class _SldsToggleState extends State<SldsToggle> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  bool _focused = false;

  void _onFocusChanged() => setState(() => _focused = _focusNode.hasFocus);

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  bool get _enabled => widget.enabled && widget.onChanged != null;

  void _toggle() {
    if (!_enabled) return;
    widget.onChanged!.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final dimensions = tokens.dimensions;
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;

    // Figma Toggle (543:6036): off track Toggle/Track/Disabled #DDDDDD
    // (#159), on track #FFC700, thumb Surface/Page #F7F7F7 (#160); disabled
    // keeps the #DDDDDD track with a Toggle/Thumb/Disabled #BCBCBC thumb.
    final colors = tokens.colors;
    final Color trackColor;
    final Color thumbColor;
    if (!_enabled) {
      trackColor = colors.disabledBackground;
      thumbColor = colors.disabledForeground;
    } else if (widget.value) {
      trackColor = accent;
      thumbColor = colors.surfacePage;
    } else {
      trackColor = colors.disabledBackground;
      thumbColor = colors.surfacePage;
    }

    // The track keeps its designed size; the tappable area around it is
    // expanded to the 48x48 minimum instead. Shrinking the visual switch to
    // fit, or leaving a 28px-tall tap target, would each fail one of the two
    // requirements — this satisfies both.
    // `toggled`, not `checked`: that is what makes a screen reader announce
    // this as a switch rather than a checkbox.
    return Semantics(
      toggled: widget.value,
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
            behavior: HitTestBehavior.opaque,
            child: Container(
              constraints: BoxConstraints(
                minWidth: dimensions.tapTargetMin,
                minHeight: dimensions.tapTargetMin,
              ),
              alignment: Alignment.center,
              // Figma's Default/Checked - Focus: the shared Focus/Default
              // gold ring round the track, which keeps its size (#163).
              child: SldsFocusRing(
                focused: _focused,
                child: SizedBox(
                  width: widget.size.width,
                  height: widget.size.height,
                  child: AnimatedContainer(
                    duration: tokens.motion.fast,
                    // Figma insets the thumb 4px from the track's ends.
                    padding: EdgeInsets.symmetric(
                      horizontal: dimensions.space4,
                    ),
                    decoration: BoxDecoration(
                      color: trackColor,
                      borderRadius: BorderRadius.circular(
                        widget.size.height / 2,
                      ),
                    ),
                    // Directional: "on" belongs at the trailing edge of the
                    // track, which is the left edge in an RTL locale.
                    alignment: widget.value
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                    child: AnimatedContainer(
                      duration: tokens.motion.fast,
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
          ),
        ),
      ),
    );
  }
}
