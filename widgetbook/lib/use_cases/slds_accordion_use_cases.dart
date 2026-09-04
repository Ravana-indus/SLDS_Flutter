import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsAccordion,
  path: '[Display & Data]',
)
Widget buildSldsAccordionUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  return Padding(
    padding: EdgeInsets.all(24),
    child: SldsAccordion(
      initiallyExpanded: const {1},
      items: [
        SldsAccordionItem(
          title: copy['Accordion Name'],
          body: Text(copy['Collapsed by default.']),
        ),
        SldsAccordionItem(
          title: copy['Accordion Name'],
          body: Text(
            'Lorem ipsum dolor sit amet consectetur adipiscing elit '
            'Ut et massa mi. Aliquam in hendrerit urna. Pellentesque '
            'sit amet sapien fringilla, mattis ligula consectetur, '
            'ultrices.',
          ),
        ),
      ],
    ),
  );
}
