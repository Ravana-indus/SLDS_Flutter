import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsStepIndicator, path: '[Navigation]')
Widget buildSldsStepIndicatorUseCase(BuildContext context) {
  final totalSteps = context.knobs.int.slider(label: 'Total steps', initialValue: 6, min: 2, max: 8);
  final currentStep = context.knobs.int.slider(label: 'Current step', initialValue: 3, min: 0, max: 8);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsStepIndicator(
      totalSteps: totalSteps,
      currentStep: currentStep.clamp(0, totalSteps),
    ),
  );
}
