import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsTooltip,
  path: '[Display & Data]',
)
Widget buildSldsTooltipUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final titleOverride = context.knobs.string(
    label: 'Title',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final title = titleOverride.isEmpty ? copy['Tooltip Title'] : titleOverride;
  final descriptionOverride = context.knobs.string(
    label: 'Description',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final description = descriptionOverride.isEmpty
      ? copy['Enter the description text']
      : descriptionOverride;
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
    padding: EdgeInsets.all(24),
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
        SizedBox(height: 32),
        SldsTooltip(
          title: copy['Tooltip Title'],
          description: copy['Enter the description text'],
          tailAlignment: SldsTooltipTailAlignment.end,
        ),
        SizedBox(height: 32),
        SldsTooltip(
          title: copy['Title'],
          tailAlignment: SldsTooltipTailAlignment.center,
        ),
      ],
    ),
  );
}
