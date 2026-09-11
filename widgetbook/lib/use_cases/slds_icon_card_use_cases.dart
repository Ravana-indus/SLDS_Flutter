import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

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
  final copy = DemoCopy.of(context);
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: SldsIconCardVariant.values,
    labelBuilder: (v) => v.name,
    initialOption: SldsIconCardVariant.quickAction,
    description: 'The three Figma variants (node 533:2742).',
  );
  final titleOverride = context.knobs.string(
    label: 'Title',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final title = titleOverride.isEmpty ? copy['Fuel Pass'] : titleOverride;
  final descriptionOverride = context.knobs.string(
    label: 'Description',
    initialValue: '',
    description: 'Blank follows the Locale addon. Quick Action ignores it.',
  );
  final description = descriptionOverride.isEmpty
      ? copy['Apply for a fuel quota pass']
      : descriptionOverride;
  final badgeLabelOverride = context.knobs.string(
    label: 'Badge label',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final badgeLabel = badgeLabelOverride.isEmpty
      ? copy['NEW']
      : badgeLabelOverride;
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
      variant: variant,
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

@widgetbook.UseCase(
  name: 'All variants',
  type: SldsIconCard,
  path: '[Display & Data]',
)
Widget buildSldsIconCardVariantsUseCase(BuildContext context) {
  return const SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        SldsIconCard(
          title: 'Name',
          description: 'Description',
          icon: Icon(Icons.description_outlined),
          variant: SldsIconCardVariant.defaultCard,
        ),
        SldsIconCard(
          title: 'Fuel Pass',
          badgeLabel: 'NEW',
          icon: Icon(Icons.local_gas_station, color: Colors.green),
        ),
        SldsIconCard(
          title: 'Apply for Passport',
          description: 'Begin your passport request online.',
          icon: Icon(Icons.public),
          variant: SldsIconCardVariant.featuredServices,
        ),
      ],
    ),
  );
}
