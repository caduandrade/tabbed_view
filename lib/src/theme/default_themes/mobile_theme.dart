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

/// Predefined mobile theme builder.
class MobileTheme {
  static TabbedViewThemeData build(
      {required MaterialColor colorSet,
      required Color highlightedTabColor,
      required double fontSize}) {
    Color borderColor = colorSet[500]!;
    Color foregroundColor = colorSet[900]!;
    Color backgroundColor = colorSet[50]!;
    Color menuColor = colorSet[100]!;
    Color menuHoverColor = colorSet[300]!;
    ButtonColors buttonColors = ButtonColors(
        normal: colorSet[700]!,
        disabled: colorSet[300]!,
        hover: colorSet[900]!);
    return TabbedViewThemeData(
        tabsArea: tabsAreaTheme(
            buttonColors: buttonColors,
            foregroundColor: foregroundColor,
            borderColor: borderColor,
            highlightedTabColor: highlightedTabColor,
            fontSize: fontSize,
            backgroundColor: backgroundColor),
        tab: tabTheme(
            buttonColors: buttonColors,
            borderColor: borderColor,
            highlightedColor: highlightedTabColor,
            fontSize: fontSize,
            foregroundColor: foregroundColor),
        contentArea: contentAreaTheme(
            backgroundColor: backgroundColor, borderColor: borderColor),
        menu: menuTheme(
            hoverColor: menuHoverColor,
            foregroundColor: foregroundColor,
            borderColor: borderColor,
            fontSize: fontSize,
            backgroundColor: menuColor));
  }

  static TabsAreaThemeData tabsAreaTheme(
      {required ButtonColors buttonColors,
      required double fontSize,
      required Color borderColor,
      required Color highlightedTabColor,
      required Color foregroundColor,
      required Color backgroundColor}) {
    return TabsAreaThemeData(
        equalHeights: EqualHeights.all,
        initialGap: -1,
        middleGap: -1,
        buttonColors: buttonColors,
        buttonsGap: 4,
        buttonsAreaPadding: EdgeInsets.all(4),
        border: Border.all(color: borderColor, width: 1),
        color: backgroundColor);
  }

  static TabThemeData tabTheme(
      {required ButtonColors buttonColors,
      required double fontSize,
      required Color borderColor,
      required Color highlightedColor,
      required Color foregroundColor}) {
    BorderSide verticalBorderSide = BorderSide(color: borderColor, width: 1);
    Border border = Border(left: verticalBorderSide, right: verticalBorderSide);
    double borderHeight = 4;
    return TabThemeData(
        buttonColors: buttonColors,
        textStyle: TextStyle(fontSize: fontSize, color: foregroundColor),
        buttonsOffset: 8,
        buttonsGap: 4,
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        decoration: BoxDecoration(border: border),
        innerBottomBorder:
            BorderSide(color: Colors.transparent, width: borderHeight),
        highlightedStatus: TabStatusThemeData(
            decoration: BoxDecoration(border: border),
            innerBottomBorder:
                BorderSide(color: borderColor, width: borderHeight)),
        selectedStatus: TabStatusThemeData(
            decoration: BoxDecoration(border: border),
            innerBottomBorder:
                BorderSide(color: highlightedColor, width: borderHeight)));
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
      {required Color backgroundColor,
      required double fontSize,
      required Color borderColor,
      required Color foregroundColor,
      required Color hoverColor}) {
    return MenuThemeData(
        textStyle: TextStyle(fontSize: fontSize, color: foregroundColor),
        border: Border.all(width: 1, color: borderColor),
        margin: EdgeInsets.all(8),
        menuItemPadding: EdgeInsets.all(8),
        color: backgroundColor,
        hoverColor: hoverColor,
        dividerColor: borderColor,
        dividerThickness: 1);
  }
}
