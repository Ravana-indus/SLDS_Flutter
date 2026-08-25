import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_text_field.dart'
    show SldsTextField;

/// SLDS multiline text input — label (with required marker), placeholder,
/// a live `n/max` character counter, and default/focused/error/disabled
/// states. Same chrome language as [SldsTextField] but sized for paragraphs
/// rather than a single line.
///
/// Colors resolve from the ambient theme's SLDS tokens, so the field
/// follows light/dark/high-contrast without per-instance overrides.
class SldsTextArea extends StatefulWidget {
  const SldsTextArea({
    required this.label,
    super.key,
    this.controller,
    this.focusNode,
    this.isRequired = false,
    this.helpText,
    this.errorText,
    this.hintText,
    this.maxLength = 300,
    this.maxLines,
    this.enabled = true,
    this.onChanged,
    this.validator,
  });

  final String label;
  final TextEditingController? controller;

  /// Supply one to drive focus externally; the field listens either way,
  /// because the focused state changes the border colour.
  final FocusNode? focusNode;

  final bool isRequired;
  final String? helpText;
  final String? errorText;
  final String? hintText;

  /// Caps input length and drives the `n/max` counter. Null hides the
  /// counter and removes the cap.
  final int? maxLength;

  /// Caps how far the box grows. Null lets it grow without limit — the box
  /// still starts at the spec's fixed height either way.
  final int? maxLines;

  final bool enabled;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  State<SldsTextArea> createState() => _SldsTextAreaState();
}

class _SldsTextAreaState extends State<SldsTextArea> {
  TextEditingController? _internalController;
  FocusNode? _internalNode;
  late bool _focused;

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  FocusNode get _node => widget.focusNode ?? (_internalNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focused = _node.hasFocus;
    // Rebuild so the counter updates as the user types and the border
    // follows focus.
    _controller.addListener(_onTextChanged);
    _node.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(SldsTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(
        _onTextChanged,
      );
      _controller.addListener(_onTextChanged);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalNode)?.removeListener(_onFocusChanged);
      _node.addListener(_onFocusChanged);
      _onFocusChanged();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _node.removeListener(_onFocusChanged);
    _internalController?.dispose();
    _internalNode?.dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  void _onFocusChanged() {
    if (_focused != _node.hasFocus) {
      setState(() => _focused = _node.hasFocus);
    }
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final typography = tokens.typography;

    // Figma draws the same 1.6px stroke in every state — unlike the
    // single-line field, the text area never thickens on focus, so the
    // state is carried by colour alone.
    OutlineInputBorder border(Color borderColor) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(dimensions.radius2xl),
      borderSide: BorderSide(
        color: borderColor,
        width: dimensions.inputDisabledBorderWidth,
      ),
    );

    final Color borderColor;
    if (!widget.enabled) {
      borderColor = colors.disabledBorder;
    } else if (_hasError) {
      borderColor = colors.inputBorderError;
    } else if (_focused) {
      borderColor = colors.inputBorderFocused;
    } else {
      borderColor = colors.inputBorderDefault;
    }

    final helperColor = widget.enabled
        ? colors.inputHelper
        : colors.disabledForeground;

    // The counter sits inside the box, so it needs to clear the reserved
    // strip at the bottom rather than overlap the last line of text.
    final counterStyle = typography.caption1.copyWith(
      color: _hasError ? colors.error : helperColor,
    );
    final showCounter = widget.maxLength != null;
    final counterHeight = showCounter
        ? (counterStyle.fontSize ?? dimensions.space12) + dimensions.space8
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            // Figma labels the field in Body 2 (14px), matching the
            // single-line input.
            style: typography.body2.copyWith(
              color: widget.enabled
                  ? colors.inputLabel
                  : colors.disabledForeground,
            ),
            children: [
              TextSpan(text: widget.label),
              if (widget.isRequired)
                TextSpan(
                  // Disabled greys the whole label, asterisk included.
                  style: widget.enabled ? TextStyle(color: colors.error) : null,
                  text: ' *',
                ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: dimensions.space8),
        Stack(
          children: [
            TextFormField(
              controller: _controller,
              focusNode: _node,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              textAlignVertical: TextAlignVertical.top,
              inputFormatters: widget.maxLength != null
                  ? [LengthLimitingTextInputFormatter(widget.maxLength)]
                  : null,
              onChanged: widget.onChanged,
              validator: widget.validator,
              style: typography.body1.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: typography.body1.copyWith(
                  color: colors.inputPlaceholder,
                ),
                filled: true,
                // Figma's `Input/Background` is the card surface in every
                // state: disabled fades the border and text, not the fill.
                fillColor: colors.surfaceCard,
                // Figma's Content box is a fixed 128px. Treat it as a floor
                // rather than a clamp so the box still grows with content
                // and at large text scales instead of clipping.
                constraints: BoxConstraints(
                  minHeight: dimensions.textAreaHeight,
                ),
                contentPadding: EdgeInsetsDirectional.fromSTEB(
                  dimensions.space12,
                  dimensions.space8,
                  dimensions.space12,
                  // Reserve room for the counter drawn over the box.
                  dimensions.space8 + counterHeight,
                ),
                border: border(borderColor),
                enabledBorder: border(borderColor),
                focusedBorder: border(borderColor),
                errorBorder: border(borderColor),
                focusedErrorBorder: border(borderColor),
                disabledBorder: border(borderColor),
                // Figma puts the counter inside the box; Flutter's own
                // counter renders below the decorator, so it is suppressed
                // and drawn by the Stack instead.
                counterText: '',
              ),
            ),
            if (showCounter)
              PositionedDirectional(
                end: dimensions.space12,
                bottom: dimensions.space8,
                child: IgnorePointer(
                  child: Text(
                    '${_controller.text.length}/${widget.maxLength}',
                    style: counterStyle,
                  ),
                ),
              ),
          ],
        ),
        if (_hasError ||
            (widget.helpText != null && widget.helpText!.isNotEmpty)) ...[
          SizedBox(height: dimensions.space6),
          Text(
            _hasError ? widget.errorText! : widget.helpText!,
            style: typography.caption1.copyWith(
              color: _hasError ? colors.error : helperColor,
            ),
          ),
        ],
      ],
    );
  }
}
