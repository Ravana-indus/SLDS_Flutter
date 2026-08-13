import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';
import 'slds_button.dart';

/// SLDS snack bar / toast — a floating card at the bottom of the screen
/// with a [title], optional [message], and an optional trailing action
/// button. Auto-dismisses after [duration] (4s by default, per the SLDS
/// mobile spec).
///
/// Shown via [SldsSnackBar.show], which wraps the native
/// [ScaffoldMessenger.showSnackBar] — that handles queueing, auto-dismiss
/// timing, and swipe-to-dismiss, so none of it is re-implemented here.
/// Requires a [Scaffold]/[ScaffoldMessenger] ancestor like any snack bar.
class SldsSnackBar extends StatelessWidget {
  const SldsSnackBar({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final String title;

  /// Secondary line under [title]. Null shows the title alone.
  final String? message;

  /// Trailing action button label (e.g. "Undo"). Null hides the button.
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Shows this snack bar via the ambient [ScaffoldMessenger].
  ///
  /// [onAction] fires on tap but does not dismiss automatically — call
  /// `ScaffoldMessenger.of(context).hideCurrentSnackBar()` from it if the
  /// bar should close, so callers can keep it up while work runs.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String title,
    String? message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        content: SldsSnackBar(
          title: title,
          message: message,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return Container(
      padding: EdgeInsets.all(dimensions.space16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(dimensions.radius2xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: tokens.typography.body1.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                if (message != null) ...[
                  SizedBox(height: dimensions.space4),
                  Text(
                    message!,
                    style: tokens.typography.body2.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actionLabel != null) ...[
            SizedBox(width: dimensions.space16),
            SldsButton(label: actionLabel!, onPressed: onAction),
          ],
        ],
      ),
    );
  }
}
