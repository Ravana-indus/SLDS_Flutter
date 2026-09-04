import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart' show SldsEmptyState;
import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_button.dart';
import 'package:slds_components/src/widgets/slds_empty_state.dart'
    show SldsEmptyState;

/// Common failure kinds [SldsErrorState.forKind] has copy for — covers the
/// Figma "Error State" swatch's four variants. Use the base
/// [SldsErrorState] constructor instead for anything else (e.g. a custom
/// "maintenance" banner with no numeric code).
enum SldsErrorKind {
  /// The requested page does not exist (404).
  notFound,

  /// The server failed to handle the request (500).
  serverError,

  /// The caller is not permitted to see the page (401/403).
  unauthorized,
}

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
  /// Creates an error state.
  const SldsErrorState({
    required this.illustration,
    required this.title,
    super.key,
    this.code,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  /// Preset copy and a built-in icon-composition illustration for the
  /// common HTTP failure kinds. Pass [illustration] to override the
  /// built-in one (e.g. with your own artwork); override any of
  /// [title]/[description]/[code] to customize just that field.
  /// Preset copy and a built-in icon-composition illustration for the
  /// common HTTP failure kinds. Pass [illustration] to override the
  /// built-in one (e.g. with your own artwork); override any of
  /// [title]/[description]/[code] to customize just that field.
  ///
  /// The preset copy is localized, so it is resolved from the ambient
  /// [Localizations] at build time rather than baked in here — a factory
  /// has no [BuildContext] to read.
  static Widget forKind(
    SldsErrorKind kind, {
    Key? key,
    Widget? illustration,
    String? title,
    String? code,
    String? description,
    String? actionLabel,
    VoidCallback? onAction,
    bool useDefaultActionLabel = true,
  }) {
    return Builder(
      key: key,
      builder: (context) {
        final strings = context.sldsStrings;
        final (defaultCode, defaultTitle, defaultDescription) = switch (kind) {
          SldsErrorKind.notFound => (
            '404',
            strings.errorNotFoundTitle,
            strings.errorNotFoundDescription,
          ),
          SldsErrorKind.serverError => (
            '500',
            strings.errorServerTitle,
            strings.errorServerDescription,
          ),
          SldsErrorKind.unauthorized => (
            '401',
            strings.errorUnauthorizedTitle,
            strings.errorUnauthorizedDescription,
          ),
        };
        return SldsErrorState(
          illustration: illustration ?? _ErrorIllustration(kind: kind),
          code: code ?? defaultCode,
          title: title ?? defaultTitle,
          description: description ?? defaultDescription,
          actionLabel:
              actionLabel ?? (useDefaultActionLabel ? strings.goToHome : null),
          onAction: onAction,
        );
      },
    );
  }

  /// The artwork/icon shown above [code]/[title] — sized as given, this
  /// widget doesn't constrain it.
  final Widget illustration;

  /// A large numeral/code above [title] (e.g. "404"). Null hides it — the
  /// Figma "System is down for Maintenance" variant has no code.
  final String? code;

  /// The failure's headline.
  final String title;

  /// Supporting copy under [title], typically what the user can do next.
  final String? description;

  /// Shows a secondary (outlined) [SldsButton] below the text when both
  /// this and [onAction] are set.
  final String? actionLabel;

  /// Called when the action button is tapped. Shown only alongside an
  /// action label.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.slds.dimensions;

    // Scrollable so the state still reads at large text sizes: the
    // illustration, code, title, description and action together exceed a
    // short viewport once the user scales text up, and a clipped error
    // message is one the citizen cannot act on. Centred while it fits,
    // scrolling only once it does not.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: _buildBody(context, dimensions),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SldsDimensionTokens dimensions) {
    final tokens = context.slds;
    final colors = tokens.colors;

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
          PositionedDirectional(
            end: 12,
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
