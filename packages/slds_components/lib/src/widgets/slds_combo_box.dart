import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_focus.dart';

/// Figma states for [SldsComboBox], matching node `543:5821`.
enum SldsComboBoxState { defaultState, filling, multiSelect, inputExpanded }

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
    final fieldHeight = expanded ? null : dimensions.inputHeight;
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
                    ? const BoxConstraints(minHeight: 52)
                    : BoxConstraints.tightFor(height: fieldHeight),
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
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
                                SizedBox(
                                  width: expanded ? 48 : 28,
                                  child: TextField(
                                    controller: _controller,
                                    focusNode: _focusNode,
                                    onTap: () => setState(() => _open = true),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Semantics(
                              textField: true,
                              label: widget.semanticLabel ?? widget.label,
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                onTap: () => setState(() => _open = true),
                                style: tokens.typography.body1,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  hintText: widget.selectedValues.isEmpty
                                      ? widget.placeholder
                                      : widget.selectedValues.first,
                                  hintStyle: tokens.typography.body1.copyWith(
                                    color: colors.inputPlaceholder,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _open = !_open),
                      icon: Icon(
                        _open || forcedOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                      iconSize: 20,
                      constraints: const BoxConstraints.tightFor(
                        width: 36,
                        height: 36,
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
                const SizedBox(height: 4),
                Material(
                  color: colors.surfacePage,
                  borderRadius: BorderRadius.circular(dimensions.radius3xl),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final option = filtered[index];
                        final selected = widget.selectedValues.contains(option);
                        return Semantics(
                          button: true,
                          selected: selected,
                          label: option,
                          child: InkWell(
                            onTap: () => _select(option),
                            child: SizedBox(
                              height: 38,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: tokens.typography.body2,
                                      ),
                                    ),
                                    if (selected)
                                      const Icon(Icons.check, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
    padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
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
          child: InkWell(
            onTap: onRemove,
            child: const SizedBox(
              width: 20,
              height: 20,
              child: Icon(Icons.close, size: 16),
            ),
          ),
        ),
      ],
    ),
  );
}
