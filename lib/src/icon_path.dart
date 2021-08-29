import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Builds a responsive path given a size. Used to draw a icon.
typedef IconPath = Path Function(Size size);

/// [IconPath] widget
class IconPathWidget extends StatelessWidget {
  const IconPathWidget(
      {Key? key,
      required this.iconSize,
      required this.iconPath,
      required this.color})
      : super(key: key);

  final double iconSize;
  final IconPath iconPath;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(iconSize, (iconSize * 1).toDouble()),
      painter: _IconPathPainter(iconPath, color),
    );
  }
}

/// [IconPath] painter
class _IconPathPainter extends CustomPainter {
  _IconPathPainter(this.iconPath, this.color);

  final IconPath iconPath;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;
    paint.color = color;
    canvas.drawPath(iconPath(size), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
