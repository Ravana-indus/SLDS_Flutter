import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _options = [
  'Option One',
  'Option Two',
  'Option Three',
  'Option Four',
  'Option Five',
];

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsFilterDropdown,
  path: '[Forms & Inputs]',
)
Widget buildSldsFilterDropdownUseCase(BuildContext context) {
  final multiple = context.knobs.boolean(label: 'Multiple', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: _FilterDropdownDemo(multiple: multiple),
  );
}

/// Real [State] (not a closure-local var) so the selection survives
/// rebuilds — see the SldsCheckbox playground bug this pattern avoids.
class _FilterDropdownDemo extends StatefulWidget {
  const _FilterDropdownDemo({required this.multiple});

  final bool multiple;

  @override
  State<_FilterDropdownDemo> createState() => _FilterDropdownDemoState();
}

class _FilterDropdownDemoState extends State<_FilterDropdownDemo> {
  List<String> _pending = const [];
  List<String> _applied = const [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Applied: ${_applied.isEmpty ? '(none)' : _applied.join(', ')}'),
        const SizedBox(height: 12),
        SizedBox(
          width: 280,
          child: SldsFilterDropdown(
            options: _options,
            selectedValues: _pending,
            multiple: widget.multiple,
            onSelectionChanged: (v) => setState(() => _pending = v),
            onApply: (v) => setState(() => _applied = v),
            onCancel: () => setState(() => _pending = _applied),
          ),
        ),
      ],
    );
  }
}
