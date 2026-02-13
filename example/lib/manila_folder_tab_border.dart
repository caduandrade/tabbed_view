import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// A border that mimics the shape of a manila folder tab, with support for rounded corners.
class ManilaFolderTabBorder extends ShapeBorder {
  const ManilaFolderTabBorder({
    required this.tabBarPosition,
    required this.borderSide,
    this.angle = 10.0,
    this.borderRadius = BorderRadius.zero,
  });

  final TabBarPosition tabBarPosition;
  final BorderSide borderSide;
  final double angle;
  final BorderRadiusGeometry borderRadius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  Path _buildPath(Rect rect, TextDirection? textDirection, bool closed) {
    Path path = Path();
    double slant = angle;
    final br = borderRadius.resolve(textDirection);

    switch (tabBarPosition) {
      case TabBarPosition.top:
        final p1 = Offset(rect.left, rect.bottom);
        final p2 = Offset(rect.left + slant, rect.top);
        final p3 = Offset(rect.right - slant, rect.top);
        final p4 = Offset(rect.right, rect.bottom);
        final r1 = br.topLeft.x;
        final r2 = br.topRight.x;

        path.moveTo(p1.dx, p1.dy);

        if (r1 > 0) {
          final pa = p2 + (p1 - p2).scaleTo(r1);
          final pb = p2 + (p3 - p2).scaleTo(r1);
          path.lineTo(pa.dx, pa.dy);
          path.quadraticBezierTo(p2.dx, p2.dy, pb.dx, pb.dy);
        } else {
          path.lineTo(p2.dx, p2.dy);
        }

        if (r2 > 0) {
          final pa = p3 + (p2 - p3).scaleTo(r2);
          final pb = p3 + (p4 - p3).scaleTo(r2);
          path.lineTo(pa.dx, pa.dy);
          path.quadraticBezierTo(p3.dx, p3.dy, pb.dx, pb.dy);
        } else {
          path.lineTo(p3.dx, p3.dy);
        }

        path.lineTo(p4.dx, p4.dy);
        break;
      case TabBarPosition.bottom:
        final p1 = Offset(rect.left, rect.top);
        final p2 = Offset(rect.left + slant, rect.bottom);
        final p3 = Offset(rect.right - slant, rect.bottom);
        final p4 = Offset(rect.right, rect.top);
        final r1 = br.bottomLeft.x;
        final r2 = br.bottomRight.x;

        path.moveTo(p1.dx, p1.dy);

        if (r1 > 0) {
          final pa = p2 + (p1 - p2).scaleTo(r1);
          final pb = p2 + (p3 - p2).scaleTo(r1);
          path.lineTo(pa.dx, pa.dy);
          path.quadraticBezierTo(p2.dx, p2.dy, pb.dx, pb.dy);
        } else {
          path.lineTo(p2.dx, p2.dy);
        }

        if (r2 > 0) {
          final pa = p3 + (p2 - p3).scaleTo(r2);
          final pb = p3 + (p4 - p3).scaleTo(r2);
          path.lineTo(pa.dx, pa.dy);
          path.quadraticBezierTo(p3.dx, p3.dy, pb.dx, pb.dy);
        } else {
          path.lineTo(p3.dx, p3.dy);
        }

        path.lineTo(p4.dx, p4.dy);
        break;
      case TabBarPosition.left:
        final p1 = Offset(rect.right, rect.top);
        final p2 = Offset(rect.left, rect.top + slant);
        final p3 = Offset(rect.left, rect.bottom - slant);
        final p4 = Offset(rect.right, rect.bottom);
        final r1 = br.topLeft.y;
        final r2 = br.bottomLeft.y;

        path.moveTo(p1.dx, p1.dy);

        if (r1 > 0) {
          final pa = p2 + (p1 - p2).scaleTo(r1);
          final pb = p2 + (p3 - p2).scaleTo(r1);
          path.lineTo(pa.dx, pa.dy);
          path.quadraticBezierTo(p2.dx, p2.dy, pb.dx, pb.dy);
        } else {
          path.lineTo(p2.dx, p2.dy);
        }

        if (r2 > 0) {
          final pa = p3 + (p2 - p3).scaleTo(r2);
          final pb = p3 + (p4 - p3).scaleTo(r2);
          path.lineTo(pa.dx, pa.dy);
          path.quadraticBezierTo(p3.dx, p3.dy, pb.dx, pb.dy);
        } else {
          path.lineTo(p3.dx, p3.dy);
        }

        path.lineTo(p4.dx, p4.dy);
        break;
      case TabBarPosition.right:
        final p1 = Offset(rect.left, rect.top);
        final p2 = Offset(rect.right, rect.top + slant);
        final p3 = Offset(rect.right, rect.bottom - slant);
        final p4 = Offset(rect.left, rect.bottom);
        final r1 = br.topRight.y;
        final r2 = br.bottomRight.y;

        path.moveTo(p1.dx, p1.dy);

        if (r1 > 0) {
          final pa = p2 + (p1 - p2).scaleTo(r1);
          final pb = p2 + (p3 - p2).scaleTo(r1);
          path.lineTo(pa.dx, pa.dy);
          path.quadraticBezierTo(p2.dx, p2.dy, pb.dx, pb.dy);
        } else {
          path.lineTo(p2.dx, p2.dy);
        }

        if (r2 > 0) {
          final pa = p3 + (p2 - p3).scaleTo(r2);
          final pb = p3 + (p4 - p3).scaleTo(r2);
          path.lineTo(pa.dx, pa.dy);
          path.quadraticBezierTo(p3.dx, p3.dy, pb.dx, pb.dy);
        } else {
          path.lineTo(p3.dx, p3.dy);
        }

        path.lineTo(p4.dx, p4.dy);
        break;
    }
    if (closed) {
      path.close();
    }
    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _buildPath(rect, textDirection, true);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _buildPath(rect, textDirection, true);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (borderSide == BorderSide.none) {
      return;
    }
    final Path path = _buildPath(rect, textDirection, false);
    canvas.drawPath(path, borderSide.toPaint());
  }

  @override
  ShapeBorder scale(double t) => this;
}

extension on Offset {
  Offset scaleTo(double length) {
    final double d = distance;
    if (d == 0) {
      return this;
    }
    return this * (length / d);
  }
}