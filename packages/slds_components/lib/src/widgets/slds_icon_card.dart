import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart' show SldsCard;
import 'package:slds_components/src/theme/slds_tokens.dart';

/// Which Figma "Icon Card" variant to render.
///
/// The three differ in more than size — footprint, padding, corner radius,
/// icon size and the *order* of icon and text all change — so they are a
/// variant enum rather than a size ramp. Figma node 533:2742.
enum SldsIconCardVariant {
  /// 150 wide, text block above a trailing 64px icon. Figma "Default".
  defaultCard,

  /// 96x96 centred tile, 40px icon over an 11px label, optional "NEW"
  /// pill centred on the top edge. Figma "Quick Action Card".
  quickAction,

  /// 240 wide, 48px icon in a sunken tile over a title and description.
  /// Figma "Featured Services".
  featuredServices,
}

/// Fixed footprint for [SldsIconCard].
///
/// Superseded by [SldsIconCardVariant], which carries the layout as well as
/// the geometry. [SldsIconCardSize.small] maps to
/// [SldsIconCardVariant.quickAction] and [SldsIconCardSize.large] to
/// [SldsIconCardVariant.defaultCard].
@Deprecated(
  'Use SldsIconCardVariant instead. '
  'small -> quickAction, large -> defaultCard.',
)
enum SldsIconCardSize {
  /// Compact grid tile.
  small,

  /// Wider tile with more room around the icon.
  large,
}

/// Visual state for [SldsIconCard] — mirrors `SldsServiceCard`'s state
/// pattern. `state` forces one for previews; leave it null to let the
/// widget derive `hover` from pointer tracking and `disabled` from
/// `onTap` being null.
enum SldsIconCardState {
  /// At rest.
  defaultState,

  /// Pointer is over the card. Pointer input only.
  hover,

  /// Not interactive.
  disabled,
}

/// The resolved per-variant geometry for one [SldsIconCardVariant].
///
/// Follows `SldsIconButton`'s metrics-record idiom: one switch resolving
/// every dimension from the ambient token set, so the build method reads as
/// layout rather than as a pile of conditionals.
@immutable
class _SldsIconCardMetrics {
  const _SldsIconCardMetrics({
    required this.width,
    required this.height,
    required this.radius,
    required this.padding,
    required this.iconSize,
    required this.gap,
  });

  /// Resolves the metrics for [variant] from the ambient token set.
  factory _SldsIconCardMetrics.of(
    BuildContext context,
    SldsIconCardVariant variant,
  ) {
    final d = context.slds.dimensions;
    return switch (variant) {
      // 12.414 in Figma, which rounds to the 12 on the radius scale.
      SldsIconCardVariant.defaultCard => _SldsIconCardMetrics(
        width: 150,
        height: 158,
        radius: d.radius2xl,
        padding: EdgeInsets.fromLTRB(
          d.space12,
          d.space12,
          d.space12,
          d.space8,
        ),
        iconSize: 64,
        gap: d.space4,
      ),
      // Figma's own numbers do not close here: a 96x96 tile with 20 padding
      // leaves 56, and a 40 icon + 8 gap + a 12 label line needs 60. The
      // footprint and the icon are the hard constraints (they are what the
      // grid and the artwork are cut to), so the gap absorbs the 4.
      SldsIconCardVariant.quickAction => _SldsIconCardMetrics(
        width: 96,
        height: 96,
        radius: d.radius3xl,
        padding: EdgeInsets.all(d.space20),
        iconSize: 40,
        gap: d.space4,
      ),
      SldsIconCardVariant.featuredServices => _SldsIconCardMetrics(
        width: 240,
        // Figma pads 16 top and bottom; the height follows the content.
        height: null,
        radius: d.radius3xl,
        padding: EdgeInsets.all(d.space16),
        iconSize: 48,
        gap: d.space12,
      ),
    };
  }

  final double width;

  /// Null lets the tile size to its content — [
  /// SldsIconCardVariant.featuredServices] has no fixed height in Figma.
  final double? height;
  final double radius;
  final EdgeInsets padding;
  final double iconSize;

