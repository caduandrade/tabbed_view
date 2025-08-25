import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Predefined classic theme builder.
class ClassicTheme extends TabbedViewThemeData {
  ClassicTheme._({required this.borderColor});

  factory ClassicTheme(
      {required MaterialColor colorSet,
      required double fontSize,
      required Color borderColor}) {
    Color backgroundColor = colorSet[50]!;
    Color highlightedColor = colorSet[300]!;
    Color fontColor = colorSet[900]!;
    Color normalButtonColor = colorSet[900]!;
    Color disabledButtonColor = colorSet[400]!;
    Color hoverButtonColor = colorSet[900]!;

    ClassicTheme theme = ClassicTheme._(borderColor: borderColor);

    theme.divider = BorderSide(color: borderColor, width: 1);
    theme.isDividerWithinTabArea = true;

    final TabsAreaThemeData tabsArea = theme.tabsArea;
    tabsArea.normalButtonColor = normalButtonColor;
    tabsArea.hoverButtonColor = hoverButtonColor;
    tabsArea.disabledButtonColor = disabledButtonColor;
    tabsArea.buttonPadding = const EdgeInsets.all(2);
    tabsArea.hoverButtonBackground = BoxDecoration(color: highlightedColor);
    tabsArea.buttonsAreaDecoration = BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1));
    tabsArea.buttonsAreaPadding = EdgeInsets.all(2);
    tabsArea.middleGap = -1;
    tabsArea.equalHeights = EqualHeights.none;
    tabsArea.gapBottomBorder = BorderSide(color: borderColor, width: 1);
    tabsArea.gapSideBorder = BorderSide(color: borderColor, width: 1);

    final TabThemeData tab = theme.tab;
    tab.innerLeftBorder = const BorderSide(color: Colors.transparent, width: 2);
    tab.innerRightBorder =
        const BorderSide(color: Colors.transparent, width: 2);
    tab.innerBottomBorder =
        const BorderSide(color: Colors.transparent, width: 2);
    tab.textStyle = TextStyle(fontSize: fontSize, color: fontColor);
    tab.normalButtonColor = normalButtonColor;
    tab.hoverButtonColor = hoverButtonColor;
    tab.disabledButtonColor = disabledButtonColor;
    tab.hoverButtonBackground = BoxDecoration(color: highlightedColor);
    tab.buttonsOffset = 4;
    tab.buttonPadding = const EdgeInsets.all(2);
    tab.padding = EdgeInsets.fromLTRB(6, 3, 3, 3);
    tab.paddingWithoutButton = EdgeInsets.fromLTRB(6, 3, 6, 3);
    tab.margin = EdgeInsets.zero;
    tab.decoration = BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1));
    tab.draggingDecoration = BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1));
    tab.highlightedStatus = TabStatusThemeData(
        decoration: BoxDecoration(
            color: highlightedColor,
            border: Border.all(color: borderColor, width: 1)));
    // The border is now defined by a single BorderSide, allowing the
    // TabWidget to build the correct border for any TabBarPosition.
    tab.selectedStatus = TabStatusThemeData(
      decoration: BoxDecoration(color: backgroundColor),
      border: BorderSide(color: borderColor, width: 1),
      padding: EdgeInsets.fromLTRB(6, 3, 3, 8),
    );
    tab.borderBuilder = theme._tabBorderBuilder;

    final ContentAreaThemeData contentArea = theme.contentArea;
    // The border is now defined by a single BorderSide, allowing the
    // ContentArea to build the correct border for any TabBarPosition.
    BorderSide borderSide = BorderSide(width: 1, color: borderColor);
    contentArea.color = backgroundColor;
    contentArea.border = borderSide;

    final HiddenTabsMenuThemeData menu = theme.menu;
    menu.color = backgroundColor;
    menu.textStyle = TextStyle(fontSize: fontSize, color: fontColor);
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

  final Color borderColor;

  TabBorder _tabBorderBuilder(
      {required TabBarPosition tabBarPosition, required TabStatus status}) {
    final BorderSide borderSide = status == TabStatus.selected
        ? BorderSide(color: Colors.transparent, width: 5)
        : BorderSide.none;
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
    switch (tabBarPosition) {
      case TabBarPosition.top:
        return TabBorder(
            border:
                Border(top: borderSide, left: borderSide, right: borderSide));
      case TabBarPosition.bottom:
        return TabBorder(
            border: Border(
                bottom: borderSide, left: borderSide, right: borderSide));
      case TabBarPosition.left:
        return TabBorder(
            border:
                Border(left: borderSide, top: borderSide, bottom: borderSide));
      case TabBarPosition.right:
        return TabBorder(
            border:
                Border(right: borderSide, top: borderSide, bottom: borderSide));
    }
  }
}
