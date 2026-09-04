import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsTopNavBar,
  path: '[Navigation]',
)
Widget buildSldsTopNavBarUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final showProgress = context.knobs.boolean(
    label: 'Show progress steps',
    initialValue: false,
  );
  final titleOverride = context.knobs.string(
    label: 'Title',
    initialValue: '',
    description: 'Blank follows the Locale addon; type to override.',
  );
  final title = titleOverride.isEmpty ? copy['Page Title'] : titleOverride;
  final currentStep = context.knobs.int.slider(
    label: 'Current step',
    initialValue: 3,
    min: 0,
    max: 6,
  );
  final style = context.knobs.object.dropdown(
    label: 'Style',
    options: SldsTopNavBarStyle.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsTopNavBarStyle.light,
  );

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (showProgress)
        SldsTopNavBar.progress(
          totalSteps: 6,
          currentStep: currentStep,
          style: style,
          onBack: () {},
          onMenu: () {},
        )
      else
        SldsTopNavBar(title: title, style: style, onBack: () {}, onMenu: () {}),
    ],
  );
}
