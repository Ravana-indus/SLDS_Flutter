import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// Visual container styles for [SldsPullToRefresh] — mirrors
/// [SldsBottomNav]/[SldsTopNavBar]'s light/dark choice for the loading bar;
/// independent of the app's own light/dark theme.
enum SldsPullToRefreshStyle { light, dark }

/// SLDS pull-to-refresh — wraps [child] in a scrollable that reveals an
/// iOS-style "Loading…" bar (spinner + text, not a bare circular spinner)
/// as the user pulls down, driven by [CupertinoSliverRefreshControl]'s
/// native gesture/physics rather than a hand-rolled drag detector.
///
/// [child] must itself be scrollable-content-shaped — pass a [ListView]'s
/// children or any widget; it's laid out inside a [SliverToBoxAdapter], so
/// a single non-scrolling child (e.g. a [Column]) works fine too as long as
/// its height fits, or wrap your own slivers instead of a plain [child] by
/// using [CustomScrollView] directly if you need more control.
class SldsPullToRefresh extends StatelessWidget {
  const SldsPullToRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.loadingText = 'Loading…',
    this.style = SldsPullToRefreshStyle.light,
  });

  /// Called when the user releases past the trigger threshold — return the
  /// future your actual refresh work completes with; the loading bar stays
  /// visible until it resolves.
  final RefreshCallback onRefresh;

  final Widget child;
  final String loadingText;
  final SldsPullToRefreshStyle style;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dark = style == SldsPullToRefreshStyle.dark;

    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: onRefresh,
          builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
            final active = refreshState == RefreshIndicatorMode.armed ||
                refreshState == RefreshIndicatorMode.refresh ||
                refreshState == RefreshIndicatorMode.drag;
            if (!active || pulledExtent <= 0) return const SizedBox.shrink();

            return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.dimensions.space16,
                  vertical: tokens.dimensions.space8,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: tokens.dimensions.space12),
                  decoration: BoxDecoration(
                    color: dark ? Colors.black.withValues(alpha: 0.85) : colors.surfaceCard,
                    borderRadius: BorderRadius.circular(tokens.dimensions.radius2xl),
                    border: dark ? null : Border.all(color: colors.borderDefault),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CupertinoActivityIndicator(color: dark ? Colors.white : colors.textSecondary),
                      ),
                      SizedBox(width: tokens.dimensions.space8),
                      Text(
                        loadingText,
                        style: tokens.typography.body2.copyWith(
                          color: dark ? Colors.white : colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        SliverToBoxAdapter(child: child),
      ],
    );
  }
}
