import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsTopNavBar,
  path: '[Navigation]',
)
Widget buildSldsTopNavBarUseCase(BuildContext context) {
  final showProgress = context.knobs.boolean(
    label: 'Show progress steps',
    initialValue: false,
  );
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Page Title',
  );
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
