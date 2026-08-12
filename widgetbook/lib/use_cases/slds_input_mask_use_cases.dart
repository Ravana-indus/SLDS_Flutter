import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Knob-only wrapper — Widgetbook's dropdown knob requires a non-null
/// [initialOption], so [auto] stands in for "no forced state" (`null`)
/// rather than passing `null` as an option itself.
enum _ForcedState { auto, defaultState, filled, focused, error, disabled }

SldsInputMaskState? _toVisualState(_ForcedState state) => switch (state) {
      _ForcedState.auto => null,
      _ForcedState.defaultState => SldsInputMaskState.defaultState,
      _ForcedState.filled => SldsInputMaskState.filled,
      _ForcedState.focused => SldsInputMaskState.focused,
      _ForcedState.error => SldsInputMaskState.error,
      _ForcedState.disabled => SldsInputMaskState.disabled,
    };

@widgetbook.UseCase(name: 'Playground', type: SldsInputMask, path: '[Forms & Inputs]')
Widget buildSldsInputMaskUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Input');
  final prefixText = context.knobs.string(label: 'Prefix', initialValue: 'http://');
  final suffixText = context.knobs.string(label: 'Suffix', initialValue: '.com');
  final hintText = context.knobs.string(label: 'Hint', initialValue: 'slds');
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
    child: SldsInputMask(
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
