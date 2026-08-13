import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// SLDS icon card — a fixed-size mobile service-category grid tile: a
/// left-aligned title/description over a right-aligned icon/image slot,
/// with an optional top-left ribbon badge (e.g. "NEW"). Figma "Icon Card":
/// 150x158, 12.4 radius (rounds to [SldsDimensionTokens.radius2xl]),
/// `#DADDE2` border ([SldsColorTokens.borderDecorative]).
///
/// Per the Figma usage guidelines, keep [title] short enough to fit the
/// fixed 150px width and skip long [description] text — this is a compact
/// grid tile, not a content card ([SldsCard] for anything larger).
class SldsIconCard extends StatelessWidget {
  const SldsIconCard({
    super.key,
    required this.title,
    required this.icon,
    this.description,
    this.badgeLabel,
    this.onTap,
  });

  final String title;

  /// The 64x64 icon/image slot — pass an [Image] for product/service
  /// artwork or an [Icon] for a monochrome glyph; sized to fit either way.
  final Widget icon;

  /// Optional supporting line under [title]. Keep it short — Figma calls
  /// out this tile as unsuited to long descriptions.
  final String? description;

  /// Shown as a small ribbon in the top-left corner (e.g. "NEW"). Null
  /// hides it.
  final String? badgeLabel;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return SizedBox(
      width: 150,
      height: 158,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(dimensions.radius2xl),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(dimensions.radius2xl),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colors.borderDecorative),
                  borderRadius: BorderRadius.circular(dimensions.radius2xl),
                ),
                padding: EdgeInsets.only(
                  top: dimensions.space12,
                  left: dimensions.space12,
                  right: dimensions.space12,
                  bottom: dimensions.space8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tokens.typography.body1.copyWith(color: colors.textPrimary),
                          ),
                          if (description != null) ...[
                            SizedBox(height: dimensions.space4),
                            Text(
                              description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: tokens.typography.caption1.copyWith(color: colors.textSecondary),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: dimensions.space8, height: 64, child: icon),
                  ],
                ),
              ),
            ),
          ),
          if (badgeLabel != null)
            Positioned(
              top: 0,
              left: dimensions.space12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: dimensions.space8, vertical: dimensions.space4),
                decoration: BoxDecoration(
                  color: colors.notificationBadgeBackground,
                  borderRadius: BorderRadius.circular(dimensions.radiusLg),
                ),
                child: Text(
                  badgeLabel!,
                  style: tokens.typography.caption2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
