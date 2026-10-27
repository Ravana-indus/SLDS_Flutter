import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsErrorSummary,
  path: '[Forms & Inputs]',
)
Widget buildSldsErrorSummaryUseCase(BuildContext context) {
  // Empty means "unset" — see the note in the search bar use case.
  final title = context.knobs.string(label: 'Title');
  // Caller copy, so it follows the Locale addon like the title does (#107).
  final copy = DemoCopy.of(context);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsErrorSummary(
      title: title.isEmpty ? null : title,
      errors: [
        SldsErrorSummaryItem(copy['Enter your NIC Number correctly']),
        SldsErrorSummaryItem(copy['Enter you Birth date correctly']),
      ],
    ),
  );
}
