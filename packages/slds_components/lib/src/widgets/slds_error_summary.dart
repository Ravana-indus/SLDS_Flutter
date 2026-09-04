import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';

/// One row in an [SldsErrorSummary] — the field's error message, and an
/// optional [onTap] (e.g. move focus to that field) triggered by tapping it.
class SldsErrorSummaryItem {
  /// Creates one entry in the summary.
  const SldsErrorSummaryItem(this.message, {this.onTap});

  /// The validation message shown for this field.
  final String message;

  /// Called when the entry is tapped — move focus to the offending field.
  final VoidCallback? onTap;
}

/// SLDS error summary — a bordered card listing every validation error on
/// a form, each as an underlined, tappable line (jumps to the offending
/// field via [SldsErrorSummaryItem.onTap]). Show above the form on submit
/// failure; screen readers announce it as an alert as soon as it appears.
class SldsErrorSummary extends StatelessWidget {
  /// Creates an error summary.
  const SldsErrorSummary({
    required this.errors,
    super.key,
    this.title,
  });

  /// The form's validation failures, in the order fields appear.
  final List<SldsErrorSummaryItem> errors;

  /// Heading above the list. Defaults to the localized "There is a
  /// problem" when null.
  final String? title;

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
              title ?? context.sldsStrings.thereIsAProblem,
              style: tokens.typography.heading4.copyWith(
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: dimensions.space12),
            for (final error in errors)
              Padding(
                padding: EdgeInsets.only(bottom: dimensions.space8),
                // The tap target is expanded with padding rather than a
                // wrapper box: an SldsTapTarget here makes the *semantics
                // node* 48dp tall, and textContrastGuideline then averages
                // 22dp of text against 26dp of card and reports a diluted
                // ratio for text that is actually 4.98:1. Padding grows the
                // hit area while the node stays the size of its text.
                child: Semantics(
                  container: true,
                  button: error.onTap != null,
                  label: error.message,
                  excludeSemantics: true,
                  onTap: error.onTap,
                  child: GestureDetector(
                    onTap: error.onTap,
                    behavior: HitTestBehavior.opaque,
                    // Height driven off the tap-target token rather than a
                    // spacing constant, so the row cannot drift back under
                    // the floor if the type scale changes (WCAG 2.5.8).
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: dimensions.tapTargetMin,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          error.message,
                          style: tokens.typography.body2.copyWith(
                            color: colors.badgeErrorText,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: colors.badgeErrorText,
                          ),
                        ),
                      ),
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
