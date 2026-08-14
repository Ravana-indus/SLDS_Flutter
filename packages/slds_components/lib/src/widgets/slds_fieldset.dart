import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// SLDS fieldset — logical grouping for a multi-field section: a legend
/// (with optional required marker), a vertically-spaced column of
/// [children], and shared [helperText]/[errorText] below the group (for
/// group-level validation, e.g. "select at least one option" spanning
/// several checkboxes).
///
/// This is a layout/semantics wrapper only — it doesn't manage the state of
/// what it contains. Exposed to assistive tech as an `HTML fieldset`/`legend`
/// pair equivalent via [Semantics.container].
class SldsFieldset extends StatelessWidget {
  const SldsFieldset({
    super.key,
    required this.legend,
    required this.children,
    this.description,
    this.required = false,
    this.helperText,
    this.errorText,
    this.spacing,
    this.enabled = true,
  });

  /// The group's heading (SLDS calls a text-field's own label "label";
  /// a fieldset's is "legend" to mirror HTML's `<legend>`).
  final String legend;

  /// Optional supporting copy shown under [legend], above [children].
  final String? description;

  /// Whether to show the required marker beside [legend] (e.g. "answer at
  /// least one question in this group").
  final bool required;

  /// The grouped fields — rendered in a single spaced [Column]. Wrap your
  /// own [Row] around a subset of these if some fields should sit side by
  /// side instead of stacked.
  final List<Widget> children;

  /// Shared guidance shown below the whole group when there's no [errorText].
  final String? helperText;

  /// Group-level validation message — replaces [helperText] and colors it
  /// as an error, same convention as every other SLDS field.
  final String? errorText;

  /// Vertical gap between [children]. Defaults to [SldsDimensionTokens.space16].
  final double? spacing;

  /// Dims the legend/description/helper text — does not disable [children]
  /// itself; disable each child individually.
  final bool enabled;

  bool get _hasError => errorText != null && errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final gap = spacing ?? dimensions.space16;
    final legendColor = enabled
        ? colors.textPrimary
        : colors.disabledForeground;
    final supportText = _hasError ? errorText : helperText;
    final supportColor = !enabled
        ? colors.disabledForeground
        : _hasError
        ? colors.error
        : colors.textSecondary;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: legend,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                legend,
                style: tokens.typography.heading4.copyWith(color: legendColor),
              ),
              if (required)
                Text(
                  '*',
                  style: tokens.typography.heading4.copyWith(
                    color: enabled
                        ? colors.inputBorderError
                        : colors.disabledForeground,
                  ),
                ),
            ],
          ),
          if (description != null) ...[
            SizedBox(height: dimensions.space4),
            Text(
              description!,
              style: tokens.typography.body2.copyWith(
                color: enabled
                    ? colors.textSecondary
                    : colors.disabledForeground,
              ),
            ),
          ],
          SizedBox(height: dimensions.space12),
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
          if (supportText != null) ...[
            SizedBox(height: dimensions.space8),
            Text(
              supportText,
              style: tokens.typography.caption1.copyWith(color: supportColor),
            ),
          ],
        ],
      ),
    );
  }
}
