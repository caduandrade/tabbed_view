import 'package:flutter/widgets.dart';

/// Builds a responsive path given a size. Used to draw a icon.
typedef IconPath = Path Function(Size size);

/// Provides an icon
class IconProvider {
  IconProvider._(this.iconPath, this.iconData);

  /// Provides an [IconData]
  factory IconProvider.data(IconData iconData) {
    return IconProvider._(null, iconData);
  }

  /// Provides an [IconPath]
  factory IconProvider.path(IconPath iconPath) {
    return IconProvider._(iconPath, null);
  }

  final IconPath? iconPath;
  final IconData? iconData;

  /// Builds an icon
  Widget buildIcon(Color color, double size) {
    if (iconData != null) {
      return Icon(iconData, color: color, size: size);
    }
    return CustomPaint(
      size: Size(size, (size * 1).toDouble()),
      painter: _IconPathPainter(iconPath!, color),
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
