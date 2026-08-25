import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// SLDS text input — label (with a required marker), leading/trailing
/// icons, an optional info button, help/error text, and
/// default/focused/error/disabled/filled states.
/// Thin wrapper over [TextFormField] so validation, controllers, keyboard
/// types, and obscureText all work exactly as they would on a bare
/// [TextFormField]; only the visual chrome is themed.
///
/// Set [compact] for the shorter density: Figma's `Compact=True` variant is
/// not merely a shorter box — it also drops to a smaller radius, sets both
/// the label and the value in Caption 1, and tightens the label gap.
///
/// Colors resolve from the ambient theme's SLDS tokens, so the field
/// follows light/dark/high-contrast without per-instance overrides.
class SldsTextField extends StatefulWidget {
  const SldsTextField({
    required this.label,
    super.key,
    this.controller,
    this.focusNode,
    this.compact = false,
    this.isRequired = false,
    this.helpText,
    this.errorText,
    this.hintText,
    this.leadingIcon,
    this.leadingWidget,
    this.trailingIcon,
    this.trailingIconColor,
    this.trailingIconTooltip,
    this.onTrailingIconPressed,
    this.largeTrailingIcon = false,
    this.infoIcon,
    this.infoTooltip,
    this.onInfoPressed,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.validator,
  });

  final String label;
  final TextEditingController? controller;

  /// Supply one to drive focus externally. When null the field owns an
  /// internal node — the field listens either way, because the focused
  /// state changes the border width and horizontal padding, not just the
  /// border colour.
  final FocusNode? focusNode;

  /// Figma's `Compact=True` density.
  final bool compact;

  final bool isRequired;
  final String? helpText;
  final String? errorText;
  final String? hintText;
  final IconData? leadingIcon;

  /// A full leading widget (e.g. a country-code prefix) — takes precedence
  /// over [leadingIcon] when both are given.
  final Widget? leadingWidget;
  final IconData? trailingIcon;

  /// Overrides the trailing icon's color; defaults to the input icon token
  /// (or the error token while [errorText] is set).
  final Color? trailingIconColor;

  /// Accessible name for the trailing icon button. An icon-only control has
  /// no visible text, so pass this whenever [onTrailingIconPressed] is set.
  final String? trailingIconTooltip;

  final VoidCallback? onTrailingIconPressed;

  /// Draws the trailing icon in the larger 36dp box rather than the 28dp
  /// one. Figma uses the bigger slot where the trailing icon is the field's
  /// primary control rather than an adornment — the password reveal toggle
  /// being the case in the spec.
  final bool largeTrailingIcon;

  /// Figma's third trailing slot — a filled affordance sitting after the
  /// trailing icon, used for "what is this field for?" help.
  final IconData? infoIcon;

  /// Accessible name for the info button. Required in practice whenever
  /// [infoIcon] is set, for the same reason as [trailingIconTooltip].
  final String? infoTooltip;

  final VoidCallback? onInfoPressed;

  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  State<SldsTextField> createState() => _SldsTextFieldState();
}

class _SldsTextFieldState extends State<SldsTextField> {
  FocusNode? _internalNode;
  late bool _focused;

