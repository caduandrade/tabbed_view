import 'package:flutter/material.dart';

import '../../tab_bar_position.dart';
import '../../tab_status.dart';
import '../tab_decoration_builder.dart';
import '../tab_header_extent_behavior.dart';
import '../tab_style_context.dart';
import '../tab_style_resolver.dart';
import '../tabbed_view_theme_data.dart';

/// Predefined folder theme builder.
class FolderTheme extends TabbedViewThemeData {
  FolderTheme({
    required Brightness brightness,
    required MaterialColor colorSet,
    required double fontSize,
    required double initialGap,
    required FolderTabStyleResolver? tabStyleResolver,
  }) {
    final bool isLight = brightness == Brightness.light;

    _unselectedBackgroundColor = isLight ? colorSet[300]! : colorSet[900]!;
    _selectedBackgroundColor = isLight ? colorSet[800]! : colorSet[400]!;
    _hoveredBackgroundColor = isLight ? colorSet[400]! : colorSet[800]!;
    final Color buttonColor = isLight ? colorSet[800]! : colorSet[100]!;
    final Color disabledButtonColor = buttonColor.withValues(alpha: .3);
    final Color fontColor = isLight ? colorSet[900]! : colorSet[100]!;
    final Color selectedFontColor = isLight ? colorSet[100]! : colorSet[900]!;

    divider = BorderSide(color: _selectedBackgroundColor, width: 4);

    tabsArea.tabHeaderExtentBehavior = TabHeaderExtentBehavior.uniform;
    tabsArea.initialGap = initialGap;
    tabsArea.buttonsAreaPadding = EdgeInsets.all(4);
    tabsArea.buttonPadding = const EdgeInsets.all(4);
    tabsArea.hoveredButtonBackground = BoxDecoration(
        color: isLight
            ? colorSet[300]!.withValues(alpha: .5)
            : colorSet[800]!.withValues(alpha: .5));
    tabsArea.buttonColor = buttonColor;
    tabsArea.disabledButtonColor = disabledButtonColor;
    tabsArea.dropColor = isLight
        ? const Color.fromARGB(150, 0, 0, 0)
        : const Color.fromARGB(150, 255, 255, 255);

    tab.styleResolver = tabStyleResolver;
    tab.buttonsOffset = 4;
    tab.textStyle = TextStyle(fontSize: fontSize, color: fontColor);
    tab.draggingDecoration = BoxDecoration(color: _unselectedBackgroundColor);
    tab.padding = const EdgeInsets.fromLTRB(16, 4, 12, 4);
    tab.paddingWithoutButton = const EdgeInsets.fromLTRB(16, 6, 16, 4);
    tab.hoveredButtonBackground =
        BoxDecoration(color: isLight ? colorSet[500]! : colorSet[700]!);
    tab.buttonPadding = const EdgeInsets.all(4);
    tab.buttonColor = buttonColor;
    tab.disabledButtonColor = disabledButtonColor;
    tab.decorationBuilder = _tabDecorationBuilder;
    tab.selectedStatus.fontColor = selectedFontColor;
    tab.selectedStatus.buttonColor = selectedFontColor;
    tab.selectedStatus.hoveredButtonBackground = BoxDecoration(
        color: isLight
            ? colorSet[700]!.withValues(alpha: .5)
            : colorSet[500]!.withValues(alpha: .5));
    tab.hoveredStatus.disabledButtonColor =
        isLight ? colorSet[500]! : colorSet[600]!;
  }

  late final Color _unselectedBackgroundColor;
  late final Color _selectedBackgroundColor;
  late final Color _hoveredBackgroundColor;

  FolderTabStyleResolver? get _folderTabStyleResolver {
    final TabStyleResolver? styleResolver = tab.styleResolver;
    if (styleResolver is FolderTabStyleResolver) {
      return styleResolver;
    }
    return null;
  }

  TabDecoration _tabDecorationBuilder(
      {required TabBarPosition tabBarPosition,
      required TabStyleContext styleContext}) {
    Color? backgroundColor;
    final FolderTabStyleResolver? resolver = _folderTabStyleResolver;
    switch (styleContext.status) {
      case TabStatus.selected:
        backgroundColor =
            resolver?.backgroundColor(styleContext) ?? _selectedBackgroundColor;
        break;
      case TabStatus.hovered:
        backgroundColor =
            resolver?.backgroundColor(styleContext) ?? _hoveredBackgroundColor;
        break;
      case TabStatus.normal:
        backgroundColor = resolver?.backgroundColor(styleContext) ??
            _unselectedBackgroundColor;
        break;
    }

    return TabDecoration(
      color: backgroundColor,
      shape: _FolderTabBorder(
        tabBarPosition: tabBarPosition,
        borderSide:
            BorderSide(color: _selectedBackgroundColor.withValues(alpha: 0.5)),
        angle: 10,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

/// A border that mimics the shape of a folder tab, with support for rounded corners.
class _FolderTabBorder extends ShapeBorder {
  const _FolderTabBorder({
    required this.tabBarPosition,
    required this.borderSide,
    required this.angle,
    required this.borderRadius,
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
