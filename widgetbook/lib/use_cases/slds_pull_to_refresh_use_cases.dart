import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsPullToRefresh,
  path: '[Navigation]',
)
Widget buildSldsPullToRefreshUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  // Empty means "unset" — see the note in the search bar use case.
  final loadingText = context.knobs.string(label: 'Loading text');
  final style = context.knobs.object.dropdown(
    label: 'Style',
    options: SldsPullToRefreshStyle.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsPullToRefreshStyle.light,
  );

  return SizedBox(
    height: 400,
    child: SldsPullToRefresh(
      loadingText: loadingText.isEmpty ? null : loadingText,
      style: style,
      onRefresh: () => Future.delayed(Duration(seconds: 2)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(copy['Pull down from the top to refresh']),
            SizedBox(height: 12),
            Text(copy['Item 1']),
            Text(copy['Item 2']),
            Text(copy['Item 3']),
          ],
        ),
      ),
    ),
  );
}
