import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsProcessList,
  path: '[Display & Data]',
)
Widget buildSldsProcessListUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  return Padding(
    padding: EdgeInsets.all(16),
    child: SldsProcessList(
      steps: [
        SldsProcessStep(
          title: copy['Prepare documents'],
          description:
              copy['Gather all required identification and supporting files'],
          status: SldsProcessStepStatus.done,
        ),
        SldsProcessStep(
          title: copy['Submit application'],
          description: copy['Upload documents through the online portal'],
          status: SldsProcessStepStatus.done,
        ),
        SldsProcessStep(
          title: copy['Verification in progress'],
          description:
              copy['Our team reviews your documents (2–5 business days)'],
          status: SldsProcessStepStatus.current,
        ),
        SldsProcessStep(
          title: copy['Receive approval'],
          description: copy['Notification sent via email and SMS'],
        ),
      ],
    ),
  );
}
