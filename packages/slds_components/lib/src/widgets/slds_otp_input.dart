import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';

/// Fixed box dimensions for [SldsOtpInput], per the SLDS spec's size scale.
enum SldsOtpInputSize {
  /// 56x80 boxes.
  large(width: 56, height: 80),

  /// 48x60 boxes.
  medium(width: 48, height: 60),

  /// 44x52 boxes.
  small(width: 44, height: 52)
  ;

  const SldsOtpInputSize({required this.width, required this.height});

  /// Box width in logical pixels.
  final double width;

  /// Box height in logical pixels.
  final double height;
}

/// SLDS OTP (one-time-passcode) input — a row of single-digit boxes that
/// auto-advances focus as the user types, supports pasting the full code,
/// and colors each box by state: empty (outline), active/focused (gold
/// border), filled (outline, black digit), [errorText] set (red border +
/// digit), [success] (green border + digit), disabled (dimmed).
///
/// Boxes are a fixed size from [SldsOtpInputSize] (large/medium/small) per
/// the design spec, rather than stretching to fill the parent — pick the
/// size that fits the breakpoint you're rendering at.
class SldsOtpInput extends StatefulWidget {
  /// Creates a row of one-time-passcode boxes.
  const SldsOtpInput({
    super.key,
    this.length = 6,
    this.size = SldsOtpInputSize.large,
    this.onChanged,
    this.onCompleted,
    this.errorText,
    this.success = false,
    this.enabled = true,
    this.autofocus = false,
    this.semanticLabel,
  });

  /// Number of digit boxes. Defaults to 6.
  final int length;

  /// Box dimensions. Defaults to [SldsOtpInputSize.large].
  final SldsOtpInputSize size;

  /// Called with the current joined digits on every change.
  final ValueChanged<String>? onChanged;

  /// Called once with the full code when all [length] boxes are filled.
  final ValueChanged<String>? onCompleted;

  /// Non-null/non-empty colors every box's border and digit red, per the
  /// SLDS error convention.
  final String? errorText;

  /// Colors every box green — set once the caller has verified the code.
  final bool success;

  /// Whether the boxes accept input.
  final bool enabled;

  /// Focuses the first box on mount, so the keyboard opens immediately.
  final bool autofocus;

  /// Accessible name for the group of boxes as a whole, e.g. "One-time
  /// passcode". Each box announces its own position within the group.
  final String? semanticLabel;

  @override
  State<SldsOtpInput> createState() => _SldsOtpInputState();
}

class _SldsOtpInputState extends State<SldsOtpInput> {
  late final List<TextEditingController> controllers = List.generate(
    widget.length,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> focusNodes = List.generate(
    widget.length,
    (_) => FocusNode(),
  );

  /// Key-listener nodes, one per box.
  ///
  /// Owned here rather than constructed inline in [build]: a node created
  /// during build is rebuilt and leaked on every frame.
  late final List<FocusNode> keyNodes = List.generate(
    widget.length,
    (_) => FocusNode(skipTraversal: true),
  );

  @override
  void initState() {
    super.initState();
    // Rebuild so the focused box's border/cursor/digit turn gold as focus
    // moves between boxes — FocusNode changes don't otherwise trigger a build.
    for (final f in focusNodes) {
      f.addListener(_onFocusChanged);
    }
  }

  void _onFocusChanged() => setState(() {});

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f
        ..removeListener(_onFocusChanged)
        ..dispose();
    }
    for (final f in keyNodes) {
      f.dispose();
    }
    super.dispose();
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  String get _code => controllers.map((c) => c.text).join();

  void _emit() {
    widget.onChanged?.call(_code);
    if (_code.length == widget.length) widget.onCompleted?.call(_code);
  }

  /// Splits a pasted/autofilled multi-char value across boxes starting at
  /// [startIndex]; single-char typing takes the fast path below.
  void _fillFrom(int startIndex, String digits) {
    var i = startIndex;
    for (final digit in digits.split('')) {
      if (i >= widget.length) break;
      controllers[i].text = digit;
      i++;
    }
    final next = i.clamp(0, widget.length - 1);
    if (i >= widget.length) {
      focusNodes[widget.length - 1].unfocus();
    } else {
      focusNodes[next].requestFocus();
    }
    _emit();
  }

