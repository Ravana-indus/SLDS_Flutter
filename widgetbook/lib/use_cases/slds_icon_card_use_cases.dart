import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsIconCard, path: '[Display & Data]')
Widget buildSldsIconCardUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Fuel Pass');
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Apply for a fuel quota pass',
  );
  final badgeLabel = context.knobs.string(label: 'Badge label', initialValue: 'NEW');

  return Padding(
    padding: const EdgeInsets.all(16),
    child: SldsIconCard(
      title: title,
      description: description.isEmpty ? null : description,
      badgeLabel: badgeLabel.isEmpty ? null : badgeLabel,
      icon: const Icon(Icons.local_gas_station, size: 40, color: Colors.green),
      onTap: () {},
    ),
  );
}
