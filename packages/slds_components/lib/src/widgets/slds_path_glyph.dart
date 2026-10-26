import 'package:flutter/widgets.dart';

/// Paints a single-path glyph exported from Figma — for icons Material has
/// no match for (Phosphor's FileDoc, User). [path] is drawn on a square
/// [viewBox] grid and scaled to [size].
class SldsPathGlyph extends StatelessWidget {
  /// Creates a glyph of [path], laid out on a [viewBox]-unit square grid.
  const SldsPathGlyph({
    required this.path,
    required this.viewBox,
    required this.size,
    required this.color,
    super.key,
    this.semanticLabel,
  });

  /// The glyph outline, in [viewBox] units.
  final Path path;

  /// Edge length of the square grid [path] is drawn on.
  final double viewBox;

  /// Rendered edge length.
  final double size;

  /// Fill colour.
  final Color color;

  /// Screen-reader label; null leaves the glyph decorative.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    image: semanticLabel != null,
    child: CustomPaint(
      size: Size.square(size),
      painter: _GlyphPainter(path, viewBox, color),
    ),
  );
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.path, this.viewBox, this.color);

  final Path path;
  final double viewBox;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..scale(size.width / viewBox, size.height / viewBox)
      ..drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.path != path || old.viewBox != viewBox || old.color != color;
}