  void _onChanged(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 1) {
      // Pasted or autofilled — distribute across remaining boxes.
      controllers[index].clear();
      _fillFrom(index, digits);
      return;
    }
    if (digits.isEmpty) {
      controllers[index].clear();
      _emit();
      return;
    }
    controllers[index].text = digits;
    if (index < widget.length - 1) {
      focusNodes[index + 1].requestFocus();
    } else {
      focusNodes[index].unfocus();
    }
    _emit();
  }

  void _onKey(int index, KeyEvent event) {
    if (event is! KeyDownEvent) return;
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        controllers[index].text.isEmpty &&
        index > 0) {
      focusNodes[index - 1].requestFocus();
      controllers[index - 1].clear();
      _emit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = context.slds.dimensions;

    // The boxes are one logical field split across [length] controls. The
    // group carries the name and, since the error is otherwise only a red
    // border, announces the error once for the whole code rather than
    // repeating it on every box.
    //
    // Wrap (not Row+Expanded) — boxes are a fixed [widget.size], so at
    // narrow widths (mobile) the row wraps onto a second line instead of
    // overflowing or squeezing the boxes out of spec.
    return Semantics(
      container: true,
      label: widget.semanticLabel,
      value: _code,
      liveRegion: _hasError,
      hint: _hasError ? widget.errorText : null,
      child: Wrap(
        spacing: dimensions.space8,
        runSpacing: dimensions.space8,
        children: [
          for (var i = 0; i < widget.length; i++) _buildBox(context, i),
        ],
      ),
    );
  }

  /// The box outline: a flat `radius2xl` corner at every size. The stroke
  /// widens for the states Figma emphasizes — Focused, Error and Success —
  /// and stays 1px for Default, Filled and Disabled.
  OutlineInputBorder _boxBorder(
    SldsTokenSet tokens,
    Color color, {
    required bool emphasized,
  }) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(tokens.dimensions.radius2xl),
    borderSide: BorderSide(
      color: color,
      width: emphasized
          ? tokens.dimensions.emphasizedBorderWidth
          : tokens.dimensions.controlBorderWidth,
    ),
  );

  Widget _buildBox(BuildContext context, int index) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final focused = focusNodes[index].hasFocus;

    final Color borderColor;
    final Color textColor;
    // Figma emphasizes exactly the three states that need to catch the eye.
    final bool emphasized;
    if (!widget.enabled) {
      borderColor = colors.disabledBorder;
      textColor = colors.disabledForeground;
      emphasized = false;
    } else if (_hasError) {
      // The digit goes red with the border, not just the outline.
      borderColor = colors.inputBorderError;
      textColor = colors.inputBorderError;
      emphasized = true;
    } else if (widget.success) {
      borderColor = colors.success;
      textColor = colors.success;
      emphasized = true;
    } else if (focused) {
      // Gold — the active box, whether or not it already holds a digit.
      // Figma has no filled-vs-empty carve-out here, and dropping the ring
      // when typing over an existing digit would lose the focus indicator.
      borderColor = colors.inputBorderFocused;
      textColor = colors.inputLabel;
      emphasized = true;
    } else {
      // Figma's Default and Filled nodes share a border; only the digit
      // differs, and an empty box has no digit to colour.
      borderColor = colors.inputBorderDefault;
      textColor = colors.inputLabel;
      emphasized = false;
    }

    return Semantics(
      // Without a position each box announces as an anonymous text field,
      // so a reader tabbing through six of them cannot tell which digit
      // they are on or how many are left.
      textField: true,
      label: context.sldsStrings.digitOf(index + 1, widget.length),
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: KeyboardListener(
          focusNode: keyNodes[index],
          onKeyEvent: (event) => _onKey(index, event),
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            enabled: widget.enabled,
            autofocus: widget.autofocus && index == 0,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength:
                widget.length, // allows pasting the full code into one box
            cursorColor: borderColor,
            // Figma sets the digit in Heading 1 at every size — the box grows,
            // the numeral does not.
            style: tokens.typography.heading1.copyWith(color: textColor),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              // Figma's `Input/Background` is the card surface in every state:
              // disabled fades the border and digit but keeps the fill white.
              fillColor: colors.surfaceCard,
              contentPadding: EdgeInsets.zero,
              // One radius for every size and state; the state is carried by
              // the border colour and, for the emphasized states, its width.
              border: _boxBorder(tokens, borderColor, emphasized: emphasized),
              enabledBorder: _boxBorder(
                tokens,
                borderColor,
                emphasized: emphasized,
              ),
              focusedBorder: _boxBorder(
                tokens,
                borderColor,
                emphasized: emphasized,
              ),
              disabledBorder: _boxBorder(
                tokens,
                borderColor,
                emphasized: emphasized,
              ),
            ),
            onChanged: (value) => _onChanged(index, value),
          ),
        ),
      ),
    );
  }
}
