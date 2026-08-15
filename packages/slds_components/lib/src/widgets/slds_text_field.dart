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

    OutlineInputBorder border(Color borderColor, {double? width}) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(dimensions.radiusLg),
          borderSide: BorderSide(
            color: borderColor,
            width: width ?? dimensions.controlBorderWidth,
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style: tokens.typography.fieldLabel.copyWith(
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
          // The default '•' obscuring dot renders oversized at bodyLarge's
          // 18px next to normal letters — a slightly smaller size keeps the
          // obscured and revealed states visually balanced.
          style: obscureText
              ? Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14)
              : Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
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
                      size: 20,
                      color: trailingIconColor,
                    ),
                    onPressed: onTrailingIconPressed,
                  )
                : null,
            filled: true,
            fillColor: enabled ? colors.surfaceCard : colors.disabledBackground,
            contentPadding: EdgeInsetsDirectional.symmetric(
              horizontal: dimensions.space12,
              vertical: dimensions.space12,
            ),
            border: border(colors.inputBorderDefault),
            enabledBorder: border(
              _hasError ? colors.inputBorderError : colors.inputBorderDefault,
            ),
            focusedBorder: border(
              _hasError ? colors.inputBorderError : colors.inputBorderFocused,
              width: dimensions.emphasizedBorderWidth,
            ),
            errorBorder: border(colors.inputBorderError),
            focusedErrorBorder: border(
              colors.inputBorderError,
              width: dimensions.emphasizedBorderWidth,
            ),
            disabledBorder: border(
              colors.inputBorderDisabled,
              width: dimensions.inputDisabledBorderWidth,
            ),
          ),
        ),
        if (_hasError || (helpText != null && helpText!.isNotEmpty)) ...[
          SizedBox(height: dimensions.space8),
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
