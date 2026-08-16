import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_focus.dart';

/// Figma visual states for [SldsMobileNumberInput], matching node `510:3072`.
enum SldsMobileNumberInputState {
  /// The resting field.
  defaultState,

  /// The field with a valid entered value.
  filled,

  /// The keyboard-focused field.
  focused,

  /// The field with validation feedback.
  error,

  /// The non-interactive field.
  disabled,
}

/// Responsive mobile-number field with a country selector prefix.
///
/// The source design is 361dp wide, but this widget takes the available parent
/// width on smaller screens. Pass a [countryFlag] built from your own approved
/// flag asset; SLDS deliberately does not bake a country or locale into apps.
class SldsMobileNumberInput extends StatefulWidget {
  /// Creates an SLDS mobile-number input.
  const SldsMobileNumberInput({
    required this.label,
    super.key,
    this.controller,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.required = true,
    this.visualState,
    this.countryCode = '+94',
    this.countryFlag,
    this.onCountryPressed,
    this.countrySemanticLabel,
    this.trailing,
    this.trailingWidth,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.readOnly = false,
    this.enabled = true,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.textInputAction,
    this.semanticLabel,
    this.width,
  });

  /// Visible field label.
  final String label;

  /// Controller for the national-number portion (without [countryCode]).
  final TextEditingController? controller;

  /// Hint for the national-number portion.
  final String? placeholder;

  /// Supporting guidance shown below the field.
  final String? helperText;

  /// Validation guidance shown when the resolved state is [error].
  final String? errorText;

  /// Whether to show the required marker beside [label].
  final bool required;

  /// Figma state used for catalog documentation and visual tests.
  final SldsMobileNumberInputState? visualState;

  /// Calling code displayed before the national-number portion.
  final String countryCode;

  /// Approved country-flag asset supplied by the consuming app.
  final Widget? countryFlag;

  /// Invoked when the country selector is activated.
  final VoidCallback? onCountryPressed;

  /// Accessible name for the country selector when it is interactive.
  final String? countrySemanticLabel;

  /// Optional state-specific status or action icon at the end of the field.
  final Widget? trailing;

  /// Width reserved for [trailing].
  ///
  /// A normal source status action is 36px wide. Error can contain the clear
  /// and error-status actions together, which uses a 72px trailing region.
  final double? trailingWidth;

  /// Called when the national-number value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the platform submits this field.
  final ValueChanged<String>? onSubmitted;

  /// Controls keyboard focus for normal Flutter form workflows.
  final FocusNode? focusNode;

  /// Makes the national-number portion selectable but not editable.
  final bool readOnly;

  /// Enables the field unless [visualState] is [disabled].
  final bool enabled;

  /// Restricts or transforms user input before it is committed.
  final List<TextInputFormatter>? inputFormatters;

  /// Form validation callback used by an ancestor [Form].
  final FormFieldValidator<String>? validator;

  /// Controls when [validator] messages are evaluated.
  final AutovalidateMode? autovalidateMode;

  /// Configures the keyboard action button.
  final TextInputAction? textInputAction;

  /// Screen-reader label for the editable national-number portion.
  final String? semanticLabel;

  /// Preferred width, clamped to the available parent width.
  final double? width;

  @override
  State<SldsMobileNumberInput> createState() => _SldsMobileNumberInputState();
}

