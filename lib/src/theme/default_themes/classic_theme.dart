import 'package:flutter/material.dart';

import '../../tab_bar_position.dart';
import '../../tab_status.dart';
import '../tab_header_extent_behavior.dart';
import '../tab_decoration_builder.dart';
import '../tabbed_view_theme_data.dart';
import '../tabs_area_cross_axis_fit.dart';

/// Predefined classic theme builder.
class ClassicTheme extends TabbedViewThemeData {
  ClassicTheme(
      {required Brightness brightness,
      required MaterialColor colorSet,
      required double fontSize,
      required Color? borderColor,
      double? tabRadius}) {
    final bool isLight = brightness == Brightness.light;

    _backgroundColor = isLight ? colorSet[50]! : colorSet[900]!;
    final Color hoveredColor = isLight ? colorSet[300]! : colorSet[600]!;
    final Color fontColor = isLight ? colorSet[900]! : colorSet[200]!;
    final Color buttonColor = isLight ? colorSet[900]! : colorSet[200]!;
    final Color disabledButtonColor = buttonColor.withValues(alpha: .3);
    final Color hoveredButtonColor = isLight ? colorSet[900]! : colorSet[50]!;
    _borderColor = borderColor ?? (isLight ? colorSet[900]! : colorSet[800]!);
    this._tabRadius = tabRadius != null ? Radius.circular(tabRadius) : null;

    divider = BorderSide(color: _borderColor, width: 1);
    isDividerWithinTabArea = true;

    tabsArea.crossAxisFit = TabsAreaCrossAxisFit.none;
    tabsArea.tabHeaderExtentBehavior = TabHeaderExtentBehavior.uniform;
    tabsArea.buttonColor = buttonColor;
    tabsArea.hoveredButtonColor = hoveredButtonColor;
    tabsArea.disabledButtonColor = disabledButtonColor;
    tabsArea.buttonPadding = const EdgeInsets.all(2);
    tabsArea.hoveredButtonBackground = BoxDecoration(color: hoveredColor);
    BorderSide borderSide = BorderSide(color: _borderColor, width: 1);
    tabsArea.buttonsAreaDecoration = BoxDecoration(
        color: _backgroundColor,
        border: Border(top: borderSide, left: borderSide, right: borderSide));
    tabsArea.buttonsAreaPadding = EdgeInsets.all(2);
    tabsArea.middleGap = -1;
    tabsArea.dropColor = isLight
        ? const Color.fromARGB(150, 0, 0, 0)
        : const Color.fromARGB(150, 255, 255, 255);

    tab.textStyle = TextStyle(fontSize: fontSize, color: fontColor);
    tab.buttonColor = buttonColor;
    tab.hoveredButtonColor = hoveredButtonColor;
    tab.disabledButtonColor = disabledButtonColor;
    tab.hoveredButtonBackground = BoxDecoration(color: hoveredColor);
    tab.buttonsOffset = 4;
    tab.buttonPadding = const EdgeInsets.all(4);
    tab.padding = EdgeInsets.fromLTRB(8, 4, 4, 4);
    tab.paddingWithoutButton = EdgeInsets.fromLTRB(8, 6, 8, 5);
    tab.draggingDecoration = BoxDecoration(
        color: _backgroundColor,
        border: Border.all(color: _borderColor, width: 1));
    tab.decorationBuilder = _tabDecorationBuilder;

    contentArea.color = _backgroundColor;
    contentArea.border = BorderSide(width: 1, color: _borderColor);
  }

  late final Color _backgroundColor;
  late final Color _borderColor;
  late final Radius? _tabRadius;

  TabDecoration _tabDecorationBuilder(
      {required TabBarPosition tabBarPosition, required TabStatus status}) {
    final BorderSide borderSide = status == TabStatus.selected
        ? BorderSide(color: _backgroundColor, width: 10)
        : divider ?? BorderSide.none;
    switch (tabBarPosition) {
      case TabBarPosition.top:
        return TabDecoration(
            color: _backgroundColor,
            border: Border(bottom: borderSide),
            wrapperBorderBuilder: _externalDecorationBuilder);
      case TabBarPosition.bottom:
        return TabDecoration(
            color: _backgroundColor,
            border: Border(top: borderSide),
            wrapperBorderBuilder: _externalDecorationBuilder);
      case TabBarPosition.left:
        return TabDecoration(
            color: _backgroundColor,
            border: Border(right: borderSide),
            wrapperBorderBuilder: _externalDecorationBuilder);
      case TabBarPosition.right:
        return TabDecoration(
            color: _backgroundColor,
            border: Border(left: borderSide),
            wrapperBorderBuilder: _externalDecorationBuilder);
    }
  }

  TabDecoration _externalDecorationBuilder(
      {required TabBarPosition tabBarPosition, required TabStatus status}) {
    final BorderSide borderSide = BorderSide(color: _borderColor, width: 1);
    final Radius? radius = this._tabRadius;
    switch (tabBarPosition) {
      case TabBarPosition.top:
        return TabDecoration(
            border:
                Border(top: borderSide, left: borderSide, right: borderSide),
            borderRadius: radius != null
                ? BorderRadius.only(topLeft: radius, topRight: radius)
                : null);
      case TabBarPosition.bottom:
        return TabDecoration(
            border:
                Border(bottom: borderSide, left: borderSide, right: borderSide),
            borderRadius: radius != null
                ? BorderRadius.only(bottomLeft: radius, bottomRight: radius)
                : null);
      case TabBarPosition.left:
        return TabDecoration(
            border:
                Border(left: borderSide, top: borderSide, bottom: borderSide),
            borderRadius: radius != null
                ? BorderRadius.only(topLeft: radius, bottomLeft: radius)
                : null);
      case TabBarPosition.right:
        return TabDecoration(
            border:
                Border(right: borderSide, top: borderSide, bottom: borderSide),
            borderRadius: radius != null
                ? BorderRadius.only(topRight: radius, bottomRight: radius)
                : null);
    }
  }
}
