import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slds_components/slds_components.dart' show SldsInput;
import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_input.dart' show SldsInput;

/// Figma visual states for [SldsInputMask].
enum SldsInputMaskState {
  /// The resting, empty field.
  defaultState,

  /// A committed value, unfocused and valid.
  filled,

  /// The keyboard-focused field.
  focused,

  /// The field with validation feedback.
  error,

  /// The non-interactive field.
  disabled,
}

/// SLDS masked text input — a fixed [prefixText]/[suffixText] (e.g.
/// `http://` / `.com`) rendered in their own divided cells flanking the
/// editable value, rather than as inline labels like [SldsInput]. Same
/// label/required marker and default/filled/focused/error/disabled states.
///
/// The prefix/suffix cells are static text, not editable — build your own
/// composited field if either side needs to be interactive.
class SldsInputMask extends StatefulWidget {
  /// Creates an [SldsInputMask].
  const SldsInputMask({
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

  /// Static mask segment rendered in its own cell before the value (e.g.
  /// `http://`).
  final String? prefixText;

  /// Static mask segment rendered in its own cell after the value (e.g.
  /// `.com`).
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
  final SldsInputMaskState? visualState;

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

  /// Formatters applied as the user types. The mask's own formatter runs
  /// first; these are appended after it.
  final List<TextInputFormatter>? inputFormatters;

  /// Validation callback, used when the field sits inside a [Form].
  final FormFieldValidator<String>? validator;

  /// When [validator] re-runs — on every change, on interaction, or never.
  final AutovalidateMode? autovalidateMode;

  /// Preferred width, clamped to the available parent width.
  final double? width;

  @override
  State<SldsInputMask> createState() => _SldsInputMaskState();
}

class _SldsInputMaskState extends State<SldsInputMask> {
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
  void didUpdateWidget(covariant SldsInputMask oldWidget) {
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
    _focusNode =
        provided ?? FocusNode(debugLabel: 'SldsInputMask:${widget.label}');
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

  SldsInputMaskState get _resolvedState {
    if (!widget.enabled || widget.visualState == SldsInputMaskState.disabled) {
      return SldsInputMaskState.disabled;
    }
    if (widget.visualState != null) return widget.visualState!;
    if (_hasError) return SldsInputMaskState.error;
    if (_focusNode.hasFocus) return SldsInputMaskState.focused;
    return _hasValue
        ? SldsInputMaskState.filled
        : SldsInputMaskState.defaultState;
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
    final disabled = state == SldsInputMaskState.disabled;
    final error = state == SldsInputMaskState.error;
    final focused = state == SldsInputMaskState.focused;

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
    // Boxier corners than SldsInput's pill-ish radius2xl — matches the
    // reference's segmented-cell look (radiusLg is Figma's compact-field
    // radius).
    final radius = dimensions.radiusLg;

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
                decoration: BoxDecoration(
                  color: disabled
                      ? colors.disabledBackground
                      : colors.surfaceCard,
                  border: Border.all(color: borderColor, width: borderWidth),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Row(
                  children: [
                    if (widget.prefixText != null)
                      _MaskCell(
                        text: widget.prefixText!,
                        color: affixColor,
                        dividerColor: borderColor,
                        dividerWidth: borderWidth,
                        dimensions: dimensions,
                        typography: tokens.typography,
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: dimensions.space12,
                        ),
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
                              // The decorated field paints taller, but the
                              // text node itself is the tappable target and
                              // must clear the 48dp floor (WCAG 2.5.8).
                              constraints: BoxConstraints(
                                minHeight: dimensions.tapTargetMin,
                              ),
                              contentPadding: EdgeInsets.zero,
                              hintText: widget.hintText,
                              hintStyle: tokens.typography.body1.copyWith(
                                color: colors.inputPlaceholder,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (widget.suffixText != null)
                      _MaskCell(
                        text: widget.suffixText!,
                        color: affixColor,
                        dividerColor: borderColor,
                        dividerWidth: borderWidth,
                        leading: true,
                        dimensions: dimensions,
                        typography: tokens.typography,
                      ),
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

/// A prefix or suffix mask segment — its own padded cell with a single
/// dividing border on the side facing the editable value.
class _MaskCell extends StatelessWidget {
  const _MaskCell({
    required this.text,
    required this.color,
    required this.dividerColor,
    required this.dividerWidth,
    required this.dimensions,
    required this.typography,
    this.leading = false,
  });

  final String text;
  final Color color;
  final Color dividerColor;

  /// Matches the outer field border's current width so the divider doesn't
  /// look thin/mismatched next to a focused (thicker) outer border.
  final double dividerWidth;

  /// True for the suffix cell — puts the divider on its left instead of right.
  final bool leading;
  final SldsDimensionTokens dimensions;
  final SldsTypographyTokens typography;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dimensions.space12),
      decoration: BoxDecoration(
        border: Border(
          left: leading
              ? BorderSide(color: dividerColor, width: dividerWidth)
              : BorderSide.none,
          right: leading
              ? BorderSide.none
              : BorderSide(color: dividerColor, width: dividerWidth),
        ),
      ),
      child: Text(text, style: typography.body1.copyWith(color: color)),
    );
  }
}
