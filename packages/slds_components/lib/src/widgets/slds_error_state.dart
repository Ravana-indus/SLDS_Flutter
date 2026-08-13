import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';
import 'slds_button.dart';

/// Common failure kinds [SldsErrorState.forKind] has copy for — covers the
/// Figma "Error State" swatch's four variants. Use the base
/// [SldsErrorState] constructor instead for anything else (e.g. a custom
/// "maintenance" banner with no numeric code).
enum SldsErrorKind { notFound, serverError, unauthorized }

/// SLDS error state — a centered illustration, optional large [code]
/// (e.g. "404"), title, optional description, and an optional action
/// button. Same shape as [SldsEmptyState] — use this one for failures
/// (page crashed, request rejected), that one for "nothing here yet".
///
/// This package ships no illustration assets — pass your own [illustration]
/// widget; there's no default.
class SldsErrorState extends StatelessWidget {
  const SldsErrorState({
    super.key,
    required this.illustration,
    required this.title,
    this.code,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  /// Preset copy for the common HTTP failure kinds — pass your own
  /// [illustration] (this package ships none) and override any of
  /// [title]/[description]/[code] to customize just that field.
  factory SldsErrorState.forKind(
    SldsErrorKind kind, {
    Key? key,
    required Widget illustration,
    String? title,
    String? code,
    String? description,
    String? actionLabel = 'Go to Home',
    VoidCallback? onAction,
  }) {
    final (defaultCode, defaultTitle, defaultDescription) = switch (kind) {
      SldsErrorKind.notFound => ('404', 'Page not found', 'Sorry we were unable to find that page'),
      SldsErrorKind.serverError => (
          '500',
          "This page isn't working",
          "We apologise and are fixing the problem. Please try again later.",
        ),
      SldsErrorKind.unauthorized => ('401', 'Unauthorized', "Something has gone wrong on the app's server"),
    };
    return SldsErrorState(
      key: key,
      illustration: illustration,
      code: code ?? defaultCode,
      title: title ?? defaultTitle,
      description: description ?? defaultDescription,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// The artwork/icon shown above [code]/[title] — sized as given, this
  /// widget doesn't constrain it.
  final Widget illustration;

  /// A large numeral/code above [title] (e.g. "404"). Null hides it — the
  /// Figma "System is down for Maintenance" variant has no code.
  final String? code;

  final String title;
  final String? description;

  /// Shows a secondary (outlined) [SldsButton] below the text when both
  /// this and [onAction] are set.
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
            SizedBox(height: dimensions.space16),
            if (code != null) ...[
              Text(
                code!,
                textAlign: TextAlign.center,
                style: tokens.typography.display2.copyWith(color: colors.textTertiary),
              ),
              SizedBox(height: dimensions.space8),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: tokens.typography.heading3.copyWith(color: colors.textPrimary),
            ),
            if (description != null) ...[
              SizedBox(height: dimensions.space8),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: tokens.typography.body2.copyWith(color: colors.textSecondary),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: dimensions.space24),
              SldsButton(label: actionLabel!, onPressed: onAction, variant: SldsButtonVariant.secondary),
            ],
          ],
        ),
      ),
    );
  }
}
