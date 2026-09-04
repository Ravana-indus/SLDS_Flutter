import 'package:flutter/material.dart';

import 'package:slds_components/src/theme/slds_tokens.dart';

/// Visual state for [SldsServiceCard] — background/accent per Figma spec.
/// [hover] only applies via [MouseRegion] on desktop/web pointer input;
/// touch devices go straight from [defaultState] to [active] on tap.
enum SldsServiceCardState {
  /// At rest.
  defaultState,

  /// Pointer is over the card. Pointer input only.
  hover,

  /// Marked as chosen.
  selected,

  /// Being pressed.
  active,
}

/// SLDS service card — a 58px-tall tappable row: icon tile, title +
/// description, trailing status badge and chevron. Used for lists of
/// government services (e.g. "My Requests").
///
/// [state] forces a visual state (for previews); leave it null to let the
/// widget derive [SldsServiceCardState.active] from [selected] plus its own
/// pointer-hover tracking.
class SldsServiceCard extends StatefulWidget {
  /// Creates a service row.
  const SldsServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
    this.badgeText,
    this.selected = false,
    this.state,
    this.onTap,
    this.semanticLabel,
  });

  /// 32x32 leading icon/image, laid inside a 40x40 white tile.
  final Widget icon;

  /// The service name — the card's primary line.
  final String title;

  /// Supporting line under [title].
  final String description;

  /// Trailing status badge text (e.g. "Success"). Null hides the badge.
  final String? badgeText;

  /// Marks the row as the current/active service — solid gold background,
  /// per the "Active" row in the Figma spec (labelled Selected=Active).
  final bool selected;

  /// Overrides the derived visual state — for widgetbook/preview use.
  final SldsServiceCardState? state;

  /// Called when the card is tapped. Null renders it non-interactive.
  final VoidCallback? onTap;

  /// Overrides the accessible name. Defaults to [title] and [description]
  /// read together.
  final String? semanticLabel;

  @override
  State<SldsServiceCard> createState() => _SldsServiceCardState();
}

class _SldsServiceCardState extends State<SldsServiceCard> {
  bool _hovered = false;

  SldsServiceCardState get _resolvedState {
    if (widget.state != null) return widget.state!;
    if (widget.selected) return SldsServiceCardState.active;
    if (_hovered) return SldsServiceCardState.hover;
    return SldsServiceCardState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final typography = tokens.typography;
    final state = _resolvedState;

    final background = switch (state) {
      SldsServiceCardState.defaultState => colors.surfacePage,
      SldsServiceCardState.hover => colors.surfaceHover,
      SldsServiceCardState.selected => colors.serviceCardSelectedBackground,
      SldsServiceCardState.active => colors.buttonPrimaryBackground,
    };
    final titleColor = state == SldsServiceCardState.active
        ? colors.textStaticBlack
        : colors.textPrimary;
    final descriptionColor = state == SldsServiceCardState.active
        ? colors.textStaticBlack
        : colors.textSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        button: widget.onTap != null,
        selected: widget.selected,
        label: widget.semanticLabel ?? widget.title,
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(dimensions.radiusMd),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(dimensions.radiusMd),
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: dimensions.space16,
                end: dimensions.space8,
                top: dimensions.space8,
                bottom: dimensions.space8,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.surfaceCard,
                      borderRadius: BorderRadius.circular(dimensions.radiusXl),
                    ),
                    alignment: Alignment.center,
                    child: SizedBox(width: 32, height: 32, child: widget.icon),
                  ),
                  SizedBox(width: dimensions.space16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: typography.body1.copyWith(color: titleColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.description,
                          style: typography.body2.copyWith(
                            color: descriptionColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (widget.badgeText != null) ...[
                    SizedBox(width: dimensions.space16),
                    Container(
                      height: 28,
                      padding: EdgeInsets.symmetric(
                        horizontal: dimensions.space12,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.badgeSuccessBackground,
                        borderRadius: BorderRadius.circular(
                          dimensions.radius2xl,
                        ),
                      ),
                      child: Text(
                        widget.badgeText!,
                        style: typography.caption1.copyWith(
                          color: colors.badgeSuccessText,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(width: dimensions.space8),
                  Icon(Icons.chevron_right, size: 20, color: descriptionColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
