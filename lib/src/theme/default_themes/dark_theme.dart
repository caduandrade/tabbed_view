import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tabbed_view/src/theme/button_colors.dart';
import 'package:tabbed_view/src/theme/content_area_theme_data.dart';
import 'package:tabbed_view/src/theme/equal_heights.dart';
import 'package:tabbed_view/src/theme/menu_theme_data.dart';
import 'package:tabbed_view/src/theme/tab_status_theme_data.dart';
import 'package:tabbed_view/src/theme/tab_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/tabs_area_theme_data.dart';

/// Predefined dark theme builder.
class DarkTheme {
  static TabbedViewThemeData build(
      {required MaterialColor colorSet, required double fontSize}) {
    Color tabColor = colorSet[900]!;
    Color selectedTabColor = colorSet[800]!;
    Color highlightedTabColor = colorSet[700]!;
    ButtonColors buttonColors = ButtonColors(
        normal: colorSet[300]!,
        disabled: colorSet[600]!,
        hover: colorSet[100]!);
    Color menuColor = colorSet[700]!;
    Color menuHoverColor = colorSet[600]!;
    Color menuDividerColor = colorSet[500]!;
    Color fontColor = colorSet[100]!;
    Color buttonsAreaColor = colorSet[800]!;

    return TabbedViewThemeData(
        tabsArea: tabsAreaTheme(
            buttonsAreaColor: buttonsAreaColor,
            fontSize: fontSize,
            fontColor: fontColor,
            tabColor: tabColor,
            selectedTabColor: selectedTabColor,
            highlightedTabColor: highlightedTabColor,
            buttonColors: buttonColors),
        tab: tabTheme(
            fontSize: fontSize,
            fontColor: fontColor,
            tabColor: tabColor,
            selectedTabColor: selectedTabColor,
            highlightedTabColor: highlightedTabColor,
            buttonColors: buttonColors),
        contentArea: contentAreaTheme(selectedTabColor: selectedTabColor),
        menu: menuTheme(
            fontColor: fontColor,
            fontSize: fontSize,
            color: menuColor,
            hoverColor: menuHoverColor,
            dividerColor: menuDividerColor));
  }

  static TabsAreaThemeData tabsAreaTheme(
      {required Color buttonsAreaColor,
      required Color fontColor,
      required double fontSize,
      required Color tabColor,
      required Color selectedTabColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors}) {
    return TabsAreaThemeData(
        equalHeights: EqualHeights.all,
        middleGap: 4,
        buttonsAreaPadding: EdgeInsets.all(4),
        buttonsAreaDecoration: BoxDecoration(color: buttonsAreaColor),
        buttonColors: buttonColors,
        buttonsGap: 4);
  }

  static TabThemeData tabTheme(
      {required Color fontColor,
      required double fontSize,
      required Color tabColor,
      required Color selectedTabColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors}) {
    double bottomWidth = 3;
    return TabThemeData(
        buttonsOffset: 8,
        buttonsGap: 4,
        textStyle: TextStyle(fontSize: fontSize, color: fontColor),
        decoration: BoxDecoration(color: tabColor),
        margin: EdgeInsets.only(bottom: bottomWidth),
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        selectedStatus: TabStatusThemeData(
            decoration: BoxDecoration(
                color: selectedTabColor,
                border: Border(
                    bottom: BorderSide(
                        width: bottomWidth, color: selectedTabColor))),
            margin: EdgeInsets.zero),
        highlightedStatus: TabStatusThemeData(
            decoration: BoxDecoration(color: highlightedTabColor)),
        buttonColors: buttonColors);
  }

  static ContentAreaThemeData contentAreaTheme(
      {required Color selectedTabColor}) {
    return ContentAreaThemeData(
        decoration: BoxDecoration(color: selectedTabColor),
        padding: EdgeInsets.all(8));
  }

  static MenuThemeData menuTheme(
      {required Color fontColor,
      required double fontSize,
      required Color color,
      required hoverColor,
      required dividerColor}) {
    return MenuThemeData(
        textStyle: TextStyle(fontSize: fontSize, color: fontColor),
        margin: EdgeInsets.all(8),
        menuItemPadding: EdgeInsets.all(8),
        color: color,
        hoverColor: hoverColor,
        dividerColor: dividerColor,
        dividerThickness: 1);
  }
}
