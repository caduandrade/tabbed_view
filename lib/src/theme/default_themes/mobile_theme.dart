import 'package:flutter/material.dart';
import 'package:tabbed_view/src/theme/content_area_theme_data.dart';
import 'package:tabbed_view/src/theme/equal_heights.dart';
import 'package:tabbed_view/src/theme/menu_theme_data.dart';
import 'package:tabbed_view/src/theme/tab_status_theme_data.dart';
import 'package:tabbed_view/src/theme/tab_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/tabs_area_theme_data.dart';

/// Predefined mobile theme builder.
class MobileTheme {
  static TabbedViewThemeData build({required MaterialColor colorSet, required Color accentColor, required double fontSize}) {
    Color borderColor = colorSet[500]!;
    Color foregroundColor = colorSet[900]!;
    Color backgroundColor = colorSet[50]!;
    Color menuColor = colorSet[100]!;
    Color menuHoverColor = colorSet[300]!;
    Color normalButtonColor = colorSet[700]!;
    Color disabledButtonColor = colorSet[300]!;
    Color hoverButtonColor = colorSet[900]!;
    Color highlightedColor = colorSet[300]!;
    return TabbedViewThemeData(
        tabsArea: tabsAreaTheme(
            normalButtonColor: normalButtonColor,
            hoverButtonColor: hoverButtonColor,
            disabledButtonColor: disabledButtonColor,
            highlightedColor: highlightedColor,
            foregroundColor: foregroundColor,
            borderColor: borderColor,
            fontSize: fontSize,
            backgroundColor: backgroundColor),
        tab: tabTheme(
            normalButtonColor: normalButtonColor,
            hoverButtonColor: hoverButtonColor,
            disabledButtonColor: disabledButtonColor,
            highlightedColor: highlightedColor,
            borderColor: borderColor,
            accentColor: accentColor,
            fontSize: fontSize,
            foregroundColor: foregroundColor),
        contentArea: contentAreaTheme(backgroundColor: backgroundColor, borderColor: borderColor),
        menu: menuTheme(hoverColor: menuHoverColor, foregroundColor: foregroundColor, borderColor: borderColor, fontSize: fontSize, backgroundColor: menuColor));
  }

  static TabsAreaThemeData tabsAreaTheme(
      {required Color normalButtonColor,
      required Color hoverButtonColor,
      required Color disabledButtonColor,
      required Color highlightedColor,
      required double fontSize,
      required Color borderColor,
      required Color foregroundColor,
      required Color backgroundColor}) {
    return TabsAreaThemeData(
        equalHeights: EqualHeights.all,
        initialGap: -1,
        middleGap: -1,
        normalButtonColor: normalButtonColor,
        hoverButtonColor: hoverButtonColor,
        disabledButtonColor: disabledButtonColor,
        buttonsAreaPadding: EdgeInsets.all(2),
        hoverButtonBackground: BoxDecoration(color: highlightedColor),
        buttonPadding: const EdgeInsets.all(2),
        border: Border.all(color: borderColor, width: 1),
        color: backgroundColor);
  }

  static TabThemeData tabTheme(
      {required Color normalButtonColor,
      required Color hoverButtonColor,
      required Color disabledButtonColor,
      required Color highlightedColor,
      required double fontSize,
      required Color borderColor,
      required Color accentColor,
      required Color foregroundColor}) {
    BorderSide verticalBorderSide = BorderSide(color: borderColor, width: 1);
    Border border = Border(left: verticalBorderSide, right: verticalBorderSide);
    double borderHeight = 4;
    return TabThemeData(
        normalButtonColor: normalButtonColor,
        hoverButtonColor: hoverButtonColor,
        disabledButtonColor: disabledButtonColor,
        textStyle: TextStyle(fontSize: fontSize, color: foregroundColor),
        buttonsOffset: 4,
        padding: EdgeInsets.fromLTRB(6, 3, 3, 3),
        paddingWithoutButton: EdgeInsets.fromLTRB(6, 3, 6, 3),
        hoverButtonBackground: BoxDecoration(color: highlightedColor),
        buttonPadding: const EdgeInsets.all(2),
        decoration: BoxDecoration(border: border),
        draggingDecoration: BoxDecoration(border: Border.all(color: borderColor, width: 1)),
        innerBottomBorder: BorderSide(color: Colors.transparent, width: borderHeight),
        highlightedStatus: TabStatusThemeData(innerBottomBorder: BorderSide(color: borderColor, width: borderHeight)),
        selectedStatus: TabStatusThemeData(innerBottomBorder: BorderSide(color: accentColor, width: borderHeight)));
  }

  static ContentAreaThemeData contentAreaTheme({required Color borderColor, required Color backgroundColor}) {
    BorderSide borderSide = BorderSide(width: 1, color: borderColor);
    BoxDecoration decoration = BoxDecoration(color: backgroundColor, border: Border(bottom: borderSide, left: borderSide, right: borderSide));
    BoxDecoration decorationNoTabsArea = BoxDecoration(color: backgroundColor, border: Border.all(width: 1, color: borderColor));
    return ContentAreaThemeData(decoration: decoration, decorationNoTabsArea: decorationNoTabsArea);
  }

  static TabbedViewMenuThemeData menuTheme({required Color backgroundColor, required double fontSize, required Color borderColor, required Color foregroundColor, required Color hoverColor}) {
    return TabbedViewMenuThemeData(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: borderColor),
          color: backgroundColor,
        ),
        textStyle: TextStyle(fontSize: fontSize, color: foregroundColor),
        margin: EdgeInsets.all(8),
        menuItemPadding: EdgeInsets.all(8),
        hoverColor: hoverColor,
        dividerColor: borderColor,
        dividerThickness: 1);
  }
}
