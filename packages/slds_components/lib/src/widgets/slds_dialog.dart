import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';

/// SLDS alert dialog — a blocking modal window with a [title], [message],
/// and up to two actions (a [cancelLabel]/[onCancel] outlined button and a
/// [confirmLabel]/[onConfirm] filled button). Use for critical information
/// or a decision the user must make before continuing.
///
/// Built on the native [showDialog]/[AlertDialog] (handles the barrier,
/// focus trap, and Material ancestor for you) with SLDS shape/typography —
/// not a hand-rolled modal.
class SldsDialog extends StatelessWidget {
  const SldsDialog({
    required this.title,
    super.key,
    this.message,
    this.cancelLabel,
    this.onCancel,
    this.confirmLabel,
    this.onConfirm,
    this.barrierDismissible = true,
  });

  final String title;
  final String? message;

  /// Null hides the cancel button.
  final String? cancelLabel;
  final VoidCallback? onCancel;

  /// Null hides the confirm button.
  final String? confirmLabel;
  final VoidCallback? onConfirm;

  final bool barrierDismissible;

  /// Shows [SldsDialog] via [showDialog], returning after it's dismissed.
  /// [onCancel]/[onConfirm] should pop the navigator themselves (e.g.
  /// `Navigator.of(context).pop()`) if the dialog should close on tap —
  /// this helper doesn't pop for you, so callers can run async work first.
  ///
  /// [useRootNavigator] defaults to false (Flutter's own default is true) so
  /// the dialog stays inside the nearest enclosing [Navigator] — otherwise it
  /// escapes any ancestor that sizes or frames it, e.g. rendering across the
  /// whole browser window instead of Widgetbook's device viewport. Pass true
  /// if the dialog must cover a nested navigator's own chrome.
  static Future<void> show(
    BuildContext context, {
    required String title,
    String? message,
    String? cancelLabel,
    VoidCallback? onCancel,
    String? confirmLabel,
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
    bool useRootNavigator = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (context) => SldsDialog(
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        onCancel: onCancel,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  bool get _hasActions => cancelLabel != null || confirmLabel != null;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    // Built on the lower-level Dialog (barrier/positioning/Material
    // surface only) instead of AlertDialog — AlertDialog's own internal
    // layout queries its content's intrinsic height to size itself, and
    // SldsButton's mobile-full-width handling relies on a LayoutBuilder
    // that can't answer intrinsic-dimension queries at all, crashing the
    // instant AlertDialog (or an OverflowBar-based `actions` row) asks.
    // Dialog hands its child a normal bounded box instead, so a plain
    // Column/Row of real content works exactly like anywhere else.
    return Dialog(
      backgroundColor: colors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimensions.radius2xl),
      ),
      // Dialog's own default is `minWidth: 280` with no maximum, so the
      // dialog stretches to the full window on a desktop-width viewport.
      // 560 is the Material 3 spec width.
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 560),
      child: Padding(
        padding: EdgeInsets.all(dimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: tokens.typography.heading4.copyWith(
                color: colors.textPrimary,
              ),
            ),
            if (message != null) ...[
              SizedBox(height: dimensions.space8),
              Text(
                message!,
                style: tokens.typography.body2.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
            if (_hasActions) ...[
              SizedBox(height: dimensions.space16),
              // Flexible, not bare children: below the mobile breakpoint an
              // SldsButton asks for the full width it is offered, so two of
              // them in one Row overflow a phone-width dialog unless each is
              // held to a share of the line.
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (cancelLabel != null)
                    Flexible(
                      child: SldsButton(
                        label: cancelLabel!,
                        onPressed: onCancel,
                        variant: SldsButtonVariant.secondary,
                      ),
                    ),
                  if (cancelLabel != null && confirmLabel != null)
                    SizedBox(width: dimensions.space8),
                  if (confirmLabel != null)
                    Flexible(
                      child: SldsButton(
                        label: confirmLabel!,
                        onPressed: onConfirm,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
