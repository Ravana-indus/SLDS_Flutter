import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_checkbox.dart';
import 'package:slds_components/src/widgets/slds_focus.dart';

/// Figma states for [SldsComboBox], matching node `543:5821`.
enum SldsComboBoxState {
  /// Closed, at rest.
  defaultState,

  /// The user is typing a filter query.
  filling,

  /// Open with multiple options selectable.
  multiSelect,

  /// Open with the input expanded over the field.
  inputExpanded,
}

/// A controlled, filterable single- or multi-select combo box.
///
/// [selectedValues] and [onSelectionChanged] form the component contract; no
/// option list or selected copy is hardcoded into the design-system package.
class SldsComboBox extends StatefulWidget {
  /// Creates an SLDS combo box.
  const SldsComboBox({
    required this.label,
    required this.placeholder,
    required this.options,
    required this.selectedValues,
    required this.onSelectionChanged,
    super.key,
    this.helperText,
    this.searchPlaceholder,
    this.required = true,
    this.multiple = false,
    this.visualState,
    this.width,
    this.semanticLabel,
    this.clearSelectionSemanticLabel,
  });

  /// Visible field label.
  final String label;

  /// Localized input hint.
  final String placeholder;

  /// Application-owned option labels.
  final List<String> options;

  /// Currently selected option labels.
  final List<String> selectedValues;

  /// Reports the next controlled selection list.
  final ValueChanged<List<String>> onSelectionChanged;

  /// Optional supporting guidance.
  final String? helperText;

  /// Hint for the in-panel search field. Defaults to the localized "Search".
  final String? searchPlaceholder;

  /// Whether to display the required marker.
  final bool required;

  /// Enables Figma multi-select chip behavior.
  final bool multiple;

  /// Forced Figma state for documentation and visual tests.
  final SldsComboBoxState? visualState;

  /// Preferred width, clamped to parent constraints.
  final double? width;

  /// Accessible name for the editable filter field.
  final String? semanticLabel;

  /// Optional accessible text for a chip removal button.
  final String? clearSelectionSemanticLabel;

  @override
  State<SldsComboBox> createState() => _SldsComboBoxState();
}

