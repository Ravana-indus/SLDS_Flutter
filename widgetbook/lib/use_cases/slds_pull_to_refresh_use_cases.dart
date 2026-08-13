import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Playground', type: SldsPullToRefresh, path: '[Navigation]')
Widget buildSldsPullToRefreshUseCase(BuildContext context) {
  final loadingText = context.knobs.string(label: 'Loading text', initialValue: 'Loading…');
  final style = context.knobs.object.dropdown(
    label: 'Style',
    options: SldsPullToRefreshStyle.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsPullToRefreshStyle.light,
  );

  return SizedBox(
    height: 400,
    child: SldsPullToRefresh(
      loadingText: loadingText,
      style: style,
      onRefresh: () => Future.delayed(const Duration(seconds: 2)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Pull down from the top to refresh'),
            SizedBox(height: 12),
            Text('Item 1'),
            Text('Item 2'),
            Text('Item 3'),
          ],
        ),
      ),
    ),
  );
}
