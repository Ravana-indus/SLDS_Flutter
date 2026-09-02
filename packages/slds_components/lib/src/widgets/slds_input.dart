import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slds_components/slds_components.dart'
    show SldsMobileNumberInput;
import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_mobile_number_input.dart'
    show SldsMobileNumberInput;

/// Figma visual states for [SldsInput].
enum SldsInputState {
  /// The resting, empty field.
  defaultState,

  /// A committed value, unfocused and valid — darker border than
  /// [defaultState] so a filled field reads as distinct from an empty one.
  filled,

  /// The keyboard-focused field.
  focused,

  /// The field with validation feedback.
  error,

  /// The non-interactive field.
  disabled,
}

/// SLDS text input with optional static [prefixText]/[suffixText] labels
/// inline with the value (e.g. a currency code or unit) — label (with
/// required marker), default/focused/error/disabled states, and help/error
/// text below.
///
/// Unlike [SldsMobileNumberInput]'s prefix, [prefixText]/[suffixText] are
/// plain inline labels, not interactive — for a tappable prefix (country
/// picker, unit picker), build that yourself and pass it through a
/// [TextField] directly instead.
class SldsInput extends StatefulWidget {
  /// Creates an [SldsInput].
  const SldsInput({
    required this.label,
    super.key,
    this.controller,
    this.prefixText,
    this.suffixText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.required = true,
    this.visualState,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.width,
  });

  /// Visible field label.
  final String label;

  /// Supply one to read or drive the text externally. When null the field
  /// owns an internal controller for its lifetime.
  final TextEditingController? controller;

  /// Static label rendered before the value (e.g. `LKR`).
  final String? prefixText;

  /// Static label rendered after the value (e.g. `KG`).
  final String? suffixText;

  /// Placeholder shown inside an empty field. Not a label substitute — it
  /// disappears on the first keystroke.
  final String? hintText;

  /// Guidance shown below the field. Hidden while [errorText] is set.
  final String? helperText;

  /// Validation message shown below the field. Non-null puts the field in
  /// its error state and announces it as an error.
  final String? errorText;

  /// Whether to show the required marker beside [label].
  final bool required;

  /// Figma state used for catalog documentation and visual tests — leave
  /// null to resolve from live focus/[enabled]/[errorText] instead.
  final SldsInputState? visualState;

  /// Called on every change to the text.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits from the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Supply one to drive focus externally. When null the field owns an
  /// internal node.
  final FocusNode? focusNode;

  /// Whether the field accepts input. Disabled fields dim and stop taking
  /// focus, but stay readable by a screen reader.
  final bool enabled;

  /// Which soft keyboard to raise (e.g. [TextInputType.emailAddress]).
  final TextInputType? keyboardType;

  /// Formatters applied as the user types, e.g. to restrict input.
  final List<TextInputFormatter>? inputFormatters;

  /// Validation callback, used when the field sits inside a [Form].
  final FormFieldValidator<String>? validator;

  /// When [validator] re-runs — on every change, on interaction, or never.
  final AutovalidateMode? autovalidateMode;

  /// Preferred width, clamped to the available parent width.
  final double? width;

  @override
  State<SldsInput> createState() => _SldsInputState();
}

class _SldsInputState extends State<SldsInput> {
  late FocusNode _focusNode;
  late bool _ownsFocusNode;
  late TextEditingController _controller;
  late bool _ownsController;

  @override
  void initState() {
    super.initState();
    _attachFocusNode(widget.focusNode);
    _attachController(widget.controller);
  }

