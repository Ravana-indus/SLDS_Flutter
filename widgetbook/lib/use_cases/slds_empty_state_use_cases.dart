import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsEmptyState,
  path: '[Feedback & Status]',
)
Widget buildSldsEmptyStateUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final titleOverride = context.knobs.string(
    label: 'Title',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final title = titleOverride.isEmpty
      ? copy['No documents added yet']
      : titleOverride;
  final descriptionOverride = context.knobs.string(
    label: 'Description',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final description = descriptionOverride.isEmpty
      ? copy['Your uploaded documents will appear here once added.']
      : descriptionOverride;
  final actionLabelOverride = context.knobs.string(
    label: 'Action label',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final actionLabel = actionLabelOverride.isEmpty
      ? copy['Add Document']
      : actionLabelOverride;

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
