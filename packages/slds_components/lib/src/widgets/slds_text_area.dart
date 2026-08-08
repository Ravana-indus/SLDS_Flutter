import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/slds_colors.dart';
import '../tokens/slds_spacing.dart';

/// SLDS multiline text input — label (with required marker), placeholder,
/// a live `n/max` character counter, and default/focused/error/disabled
/// states. Same chrome language as [SldsTextField] but sized for paragraphs
/// rather than a single line.
///
/// Colors resolve from the ambient [Theme]'s [ColorScheme] (light/dark
/// aware); pass [color] to override the focus/accent color for one instance.
class SldsTextArea extends StatefulWidget {
  const SldsTextArea({
    super.key,
    required this.label,
    this.controller,
    this.isRequired = false,
    this.helpText,
    this.errorText,
    this.hintText,
    this.maxLength = 300,
    this.minLines = 3,
    this.maxLines = 6,
    this.enabled = true,
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

  /// Caps input length and drives the `n/max` counter. Null hides the
  /// counter and removes the cap.
  final int? maxLength;
  final int minLines;
  final int maxLines;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  /// Overrides the token-driven focus/accent color for this instance only.
  final Color? color;

  @override
  State<SldsTextArea> createState() => _SldsTextAreaState();
}

class _SldsTextAreaState extends State<SldsTextArea> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final bool _ownsController = widget.controller == null;

  @override
  void initState() {
    super.initState();
    // Rebuild so the counter updates as the user types.
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  bool get _hasError => widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = widget.color ?? scheme.primary;

    OutlineInputBorder border(Color borderColor) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(SldsSpacing.sm),
          borderSide: BorderSide(color: borderColor),
        );

    final counterColor = widget.enabled
        ? scheme.onSurface.withValues(alpha: 0.6)
        : scheme.onSurface.withValues(alpha: SldsColors.disabledOpacity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scheme.onSurface),
            children: [
              TextSpan(text: widget.label),
              if (widget.isRequired) TextSpan(text: ' *', style: TextStyle(color: scheme.error)),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: SldsSpacing.xs),
        TextFormField(
          controller: _controller,
          enabled: widget.enabled,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          inputFormatters: widget.maxLength != null
              ? [LengthLimitingTextInputFormatter(widget.maxLength)]
              : null,
          onChanged: widget.onChanged,
          validator: widget.validator,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: widget.enabled ? scheme.surface : scheme.onSurface.withValues(alpha: 0.04),
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
            counterText: widget.maxLength != null
                ? '${_controller.text.length}/${widget.maxLength}'
                : '',
            counterStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: counterColor),
          ),
        ),
        if (_hasError || (widget.helpText != null && widget.helpText!.isNotEmpty)) ...[
          const SizedBox(height: SldsSpacing.xs),
          Text(
            _hasError ? widget.errorText! : widget.helpText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _hasError
                      ? scheme.error
                      : scheme.onSurface.withValues(alpha: widget.enabled ? 0.6 : SldsColors.disabledOpacity),
                ),
          ),
        ],
      ],
    );
  }
}
