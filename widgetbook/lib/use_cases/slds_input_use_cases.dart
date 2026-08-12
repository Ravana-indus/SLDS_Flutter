import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Knob-only wrapper — Widgetbook's dropdown knob requires a non-null
/// [initialOption], so [auto] stands in for "no forced state" (`null`)
/// rather than passing `null` as an option itself.
enum _ForcedState { auto, defaultState, filled, focused, error, disabled }

SldsInputState? _toVisualState(_ForcedState state) => switch (state) {
      _ForcedState.auto => null,
      _ForcedState.defaultState => SldsInputState.defaultState,
      _ForcedState.filled => SldsInputState.filled,
      _ForcedState.focused => SldsInputState.focused,
      _ForcedState.error => SldsInputState.error,
      _ForcedState.disabled => SldsInputState.disabled,
    };

@widgetbook.UseCase(name: 'Playground', type: SldsInput, path: '[Forms & Inputs]')
Widget buildSldsInputUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Input');
  final prefixText = context.knobs.string(label: 'Prefix', initialValue: 'LKR');
  final suffixText = context.knobs.string(label: 'Suffix', initialValue: 'KG');
  final hintText = context.knobs.string(label: 'Hint', initialValue: '0000');
  final helperText = context.knobs.string(label: 'Help text', initialValue: 'Help Text');
  final isRequired = context.knobs.boolean(label: 'Required', initialValue: true);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final forcedState = context.knobs.object.dropdown(
    label: 'Forced visual state',
    options: _ForcedState.values,
    labelBuilder: (s) => s.name,
    initialOption: _ForcedState.auto,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsInput(
      label: label,
      prefixText: prefixText.isEmpty ? null : prefixText,
      suffixText: suffixText.isEmpty ? null : suffixText,
      hintText: hintText,
      helperText: helperText,
      errorText: 'Help Text',
      required: isRequired,
      enabled: isEnabled,
      visualState: _toVisualState(forcedState),
    ),
  );
}
