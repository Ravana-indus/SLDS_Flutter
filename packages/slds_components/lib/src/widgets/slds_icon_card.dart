import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart'
    show SldsCard, SldsServiceCard;
import 'package:slds_components/src/theme/slds_tokens.dart';

/// Fixed footprint for [SldsIconCard]. [small] is the compact grid tile
/// (150x158, 40x40 icon — Figma "Fuel Pass"); [large] is the wider variant
/// with more breathing room for the icon (Figma "Name/Description", 64x64
/// icon). Both keep the same icon-then-title-then-description stack.
enum SldsIconCardSize {
  /// Compact grid tile, 150x158 with a 40x40 icon.
  small,

  /// Wider tile with more room around a 64x64 icon.
  large,
}

/// Visual state for [SldsIconCard] — mirrors [SldsServiceCard]'s state
/// pattern. [state] forces one for previews; leave it null to let the
/// widget derive [hover] from pointer tracking and [disabled] from
/// [onTap] being null.
enum SldsIconCardState {
  /// At rest.
  defaultState,

  /// Pointer is over the card. Pointer input only.
  hover,

  /// Not interactive.
  disabled,
}

/// SLDS icon card — a fixed-size mobile service-category grid tile: an
/// icon/image slot over a left-aligned title/description, with an optional
/// top-left ribbon badge (e.g. "NEW"). Figma "Icon Card": 12.4 radius
/// (rounds to [SldsDimensionTokens.radius2xl]), `#DADDE2` border
/// ([SldsColorTokens.borderDecorative]).
///
/// Per the Figma usage guidelines, keep [title] short enough to fit the
/// tile width and skip long [description] text — this is a compact grid
/// tile, not a content card ([SldsCard] for anything larger).
class SldsIconCard extends StatefulWidget {
  /// Creates an icon card tile.
  const SldsIconCard({
    required this.title,
    required this.icon,
    super.key,
    this.description,
    this.badgeLabel,
    this.size = SldsIconCardSize.small,
    this.state,
    this.onTap,
  });

  /// The tile's primary line. Keep it short enough to fit the tile.
  final String title;

  /// The icon/image slot — pass an [Image] for product/service artwork or
  /// an [Icon] for a monochrome glyph; sized per [size] either way.
  final Widget icon;

  /// Optional supporting line under [title]. Keep it short — Figma calls
  /// out this tile as unsuited to long descriptions.
  final String? description;

  /// Shown as a small ribbon in the top-left corner (e.g. "NEW"). Null
  /// hides it.
  final String? badgeLabel;

  /// Which fixed footprint the tile uses.
  final SldsIconCardSize size;

  /// Overrides the derived visual state — for widgetbook/preview use.
  final SldsIconCardState? state;

  /// Called when the tile is tapped. Null renders it disabled.
  final VoidCallback? onTap;

  @override
  State<SldsIconCard> createState() => _SldsIconCardState();
}

class _SldsIconCardState extends State<SldsIconCard> {
  bool _hovered = false;

  SldsIconCardState get _resolvedState {
    if (widget.state != null) return widget.state!;
    if (widget.onTap == null) return SldsIconCardState.disabled;
    if (_hovered) return SldsIconCardState.hover;
    return SldsIconCardState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final state = _resolvedState;
    final disabled = state == SldsIconCardState.disabled;

    final background = switch (state) {
      SldsIconCardState.hover => colors.surfaceHover,
      _ => colors.surfaceCard,
    };
    final titleColor = disabled
        ? colors.disabledForeground
        : colors.textPrimary;
    final descriptionColor = disabled
        ? colors.disabledForeground
        : colors.textSecondary;
    final (double height, double iconSize) = switch (widget.size) {
      SldsIconCardSize.small => (158.0, 40.0),
      SldsIconCardSize.large => (220.0, 64.0),
    };

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // small is a fixed compact tile; large fills its parent's width
          // when bounded (e.g. a grid cell), falling back to the Figma
          // reference width when the parent is unbounded — mirrors
          // SldsSummaryList/SldsButton's guard against `double.infinity`
          // crashing inside an unbounded parent like a Row.
          const figmaLargeWidth = 320.0;
          final width = switch (widget.size) {
            SldsIconCardSize.small => 150.0,
            SldsIconCardSize.large =>
              constraints.hasBoundedWidth
                  ? constraints.maxWidth
                  : figmaLargeWidth,
          };

          return SizedBox(
            width: width,
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Semantics(
                    container: true,
                    explicitChildNodes: true,
                    button: widget.onTap != null,
                    enabled: !disabled,
                    label: widget.title,
                    child: Material(
                      color: background,
                      borderRadius: BorderRadius.circular(dimensions.radius2xl),
                      child: InkWell(
                        onTap: disabled ? null : widget.onTap,
                        borderRadius: BorderRadius.circular(
                          dimensions.radius2xl,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: colors.borderDecorative),
                            borderRadius: BorderRadius.circular(
                              dimensions.radius2xl,
                            ),
                          ),
                          padding: EdgeInsets.all(dimensions.space12),
                          // badgeLabel needs room to float above the icon
                          // without overlapping it — this pushes content
                          // down to clear it.
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Opacity(
                                opacity: disabled ? 0.5 : 1,
                                child: SizedBox(
                                  width: iconSize,
                                  height: iconSize,
                                  child: widget.icon,
                                ),
                              ),
                              SizedBox(height: dimensions.space8),
                              Text(
                                widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: tokens.typography.body1.copyWith(
                                  color: titleColor,
                                ),
                              ),
                              if (widget.description != null) ...[
                                SizedBox(height: dimensions.space4),
                                Text(
                                  widget.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: tokens.typography.caption1.copyWith(
                                    color: descriptionColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.badgeLabel != null)
                  PositionedDirectional(
                    top: -dimensions.space8,
                    start: dimensions.space12,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: dimensions.space8,
                        vertical: dimensions.space4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.notificationBadgeBackground,
                        borderRadius: BorderRadius.circular(
                          dimensions.radiusLg,
                        ),
                      ),
                      child: Text(
                        widget.badgeLabel!,
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
        },
      ),
    );
  }
}
