import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Knob-only wrapper — Widgetbook's dropdown knob requires a non-null
/// [initialOption], so [auto] stands in for "no forced state" (`null`)
/// rather than passing `null` as an option itself.
enum _ForcedState { auto, defaultState, filled, focused, error, disabled }

SldsMobileNumberInputState? _toVisualState(_ForcedState state) =>
    switch (state) {
      _ForcedState.auto => null,
      _ForcedState.defaultState => SldsMobileNumberInputState.defaultState,
      _ForcedState.filled => SldsMobileNumberInputState.filled,
      _ForcedState.focused => SldsMobileNumberInputState.focused,
      _ForcedState.error => SldsMobileNumberInputState.error,
      _ForcedState.disabled => SldsMobileNumberInputState.disabled,
    };

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsMobileNumberInput,
  path: '[Forms & Inputs]',
)
Widget buildSldsMobileNumberInputUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Mobile Number',
  );
  final helperText = context.knobs.string(
    label: 'Helper text',
    initialValue: 'Help Text',
  );
  final errorText = context.knobs.string(
    label: 'Error text',
    initialValue: 'Enter a valid number',
  );
  final isRequired = context.knobs.boolean(
    label: 'Required',
    initialValue: true,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final forcedState = context.knobs.object.dropdown(
    label: 'Forced visual state',
    options: _ForcedState.values,
    labelBuilder: (s) => s.name,
    initialOption: _ForcedState.auto,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsMobileNumberInput(
      label: label,
      placeholder: '77 123 4567',
      helperText: helperText,
      errorText: errorText,
      required: isRequired,
      enabled: isEnabled,
      visualState: _toVisualState(forcedState),
      countryFlag: const Text('🇱🇰', style: TextStyle(fontSize: 20)),
      trailing: const Icon(Icons.close),
    ),
  );
}
