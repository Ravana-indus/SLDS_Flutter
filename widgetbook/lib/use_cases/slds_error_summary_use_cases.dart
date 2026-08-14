import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsErrorSummary,
  path: '[Forms & Inputs]',
)
Widget buildSldsErrorSummaryUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'There is a problem',
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsErrorSummary(
      title: title,
      errors: const [
        SldsErrorSummaryItem('Enter your NIC Number correctly'),
        SldsErrorSummaryItem('Enter you Birth date correctly'),
      ],
    ),
  );
}
