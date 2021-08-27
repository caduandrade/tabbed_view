import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tabbed_view/src/theme/button_colors.dart';
import 'package:tabbed_view/src/theme/content_area_theme_data.dart';
import 'package:tabbed_view/src/theme/menu_theme_data.dart';
import 'package:tabbed_view/src/theme/tab_status_theme_data.dart';
import 'package:tabbed_view/src/theme/tab_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/tabs_area_theme_data.dart';

/// Predefined classic theme builder.
class ClassicTheme {
  static TabbedViewThemeData build(
      {required MaterialColor colorSet,
      required double fontSize,
      required Color borderColor}) {
    Color backgroundColor = colorSet[50]!;
    Color highlightedTabColor = colorSet[300]!;
    Color fontColor = colorSet[900]!;
    Color menuHoverColor = colorSet[200]!;
    ButtonColors buttonColors = ButtonColors(
        normal: colorSet[700]!,
        disabled: colorSet[400]!,
        hover: colorSet[900]!);

    return TabbedViewThemeData(
        tabsArea: tabsAreaTheme(
            backgroundColor: backgroundColor,
            highlightedTabColor: highlightedTabColor,
            buttonColors: buttonColors,
            borderColor: borderColor,
            fontSize: fontSize,
            fontColor: fontColor),
        contentArea: contentAreaTheme(
            borderColor: borderColor, backgroundColor: backgroundColor),
        menu: menuTheme(
            hoverColor: menuHoverColor,
            color: backgroundColor,
            borderColor: borderColor,
            fontSize: fontSize,
            fontColor: fontColor));
  }

  static TabsAreaThemeData tabsAreaTheme(
      {required Color borderColor,
      required Color fontColor,
      required double fontSize,
      required Color backgroundColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors}) {
    return TabsAreaThemeData(
        tab: tabTheme(
            borderColor: borderColor,
            buttonColors: buttonColors,
            fontColor: fontColor,
            fontSize: fontSize,
            backgroundColor: backgroundColor,
            highlightedTabColor: highlightedTabColor),
        buttonColors: buttonColors,
        buttonsAreaDecoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1)),
        buttonsAreaPadding: EdgeInsets.fromLTRB(4, 2, 4, 2),
        buttonsGap: 4,
        middleGap: -1,
        gapBottomBorder: BorderSide(color: borderColor, width: 1));
  }

  static TabThemeData tabTheme(
      {required Color borderColor,
      required Color fontColor,
      required double fontSize,
      required Color backgroundColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors}) {
    return TabThemeData(
        textStyle: TextStyle(fontSize: fontSize, color: fontColor),
        buttonColors: buttonColors,
        buttonsOffset: 8,
        buttonsGap: 4,
        padding: EdgeInsets.fromLTRB(6, 2, 6, 3),
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1)),
        highlightedStatus: TabStatusThemeData(
            decoration: BoxDecoration(
                color: highlightedTabColor,
                border: Border.all(color: borderColor, width: 1))),
        selectedStatus: TabStatusThemeData(
          decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                  left: BorderSide(color: borderColor, width: 1),
                  top: BorderSide(color: borderColor, width: 1),
                  right: BorderSide(color: borderColor, width: 1))),
          padding: EdgeInsets.fromLTRB(6, 2, 6, 8),
        ));
  }

  static ContentAreaThemeData contentAreaTheme(
      {required Color borderColor, required Color backgroundColor}) {
    BorderSide borderSide = BorderSide(width: 1, color: borderColor);
    BoxBorder border =
        Border(bottom: borderSide, left: borderSide, right: borderSide);
    BoxDecoration decoration =
        BoxDecoration(color: backgroundColor, border: border);
    return ContentAreaThemeData(decoration: decoration);
  }

  static MenuThemeData menuTheme(
      {required Color fontColor,
      required double fontSize,
      required Color color,
      required hoverColor,
      required borderColor}) {
    return MenuThemeData(
        textStyle: TextStyle(fontSize: fontSize, color: fontColor),
        border: Border.all(width: 1, color: borderColor),
        margin: EdgeInsets.all(8),
        menuItemPadding: EdgeInsets.all(8),
        color: color,
        hoverColor: hoverColor,
        dividerColor: borderColor,
        dividerThickness: 1);
  }
}