class _SldsMobileNumberInputState extends State<SldsMobileNumberInput> {
  late FocusNode _focusNode;
  late bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _attachFocusNode(widget.focusNode);
  }

  @override
  void didUpdateWidget(covariant SldsMobileNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_onFocusChange);
      if (_ownsFocusNode) _focusNode.dispose();
      _attachFocusNode(widget.focusNode);
    }
  }

  void _attachFocusNode(FocusNode? provided) {
    _ownsFocusNode = provided == null;
    _focusNode =
        provided ??
        FocusNode(debugLabel: 'SldsMobileNumberInput:${widget.label}');
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  SldsMobileNumberInputState get _resolvedState {
    if (!widget.enabled ||
        widget.visualState == SldsMobileNumberInputState.disabled) {
      return SldsMobileNumberInputState.disabled;
    }
    return widget.visualState ??
        (_focusNode.hasFocus
            ? SldsMobileNumberInputState.focused
            : SldsMobileNumberInputState.defaultState);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final state = _resolvedState;
    final disabled = state == SldsMobileNumberInputState.disabled;
    final error = state == SldsMobileNumberInputState.error;
    final focused = state == SldsMobileNumberInputState.focused;
    final borderColor = disabled
        ? colors.inputBorderDisabled
        : error
        ? colors.inputBorderError
        : focused
        ? colors.inputBorderFocused
        : colors.inputBorderDefault;
    // Figma carries the state in the border colour alone; no state thickens
    // the stroke. (This frame's Default node exports a one-off 1.6px, but its
    // Focused node declares no width at all and the rest of the Input family
    // is a plain 1px, so the ramp is normalised here.)
    final borderWidth = dimensions.controlBorderWidth;
    final labelColor = disabled ? colors.disabledForeground : colors.inputLabel;
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
            children: [
              _MobileNumberLabel(
                label: widget.label,
                required: widget.required,
                color: labelColor,
                requiredColor: disabled
                    ? colors.disabledForeground
                    : colors.inputBorderError,
              ),
              SizedBox(height: dimensions.space8),
              AnimatedContainer(
                duration: tokens.motion.fast,
                height: dimensions.inputHeight,
                padding: EdgeInsets.symmetric(horizontal: dimensions.space8),
                decoration: BoxDecoration(
                  color: disabled
                      ? colors.disabledBackground
                      : colors.surfaceCard,
                  border: Border.all(color: borderColor, width: borderWidth),
                  borderRadius: BorderRadius.circular(dimensions.radius2xl),
                  boxShadow: focused ? sldsFocusRing(tokens) : null,
                ),
                child: Row(
                  children: [
                    _CountryPrefix(
                      flag: widget.countryFlag,
                      code: widget.countryCode,
                      onPressed: disabled ? null : widget.onCountryPressed,
                      semanticLabel: widget.countrySemanticLabel,
                      disabled: disabled,
                    ),
                    SizedBox(width: dimensions.space8),
                    Expanded(
                      child: Semantics(
                        textField: true,
                        label: widget.semanticLabel ?? widget.label,
                        child: TextFormField(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          enabled: !disabled,
                          keyboardType: TextInputType.phone,
                          onChanged: widget.onChanged,
                          onFieldSubmitted: widget.onSubmitted,
                          readOnly: widget.readOnly,
                          inputFormatters:
                              widget.inputFormatters ??
                              [FilteringTextInputFormatter.digitsOnly],
                          validator: widget.validator,
                          autovalidateMode: widget.autovalidateMode,
                          textInputAction: widget.textInputAction,
                          style: tokens.typography.body1.copyWith(
                            color: disabled
                                ? colors.disabledForeground
                                : colors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: widget.placeholder,
                            hintStyle: tokens.typography.body1.copyWith(
                              color: colors.inputPlaceholder,
                            ),
                            counterText: '',
                          ),
                        ),
                      ),
                    ),
                    if (widget.trailing != null) ...[
                      SizedBox(width: dimensions.space4),
                      SizedBox(
                        width:
                            widget.trailingWidth ??
                            dimensions.buttonHeightSmall,
                        height: dimensions.buttonHeightSmall,
                        child: Center(
                          child: IconTheme.merge(
                            data: IconThemeData(
                              color: disabled
                                  ? colors.disabledForeground
                                  : colors.inputIcon,
                              size: dimensions.iconSizeMedium,
                            ),
                            child: widget.trailing!,
                          ),
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
                  locale: Localizations.maybeLocaleOf(context),
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

class _MobileNumberLabel extends StatelessWidget {
  const _MobileNumberLabel({
    required this.label,
    required this.required,
    required this.color,
    required this.requiredColor,
  });

  final String label;
  final bool required;
  final Color color;
  final Color requiredColor;

  @override
  Widget build(BuildContext context) {
    final typography = context.slds.typography;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            label,
            locale: Localizations.maybeLocaleOf(context),
            style: typography.body2.copyWith(color: color),
          ),
        ),
        if (required)
          Text(
            '*',
            style: typography.body2.copyWith(color: requiredColor),
          ),
      ],
    );
  }
}

class _CountryPrefix extends StatelessWidget {
  const _CountryPrefix({
    required this.flag,
    required this.code,
    required this.onPressed,
    required this.semanticLabel,
    required this.disabled,
  });

  final Widget? flag;
  final String code;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final color = disabled
        ? tokens.colors.disabledForeground
        : tokens.colors.textPrimary;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(dimension: 36, child: Center(child: flag)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            code,
            style: tokens.typography.body1.copyWith(color: color),
          ),
        ),
        const SizedBox(
          width: 20,
          height: 28,
          child: Center(child: Icon(Icons.keyboard_arrow_down, size: 16)),
        ),
      ],
    );
    if (onPressed == null) return ExcludeSemantics(child: content);
    return Semantics(
      container: true,
      excludeSemantics: true,
      button: true,
      enabled: !disabled,
      label: semanticLabel ?? code,
      child: InkWell(
        borderRadius: BorderRadius.circular(tokens.dimensions.radiusXl),
        onTap: onPressed,
        child: content,
      ),
    );
  }
}
