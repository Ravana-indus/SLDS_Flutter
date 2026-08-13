import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';
import 'slds_button.dart';

/// SLDS empty state — a centered illustration, title, optional description,
/// and an optional call-to-action button. Use wherever a list/collection
/// has nothing in it yet (e.g. "No documents added yet") — pair with
/// [SldsErrorState] for failure states instead of empty-but-valid ones.
///
/// This package ships no illustration assets — pass your own [illustration]
/// widget (an [Image] or [Icon]); there's no default.
class SldsEmptyState extends StatelessWidget {
  const SldsEmptyState({
    super.key,
    required this.illustration,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  /// The artwork/icon shown above [title] — sized as given, this widget
  /// doesn't constrain it.
  final Widget illustration;

  final String title;
  final String? description;

  /// Shows a primary [SldsButton] below the text when both this and
  /// [onAction] are set.
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(dimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            illustration,
            SizedBox(height: dimensions.space24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: tokens.typography.heading3.copyWith(
                color: colors.textPrimary,
              ),
            ),
            if (description != null) ...[
              SizedBox(height: dimensions.space8),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: tokens.typography.body2.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: dimensions.space24),
              SldsButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
