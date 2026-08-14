import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsTooltip,
  path: '[Display & Data]',
)
Widget buildSldsTooltipUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Tooltip Title',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Enter the description text',
  );
  final stepLabel = context.knobs.string(
    label: 'Step label',
    initialValue: '1 of 5',
  );
  final actionLabel = context.knobs.string(
    label: 'Action label',
    initialValue: 'Action',
  );
  final showClose = context.knobs.boolean(
    label: 'Show close button',
    initialValue: true,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SldsTooltip(
          title: title,
          description: description.isEmpty ? null : description,
          stepLabel: stepLabel.isEmpty ? null : stepLabel,
          actionLabel: actionLabel.isEmpty ? null : actionLabel,
          onAction: () {},
          onClose: showClose ? () {} : null,
          tailAlignment: SldsTooltipTailAlignment.end,
        ),
        const SizedBox(height: 32),
        const SldsTooltip(
          title: 'Tooltip Title',
          description: 'Enter the description text',
          tailAlignment: SldsTooltipTailAlignment.end,
        ),
        const SizedBox(height: 32),
        const SldsTooltip(
          title: 'Title',
          tailAlignment: SldsTooltipTailAlignment.center,
        ),
      ],
    ),
  );
}
