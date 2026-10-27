import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
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
  /// Creates a labelled text field.
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
    this.semanticLabel,
  });

  /// Visible label above the field, and its default accessible name.
  final String label;

  /// Supply one to read or drive the text externally. When null the field
  /// owns an internal controller for its lifetime.
  final TextEditingController? controller;

  /// Supply one to drive focus externally. When null the field owns an
  /// internal node — the field listens either way, because the focused
  /// state changes the border width and horizontal padding, not just the
  /// border colour.
  final FocusNode? focusNode;

  /// Figma's `Compact=True` density.
  final bool compact;

  /// Marks the field as required, appending the required marker to the
  /// label and announcing it as required to a screen reader.
  final bool isRequired;

  /// Guidance shown below the field. Hidden while [errorText] is set, so the
  /// error replaces it rather than stacking.
  final String? helpText;

  /// Validation message shown below the field. Non-null puts the field in
  /// its error state: error-toned border and message, announced as an error.
  final String? errorText;

  /// Placeholder shown inside an empty field. Not a label substitute — it
  /// disappears on the first keystroke, so [label] must still carry meaning.
  final String? hintText;

  /// Decorative icon at the leading edge. Superseded by [leadingWidget].
  final IconData? leadingIcon;

  /// A full leading widget (e.g. a country-code prefix) — takes precedence
  /// over [leadingIcon] when both are given.
  final Widget? leadingWidget;

  /// Icon at the trailing edge. Interactive when [onTrailingIconPressed] is
  /// set, in which case [trailingIconTooltip] names it.
  final IconData? trailingIcon;

  /// Accessible name for the trailing icon button. An icon-only control has
  /// no visible text, so pass this whenever [onTrailingIconPressed] is set.
  final String? trailingIconTooltip;

  /// Makes the trailing icon a button. Null leaves it decorative.
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

  /// Called when the info affordance is tapped.
  final VoidCallback? onInfoPressed;

  /// Whether the field accepts input. Disabled fields dim and stop taking
  /// focus, but stay readable by a screen reader.
  final bool enabled;

  /// Hides the entered text, for passwords and other secrets.
  final bool obscureText;

  /// Which soft keyboard to raise (e.g. [TextInputType.emailAddress]).
  final TextInputType? keyboardType;

  /// Formatters applied as the user types, e.g. to mask or restrict input.
  final List<TextInputFormatter>? inputFormatters;

  /// Called on every change to the text.
  final ValueChanged<String>? onChanged;

  /// Validation callback, used when the field sits inside a [Form].
  ///
  /// Returning a message does not itself paint the error state — surface it
  /// through [errorText] so the styling and the announcement stay in step.
  final FormFieldValidator<String>? validator;

  /// Overrides the accessible name. Defaults to [label]; pass this where the
  /// visible label is too terse to stand alone out of context ("From", "To").
  final String? semanticLabel;

  @override
  State<SldsTextField> createState() => _SldsTextFieldState();
}

class _SldsTextFieldState extends State<SldsTextField> {
  FocusNode? _internalNode;

  FocusNode get _node => widget.focusNode ?? (_internalNode ??= FocusNode());