  /// Gap between the icon block and the text block.
  final double gap;
}

/// SLDS icon card — a mobile service-category tile in one of three Figma
/// variants ([SldsIconCardVariant]): a 150-wide "Default" tile with the text
/// above a trailing icon, a 96x96 centred "Quick Action" tile with an
/// optional "NEW" pill, or a 240-wide "Featured Services" tile with a sunken
/// icon slot over a title and description.
///
/// Per the Figma usage guidelines, keep [title] short enough to fit the tile
/// width and skip long [description] text — this is a compact grid tile, not
/// a content card ([SldsCard] for anything larger).
class SldsIconCard extends StatefulWidget {
  /// Creates an icon card tile.
  const SldsIconCard({
    required this.title,
    required this.icon,
    super.key,
    this.description,
    this.badgeLabel,
    this.variant = SldsIconCardVariant.quickAction,
    @Deprecated('Use variant instead.') this.size,
    this.state,
    this.onTap,
  });

  /// The tile's primary line. Keep it short enough to fit the tile.
  final String title;

  /// The icon/image slot — pass an [Image] for product/service artwork or
  /// an [Icon] for a monochrome glyph; sized per [variant] either way.
  final Widget icon;

  /// Optional supporting line under [title]. Keep it short — Figma calls
  /// out this tile as unsuited to long descriptions.
  ///
  /// Not rendered by [SldsIconCardVariant.quickAction], which is a
  /// label-only tile in Figma.
  final String? description;

  /// Shown as a small pill badge (e.g. "NEW"). Null hides it. Centred on
  /// the top edge for [SldsIconCardVariant.quickAction], leading-aligned
  /// otherwise.
  final String? badgeLabel;

  /// Which Figma variant the tile renders as.
  final SldsIconCardVariant variant;

  /// Superseded by [variant]. Non-null wins over [variant] so existing
  /// callers keep their layout until they migrate.
  @Deprecated('Use variant instead.')
  final SldsIconCardSize? size;

  /// Overrides the derived visual state — for widgetbook/preview use.
  final SldsIconCardState? state;

  /// Called when the tile is tapped. Null renders it disabled.
  final VoidCallback? onTap;

  /// The variant actually rendered, honouring a legacy [size] if one is set.
  SldsIconCardVariant get effectiveVariant => switch (size) {
    SldsIconCardSize.small => SldsIconCardVariant.quickAction,
    SldsIconCardSize.large => SldsIconCardVariant.defaultCard,
    null => variant,
  };

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
    final typography = tokens.typography;
    final variant = widget.effectiveVariant;
    final metrics = _SldsIconCardMetrics.of(context, variant);
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

    // Quick Action labels its tile in caption_2; the other two use body_1
    // for the title and caption_1/caption_2 for the description.
    final (
      TextStyle titleStyle,
      TextStyle descriptionStyle,
    ) = switch (variant) {
      // The caption_2 token ships lineHeight 16; Figma's Quick Action label
      // is 11/12. The tile is a fixed 96x96, so those 4px are the difference
      // between fitting and overflowing (40 icon + 8 gap + label vs the 56
      // the padding leaves). Pinned locally rather than changing the shared
      // token, which every other component reads.
      SldsIconCardVariant.quickAction => (
        typography.caption2.copyWith(height: 12 / 11),
        typography.caption2.copyWith(height: 12 / 11),
      ),
      SldsIconCardVariant.defaultCard => (
        typography.body1,
        typography.caption1,
      ),
      SldsIconCardVariant.featuredServices => (
        typography.caption2,
        typography.caption2,
      ),
    };

    final showsDescription =
        widget.description != null &&
        variant != SldsIconCardVariant.quickAction;

