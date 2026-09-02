import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart' show SldsTimePickerDialog;
import 'package:slds_components/src/theme/slds_tokens.dart';
import 'package:slds_components/src/widgets/slds_time_picker.dart'
    show SldsTimePickerDialog;

/// One tappable row inside an [SldsFlyoutMenuGroup].
class SldsFlyoutMenuEntry {
  /// Creates a menu row.
  const SldsFlyoutMenuEntry({required this.label, this.icon, this.onTap});

  /// The row's visible text, and its accessible name.
  final String label;

  /// Optional leading icon. Decorative — [label] carries the meaning.
  final IconData? icon;

  /// Called when the row is tapped.
  final VoidCallback? onTap;
}

/// A labeled section of [entries] shown under an expanded [SldsFlyoutMenuItem]
/// (e.g. "Tools for Trusted Data").
class SldsFlyoutMenuGroup {
  /// Creates a labelled group of [entries].
  const SldsFlyoutMenuGroup({required this.header, required this.entries});

  /// Section heading shown above [entries].
  final String header;

  /// The rows in this section, in display order.
  final List<SldsFlyoutMenuEntry> entries;
}

/// One top-level row in an [SldsFlyoutMenu]. A row with [groups] expands in
/// place to reveal them when tapped; a row with no [groups] is a plain
/// tappable link (fires [onTap] directly, never expands).
class SldsFlyoutMenuItem {
  /// Creates a top-level menu row.
  const SldsFlyoutMenuItem({
    required this.label,
    this.groups = const [],
    this.onTap,
  });

  /// The row's visible text, and its accessible name.
  final String label;

  /// Sub-sections revealed when the row expands. Empty makes the row a
  /// plain link that fires [onTap] instead of expanding.
  final List<SldsFlyoutMenuGroup> groups;

  /// Called when a row with no [groups] is tapped.
  final VoidCallback? onTap;
}

/// SLDS mobile flyout navigation menu — a vertical list of [items], each
/// either a plain link or an accordion row that expands to grouped
/// sub-items with section headers and leading icons. Only one item is
/// expanded at a time. This is the panel content only (matches
/// [SldsTimePickerDialog]'s split) — wrap it in [showSldsFlyoutMenu] (a
/// full-screen scrim + sheet with a close button, matching the mock) or
/// your own [showModalBottomSheet]/[Drawer] if you need different framing.
class SldsFlyoutMenu extends StatefulWidget {
  /// Creates a flyout menu panel listing [items].
  const SldsFlyoutMenu({required this.items, super.key, this.onClose});

  /// The top-level rows, in display order.
  final List<SldsFlyoutMenuItem> items;

  /// Null hides the close button (e.g. when embedded without its own modal
  /// shell).
  final VoidCallback? onClose;

  @override
  State<SldsFlyoutMenu> createState() => _SldsFlyoutMenuState();
}

class _SldsFlyoutMenuState extends State<SldsFlyoutMenu> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return Material(
      // Its InkWell rows (here and inside _FlyoutItem) need a Material
      // ancestor to paint splashes — this widget isn't guaranteed one from
      // its caller (e.g. showGeneralDialog's pageBuilder doesn't provide
      // one, unlike showDialog), so it brings its own.
      color: colors.surfaceCard,
      borderRadius: BorderRadius.circular(dimensions.radius2xl),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.onClose != null)
              Align(
                // The close affordance sits in the trailing corner, which
                // flips to the left in an RTL locale.
                alignment: AlignmentDirectional.topEnd,
                child: IconButton(
                  onPressed: widget.onClose,
                  icon: Icon(Icons.close, color: colors.textPrimary),
                ),
              ),
            for (var i = 0; i < widget.items.length; i++)
              _FlyoutItem(
                item: widget.items[i],
                expanded: i == _expandedIndex,
                onTap: widget.items[i].groups.isEmpty
                    ? widget.items[i].onTap
                    : () => setState(
                        () => _expandedIndex = _expandedIndex == i ? null : i,
                      ),
              ),
            SizedBox(height: dimensions.space12),
          ],
        ),
      ),
    );
  }
}

class _FlyoutItem extends StatelessWidget {
  const _FlyoutItem({
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final SldsFlyoutMenuItem item;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final expandable = item.groups.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          // Expandable rows show their state only as a chevron direction.
          button: true,
          expanded: expandable ? expanded : null,
          label: item.label,
          excludeSemantics: true,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dimensions.space20,
                vertical: dimensions.space16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.label,
                      style: tokens.typography.body2.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (expandable)
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: dimensions.iconSizeMedium,
                      color: colors.textPrimary,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (expanded)
          for (final group in item.groups)
            Padding(
              padding: EdgeInsets.only(bottom: dimensions.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: dimensions.space20,
                    ),
                    child: Text(
                      group.header,
                      style: tokens.typography.caption1.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ),
                  SizedBox(height: dimensions.space8),
                  for (final entry in group.entries)
                    Semantics(
                      button: true,
                      label: entry.label,
                      excludeSemantics: true,
                      child: InkWell(
                        onTap: entry.onTap,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: dimensions.space20,
                            vertical: dimensions.space8,
                          ),
                          child: Row(
                            children: [
                              if (entry.icon != null) ...[
                                Icon(
                                  entry.icon,
                                  size: dimensions.iconSizeMedium,
                                  color: colors.textSecondary,
                                ),
                                SizedBox(width: dimensions.space12),
                              ],
                              Expanded(
                                child: Text(
                                  entry.label,
                                  style: tokens.typography.body2.copyWith(
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
      ],
    );
  }
}

/// Shows [items] in an [SldsFlyoutMenu] as a full-screen dark-scrim modal
/// with a close button, matching the mock's "Mobile Flyout" framing —
/// [SldsFlyoutMenu] docs on when to reach for this vs. rolling your own
/// shell. Dismiss by tapping the scrim, the close button, or the back
/// gesture.
Future<void> showSldsFlyoutMenu(
  BuildContext context, {
  required List<SldsFlyoutMenuItem> items,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierLabel: 'Navigation menu',
    barrierDismissible: true,
    barrierColor: Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SldsFlyoutMenu(
              items: items,
              onClose: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      );
    },
  );
}
