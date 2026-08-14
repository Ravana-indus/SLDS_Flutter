import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _allDocuments = [
  'Birth Certificate',
  'Driving License',
  'National Identity Card',
];

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsSearchBar,
  path: '[Forms & Inputs]',
)
Widget buildSldsSearchBarUseCase(BuildContext context) {
  final hintText = context.knobs.string(label: 'Hint', initialValue: 'Search');
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final showRecent = context.knobs.boolean(
    label: 'Show recent searches',
    initialValue: true,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: _SearchBarDemo(
      hintText: hintText,
      isEnabled: isEnabled,
      showRecent: showRecent,
    ),
  );
}

/// Real [State] (not a closure-local var) so the query/suggestions survive
/// rebuilds — see the SldsCheckbox playground bug this pattern avoids.
class _SearchBarDemo extends StatefulWidget {
  const _SearchBarDemo({
    required this.hintText,
    required this.isEnabled,
    required this.showRecent,
  });

  final String hintText;
  final bool isEnabled;
  final bool showRecent;

  @override
  State<_SearchBarDemo> createState() => _SearchBarDemoState();
}

class _SearchBarDemoState extends State<_SearchBarDemo> {
  final _controller = TextEditingController();
  List<String> _suggestions = const [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    setState(() {
      _suggestions = query.isEmpty
          ? const []
          : _allDocuments
                .where((d) => d.toLowerCase().contains(query.toLowerCase()))
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SldsSearchBar(
      controller: _controller,
      hintText: widget.hintText,
      enabled: widget.isEnabled,
      suggestions: _suggestions,
      recentSearches: widget.showRecent
          ? const ['National Identity Card', 'Birth Certificate']
          : const [],
      onChanged: _onChanged,
      onSuggestionSelected: (s) => setState(() => _suggestions = const []),
    );
  }
}
