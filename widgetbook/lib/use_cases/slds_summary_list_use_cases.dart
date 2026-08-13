import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsSummaryList, path: '[Display & Data]')
Widget buildSldsSummaryListUseCase(BuildContext context) {
  final status = context.knobs.object.dropdown(
    label: 'Status badge',
    options: SldsSummaryBadgeStatus.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsSummaryBadgeStatus.inReview,
  );

  return Padding(
    padding: const EdgeInsets.all(16),
    child: SldsSummaryList(
      rows: [
        const SldsSummaryRow(label: 'Application ID', value: 'APP-2026-001234'),
        const SldsSummaryRow(label: 'Submitted date', value: '28th June 2026'),
        SldsSummaryRow(label: 'Current status', value: status.name, badgeStatus: status),
      ],
    ),
  );
}