  @override
  void dispose() {
    _internalNode?.dispose();
    super.dispose();
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  /// The field's accessible name: the visible label, plus the two things
  /// the design conveys only in colour — the required asterisk and the
  /// error message.
  String _semanticLabel(BuildContext context) {
    final strings = context.sldsStrings;
    final buffer = StringBuffer(widget.semanticLabel ?? widget.label);
    if (widget.isRequired) buffer.write(', ${strings.required}');
    if (_hasError) buffer.write(', ${strings.error}: ${widget.errorText}');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final typography = tokens.typography;
    final compact = widget.compact;

    // Compact sets both the label and the value in Caption 1; the standard
    // density splits them across Body 2 and Body 1.
    final labelStyle = compact ? typography.caption1 : typography.fieldLabel;
    // Figma's value is Mobile/Body 1 on a 24px line; the shared body1 token
    // carries 20, which left the text and its icons 2px above centre (#169).
    final valueStyle = compact
        ? typography.caption1
        : typography.body1.copyWith(height: 24 / 16);

    // Focus thickens the stroke, and so does error: Figma's Text Input and
    // Password Error variants draw #D32F2F at 1.5px (1px when compact) (#106).
    final errorEmphasized = !compact;
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
          color: _hasError ? colors.error : iconColor,
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
          // Figma's Info glyph is #17171A, and #898989 when disabled — darker
          // than the grey star icons beside it (#116).
          color: widget.enabled ? colors.textPrimary : colors.inputIcon,
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
                // Disabled, Figma greys the asterisk with the label (#117).
                TextSpan(
                  text: '*',
                  style: widget.enabled ? TextStyle(color: colors.error) : null,
                ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: compact ? dimensions.space4 : dimensions.space8,
        ),
        // MergeSemantics is load-bearing: TextFormField wraps its field in a
        // FormField, whose semantics boundary drops a plain ancestor
        // Semantics label (a bare TextField would have taken it). Without
        // the merge the field announces with no name at all.
        MergeSemantics(
          child: Semantics(
            // The visible label is a sibling Text, so nothing connects it to
            // the field. Required and error state are visual-only too (a red
            // asterisk, red helper text), so both are folded into the name —
            // a screen-reader user otherwise cannot tell a mandatory field
            // from an optional one, or know why the form refused to submit.
            textField: true,
            label: _semanticLabel(context),
            child: TextFormField(
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
                // Figma Text Input: the 28px leading icon box sits 8px in from
                // the border, not centred in Flutter's 48px prefix slot.
                prefixIcon:
                    widget.leadingWidget ??
                    (widget.leadingIcon != null
                        ? Padding(
                            // End 4: with the decorator's own 4px after a
                            // prefix, the text starts 8px past the box, at
                            // Figma's 44px.
                            padding: EdgeInsetsDirectional.only(
                              start: dimensions.space8,
                              end: dimensions.space4,
                            ),
                            child: iconSlot(
                              icon: widget.leadingIcon!,
                              box: dimensions.buttonHeightSmall,
                              color: iconColor,
                            ),
                          )
                        : null),
                prefixIconConstraints: const BoxConstraints(),
                // Figma's Content box pads 8px inside the border on the
                // trailing side too; the icons sat flush against it (#169).
                suffixIcon: trailing.isEmpty
                    ? null
                    : Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: dimensions.space8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: trailing,
                        ),
                      ),
                suffixIconConstraints: const BoxConstraints(),
                filled: true,
                // Figma's `Input/Background` is the card surface in every
                // state: disabled fades the border and text but does not
                // darken the fill.
                fillColor: colors.surfaceCard,
                // Figma's Content box is a fixed height with the padding below;
                // constraints rather than vertical padding so the height is a
                // floor the field can still grow past at large text scales.
                constraints: BoxConstraints(
                  minHeight: compact
                      ? dimensions.inputHeightCompact
                      : dimensions.inputHeight,
                ),
                // Text starts 16px in without a leading icon (Figma's 8px
                // Content pad plus its 8px Text frame pad; the decorator adds
                // 4px of its own) and holds still on focus: Figma's Default
                // and Filled text share one position, so widening the pad on
                // focus only made the text jump (#169).
                // Vertically, the line is padded to fill the box exactly: any
                // slack under the height floor fell below the text, leaving
                // it and the icons 2px above centre.
                contentPadding: EdgeInsetsDirectional.symmetric(
                  horizontal: dimensions.space12,
                  vertical:
                      ((compact
                              ? dimensions.inputHeightCompact
                              : dimensions.inputHeight) -
                          valueStyle.fontSize! * valueStyle.height!) /
                      2,
                ),
                border: border(colors.inputBorderDefault),
                enabledBorder: _hasError
                    ? border(
                        colors.inputBorderError,
                        emphasized: errorEmphasized,
                      )
                    : border(colors.inputBorderDefault),
                focusedBorder: border(
                  _hasError
                      ? colors.inputBorderError
                      : colors.inputBorderFocused,
                  emphasized: true,
                ),
                errorBorder: border(
                  colors.inputBorderError,
                  emphasized: errorEmphasized,
                ),
                focusedErrorBorder: border(
                  colors.inputBorderError,
                  emphasized: true,
                ),
                disabledBorder: border(colors.inputBorderDisabled),
              ),
            ),
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
