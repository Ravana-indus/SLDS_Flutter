import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsTabStrip,
  path: '[Navigation]',
)
Widget buildSldsTabStripUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final style = context.knobs.object.dropdown(
    label: 'Style',
    options: SldsTabStripStyle.values,
    labelBuilder: (value) => value.name,
    initialOption: SldsTabStripStyle.light,
  );
  final currentIndex = context.knobs.int.slider(
    label: 'Selected index',
    initialValue: 0,
    min: 0,
    max: 3,
  );

  return Padding(
    padding: EdgeInsets.all(24),
    child: SldsTabStrip(
      style: style,
      currentIndex: currentIndex,
      onTap: (_) {},
      items: [
        SldsTabStripItem(label: copy['Label'], count: 2),
        SldsTabStripItem(label: copy['Label']),
        SldsTabStripItem(label: copy['Label'], indicatorLeading: false),
        SldsTabStripItem(label: copy['Label'], count: 2),
      ],
    ),
  );
}