class _SldsComboBoxState extends State<SldsComboBox> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode(debugLabel: 'SldsComboBox');
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refresh);
    _focusNode.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refresh)
      ..dispose();
    _focusNode
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _select(String option) {
    final next = List<String>.of(widget.selectedValues);
    if (widget.multiple) {
      if (next.contains(option)) {
        next.remove(option);
      } else {
        next.add(option);
      }
    } else {
      next
        ..clear()
        ..add(option);
      _controller.clear();
      _open = false;
    }
    widget.onSelectionChanged(next);
  }

  void _remove(String value) {
    final next = List<String>.of(widget.selectedValues)..remove(value);
    widget.onSelectionChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final dimensions = tokens.dimensions;
    final colors = tokens.colors;
    final forcedOpen =
        widget.visualState == SldsComboBoxState.filling ||
        widget.visualState == SldsComboBoxState.multiSelect ||
        widget.visualState == SldsComboBoxState.inputExpanded;
    final expanded =
        widget.visualState == SldsComboBoxState.inputExpanded ||
        (widget.visualState == null && widget.selectedValues.length > 2);
    final focused =
        _focusNode.hasFocus ||
        widget.visualState == SldsComboBoxState.filling ||
        widget.visualState == SldsComboBoxState.inputExpanded;
    final displayChips = widget.multiple && widget.selectedValues.isNotEmpty;
    // The collapsed field holds the trailing toggle, which is a tap target:
    // clamp up to the 48dp floor so the button is not squeezed under it
    // (WCAG 2.5.8).
    final fieldHeight = expanded
        ? null
        : (dimensions.inputHeight < dimensions.tapTargetMin
              ? dimensions.tapTargetMin
              : dimensions.inputHeight);
    final query = _controller.text.toLowerCase();
    final filtered = widget.options
        .where((option) => option.toLowerCase().contains(query))
        .toList(growable: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        const referenceWidth = 361.0;
        final desired = widget.width ?? referenceWidth;
        final width = constraints.hasBoundedWidth
            ? desired.clamp(0.0, constraints.maxWidth)
            : desired;
        return SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      widget.label,
                      style: tokens.typography.fieldLabel.copyWith(
                        color: colors.inputLabel,
                      ),
                    ),
                  ),
                  if (widget.required)
                    Text(
                      '*',
                      style: tokens.typography.fieldLabel.copyWith(
                        color: colors.inputBorderError,
                      ),
                    ),
                ],
              ),
              SizedBox(height: dimensions.space4),
              Container(
                constraints: fieldHeight == null
                    ? const BoxConstraints(minHeight: 56)
                    : BoxConstraints.tightFor(height: fieldHeight),
                // No vertical padding: the 52dp field minus a 1dp border top
                // and bottom leaves exactly the 48dp the trailing toggle
                // needs as a tap target (WCAG 2.5.8). Children inset
                // themselves.
                padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 8, 0),
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  border: Border.all(
                    color: focused
                        ? colors.inputBorderFocused
                        : colors.inputBorderDefault,
                    width: focused
                        ? dimensions.emphasizedBorderWidth
                        : dimensions.controlBorderWidth,
                  ),
                  borderRadius: BorderRadius.circular(dimensions.radius2xl),
                  boxShadow: focused ? sldsFocusRing(tokens) : null,
                ),
                child: Row(
                  // The field's 8dp vertical padding would otherwise squeeze
                  // the trailing toggle below the 48dp tap-target floor; the
                  // button manages its own inset instead.
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: displayChips
                          ? Wrap(
                              spacing: 10,
                              runSpacing: 6,
                              children: [
                                for (final value in widget.selectedValues)
                                  _SelectionChip(
                                    value: value,
                                    semanticLabel:
                                        widget.clearSelectionSemanticLabel,
                                    onRemove: () => _remove(value),
                                  ),
                                // Filtering moved into the panel's search bar,
                                // so the chip row keeps only a tappable gap
                                // that opens the panel — no second TextField
                                // sharing this state's controller.
                                SizedBox(
                                  width: dimensions.tapTargetMin,
                                  height: dimensions.tapTargetMin,
                                ),
                              ],
                            )
                          // Display-only: the panel's search bar owns the
                          // filter text, so the collapsed field just shows the
                          // selection or the placeholder and opens the panel.
                          : Semantics(
                              button: true,
                              label: widget.semanticLabel ?? widget.label,
                              child: InkWell(
                                onTap: () => setState(() => _open = true),
                                child: Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  constraints: BoxConstraints(
                                    minHeight: dimensions.tapTargetMin,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: dimensions.space8,
                                  ),
                                  child: Text(
                                    widget.selectedValues.isEmpty
                                        ? widget.placeholder
                                        : widget.selectedValues.first,
                                    style: tokens.typography.body1.copyWith(
                                      color: widget.selectedValues.isEmpty
                                          ? colors.inputPlaceholder
                                          : colors.inputLabel,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    // Icon-only, so it needs its own name: the field's label
                    // sits on a different node and a screen reader landing
                    // here would otherwise announce nothing. Sized to the
                    // 48dp tap-target floor (WCAG 2.5.8) rather than 36.
                    IconButton(
                      onPressed: () => setState(() => _open = !_open),
                      tooltip: [
                        widget.semanticLabel ?? widget.label,
                        if (_open || forcedOpen)
                          context.sldsStrings.expanded
                        else
                          context.sldsStrings.collapsed,
                      ].join(', '),
                      icon: Icon(
                        _open || forcedOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                      iconSize: 20,
                      constraints: BoxConstraints(
                        minWidth: dimensions.tapTargetMin,
                        minHeight: dimensions.tapTargetMin,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              if (widget.helperText != null) ...[
                SizedBox(height: dimensions.space6),
                Text(
                  widget.helperText!,
                  style: tokens.typography.caption1.copyWith(
                    color: colors.inputHelper,
                  ),
                ),
              ],
              if (_open || forcedOpen) ...[
                SizedBox(height: dimensions.space4),
                Container(
                  decoration: BoxDecoration(
                    color: colors.surfacePage,
                    borderRadius: BorderRadius.circular(dimensions.radius3xl),
                    border: Border.all(
                      color: colors.borderDecorative,
                      width: dimensions.controlBorderWidth,
                    ),
                    // Figma "Elevation/3 · Floating": the panel overlaps the
                    // content beneath it, so it carries the elevation tokens
                    // rather than sitting flat on the page.
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadowColor,
                        blurRadius: dimensions.elevationBlur,
                        offset: Offset(0, dimensions.elevationOffsetY),
                        spreadRadius: -dimensions.elevationSpread,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: dimensions.space8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: dimensions.space8,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: dimensions.space12,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfacePage,
                            borderRadius: BorderRadius.circular(
                              dimensions.radius2xl,
                            ),
                            // Figma Search Bar: the input border tokens, not
                            // the decorative one that outlines the panel, and
                            // it turns gold in the Typing state.
                            border: Border.all(
                              color: _controller.text.isEmpty
                                  ? colors.inputBorderDefault
                                  : colors.inputBorderFocused,
                              width: dimensions.emphasizedBorderWidth,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                size: dimensions.iconSizeMedium,
                                color: colors.inputIcon,
                              ),
                              SizedBox(width: dimensions.space8),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  style: tokens.typography.body2,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    // The decorated field paints taller, but
                                    // the text node is the tap target and must
                                    // clear the 48dp floor (WCAG 2.5.8).
                                    constraints: BoxConstraints(
                                      minHeight: dimensions.tapTargetMin,
                                    ),
                                    // Vertical padding centres the line inside
                                    // that 48dp box; EdgeInsets.zero
                                    // top-aligns it.
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: dimensions.space12,
                                    ),
                                    hintText:
                                        widget.searchPlaceholder ??
                                        context.sldsStrings.search,
                                    hintStyle: tokens.typography.body2.copyWith(
                                      color: colors.inputPlaceholder,
                                    ),
                                  ),
                                ),
                              ),
                              // Figma Typing state: a 28px secondary-styled
                              // circle that clears the query. Only present
                              // once there is something to clear.
                              if (_controller.text.isNotEmpty)
                                IconButton(
                                  onPressed: _controller.clear,
                                  tooltip: context.sldsStrings.clearSearch,
                                  icon: Icon(
                                    Icons.close,
                                    size: dimensions.iconSizeSmall,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor:
                                        colors.buttonSecondaryBackground,
                                    side: BorderSide(
                                      color: colors.buttonSecondaryBorder,
                                      width: dimensions.controlBorderWidth,
                                    ),
                                    // The glyph circle stays 28dp as drawn;
                                    // the tap target below expands the hit
                                    // area to the 48dp floor (WCAG 2.5.8).
                                    fixedSize: const Size.square(28),
                                    minimumSize: const Size.square(28),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: dimensions.space4),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 240),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final option = filtered[index];
                            final selected = widget.selectedValues.contains(
                              option,
                            );
                            // The row already carries the option name and its
                            // selected state, so the checkbox inside it is
                            // decorative to assistive tech.
                            return MergeSemantics(
                              child: Semantics(
                                selected: selected,
                                child: InkWell(
                                  onTap: () => _select(option),
                                  borderRadius: BorderRadius.circular(
                                    dimensions.radiusXl,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(dimensions.space8),
                                    child: Row(
                                      children: [
                                        ExcludeSemantics(
                                          child: SldsCheckbox(
                                            value: selected,
                                            size: SldsCheckboxSize.small,
                                            onChanged: (_) => _select(option),
                                          ),
                                        ),
                                        SizedBox(width: dimensions.space8),
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: tokens.typography.body2
                                                .copyWith(
                                                  color: colors.inputLabel,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SelectionChip extends StatelessWidget {
  const _SelectionChip({
    required this.value,
    required this.semanticLabel,
    required this.onRemove,
  });

  final String value;
  final String? semanticLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 4, 4),
    decoration: BoxDecoration(
      color: context.slds.colors.badgeNeutralBackground,
      borderRadius: BorderRadius.circular(9999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: context.slds.typography.body1),
        Semantics(
          container: true,
          excludeSemantics: true,
          button: true,
          label: semanticLabel == null ? value : '$semanticLabel $value',
          // The glyph stays 20x20; SldsTapTarget expands only the hit area
          // to the 48dp floor (WCAG 2.5.8) without changing the chip's look.
          child: SldsTapTarget(
            child: InkWell(
              onTap: onRemove,
              child: const SizedBox(
                width: 20,
                height: 20,
                child: Icon(Icons.close, size: 16),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
