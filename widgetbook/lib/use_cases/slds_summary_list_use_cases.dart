import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsSummaryList,
  path: '[Display & Data]',
)
Widget buildSldsSummaryListUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final status = context.knobs.object.dropdown(
    label: 'Status badge',
    options: SldsSummaryBadgeStatus.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsSummaryBadgeStatus.inReview,
  );

  return Padding(
    padding: EdgeInsets.all(16),
    child: SldsSummaryList(
      rows: [
        SldsSummaryRow(label: copy['Application ID'], value: 'APP-2026-001234'),
        SldsSummaryRow(label: copy['Submitted date'], value: '28th June 2026'),
        SldsSummaryRow(
          label: copy['Current status'],
          value: status.name,
          badgeStatus: status,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Sensitive value',
  type: SldsSummaryList,
  path: '[Display & Data]',
)
Widget buildSldsSummaryListSensitiveUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final sensitive = context.knobs.boolean(
    label: 'Mark identifiers sensitive',
    initialValue: true,
  );

  // Synthetic values — never a real NIC or licence number.
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SldsSummaryList(
      rows: [
        SldsSummaryRow(label: copy['Application ID'], value: 'APP-2026-001234'),
        SldsSummaryRow(
          label: copy['NIC number'],
          value: '000000000V',
          isSensitive: sensitive,
        ),
        SldsSummaryRow(
          label: copy['Licence number'],
          value: 'B0000000',
          isSensitive: sensitive,
        ),
      ],
    ),
  );
}
