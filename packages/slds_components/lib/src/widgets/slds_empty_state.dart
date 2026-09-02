import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart' show SldsErrorState;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';
import 'package:slds_components/src/widgets/slds_error_state.dart'
    show SldsErrorState;

/// SLDS empty state — a centered illustration, title, optional description,
/// and an optional call-to-action button. Use wherever a list/collection
/// has nothing in it yet (e.g. "No documents added yet") — pair with
/// [SldsErrorState] for failure states instead of empty-but-valid ones.
///
/// This package ships no illustration assets — pass your own [illustration]
/// widget (an [Image] or [Icon]); there's no default.
class SldsEmptyState extends StatelessWidget {
  /// Creates an empty state.
  const SldsEmptyState({
    required this.illustration,
    required this.title,
    super.key,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  /// The artwork/icon shown above [title] — sized as given, this widget
  /// doesn't constrain it.
  final Widget illustration;

  /// The state's headline.
  final String title;

  /// Supporting copy under [title], typically what the user can do next.
  final String? description;

  /// Shows a primary [SldsButton] below the text when both this and
  /// [onAction] are set.
  final String? actionLabel;

  /// Called when the action button is tapped.
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
