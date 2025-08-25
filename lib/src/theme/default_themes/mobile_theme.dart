import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Predefined mobile theme builder.
class MobileTheme extends TabbedViewThemeData {
  MobileTheme._(
      {required this.borderColor,
      required this.highlightedColor,
      required this.selectedColor});

  factory MobileTheme(
      {required MaterialColor colorSet,
      required Color accentColor,
      required double fontSize}) {
    Color borderColor = colorSet[500]!;
    Color foregroundColor = colorSet[900]!;
    Color backgroundColor = colorSet[50]!;
    Color menuColor = colorSet[100]!;
    Color normalButtonColor = colorSet[700]!;
    Color disabledButtonColor = colorSet[300]!;
    Color hoverButtonColor = colorSet[900]!;
    Color highlightedColor = colorSet[300]!;

    MobileTheme theme = MobileTheme._(
        borderColor: borderColor,
        highlightedColor: highlightedColor,
        selectedColor: accentColor);

    theme.divider = BorderSide(width: 5, color: borderColor);

    final TabsAreaThemeData tabsArea = theme.tabsArea;
    tabsArea.equalHeights = EqualHeights.all;
    tabsArea.initialGap = 10;
    tabsArea.middleGap = 10;
    tabsArea.normalButtonColor = normalButtonColor;
    tabsArea.hoverButtonColor = hoverButtonColor;
    tabsArea.disabledButtonColor = disabledButtonColor;
    tabsArea.buttonsAreaPadding = EdgeInsets.all(2);
    tabsArea.hoverButtonBackground = BoxDecoration(color: highlightedColor);
    tabsArea.buttonPadding = const EdgeInsets.all(2);
    tabsArea.border = BorderSide(color: borderColor, width: 5);
    tabsArea.color = backgroundColor;

    final TabThemeData tab = theme.tab;
    BorderSide verticalBorderSide = BorderSide(color: borderColor, width: 5);
    double borderHeight = 4;
    tab.innerLeftBorder = verticalBorderSide;
    tab.innerRightBorder = verticalBorderSide;
    tab.innerTopBorder = verticalBorderSide;
    tab.normalButtonColor = normalButtonColor;
    tab.hoverButtonColor = hoverButtonColor;
    tab.disabledButtonColor = disabledButtonColor;
    tab.textStyle = TextStyle(fontSize: fontSize, color: foregroundColor);
    tab.buttonsOffset = 4;
    tab.padding = EdgeInsets.fromLTRB(6, 3, 3, 3);
    tab.paddingWithoutButton = EdgeInsets.fromLTRB(6, 3, 6, 3);
    tab.hoverButtonBackground = BoxDecoration(color: highlightedColor);
    tab.buttonPadding = const EdgeInsets.all(2);
    tab.draggingDecoration =
        BoxDecoration(border: Border.all(color: borderColor, width: 1));
    tab.highlightedStatus = TabStatusThemeData(
        border: BorderSide(color: borderColor, width: borderHeight));
    tab.selectedStatus = TabStatusThemeData(
        border: BorderSide(color: accentColor, width: borderHeight));
    tab.borderBuilder = theme._tabBorderBuilder;

    final ContentAreaThemeData contentArea = theme.contentArea;
    // For the mobile theme, the content area is a distinct, bordered box
    // that does not try to connect its border with the tabs area. A full
    // border works for any TabBarPosition.
    contentArea.color = backgroundColor;
    contentArea.border = BorderSide(width: 1, color: borderColor);

    final HiddenTabsMenuThemeData menu = theme.menu;
    menu.color = backgroundColor;
    menu.textStyle = TextStyle(fontSize: fontSize, color: foregroundColor);
    menu.menuItemPadding =
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    menu.boxShadow = [
      BoxShadow(
          color: borderColor.withAlpha(100),
          blurRadius: 4,
          offset: const Offset(0, 2))
    ];
    menu.borderRadius = BorderRadius.circular(4);

    return theme;
  }

  Color borderColor;
  Color highlightedColor;
  Color selectedColor;

  TabBorder _tabBorderBuilder(
      {required TabBarPosition tabBarPosition, required TabStatus status}) {
    Color? color;
    switch (status) {
      case TabStatus.selected:
        color = selectedColor;
        break;
      case TabStatus.highlighted:
        color = highlightedColor;
        break;
      case TabStatus.normal:
        color = Colors.transparent;
        break;
    }
    final BorderSide borderSide = BorderSide(color: color, width: 5);
    switch (tabBarPosition) {
      case TabBarPosition.top:
        return TabBorder(
            border: Border(bottom: borderSide),
            wrapperBorderBuilder: _externalBorderBuilder);
      case TabBarPosition.bottom:
        return TabBorder(
            border: Border(top: borderSide),
            wrapperBorderBuilder: _externalBorderBuilder);
      case TabBarPosition.left:
        return TabBorder(
            border: Border(right: borderSide),
            wrapperBorderBuilder: _externalBorderBuilder);
      case TabBarPosition.right:
        return TabBorder(
            border: Border(left: borderSide),
            wrapperBorderBuilder: _externalBorderBuilder);
    }
  }

  TabBorder _externalBorderBuilder(
      {required TabBarPosition tabBarPosition, required TabStatus status}) {
    final BorderSide borderSide = BorderSide(color: borderColor, width: 1);
    if (tabBarPosition.isHorizontal) {
      return TabBorder(border: Border(left: borderSide, right: borderSide));
    }
    return TabBorder(border: Border(top: borderSide, bottom: borderSide));
  }
}
