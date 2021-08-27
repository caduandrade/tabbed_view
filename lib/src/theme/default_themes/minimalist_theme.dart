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

/// Predefined minimalist theme builder.
class MinimalistTheme {
  static TabbedViewThemeData build({required MaterialColor colorSet}) {
    Color borderColor = colorSet[700]!;
    Color background = colorSet[50]!;
    Color selectedTabColor = borderColor;
    Color highlightedTabColor = colorSet[300]!;
    Color menuColor = colorSet[50]!;
    Color menuHoverColor = colorSet[200]!;
    Color menuDividerColor = colorSet[400]!;
    ButtonColors buttonColors = ButtonColors(normal: colorSet[300]!);
    ButtonColors selectedButtonColors = ButtonColors(
        normal: colorSet[400]!, hover: colorSet[50]!, disabled: colorSet[600]!);
    Color fontColor = colorSet[900]!;
    Color selectedFontColor = colorSet[50]!;
    Color hiddenTabsMenuButtonColor = borderColor;
    return TabbedViewThemeData(
        tabsArea: tabsAreaTheme(
            borderColor: borderColor,
            background: background,
            selectedTabColor: selectedTabColor,
            highlightedTabColor: highlightedTabColor,
            buttonColors: buttonColors,
            selectedButtonColors: selectedButtonColors,
            fontColor: fontColor,
            selectedFontColor: selectedFontColor,
            hiddenTabsMenuButtonColor: hiddenTabsMenuButtonColor),
        contentArea:
            contentAreaTheme(borderColor: borderColor, background: background),
        menu: menuTheme(
            borderColor: borderColor,
            menuColor: menuColor,
            hoverMenuColor: menuHoverColor,
            dividerMenuColor: menuDividerColor,
            menuFontColor: fontColor));
  }

  static TabsAreaThemeData tabsAreaTheme(
      {required Color borderColor,
      required Color background,
      required Color selectedTabColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors,
      required ButtonColors selectedButtonColors,
      required Color fontColor,
      required Color selectedFontColor,
      required Color hiddenTabsMenuButtonColor}) {
    return TabsAreaThemeData(
        buttonsAreaDecoration: BoxDecoration(color: background),
        buttonColors: ButtonColors(normal: hiddenTabsMenuButtonColor),
        buttonsAreaPadding: EdgeInsets.fromLTRB(4, 2, 4, 2),
        buttonsGap: 4,
        tab: tabTheme(
            borderColor: borderColor,
            background: background,
            selectedTabColor: selectedTabColor,
            highlightedTabColor: highlightedTabColor,
            buttonColors: buttonColors,
            selectedButtonColors: selectedButtonColors,
            fontColor: fontColor,
            selectedFontColor: selectedFontColor),
        equalHeights: EqualHeights.all,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)));
  }

  static TabThemeData tabTheme(
      {required Color borderColor,
      required Color background,
      required Color selectedTabColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors,
      required ButtonColors selectedButtonColors,
      required Color fontColor,
      required Color selectedFontColor}) {
    return TabThemeData(
      buttonsOffset: 8,
      buttonsGap: 4,
      textStyle: TextStyle(color: fontColor, fontSize: 13),
      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
      decoration: BoxDecoration(color: background),
      buttonColors: buttonColors,
      highlightedStatus: TabStatusThemeData(
          decoration: BoxDecoration(color: highlightedTabColor)),
      selectedStatus: TabStatusThemeData(
          buttonColors: selectedButtonColors,
          fontColor: selectedFontColor,
          decoration: BoxDecoration(color: selectedTabColor)),
    );
  }

  static ContentAreaThemeData contentAreaTheme(
      {required Color borderColor, required Color background}) {
    BorderSide borderSide = BorderSide(width: 1, color: borderColor);
    BoxBorder border =
        Border(bottom: borderSide, left: borderSide, right: borderSide);
    BoxDecoration decoration = BoxDecoration(color: background, border: border);
    return ContentAreaThemeData(decoration: decoration);
  }

  static MenuThemeData menuTheme(
      {required Color borderColor,
      required Color menuColor,
      required Color hoverMenuColor,
      required Color dividerMenuColor,
      required Color menuFontColor}) {
    return MenuThemeData(
        border: Border.all(width: 1, color: borderColor),
        margin: EdgeInsets.all(8),
        menuItemPadding: EdgeInsets.all(8),
        textStyle: TextStyle(color: menuFontColor, fontSize: 13),
        color: menuColor,
        hoverColor: hoverMenuColor,
        dividerColor: dividerMenuColor,
        dividerThickness: 1);
  }
}
