import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

const _districts = [
  'Batticaloa',
  'Colombo',
  'Galle',
  'Jaffna',
  'Kegalle',
  'Trincomalee',
  'Kurunegala',
  'Mannar',
  'Kilinochchi',
];

/// Knob-only wrapper — Widgetbook's dropdown knob requires a non-null
/// [initialOption], so [auto] stands in for "no forced state" (`null`)
/// rather than passing `null` as an option itself.
enum _ForcedState { auto, defaultState, filling, multiSelect, inputExpanded }

SldsComboBoxState? _toVisualState(_ForcedState state) => switch (state) {
  _ForcedState.auto => null,
  _ForcedState.defaultState => SldsComboBoxState.defaultState,
  _ForcedState.filling => SldsComboBoxState.filling,
  _ForcedState.multiSelect => SldsComboBoxState.multiSelect,
  _ForcedState.inputExpanded => SldsComboBoxState.inputExpanded,
};

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsComboBox,
  path: '[Forms & Inputs]',
)
Widget buildSldsComboBoxUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final labelOverride = context.knobs.string(
    label: 'Label',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final label = labelOverride.isEmpty ? copy['District'] : labelOverride;
  final helperTextOverride = context.knobs.string(
    label: 'Helper text',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final helperText = helperTextOverride.isEmpty
      ? copy['Help Text']
      : helperTextOverride;
  final searchPlaceholderOverride = context.knobs.string(
    label: 'Search placeholder',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final isRequired = context.knobs.boolean(
    label: 'Required',
    initialValue: true,
  );
  final multiple = context.knobs.boolean(label: 'Multiple', initialValue: true);
  final forcedState = context.knobs.object.dropdown(
    label: 'Forced visual state',
    options: _ForcedState.values,
    labelBuilder: (s) => s.name,
    initialOption: _ForcedState.auto,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: _ComboBoxDemo(
      label: label,
      helperText: helperText,
      // Blank means "no override" — the widget then falls back to the
      // localized "Search", which is what the Locale addon exercises.
      searchPlaceholder: searchPlaceholderOverride.isEmpty
          ? null
          : searchPlaceholderOverride,
      isRequired: isRequired,
      multiple: multiple,
      visualState: _toVisualState(forcedState),
    ),
  );
}

/// Real [State] (not a closure-local var) so the selection survives
/// rebuilds — see the SldsCheckbox playground bug this pattern avoids.
class _ComboBoxDemo extends StatefulWidget {
  const _ComboBoxDemo({
    required this.label,
    required this.helperText,
    required this.searchPlaceholder,
    required this.isRequired,
    required this.multiple,
    required this.visualState,
  });

  final String label;
  final String helperText;
  final String? searchPlaceholder;
  final bool isRequired;
  final bool multiple;
  final SldsComboBoxState? visualState;

  @override
  State<_ComboBoxDemo> createState() => _ComboBoxDemoState();
}

class _ComboBoxDemoState extends State<_ComboBoxDemo> {
  List<String> _selected = const [];

  @override
  Widget build(BuildContext context) {
    return SldsComboBox(
      label: widget.label,
      placeholder: 'Select district',
      helperText: widget.helperText,
      searchPlaceholder: widget.searchPlaceholder,
      required: widget.isRequired,
      multiple: widget.multiple,
      visualState: widget.visualState,
      options: _districts,
      selectedValues: _selected,
      onSelectionChanged: (v) => setState(() => _selected = v),
    );
  }
}
