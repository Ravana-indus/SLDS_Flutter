import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsProcessList, path: '[Display & Data]')
Widget buildSldsProcessListUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SldsProcessList(
      steps: const [
        SldsProcessStep(
          title: 'Prepare documents',
          description: 'Gather all required identification and supporting files',
          status: SldsProcessStepStatus.done,
        ),
        SldsProcessStep(
          title: 'Submit application',
          description: 'Upload documents through the online portal',
          status: SldsProcessStepStatus.done,
        ),
        SldsProcessStep(
          title: 'Verification in progress',
          description: 'Our team reviews your documents (2–5 business days)',
          status: SldsProcessStepStatus.current,
        ),
        SldsProcessStep(
          title: 'Receive approval',
          description: 'Notification sent via email and SMS',
        ),
      ],
    ),
  );
}
