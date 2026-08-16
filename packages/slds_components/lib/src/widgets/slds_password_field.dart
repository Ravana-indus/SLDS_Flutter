import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/widgets/slds_text_field.dart';

/// SLDS password input — an [SldsTextField] with a built-in show/hide
/// toggle (the eye icon). Owns the obscure/reveal state itself so callers
/// don't need to; everything else (label, required marker, help/error
/// text, disabled state, validation) is identical to [SldsTextField].
class SldsPasswordField extends StatefulWidget {
  const SldsPasswordField({
    super.key,
    this.label = 'Password',
    this.controller,
    this.isRequired = false,
    this.helpText,
    this.errorText,
    this.hintText = 'Example',
    this.enabled = true,
    this.onChanged,
    this.validator,
  });

  final String label;
  final TextEditingController? controller;
  final bool isRequired;
  final String? helpText;
  final String? errorText;
  final String? hintText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  State<SldsPasswordField> createState() => _SldsPasswordFieldState();
}

class _SldsPasswordFieldState extends State<SldsPasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return SldsTextField(
      label: widget.label,
      controller: widget.controller,
      isRequired: widget.isRequired,
      helpText: widget.helpText,
      errorText: widget.errorText,
      hintText: widget.hintText,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      validator: widget.validator,
      obscureText: _obscured,
      // Figma pairs Show Password=False with Eye and =True with EyeSlash: the
      // glyph shows what the field currently is, not what tapping would do.
      trailingIcon: _obscured
          ? Icons.visibility_off_outlined
          : Icons.visibility_outlined,
      // An icon-only toggle has no visible text, so this is the control's
      // accessible name — and it names the action, which is the opposite of
      // what the glyph depicts.
      trailingIconTooltip: _obscured
          ? context.sldsStrings.showPassword
          : context.sldsStrings.hidePassword,
      onTrailingIconPressed: widget.enabled
          ? () => setState(() => _obscured = !_obscured)
          : null,
    );
  }
}
