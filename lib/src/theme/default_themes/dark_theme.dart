import 'package:flutter/material.dart';
import 'package:tabbed_view/src/theme/content_area_theme_data.dart';
import 'package:tabbed_view/src/theme/tabs_area_cross_axis_fit.dart';
import 'package:tabbed_view/src/theme/hidden_tabs_menu_theme_data.dart';
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
    Color highlightedColor = colorSet[700]!;
    Color normalButtonColor = colorSet[100]!;
    Color disabledButtonColor = colorSet[600]!;
    Color hoverButtonColor = colorSet[100]!;
    Color menuColor = colorSet[700]!; // This is the background for the menu
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
          highlightedColor: highlightedColor,
          normalButtonColor: normalButtonColor,
          hoverButtonColor: hoverButtonColor,
          disabledButtonColor: disabledButtonColor,
        ),
        tab: tabTheme(
          fontSize: fontSize,
          fontColor: fontColor,
          tabColor: tabColor,
          selectedTabColor: selectedTabColor,
          highlightedColor: highlightedColor,
          normalButtonColor: normalButtonColor,
          hoverButtonColor: hoverButtonColor,
          disabledButtonColor: disabledButtonColor,
        ),
        contentArea: contentAreaTheme(selectedTabColor: selectedTabColor),
        menu: menuTheme(
            fontColor: fontColor,
            fontSize: fontSize,
            color: menuColor, // Use the defined menu color
            borderColor: menuDividerColor));
  }

  static TabsAreaThemeData tabsAreaTheme(
      {required Color buttonsAreaColor,
      required Color fontColor,
      required double fontSize,
      required Color tabColor,
      required Color selectedTabColor,
      required Color highlightedColor,
      required Color normalButtonColor,
      required Color hoverButtonColor,
      required Color disabledButtonColor}) {
    return TabsAreaThemeData(
        crossAxisFit: TabsAreaCrossAxisFit.all,
        middleGap: 4,
        buttonsAreaPadding: EdgeInsets.all(2),
        buttonsAreaDecoration: BoxDecoration(color: buttonsAreaColor),
        buttonPadding: const EdgeInsets.all(2),
        hoverButtonBackground: BoxDecoration(color: highlightedColor),
        normalButtonColor: normalButtonColor,
        hoverButtonColor: hoverButtonColor,
        disabledButtonColor: disabledButtonColor,
        dropColor: Color.fromARGB(150, 255, 255, 255));
  }

  static TabThemeData tabTheme(
      {required Color fontColor,
      required double fontSize,
      required Color tabColor,
      required Color selectedTabColor,
      required Color highlightedColor,
      required Color normalButtonColor,
      required Color hoverButtonColor,
      required Color disabledButtonColor}) {
    double bottomWidth = 3;
    return TabThemeData(
        buttonsOffset: 4,
        innerBottomBorder:
            BorderSide(color: Colors.transparent, width: bottomWidth),
        textStyle: TextStyle(fontSize: fontSize, color: fontColor),
        decoration: BoxDecoration(color: tabColor),
        draggingDecoration: BoxDecoration(color: tabColor),
        padding: EdgeInsets.fromLTRB(6, 3, 3, 3),
        paddingWithoutButton: EdgeInsets.fromLTRB(6, 3, 6, 3),
        hoverButtonBackground: BoxDecoration(color: highlightedColor),
        buttonPadding: const EdgeInsets.all(2),
        selectedStatus: TabStatusThemeData(
          decoration: BoxDecoration(color: selectedTabColor),
          border: BorderSide(width: bottomWidth, color: selectedTabColor),
        ),
        highlightedStatus: TabStatusThemeData(
          decoration: BoxDecoration(color: highlightedColor),
          border: BorderSide(width: bottomWidth, color: highlightedColor),
        ),
        normalButtonColor: normalButtonColor,
        hoverButtonColor: hoverButtonColor,
        disabledButtonColor: disabledButtonColor);
  }

  static ContentAreaThemeData contentAreaTheme(
      {required Color selectedTabColor}) {
    return ContentAreaThemeData(
        color: selectedTabColor, padding: EdgeInsets.all(8));
  }

  static HiddenTabsMenuThemeData menuTheme(
      {required Color fontColor,
      required double fontSize,
      required Color color, // background color
      required Color borderColor}) {
    return HiddenTabsMenuThemeData(
        color: color,
        textStyle: TextStyle(fontSize: fontSize, color: fontColor),
        menuItemPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        boxShadow: [
          BoxShadow(
              color: borderColor.withAlpha(100),
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
        borderRadius: BorderRadius.circular(4));
  }
}
