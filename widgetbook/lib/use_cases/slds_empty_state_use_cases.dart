import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsEmptyState,
  path: '[Feedback & Status]',
)
Widget buildSldsEmptyStateUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'No documents added yet',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Your uploaded documents will appear here once added.',
  );
  final actionLabel = context.knobs.string(
    label: 'Action label',
    initialValue: 'Add Document',
  );

  return SldsEmptyState(
    illustration: const Icon(
      Icons.folder_open,
      size: 96,
      color: Colors.black26,
    ),
    title: title,
    description: description.isEmpty ? null : description,
    actionLabel: actionLabel.isEmpty ? null : actionLabel,
    onAction: () {},
  );
}
