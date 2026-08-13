import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// One expandable section in an [SldsAccordion].
class SldsAccordionItem {
  const SldsAccordionItem({required this.title, required this.body});

  final String title;

  /// Shown below [title] once expanded — pass a [Text] for plain copy or
  /// any widget for richer content.
  final Widget body;
}

/// SLDS accordion — a vertically stacked list of [items], each a tappable
/// header that expands in place to reveal its body. Multiple sections can
/// be open at once (unlike [SldsFlyoutMenu], which allows only one);
/// pass [initiallyExpanded] to control which start open.
class SldsAccordion extends StatefulWidget {
  const SldsAccordion({super.key, required this.items, this.initiallyExpanded = const {}});

  final List<SldsAccordionItem> items;

  /// Indices into [items] that start expanded.
  final Set<int> initiallyExpanded;

  @override
  State<SldsAccordion> createState() => _SldsAccordionState();
}

class _SldsAccordionState extends State<SldsAccordion> {
  late final Set<int> _expanded = {...widget.initiallyExpanded};

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final dimensions = tokens.dimensions;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.items.length; i++) ...[
          if (i > 0) SizedBox(height: dimensions.space8),
          _AccordionTile(
            item: widget.items[i],
            expanded: _expanded.contains(i),
            onTap: () => setState(() {
              if (!_expanded.add(i)) _expanded.remove(i);
            }),
          ),
        ],
      ],
    );
  }
}

class _AccordionTile extends StatelessWidget {
  const _AccordionTile({required this.item, required this.expanded, required this.onTap});

  final SldsAccordionItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;

    return Material(
      color: colors.surfaceCard,
      borderRadius: BorderRadius.circular(dimensions.radius2xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(dimensions.radius2xl),
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          button: true,
          expanded: expanded,
          label: item.title,
          child: Padding(
            padding: EdgeInsets.all(dimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: tokens.typography.body1.copyWith(color: colors.textPrimary),
                      ),
                    ),
                    Icon(
                      expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: dimensions.iconSizeMedium,
                      color: colors.textPrimary,
                    ),
                  ],
                ),
                if (expanded) ...[
                  SizedBox(height: dimensions.space16),
                  item.body,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
