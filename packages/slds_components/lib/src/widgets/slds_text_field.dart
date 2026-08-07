import 'package:flutter/material.dart';

import '../tokens/slds_colors.dart';
import '../tokens/slds_spacing.dart';

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
    super.key,
    required this.label,
    this.controller,
    this.isRequired = false,
    this.helpText,
    this.errorText,
    this.hintText,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingIconPressed,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.color,
  });

  final String label;
  final TextEditingController? controller;
  final bool isRequired;
  final String? helpText;
  final String? errorText;
  final String? hintText;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingIconPressed;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  /// Overrides the token-driven focus/accent color for this instance only.
  final Color? color;

  bool get _hasError => errorText != null && errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = color ?? scheme.primary;

    OutlineInputBorder border(Color borderColor) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(SldsSpacing.sm),
          borderSide: BorderSide(color: borderColor),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scheme.onSurface),
            children: [
              TextSpan(text: label),
              if (isRequired) TextSpan(text: ' *', style: TextStyle(color: scheme.error)),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: SldsSpacing.xs),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: leadingIcon != null ? Icon(leadingIcon, size: 20) : null,
            suffixIcon: trailingIcon != null
                ? IconButton(
                    icon: Icon(trailingIcon, size: 20),
                    onPressed: onTrailingIconPressed,
                  )
                : null,
            filled: true,
            fillColor: enabled ? scheme.surface : scheme.onSurface.withValues(alpha: 0.04),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SldsSpacing.md,
              vertical: SldsSpacing.md,
            ),
            border: border(scheme.outline),
            enabledBorder: border(_hasError ? scheme.error : scheme.outline),
            focusedBorder: border(_hasError ? scheme.error : accent),
            errorBorder: border(scheme.error),
            focusedErrorBorder: border(scheme.error),
            disabledBorder: border(scheme.outline.withValues(alpha: SldsColors.disabledOpacity)),
          ),
        ),
        if (_hasError || (helpText != null && helpText!.isNotEmpty)) ...[
          const SizedBox(height: SldsSpacing.xs),
          Text(
            _hasError ? errorText! : helpText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _hasError
                      ? scheme.error
                      : scheme.onSurface.withValues(alpha: enabled ? 0.6 : SldsColors.disabledOpacity),
                ),
          ),
        ],
      ],
    );
  }
}
