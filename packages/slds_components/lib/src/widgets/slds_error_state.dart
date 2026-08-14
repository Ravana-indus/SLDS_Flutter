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
/// The base constructor ships no illustration assets — pass your own
/// [illustration] widget. [SldsErrorState.forKind] fills in a built-in
/// icon-based illustration per [SldsErrorKind] (still overridable via
/// [illustration]) since this package bundles no custom artwork.
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

  /// Preset copy and a built-in icon-composition illustration for the
  /// common HTTP failure kinds. Pass [illustration] to override the
  /// built-in one (e.g. with your own artwork); override any of
  /// [title]/[description]/[code] to customize just that field.
  factory SldsErrorState.forKind(
    SldsErrorKind kind, {
    Key? key,
    Widget? illustration,
    String? title,
    String? code,
    String? description,
    String? actionLabel = 'Go to Home',
    VoidCallback? onAction,
  }) {
    final (defaultCode, defaultTitle, defaultDescription) = switch (kind) {
      SldsErrorKind.notFound => (
        '404',
        'Page not found',
        'Sorry we were unable to find that page',
      ),
      SldsErrorKind.serverError => (
        '500',
        "This page isn't working",
        "We apologise and are fixing the problem. Please try again later.",
      ),
      SldsErrorKind.unauthorized => (
        '401',
        'Unauthorized',
        "Something has gone wrong on the app's server",
      ),
    };
    return SldsErrorState(
      key: key,
      illustration: illustration ?? _ErrorIllustration(kind: kind),
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
                style: tokens.typography.display2.copyWith(
                  color: colors.textTertiary,
                ),
              ),
              SizedBox(height: dimensions.space8),
            ],
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
              SldsButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: SldsButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Built-in illustration for [SldsErrorState.forKind] — a soft circular
/// backdrop with a base icon and a small badge icon layered on top (e.g.
/// a document with a magnifying-glass badge for [SldsErrorKind.notFound]),
/// standing in for the Figma reference's custom flat-style artwork until
/// this package bundles real illustration assets.
class _ErrorIllustration extends StatelessWidget {
  const _ErrorIllustration({required this.kind});

  final SldsErrorKind kind;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;

    final (IconData baseIcon, IconData badgeIcon) = switch (kind) {
      SldsErrorKind.notFound => (Icons.description_outlined, Icons.search),
      SldsErrorKind.serverError => (Icons.cloud_outlined, Icons.dns_outlined),
      SldsErrorKind.unauthorized => (
        Icons.description_outlined,
        Icons.lock_outline,
      ),
    };

    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: colors.surfaceHover,
              shape: BoxShape.circle,
            ),
          ),
          Icon(baseIcon, size: 48, color: colors.textTertiary),
          Positioned(
            right: 12,
            bottom: 12,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                shape: BoxShape.circle,
                border: Border.all(color: colors.borderDecorative),
              ),
              alignment: Alignment.center,
              child: Icon(badgeIcon, size: 18, color: colors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
