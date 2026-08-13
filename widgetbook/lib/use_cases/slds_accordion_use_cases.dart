import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsAccordion, path: '[Layout]')
Widget buildSldsAccordionUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsAccordion(
      initiallyExpanded: const {1},
      items: const [
        SldsAccordionItem(title: 'Accordion Name', body: Text('Collapsed by default.')),
        SldsAccordionItem(
          title: 'Accordion Name',
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
