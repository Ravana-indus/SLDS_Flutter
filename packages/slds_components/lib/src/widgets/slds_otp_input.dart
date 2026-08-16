import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// Fixed box dimensions for [SldsOtpInput], per the SLDS spec's size scale.
enum SldsOtpInputSize {
  large(width: 56, height: 80),
  medium(width: 48, height: 60),
  small(width: 44, height: 52)
  ;

  const SldsOtpInputSize({required this.width, required this.height});

  final double width;
  final double height;
}

/// SLDS OTP (one-time-passcode) input — a row of single-digit boxes that
/// auto-advances focus as the user types, supports pasting the full code,
/// and colors each box by state: empty (outline), active/focused (gold
/// border), filled (outline, black digit), [errorText] set (red border,
/// black digit), [success] (green border + digit), disabled (dimmed).
///
/// Boxes are a fixed size from [SldsOtpInputSize] (large/medium/small) per
/// the design spec, rather than stretching to fill the parent — pick the
/// size that fits the breakpoint you're rendering at.
class SldsOtpInput extends StatefulWidget {
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
  });

  /// Number of digit boxes. Defaults to 6.
  final int length;

  /// Box dimensions. Defaults to [SldsOtpInputSize.large].
  final SldsOtpInputSize size;

  /// Called with the current joined digits on every change.
  final ValueChanged<String>? onChanged;

  /// Called once with the full code when all [length] boxes are filled.
  final ValueChanged<String>? onCompleted;

  /// Non-null/non-empty colors every box's border red, per SLDS error
  /// convention — the digit itself stays normal ink.
  final String? errorText;

  /// Colors every box green — set once the caller has verified the code.
  final bool success;

  final bool enabled;
  final bool autofocus;

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

    // Wrap (not Row+Expanded) — boxes are a fixed [widget.size], so at
    // narrow widths (mobile) the row wraps onto a second line instead of
    // overflowing or squeezing the boxes out of spec.
    return Wrap(
      spacing: dimensions.space8,
      runSpacing: dimensions.space8,
      children: [
        for (var i = 0; i < widget.length; i++) _buildBox(context, i),
      ],
    );
  }

  /// The box outline: a flat `radius2xl` corner and a 1px stroke, per Figma.
  OutlineInputBorder _boxBorder(SldsTokenSet tokens, Color color) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(tokens.dimensions.radius2xl),
        borderSide: BorderSide(
          color: color,
          width: tokens.dimensions.controlBorderWidth,
        ),
      );

  Widget _buildBox(BuildContext context, int index) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final filled = controllers[index].text.isNotEmpty;
    final focused = focusNodes[index].hasFocus;

    final Color borderColor;
    final Color textColor;
    if (!widget.enabled) {
      borderColor = colors.disabledBorder;
      textColor = colors.disabledForeground;
    } else if (_hasError) {
      // Only the border goes red — the digit itself stays normal ink.
      borderColor = colors.inputBorderError;
      textColor = colors.inputLabel;
    } else if (widget.success) {
      borderColor = colors.success;
      textColor = colors.success;
    } else if (focused && !filled) {
      // Gold — the active box awaiting input, cursor showing (design row 2).
      borderColor = colors.inputBorderFocused;
      textColor = colors.inputLabel;
    } else {
      // Figma's Default and Filled nodes share a border; only the digit
      // differs, and an empty box has no digit to colour.
      borderColor = colors.inputBorderDefault;
      textColor = colors.inputLabel;
    }

    return SizedBox(
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
          maxLength: widget.length, // allows pasting the full code into one box
          cursorColor: borderColor,
          // Figma sets the digit in Heading 1 at every size — the box grows,
          // the numeral does not.
          style: tokens.typography.heading1.copyWith(color: textColor),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: widget.enabled
                ? colors.surfaceCard
                : colors.disabledBackground,
            contentPadding: EdgeInsets.zero,
            // One radius and one border width for every size and state; the
            // state is carried by the border colour alone.
            border: _boxBorder(tokens, borderColor),
            enabledBorder: _boxBorder(tokens, borderColor),
            focusedBorder: _boxBorder(tokens, borderColor),
            disabledBorder: _boxBorder(tokens, borderColor),
          ),
          onChanged: (value) => _onChanged(index, value),
        ),
      ),
    );
  }
}
