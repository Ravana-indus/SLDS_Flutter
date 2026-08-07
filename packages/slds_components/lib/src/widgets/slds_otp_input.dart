import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/slds_colors.dart';
import '../tokens/slds_spacing.dart';

/// SLDS OTP (one-time-passcode) input — a row of single-digit boxes that
/// auto-advances focus as the user types, supports pasting the full code,
/// and colors each box by state: empty (outline), filled (primary),
/// [errorText] set (error, all boxes), [success] (green, all boxes).
///
/// Responsive by construction — each box is an [Expanded] cell in a [Row],
/// so the whole control scales to its parent's width instead of a fixed
/// pixel grid; wrap it in a [SizedBox]/constrained parent to cap its width.
class SldsOtpInput extends StatefulWidget {
  const SldsOtpInput({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.errorText,
    this.success = false,
    this.enabled = true,
    this.autofocus = false,
  });

  /// Number of digit boxes. Defaults to 6.
  final int length;

  /// Called with the current joined digits on every change.
  final ValueChanged<String>? onChanged;

  /// Called once with the full code when all [length] boxes are filled.
  final ValueChanged<String>? onCompleted;

  /// Non-null/non-empty colors every box red, per SLDS error convention.
  final String? errorText;

  /// Colors every box green — set once the caller has verified the code.
  final bool success;

  final bool enabled;
  final bool autofocus;

  @override
  State<SldsOtpInput> createState() => _SldsOtpInputState();
}

class _SldsOtpInputState extends State<SldsOtpInput> {
  late final controllers = List.generate(
    widget.length,
    (_) => TextEditingController(),
  );
  late final focusNodes = List.generate(widget.length, (_) => FocusNode());

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
    super.dispose();
  }

  bool get _hasError => widget.errorText != null && widget.errorText!.isNotEmpty;

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
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) const SizedBox(width: SldsSpacing.sm),
          Expanded(child: _buildBox(context, scheme, i)),
        ],
      ],
    );
  }

  Widget _buildBox(BuildContext context, ColorScheme scheme, int index) {
    final filled = controllers[index].text.isNotEmpty;
    final focused = focusNodes[index].hasFocus;

    final Color borderColor;
    final Color textColor;
    if (!widget.enabled) {
      borderColor = scheme.outline.withValues(alpha: SldsColors.disabledOpacity);
      textColor = scheme.onSurface.withValues(alpha: SldsColors.disabledOpacity);
    } else if (_hasError) {
      borderColor = scheme.error;
      textColor = scheme.error;
    } else if (widget.success) {
      borderColor = Colors.green;
      textColor = Colors.green;
    } else if (focused && !filled) {
      // Gold — the active box awaiting input, cursor showing (design row 2).
      borderColor = scheme.primary;
      textColor = scheme.primary;
    } else {
      // Gray for both untouched and already-filled boxes (design rows 1/3).
      borderColor = scheme.outline;
      textColor = scheme.onSurface;
    }

    return AspectRatio(
      aspectRatio: 112 / 154, // matches the reference design's box proportions
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: widget.enabled ? scheme.surface : scheme.onSurface.withValues(alpha: 0.04),
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SldsSpacing.lg),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SldsSpacing.lg),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SldsSpacing.lg),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
          ),
          onChanged: (value) => _onChanged(index, value),
        ),
      ),
    );
  }
}
