import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _items = [
  SldsBottomNavItem(icon: Icons.home, label: 'Label'),
  SldsBottomNavItem(icon: Icons.home, label: 'Label'),
  SldsBottomNavItem(icon: Icons.home, label: 'Label'),
  SldsBottomNavItem(icon: Icons.home, label: 'Label', badgeCount: 2),
  SldsBottomNavItem(icon: Icons.home, label: 'Label', enabled: false),
];

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsBottomNav,
  path: '[Navigation]',
)
Widget buildSldsBottomNavUseCase(BuildContext context) {
  final style = context.knobs.object.dropdown(
    label: 'Style',
    options: SldsBottomNavStyle.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsBottomNavStyle.light,
  );

  return _BottomNavDemo(style: style);
}

/// Real [State] (not a closure-local var) so the selection survives
/// rebuilds — see the SldsCheckbox playground bug this pattern avoids.
class _BottomNavDemo extends StatefulWidget {
  const _BottomNavDemo({required this.style});

  final SldsBottomNavStyle style;

  @override
  State<_BottomNavDemo> createState() => _BottomNavDemoState();
}

class _BottomNavDemoState extends State<_BottomNavDemo> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Page content')),
      bottomNavigationBar: SldsBottomNav(
        items: _items,
        currentIndex: _index,
        style: widget.style,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
