import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// `auto` lets state be derived from hover/selected like a real app; forcing
/// one of the others previews it directly — dropdown knobs need a non-null
/// `initialOption`, so `auto` stands in for "no forced state".
enum _ForcedState { auto, defaultState, hover, selected, active }

@widgetbook.UseCase(name: 'Playground', type: SldsServiceCard, path: '[Display & Data]')
Widget buildSldsServiceCardUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Service Name');
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Enter the description text',
  );
  final badgeText = context.knobs.string(label: 'Badge text', initialValue: 'Success');
  final forced = context.knobs.object.dropdown(
    label: 'Force state',
    options: _ForcedState.values,
    labelBuilder: (s) => s.name,
    initialOption: _ForcedState.auto,
  );

  return Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      width: 400,
      child: SldsServiceCard(
        icon: const Icon(Icons.description, color: Colors.deepPurple),
        title: title,
        description: description,
        badgeText: badgeText.isEmpty ? null : badgeText,
        selected: forced == _ForcedState.active,
        state: switch (forced) {
          _ForcedState.auto => null,
          _ForcedState.defaultState => SldsServiceCardState.defaultState,
          _ForcedState.hover => SldsServiceCardState.hover,
          _ForcedState.selected => SldsServiceCardState.selected,
          _ForcedState.active => SldsServiceCardState.active,
        },
        onTap: () {},
      ),
    ),
  );
}
