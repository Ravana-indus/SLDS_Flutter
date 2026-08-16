import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// SLDS text input — label (with a required marker), leading/trailing
/// icons, help/error text, and default/focused/error/disabled states.
/// Thin wrapper over [TextFormField] so validation, controllers, keyboard
/// types, and obscureText all work exactly as they would on a bare
/// [TextFormField]; only the visual chrome is themed.
///
/// Colors resolve from the ambient [Theme]'s [ColorScheme] (light/dark
/// aware); pass [color] to override the focus/accent color for one
/// instance.
class SldsTextField extends StatelessWidget {
  const SldsTextField({
    required this.label,
    super.key,
    this.controller,
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
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.validator,
  });

  final String label;
  final TextEditingController? controller;
  final bool isRequired;
  final String? helpText;
  final String? errorText;
  final String? hintText;
  final IconData? leadingIcon;

  /// A full leading widget (e.g. a country-code prefix) — takes precedence
  /// over [leadingIcon] when both are given.
  final Widget? leadingWidget;
  final IconData? trailingIcon;

  /// Overrides the trailing icon's color; defaults to [ColorScheme.onSurface]
  /// (or [ColorScheme.error] while [errorText] is set).
  final Color? trailingIconColor;

  /// Accessible name for the trailing icon button. An icon-only control has
  /// no visible text, so pass this whenever [onTrailingIconPressed] is set.
  final String? trailingIconTooltip;

  final VoidCallback? onTrailingIconPressed;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  bool get _hasError => errorText != null && errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    // Figma draws a plain 1px border in every state and carries the state in
    // the colour alone, so no state thickens the stroke.
    OutlineInputBorder border(Color borderColor) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(dimensions.radius2xl),
      borderSide: BorderSide(
        color: borderColor,
        width: dimensions.controlBorderWidth,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            // Figma labels the field in Body 2 (14px), not the 16px
            // fieldLabel token used by the selection controls.
            style: tokens.typography.body2.copyWith(
              color: enabled ? colors.inputLabel : colors.disabledForeground,
            ),
            children: [
              TextSpan(text: label),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: colors.error),
                ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: dimensions.space8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          validator: validator,
          // Figma sets the value in Body 1 whether or not it is obscured, so
          // revealing a password must not reflow the field.
          style: tokens.typography.body1.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: tokens.typography.body1.copyWith(
              color: colors.inputPlaceholder,
            ),
            prefixIcon: leadingWidget != null
                ? Center(widthFactor: 1, child: leadingWidget)
                : (leadingIcon != null ? Icon(leadingIcon, size: 20) : null),
            prefixIconConstraints: leadingWidget != null
                ? const BoxConstraints()
                : null,
            suffixIcon: trailingIcon != null
                ? IconButton(
                    icon: Icon(
                      trailingIcon,
                      size: dimensions.iconSizeMedium,
                      color: trailingIconColor,
                    ),
                    tooltip: trailingIconTooltip,
                    onPressed: onTrailingIconPressed,
                  )
                : null,
            filled: true,
            fillColor: enabled ? colors.surfaceCard : colors.disabledBackground,
            // Figma's Content box is a fixed 52px tall with 8px of horizontal
            // padding; constraints rather than vertical padding so the height
            // is a floor the field can still grow past at large text scales.
            constraints: BoxConstraints(minHeight: dimensions.inputHeight),
            contentPadding: EdgeInsetsDirectional.symmetric(
              horizontal: dimensions.space8,
              vertical: dimensions.space8,
            ),
            border: border(colors.inputBorderDefault),
            enabledBorder: border(
              _hasError ? colors.inputBorderError : colors.inputBorderDefault,
            ),
            focusedBorder: border(
              _hasError ? colors.inputBorderError : colors.inputBorderFocused,
            ),
            errorBorder: border(colors.inputBorderError),
            focusedErrorBorder: border(colors.inputBorderError),
            disabledBorder: border(colors.inputBorderDisabled),
          ),
        ),
        if (_hasError || (helpText != null && helpText!.isNotEmpty)) ...[
          SizedBox(height: dimensions.space6),
          Text(
            _hasError ? errorText! : helpText!,
            style: tokens.typography.caption1.copyWith(
              color: _hasError
                  ? colors.error
                  : (enabled ? colors.inputHelper : colors.disabledForeground),
            ),
          ),
        ],
      ],
    );
  }
}