    // A fixed-height tile cannot hold text the user has scaled up: at 200%
    // the text overflows the bottom. Grow the box by whatever the text
    // actually gains, so the tile keeps its proportions at 100% and stops
    // clipping above it. The icon is unaffected — only the text expands.
    //
    // quickAction is excluded: its 96x96 is a hard Figma footprint (these
    // tiles sit in a fixed grid), so it absorbs scaling by letting the label
    // ellipsize inside the tile instead of growing the tile.
    final scaler = MediaQuery.textScalerOf(context);
    final titleSize = titleStyle.fontSize ?? 16.0;
    final descriptionSize = descriptionStyle.fontSize ?? 12.0;
    final growth = variant == SldsIconCardVariant.quickAction
        ? 0.0
        : (scaler.scale(titleSize) - titleSize) +
              (showsDescription
                  ? (scaler.scale(descriptionSize) - descriptionSize) * 2
                  : 0.0);
    final height = metrics.height == null ? null : metrics.height! + growth;

    final iconBlock = Opacity(
      opacity: disabled ? 0.5 : 1,
      child: SizedBox(
        width: metrics.iconSize,
        height: metrics.iconSize,
        child: widget.icon,
      ),
    );

    final titleText = Text(
      widget.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: variant == SldsIconCardVariant.quickAction
          ? TextAlign.center
          : TextAlign.start,
      style: titleStyle.copyWith(color: titleColor),
    );

    final descriptionText = showsDescription
        ? Text(
            widget.description!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: descriptionStyle.copyWith(color: descriptionColor),
          )
        : null;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: SizedBox(
        width: metrics.width,
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
                  borderRadius: BorderRadius.circular(metrics.radius),
                  child: InkWell(
                    onTap: disabled ? null : widget.onTap,
                    borderRadius: BorderRadius.circular(metrics.radius),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.cardBorder),
                        borderRadius: BorderRadius.circular(metrics.radius),
                      ),
                      padding: metrics.padding,
                      child: switch (variant) {
                        // Text block first, icon trailing below it — the
                        // reverse of the other two variants.
                        SldsIconCardVariant.defaultCard => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleText,
                            if (descriptionText != null) ...[
                              SizedBox(height: metrics.gap),
                              descriptionText,
                            ],
                            const Spacer(),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: iconBlock,
                            ),
                          ],
                        ),
                        // Flexible, not a bare Text: the tile is a fixed
                        // 96x96, so the label must take whatever the icon
                        // and gap leave and ellipsize inside it. A
                        // self-sizing label overflows the Column by a
                        // rounding margin at 1x and by more as text scales.
                        SldsIconCardVariant.quickAction => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            iconBlock,
                            SizedBox(height: metrics.gap),
                            Flexible(child: titleText),
                          ],
                        ),
                        SldsIconCardVariant.featuredServices => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Figma seats the icon in a sunken rounded slot.
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: colors.surfaceSunken,
                                borderRadius: BorderRadius.circular(
                                  dimensions.radius2xl,
                                ),
                              ),
                              child: iconBlock,
                            ),
                            SizedBox(height: metrics.gap),
                            titleText,
                            if (descriptionText != null) ...[
                              SizedBox(height: dimensions.space2),
                              descriptionText,
                            ],
                          ],
                        ),
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Quick Action centres its pill on the top edge (Figma puts it at
            // left: calc(50% - 0.08px)); the other variants keep it at the
            // leading corner, where it mirrors under RTL.
            if (widget.badgeLabel != null)
              if (variant == SldsIconCardVariant.quickAction)
                Positioned(
                  top: -dimensions.space8,
                  left: 0,
                  right: 0,
                  child: Align(
                    child: _badge(context, colors, typography),
                  ),
                )
              else
                PositionedDirectional(
                  top: -dimensions.space8,
                  start: dimensions.space12,
                  child: _badge(context, colors, typography),
                ),
          ],
        ),
      ),
    );
  }

  Widget _badge(
    BuildContext context,
    SldsColorTokens colors,
    SldsTypographyTokens typography,
  ) {
    final dimensions = context.slds.dimensions;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dimensions.space6),
      decoration: BoxDecoration(
        color: colors.notificationBadgeBackground,
        borderRadius: BorderRadius.circular(dimensions.radiusFull),
      ),
      child: Text(
        widget.badgeLabel!,
        style: typography.caption1.copyWith(color: colors.textInverse),
      ),
    );
  }
}
