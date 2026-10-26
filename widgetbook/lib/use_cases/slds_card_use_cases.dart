import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../support/demo_copy.dart';

@widgetbook.UseCase(name: 'Default', type: SldsCard, path: '[Layout]')
Widget buildSldsCardUseCase(BuildContext context) {
  final copy = DemoCopy.of(context);
  final tokens = context.slds;
  // A realistic card, like the cards on Figma's Layout reference: a bare
  // word in an intrinsic-width card rendered as a tiny box (#200).
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SizedBox(
      width: 320,
      child: SldsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    copy['Dashboard Grid'],
                    style: tokens.typography.body1.copyWith(
                      fontWeight: FontWeight.w500,
                      color: tokens.colors.textPrimary,
                    ),
                  ),
                ),
                const SldsBadge(label: 'v1', status: SldsBadgeStatus.success),
              ],
            ),
            SizedBox(height: tokens.dimensions.space8),
            Text(
              copy['KPI card rows + chart rows.'],
              style: tokens.typography.caption1.copyWith(
                color: tokens.colors.textSecondary,
              ),
            ),
            SizedBox(height: tokens.dimensions.space8),
            Wrap(
              spacing: tokens.dimensions.space8,
              runSpacing: tokens.dimensions.space8,
              children: [
                SldsBadge(label: copy['Dashboard']),
                SldsBadge(
                  label: copy['Exclusive'],
                  status: SldsBadgeStatus.inReview,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
