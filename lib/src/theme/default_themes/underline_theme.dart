import 'package:flutter/material.dart';

import '../../tab_bar_position.dart';
import '../../tab_status.dart';
import '../tab_decoration_builder.dart';
import '../tab_style_context.dart';
import '../tab_style_resolver.dart';
import '../tabbed_view_theme_data.dart';
import '../tabs_area_cross_axis_fit.dart';

/// Predefined underline theme builder.
class UnderlineTheme extends TabbedViewThemeData {
  UnderlineTheme({
    required Brightness brightness,
    required MaterialColor colorSet,
    required MaterialColor underlineColorSet,
    required double fontSize,
    required UnderlineTabStyleResolver? tabStyleResolver,
  }) {
    final bool isLight = brightness == Brightness.light;

    _borderColor = isLight ? colorSet[500]! : colorSet[800]!;
    final Color foregroundColor = isLight ? colorSet[900]! : colorSet[100]!;
    final Color backgroundColor = isLight ? colorSet[50]! : colorSet[900]!;
    final Color buttonColor = isLight ? colorSet[700]! : colorSet[200]!;
    final Color disabledButtonColor = buttonColor.withValues(alpha: .3);
    final Color hoveredButtonColor = isLight ? colorSet[900]! : colorSet[300]!;
    _hoveredButtonBackground = isLight
        ? colorSet[400]!.withValues(alpha: .5)
        : colorSet[600]!.withValues(alpha: .5);
    _hoveredUnderlineColor = isLight ? colorSet[400]! : colorSet[600]!;
    _selectedUnderlineColor = underlineColorSet;

    divider = BorderSide(color: _borderColor, width: 1);
    alwaysShowDivider = false;
    isDividerWithinTabArea = false;

    tabsArea.crossAxisFit = TabsAreaCrossAxisFit.all;
    tabsArea.initialGap = -1;
    tabsArea.middleGap = -1;
    tabsArea.buttonColor = buttonColor;
    tabsArea.hoveredButtonColor = hoveredButtonColor;
    tabsArea.disabledButtonColor = disabledButtonColor;
    tabsArea.buttonsAreaPadding = EdgeInsets.all(2);
    tabsArea.hoveredButtonBackground =
        BoxDecoration(color: _hoveredButtonBackground);
    tabsArea.buttonPadding = const EdgeInsets.all(2);
    tabsArea.border = BorderSide(color: _borderColor, width: 1);
    tabsArea.color = backgroundColor;
    tabsArea.dropColor = isLight
        ? const Color.fromARGB(150, 0, 0, 0)
        : const Color.fromARGB(150, 255, 255, 255);

    tab.styleResolver = tabStyleResolver;
    tab.buttonColor = buttonColor;
    tab.hoveredButtonColor = hoveredButtonColor;
    tab.disabledButtonColor = disabledButtonColor;
    tab.textStyle = TextStyle(fontSize: fontSize, color: foregroundColor);
    tab.buttonsOffset = 4;
    tab.padding = const EdgeInsets.fromLTRB(8, 4, 4, 0);
    tab.paddingWithoutButton = const EdgeInsets.fromLTRB(8, 7, 8, 3);
    tab.hoveredButtonBackground =
        BoxDecoration(color: _hoveredButtonBackground);
    tab.buttonPadding = const EdgeInsets.all(4);
    tab.draggingDecoration =
        BoxDecoration(border: Border.all(color: _borderColor, width: 1));
    tab.decorationBuilder = _tabDecorationBuilder;

    contentArea.color = backgroundColor;
    contentArea.border = BorderSide(width: 1, color: _borderColor);
  }

  late final Color _borderColor;
  late final Color _hoveredButtonBackground;
  late final Color _hoveredUnderlineColor;
  late final Color _selectedUnderlineColor;

  UnderlineTabStyleResolver? get _underlineTabStyleResolver {
    final TabStyleResolver? styleResolver = tab.styleResolver;
    if (styleResolver is UnderlineTabStyleResolver) {
      return styleResolver;
    }
    return null;
  }

  TabDecoration _tabDecorationBuilder(
      {required TabBarPosition tabBarPosition,
      required TabStyleContext styleContext}) {
    Color? underlineColor;
    final UnderlineTabStyleResolver? resolver = _underlineTabStyleResolver;
    switch (styleContext.status) {
      case TabStatus.selected:
        underlineColor =
            resolver?.underlineColor(styleContext) ?? _selectedUnderlineColor;
        break;
      case TabStatus.hovered:
        underlineColor =
            resolver?.underlineColor(styleContext) ?? _hoveredUnderlineColor;
        break;
      case TabStatus.normal:
        underlineColor =
            resolver?.underlineColor(styleContext) ?? Colors.transparent;
        break;
    }
    final BorderSide borderSide = BorderSide(color: underlineColor, width: 4);
    Color? backgroundColor;
    final TabStyleResolver? styleResolver = tab.styleResolver;
    if (styleResolver is UnderlineTabStyleResolver) {
      backgroundColor = styleResolver.backgroundColor(styleContext);
    }
    switch (tabBarPosition) {
      case TabBarPosition.top:
        return TabDecoration(
            color: backgroundColor,
            border: Border(bottom: borderSide),
            wrapperBorderBuilder: _externalDecorationBuilder);
      case TabBarPosition.bottom:
        return TabDecoration(
            color: backgroundColor,
            border: Border(top: borderSide),
            wrapperBorderBuilder: _externalDecorationBuilder);
      case TabBarPosition.left:
        return TabDecoration(
            color: backgroundColor,
            border: Border(right: borderSide),
            wrapperBorderBuilder: _externalDecorationBuilder);
      case TabBarPosition.right:
        return TabDecoration(
            color: backgroundColor,
            border: Border(left: borderSide),
            wrapperBorderBuilder: _externalDecorationBuilder);
    }
  }

  TabDecoration _externalDecorationBuilder(
      {required TabBarPosition tabBarPosition,
      required TabStyleContext styleContext}) {
    final BorderSide borderSide = BorderSide(color: _borderColor, width: 1);
    if (tabBarPosition.isHorizontal) {
      return TabDecoration(border: Border(left: borderSide, right: borderSide));
    }
    return TabDecoration(border: Border(top: borderSide, bottom: borderSide));
  }
}
