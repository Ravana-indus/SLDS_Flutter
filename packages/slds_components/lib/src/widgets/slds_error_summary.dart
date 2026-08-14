import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// One row in an [SldsErrorSummary] — the field's error message, and an
/// optional [onTap] (e.g. move focus to that field) triggered by tapping it.
class SldsErrorSummaryItem {
  const SldsErrorSummaryItem(this.message, {this.onTap});

  final String message;
  final VoidCallback? onTap;
}

/// SLDS error summary — a bordered card listing every validation error on
/// a form, each as an underlined, tappable line (jumps to the offending
/// field via [SldsErrorSummaryItem.onTap]). Show above the form on submit
/// failure; screen readers announce it as an alert as soon as it appears.
class SldsErrorSummary extends StatelessWidget {
  const SldsErrorSummary({
    required this.errors,
    super.key,
    this.title = 'There is a problem',
  });

  /// The form's validation failures, in the order fields appear.
  final List<SldsErrorSummaryItem> errors;

  final String title;

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) return const SizedBox.shrink();

    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(dimensions.space16),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(dimensions.radiusXl),
          border: Border.all(color: colors.error),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: tokens.typography.heading4.copyWith(
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: dimensions.space12),
            for (final error in errors)
              Padding(
                padding: EdgeInsets.only(bottom: dimensions.space8),
                child: GestureDetector(
                  onTap: error.onTap,
                  child: Text(
                    error.message,
                    style: tokens.typography.body2.copyWith(
                      color: colors.error,
                      decoration: TextDecoration.underline,
                      decorationColor: colors.error,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
