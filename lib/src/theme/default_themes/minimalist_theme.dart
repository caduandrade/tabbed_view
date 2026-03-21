import 'package:flutter/material.dart';

import '../../tab_bar_position.dart';
import '../../tab_status.dart';
import '../tab_decoration_builder.dart';
import '../tab_header_extent_behavior.dart';
import '../tab_style_context.dart';
import '../tab_style_resolver.dart';
import '../tabbed_view_theme_data.dart';

/// Predefined minimalist theme builder.
class MinimalistTheme extends TabbedViewThemeData {
  MinimalistTheme({
    required Brightness brightness,
    required MaterialColor colorSet,
    required double fontSize,
    required double initialGap,
    required double gap,
    required double? tabRadius,
    required MinimalistTabStyleResolver? tabStyleResolver,
  }) {
    final bool isLight = brightness == Brightness.light;

    _unselectedBackgroundColor = isLight ? colorSet[300]! : colorSet[900]!;
    _selectedBackgroundColor = isLight ? colorSet[800]! : colorSet[400]!;
    _hoveredBackgroundColor = isLight ? colorSet[400]! : colorSet[800]!;
    final Color buttonColor = isLight ? colorSet[800]! : colorSet[100]!;
    final Color disabledButtonColor = buttonColor.withValues(alpha: .3);
    final Color fontColor = isLight ? colorSet[900]! : colorSet[100]!;
    final Color selectedFontColor = isLight ? colorSet[100]! : colorSet[900]!;
    _tabRadius = tabRadius != null ? Radius.circular(tabRadius) : null;

    divider = BorderSide(color: _selectedBackgroundColor, width: 4);

    tabsArea.tabHeaderExtentBehavior = TabHeaderExtentBehavior.uniform;
    tabsArea.initialGap = initialGap;
    tabsArea.middleGap = gap;
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
    tab.padding = const EdgeInsets.fromLTRB(8, 4, 4, 4);
    tab.paddingWithoutButton = const EdgeInsets.fromLTRB(8, 6, 8, 4);
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

  late final Radius? _tabRadius;
  late final Color _unselectedBackgroundColor;
  late final Color _selectedBackgroundColor;
  late final Color _hoveredBackgroundColor;

  MinimalistTabStyleResolver? get _minimalistTabStyleResolver {
    final TabStyleResolver? styleResolver = tab.styleResolver;
    if (styleResolver is MinimalistTabStyleResolver) {
      return styleResolver;
    }
    return null;
  }

  TabDecoration _tabDecorationBuilder(
      {required TabBarPosition tabBarPosition,
      required TabStyleContext styleContext}) {
    Color? backgroundColor;
    final MinimalistTabStyleResolver? resolver = _minimalistTabStyleResolver;
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
    final Radius? radius = _tabRadius;
    switch (tabBarPosition) {
      case TabBarPosition.top:
        return TabDecoration(
            color: backgroundColor,
            borderRadius: radius != null
                ? BorderRadius.only(topLeft: radius, topRight: radius)
                : null);
      case TabBarPosition.bottom:
        return TabDecoration(
            color: backgroundColor,
            borderRadius: radius != null
                ? BorderRadius.only(bottomLeft: radius, bottomRight: radius)
                : null);
      case TabBarPosition.left:
        return TabDecoration(
            color: backgroundColor,
            borderRadius: radius != null
                ? BorderRadius.only(topLeft: radius, bottomLeft: radius)
                : null);
      case TabBarPosition.right:
        return TabDecoration(
            color: backgroundColor,
            borderRadius: radius != null
                ? BorderRadius.only(topRight: radius, bottomRight: radius)
                : null);
    }
  }
}
