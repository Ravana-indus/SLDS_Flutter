import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

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

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsInput,
  path: '[Forms & Inputs]',
)
Widget buildSldsInputUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final labelOverride = context.knobs.string(
    label: 'Label',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final label = labelOverride.isEmpty ? copy['Input'] : labelOverride;
  final prefixText = context.knobs.string(label: 'Prefix', initialValue: 'LKR');
  final suffixText = context.knobs.string(label: 'Suffix', initialValue: 'KG');
  final hintText = context.knobs.string(label: 'Hint', initialValue: '0000');
  final helperTextOverride = context.knobs.string(
    label: 'Help text',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final helperText = helperTextOverride.isEmpty
      ? copy['Help Text']
      : helperTextOverride;
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
    child: SldsInput(
      label: label,
      prefixText: prefixText.isEmpty ? null : prefixText,
      suffixText: suffixText.isEmpty ? null : suffixText,
      hintText: hintText,
      helperText: helperText,
      // Only surfaces error copy when the Error state is actually forced —
      // otherwise a real errorText would out-rank focus and the field would
      // stay red no matter what you clicked into.
      errorText: forcedState == _ForcedState.error ? 'Help Text' : null,
      required: isRequired,
      enabled: isEnabled,
      visualState: _toVisualState(forcedState),
    ),
  );
}