  @override
  void didUpdateWidget(covariant SldsInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_onFocusChange);
      if (_ownsFocusNode) _focusNode.dispose();
      _attachFocusNode(widget.focusNode);
    }
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_onTextChange);
      if (_ownsController) _controller.dispose();
      _attachController(widget.controller);
    }
  }

  void _attachFocusNode(FocusNode? provided) {
    _ownsFocusNode = provided == null;
    _focusNode = provided ?? FocusNode(debugLabel: 'SldsInput:${widget.label}');
    _focusNode.addListener(_onFocusChange);
  }

  void _attachController(TextEditingController? provided) {
    _ownsController = provided == null;
    _controller = provided ?? TextEditingController();
    _controller.addListener(_onTextChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  void _onTextChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    _controller.removeListener(_onTextChange);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;
  bool get _hasValue => _controller.text.isNotEmpty;

  SldsInputState get _resolvedState {
    if (!widget.enabled || widget.visualState == SldsInputState.disabled) {
      return SldsInputState.disabled;
    }
    if (widget.visualState != null) return widget.visualState!;
    if (_hasError) return SldsInputState.error;
    if (_focusNode.hasFocus) return SldsInputState.focused;
    return _hasValue ? SldsInputState.filled : SldsInputState.defaultState;
  }

  /// The field's accessible name: the visible label plus the state the
  /// design carries only in colour — the required marker and the error.
  String _semanticLabel(BuildContext context, bool error) {
    final strings = context.sldsStrings;
    final buffer = StringBuffer(widget.label);
    if (widget.required) buffer.write(', ${strings.required}');
    if (error && widget.errorText != null) {
      buffer.write(', ${strings.error}: ${widget.errorText}');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final state = _resolvedState;
    final disabled = state == SldsInputState.disabled;
    final error = state == SldsInputState.error;
    final focused = state == SldsInputState.focused;

    final borderColor = disabled
        ? colors.inputBorderDisabled
        : error
        ? colors.inputBorderError
        : focused
        ? colors.inputBorderFocused
        : colors.inputBorderDefault;
    final borderWidth = disabled
        ? dimensions.inputDisabledBorderWidth
        : error || focused
        ? dimensions.emphasizedBorderWidth
        : dimensions.controlBorderWidth;
    final labelColor = disabled ? colors.disabledForeground : colors.inputLabel;
    final affixColor = disabled
        ? colors.disabledForeground
        : colors.textSecondary;
    final valueColor = disabled
        ? colors.disabledForeground
        : colors.textPrimary;
    final supportText = error ? widget.errorText : widget.helperText;
    final supportColor = disabled
        ? colors.disabledForeground
        : error
        ? colors.error
        : colors.inputHelper;

    return LayoutBuilder(
      builder: (context, constraints) {
        const figmaReferenceWidth = 361.0;
        final requestedWidth =
            widget.width ??
            (constraints.hasBoundedWidth
                ? constraints.maxWidth
                : figmaReferenceWidth);
        final resolvedWidth = constraints.hasBoundedWidth
            ? requestedWidth.clamp(0.0, constraints.maxWidth)
            : requestedWidth;

        return SizedBox(
          width: resolvedWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: tokens.typography.fieldLabel.copyWith(
                      color: labelColor,
                    ),
                  ),
                  if (widget.required)
                    Text(
                      '*',
                      style: tokens.typography.fieldLabel.copyWith(
                        color: disabled
                            ? colors.disabledForeground
                            : colors.inputBorderError,
                      ),
                    ),
                ],
              ),
              SizedBox(height: dimensions.space4),
              Container(
                height: dimensions.inputHeight,
                padding: EdgeInsets.symmetric(horizontal: dimensions.space12),
                decoration: BoxDecoration(
                  color: disabled
                      ? colors.disabledBackground
                      : colors.surfaceCard,
                  border: Border.all(color: borderColor, width: borderWidth),
                  borderRadius: BorderRadius.circular(dimensions.radius2xl),
                ),
                child: Row(
                  children: [
                    if (widget.prefixText != null) ...[
                      Text(
                        widget.prefixText!,
                        style: tokens.typography.body1.copyWith(
                          color: affixColor,
                        ),
                      ),
                      SizedBox(width: dimensions.space8),
                    ],
                    Expanded(
                      child: Semantics(
                        // The visible label is a sibling Text, so the field
                        // itself announces unnamed; required and error are
                        // colour-only, so both are folded into the name.
                        textField: true,
                        label: _semanticLabel(context, error),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          enabled: !disabled,
                          keyboardType: widget.keyboardType,
                          inputFormatters: widget.inputFormatters,
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                          style: tokens.typography.body1.copyWith(
                            color: valueColor,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: widget.hintText,
                            hintStyle: tokens.typography.body1.copyWith(
                              color: colors.inputPlaceholder,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (widget.suffixText != null) ...[
                      SizedBox(width: dimensions.space8),
                      Text(
                        widget.suffixText!,
                        style: tokens.typography.body1.copyWith(
                          color: affixColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (supportText != null) ...[
                SizedBox(height: dimensions.space6),
                Text(
                  supportText,
                  style: tokens.typography.caption1.copyWith(
                    color: supportColor,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
