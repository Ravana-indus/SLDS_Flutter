import 'package:flutter/widgets.dart';

/// Owns a control's [FocusNode] and keeps its focus in step with [focused],
/// so a playground can show the control's focus state from a knob.
class FocusedDemo extends StatefulWidget {
  const FocusedDemo({required this.focused, required this.builder, super.key});

  final bool focused;
  final Widget Function(FocusNode focusNode) builder;

  @override
  State<FocusedDemo> createState() => _FocusedDemoState();
}

class _FocusedDemoState extends State<FocusedDemo> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(FocusedDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focused != widget.focused) _sync();
  }

  // After the frame, so the node is attached to the control before focusing.
  void _sync() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;
    widget.focused ? _focusNode.requestFocus() : _focusNode.unfocus();
  });

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(_focusNode);
}
