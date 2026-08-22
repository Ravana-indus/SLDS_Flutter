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
    this.label,
    this.controller,
    this.compact = false,
    this.isRequired = false,
    this.helpText,
    this.errorText,
    this.hintText,
    this.enabled = true,
    this.onChanged,
    this.validator,
  });

  /// Defaults to the localized "Password" when null.
  final String? label;

  final TextEditingController? controller;

  /// Figma's password set has no compact variant; this forwards the density
  /// so a password can sit in a compact form without breaking its rhythm.
  final bool compact;

  final bool isRequired;
  final String? helpText;
  final String? errorText;

  /// Defaults to the localized placeholder when null.
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
    final strings = context.sldsStrings;

    return SldsTextField(
      label: widget.label ?? strings.passwordLabel,
      controller: widget.controller,
      compact: widget.compact,
      isRequired: widget.isRequired,
      helpText: widget.helpText,
      errorText: widget.errorText,
      hintText: widget.hintText ?? strings.passwordHint,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      validator: widget.validator,
      obscureText: _obscured,
      // Figma pairs Show Password=False with Eye (69:23803) and =True with
      // EyeSlash (69:23894): the glyph is the affordance — a plain eye means
      // "tap to reveal" — not a depiction of the field's current state.
      trailingIcon: _obscured
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
      // The reveal toggle is the field's primary control, so Figma draws it
      // in the 36dp box rather than the 28dp adornment slot.
      largeTrailingIcon: true,
      // An icon-only toggle has no visible text, so this is the control's
      // accessible name. It names the action, matching the glyph.
      trailingIconTooltip: _obscured
          ? strings.showPassword
          : strings.hidePassword,
      onTrailingIconPressed: widget.enabled
          ? () => setState(() => _obscured = !_obscured)
          : null,
    );
  }
}
