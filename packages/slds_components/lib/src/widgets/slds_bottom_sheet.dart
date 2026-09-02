import 'package:flutter/material.dart';

import 'package:slds_components/src/l10n/slds_strings.dart';
import 'package:slds_components/slds_components.dart' show SldsFlyoutMenu;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_flyout_menu.dart'
    show SldsFlyoutMenu;

/// SLDS bottom sheet — a full-height sheet with a back chevron, centered
/// [title], a close button, and [child] content below. Use for a
/// full-screen mobile flow launched from a lower-emphasis surface (e.g.
/// picking a detail from a list) — [SldsFlyoutMenu]/`showSldsFlyoutMenu`
/// covers the compact "menu that slides up" case instead.
///
/// This is the panel content only — wrap it in [showSldsBottomSheet] (a
/// full-height [showModalBottomSheet]) or your own sheet/route if you need
/// different framing.
class SldsBottomSheet extends StatelessWidget {
  /// Creates a bottom sheet.
  const SldsBottomSheet({
    required this.title,
    required this.child,
    super.key,
    this.onBack,
    this.onClose,
  });

  /// The sheet's heading.
  final String title;

  /// The sheet's body content.
  final Widget child;

  /// Null hides the back chevron.
  final VoidCallback? onBack;

  /// Null hides the close (X) button.
  final VoidCallback? onClose;

  /// Shows [SldsBottomSheet] via [showModalBottomSheet], filling the full
  /// screen height (per the Figma reference) rather than the default
  /// content-sized sheet. [onClose] defaults to popping the navigator when
  /// not supplied.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget child,
    VoidCallback? onBack,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SldsBottomSheet(
          title: title,
          onBack: onBack,
          onClose: onClose ?? () => Navigator.of(context).pop(),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return Material(
      color: colors.surfaceCard,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(dimensions.radius2xl),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(dimensions.space16),
              child: Row(
                children: [
                  _IconSquare(
                    icon: Icons.arrow_back,
                    onTap: onBack,
                    semanticLabel: context.sldsStrings.back,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.typography.heading4.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  _IconSquare(
                    icon: Icons.close,
                    onTap: onClose,
                    semanticLabel: context.sldsStrings.close,
                  ),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _IconSquare extends StatelessWidget {
  const _IconSquare({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    // Reserves the same 40x40 footprint whether or not onTap is set, so the
    // title stays centered when only one of back/close is shown.
    if (onTap == null) return const SizedBox(width: 40, height: 40);

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: colors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dimensions.radiusMd),
          side: BorderSide(color: colors.borderDecorative),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(dimensions.radiusMd),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: Icon(icon, size: 20, color: colors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
