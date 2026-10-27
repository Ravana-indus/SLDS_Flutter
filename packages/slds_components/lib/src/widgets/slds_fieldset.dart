import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// SLDS fieldset — logical grouping for a multi-field section: a bordered
/// container whose legend (with optional required marker) sits on its top
/// edge, a vertically-spaced column of [children], and shared
/// [helperText]/[errorText] below the group (for group-level validation,
/// e.g. "select at least one option" spanning several checkboxes).
///
/// This is a layout/semantics wrapper only — it doesn't manage the state of
/// what it contains. Exposed to assistive tech as an `HTML fieldset`/`legend`
/// pair equivalent via [Semantics.container].
class SldsFieldset extends StatelessWidget {
  /// Creates a fieldset grouping related controls under a legend.
  const SldsFieldset({
    required this.legend,
    required this.children,
    super.key,
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

  /// Vertical gap between [children]. Defaults to Figma's 24px
  /// ([SldsDimensionTokens.space24]).
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
    final gap = spacing ?? dimensions.space24;
    final legendColor = enabled
        ? colors.textPrimary
        : colors.disabledForeground;
    final supportText = _hasError ? errorText : helperText;
    final supportColor = !enabled
        ? colors.disabledForeground
        : _hasError
        ? colors.error
        : colors.textSecondary;

    // Figma Form Fieldset (1097:5140): a white box, #BCBCBC 1px, radius 16,
    // 32px padding. The legend is a white chip (4/2 padding, radius 8) set
    // into the top border, 32px in, its top 12px above the border (#119,
    // #120).
    const legendOverhang = 12.0;
    final inset = dimensions.space32;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: legend,
      child: Stack(
        children: [
          // Drawn behind the content and sized by it, so a legend that wraps
          // at large text scales pushes the fields down instead of covering
          // them, and the border still runs behind its chip.
          Positioned.fill(
            top: legendOverhang,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                border: Border.all(color: colors.inputBorderDefault),
                borderRadius: BorderRadius.circular(dimensions.radius3xl),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(inset, 0, inset, inset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: dimensions.space4,
                    vertical: dimensions.space2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceCard,
                    borderRadius: BorderRadius.circular(dimensions.radiusXl),
                  ),
                  // Text.rich so a long legend wraps with its asterisk, not
                  // past it: at the 320dp floor with 200% text a legend of a
                  // few words is already wider than the box.
                  child: Text.rich(
                    TextSpan(
                      // Figma's legend is Mobile/Body 1: 16/400/24 (#122).
                      style: tokens.typography.body1.copyWith(
                        height: 24 / 16,
                        color: legendColor,
                      ),
                      children: [
                        TextSpan(text: legend),
                        if (required)
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: enabled
                                  ? colors.inputBorderError
                                  : colors.disabledForeground,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // The first field starts 32px inside the border, as in Figma.
                SizedBox(
                  height: inset - (dimensions.space2 * 2 + 24 - legendOverhang),
                ),
                if (description != null) ...[
                  Text(
                    description!,
                    style: tokens.typography.body2.copyWith(
                      color: enabled
                          ? colors.textSecondary
                          : colors.disabledForeground,
                    ),
                  ),
                  SizedBox(height: gap),
                ],
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) SizedBox(height: gap),
                  children[i],
                ],
                if (supportText != null) ...[
                  SizedBox(height: dimensions.space8),
                  Text(
                    supportText,
                    style: tokens.typography.caption1.copyWith(
                      color: supportColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