  FocusNode get _node => widget.focusNode ?? (_internalNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focused = _node.hasFocus;
    _node.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(SldsTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalNode)?.removeListener(_onFocusChanged);
      _node.addListener(_onFocusChanged);
      _onFocusChanged();
    }
  }

  @override
  void dispose() {
    _node.removeListener(_onFocusChanged);
    _internalNode?.dispose();
    super.dispose();
  }

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
    final compact = widget.compact;

    // Compact sets both the label and the value in Caption 1; the standard
    // density splits them across Body 2 and Body 1.
    final labelStyle = compact ? typography.caption1 : typography.body2;
    final valueStyle = compact ? typography.caption1 : typography.body1;

    // Only the focused state thickens the stroke — every other state carries
    // itself in the colour alone.
    OutlineInputBorder border(Color borderColor, {bool emphasized = false}) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            compact ? dimensions.radiusLg : dimensions.radius2xl,
          ),
          borderSide: BorderSide(
            color: borderColor,
            width: emphasized
                ? dimensions.emphasizedBorderWidth
                : dimensions.controlBorderWidth,
          ),
        );

    // Figma's icon slots are fixed square boxes, not the 48dp default an
    // unconstrained IconButton would claim. Keeping the box at the drawn
    // size stops the field's internals from bulging. The larger box carries
    // a proportionally larger glyph.
    Widget iconSlot({
      required IconData icon,
      required double box,
      required Color color,
      String? tooltip,
      VoidCallback? onPressed,
    }) {
      return SizedBox(
        width: box,
        height: box,
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tight(Size(box, box)),
          iconSize: box >= dimensions.iconButtonMedium
              ? dimensions.iconSizeMedium
              : dimensions.iconSizeSmall,
          icon: Icon(icon, color: color),
          tooltip: tooltip,
          onPressed: onPressed,
        ),
      );
    }

    final iconColor = widget.enabled
        ? colors.inputIcon
        : colors.disabledForeground;

    final trailing = <Widget>[
      if (widget.trailingIcon != null)
        iconSlot(
          icon: widget.trailingIcon!,
          box: widget.largeTrailingIcon && !compact
              ? dimensions.iconButtonMedium
              : dimensions.buttonHeightSmall,
          color:
              widget.trailingIconColor ??
              (_hasError ? colors.error : iconColor),
          tooltip: widget.trailingIconTooltip,
          onPressed: widget.onTrailingIconPressed,
        ),
      if (widget.infoIcon != null)
        iconSlot(
          icon: widget.infoIcon!,
          // The info affordance is drawn larger than the plain trailing icon
          // at standard density, and collapses to the same box when compact.
          box: compact
              ? dimensions.buttonHeightSmall
              : dimensions.iconButtonMedium,
          color: iconColor,
          tooltip: widget.infoTooltip,
          onPressed: widget.onInfoPressed,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style: labelStyle.copyWith(
              color: widget.enabled
                  ? colors.inputLabel
                  : colors.disabledForeground,
            ),
            children: [
              TextSpan(text: widget.label),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: colors.error),
                ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: compact ? dimensions.space4 : dimensions.space8,
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: _node,
          enabled: widget.enabled,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          validator: widget.validator,
          // The value keeps its style whether or not it is obscured, so
          // revealing a password must not reflow the field.
          style: valueStyle.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: valueStyle.copyWith(color: colors.inputPlaceholder),
            prefixIcon:
                widget.leadingWidget ??
                (widget.leadingIcon != null
                    ? iconSlot(
                        icon: widget.leadingIcon!,
                        box: dimensions.buttonHeightSmall,
                        color: iconColor,
                      )
                    : null),
            prefixIconConstraints: widget.leadingWidget != null
                ? const BoxConstraints()
                : null,
            suffixIcon: trailing.isEmpty
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: trailing,
                  ),
            suffixIconConstraints: const BoxConstraints(),
            filled: true,
            // Figma's `Input/Background` is the card surface in every state:
            // disabled fades the border and text but does not darken the fill.
            fillColor: colors.surfaceCard,
            // Figma's Content box is a fixed height with the padding below;
            // constraints rather than vertical padding so the height is a
            // floor the field can still grow past at large text scales.
            constraints: BoxConstraints(
              minHeight: compact
                  ? dimensions.inputHeightCompact
                  : dimensions.inputHeight,
            ),
            // Focus widens the horizontal padding to keep the text from
            // shifting under the thicker stroke.
            contentPadding: EdgeInsetsDirectional.symmetric(
              horizontal: _focused ? dimensions.space12 : dimensions.space8,
              vertical: dimensions.space8,
            ),
            border: border(colors.inputBorderDefault),
            enabledBorder: border(
              _hasError ? colors.inputBorderError : colors.inputBorderDefault,
            ),
            focusedBorder: border(
              _hasError ? colors.inputBorderError : colors.inputBorderFocused,
              emphasized: true,
            ),
            errorBorder: border(colors.inputBorderError),
            focusedErrorBorder: border(
              colors.inputBorderError,
              emphasized: true,
            ),
            disabledBorder: border(colors.inputBorderDisabled),
          ),
        ),
        if (_hasError ||
            (widget.helpText != null && widget.helpText!.isNotEmpty)) ...[
          SizedBox(height: dimensions.space6),
          Text(
            _hasError ? widget.errorText! : widget.helpText!,
            style: typography.caption1.copyWith(
              color: _hasError
                  ? colors.error
                  : (widget.enabled
                        ? colors.inputHelper
                        : colors.disabledForeground),
            ),
          ),
        ],
      ],
    );
  }
}
