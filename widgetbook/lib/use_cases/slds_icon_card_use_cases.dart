import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// `auto` lets state be derived from hover/onTap like a real app; forcing
/// one of the others previews it directly — dropdown knobs need a non-null
/// `initialOption`, so `auto` stands in for "no forced state".
enum _ForcedState { auto, defaultState, hover, disabled }

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsIconCard,
  path: '[Display & Data]',
)
Widget buildSldsIconCardUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Fuel Pass');
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Apply for a fuel quota pass',
  );
  final badgeLabel = context.knobs.string(
    label: 'Badge label',
    initialValue: 'NEW',
  );
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: SldsIconCardSize.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsIconCardSize.small,
  );
  final forced = context.knobs.object.dropdown(
    label: 'Force state',
    options: _ForcedState.values,
    labelBuilder: (s) => s.name,
    initialOption: _ForcedState.auto,
  );

  return Padding(
    padding: const EdgeInsets.all(16),
    child: SldsIconCard(
      title: title,
      description: description.isEmpty ? null : description,
      badgeLabel: badgeLabel.isEmpty ? null : badgeLabel,
      icon: const Icon(Icons.local_gas_station, color: Colors.green),
      size: size,
      state: switch (forced) {
        _ForcedState.auto => null,
        _ForcedState.defaultState => SldsIconCardState.defaultState,
        _ForcedState.hover => SldsIconCardState.hover,
        _ForcedState.disabled => SldsIconCardState.disabled,
      },
      onTap: forced == _ForcedState.disabled ? null : () {},
    ),
  );
}
