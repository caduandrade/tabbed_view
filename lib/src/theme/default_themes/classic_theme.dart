import 'package:flutter/material.dart';
import 'package:tabbed_view/src/theme/content_area_theme_data.dart';
import 'package:tabbed_view/src/theme/equal_heights.dart';
import 'package:tabbed_view/src/theme/hidden_tabs_menu_theme_data.dart';
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
    Color highlightedColor = colorSet[300]!;
    Color fontColor = colorSet[900]!;
    Color normalButtonColor = colorSet[900]!;
    Color disabledButtonColor = colorSet[400]!;
    Color hoverButtonColor = colorSet[900]!;

    return TabbedViewThemeData(
        tabsArea: tabsAreaTheme(
            backgroundColor: backgroundColor,
            highlightedColor: highlightedColor,
            normalButtonColor: normalButtonColor,
            hoverButtonColor: hoverButtonColor,
            disabledButtonColor: disabledButtonColor,
            borderColor: borderColor,
            fontSize: fontSize,
            fontColor: fontColor),
        tab: tabTheme(
            borderColor: borderColor,
            normalButtonColor: normalButtonColor,
            hoverButtonColor: hoverButtonColor,
            disabledButtonColor: disabledButtonColor,
            fontColor: fontColor,
            fontSize: fontSize,
            backgroundColor: backgroundColor,
            highlightedColor: highlightedColor),
        contentArea: contentAreaTheme(
            borderColor: borderColor, backgroundColor: backgroundColor),
        menu: menuTheme(
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
      required Color highlightedColor,
      required Color normalButtonColor,
      required Color hoverButtonColor,
      required Color disabledButtonColor}) {
    return TabsAreaThemeData(
        normalButtonColor: normalButtonColor,
        hoverButtonColor: hoverButtonColor,
        disabledButtonColor: disabledButtonColor,
        buttonPadding: const EdgeInsets.all(2),
        hoverButtonBackground: BoxDecoration(color: highlightedColor),
        buttonsAreaDecoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1)),
        buttonsAreaPadding: EdgeInsets.all(2),
        middleGap: -1,
        equalHeights: EqualHeights.all,
        gapBottomBorder: BorderSide(color: borderColor, width: 1),
        gapSideBorder: BorderSide(color: borderColor, width: 1));
  }

  static TabThemeData tabTheme(
      {required Color borderColor,
      required Color fontColor,
      required double fontSize,
      required Color backgroundColor,
      required Color highlightedColor,
      required Color normalButtonColor,
      required Color hoverButtonColor,
      required Color disabledButtonColor}) {
    return TabThemeData(
        innerLeftBorder: const BorderSide(color: Colors.transparent, width: 2),
        innerRightBorder: const BorderSide(color: Colors.transparent, width: 2),
        innerBottomBorder:
            const BorderSide(color: Colors.transparent, width: 2),
        textStyle: TextStyle(fontSize: fontSize, color: fontColor),
        normalButtonColor: normalButtonColor,
        hoverButtonColor: hoverButtonColor,
        disabledButtonColor: disabledButtonColor,
        hoverButtonBackground: BoxDecoration(color: highlightedColor),
        buttonsOffset: 4,
        buttonPadding: const EdgeInsets.all(2),
        padding: EdgeInsets.fromLTRB(6, 3, 3, 3),
        paddingWithoutButton: EdgeInsets.fromLTRB(6, 3, 6, 3),
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1)),
        draggingDecoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1)),
        highlightedStatus: TabStatusThemeData(
            decoration: BoxDecoration(
                color: highlightedColor,
                border: Border.all(color: borderColor, width: 1))),
        // The border is now defined by a single BorderSide, allowing the
        // TabWidget to build the correct border for any TabBarPosition.
        selectedStatus: TabStatusThemeData(
          decoration: BoxDecoration(color: backgroundColor),
          border: BorderSide(color: borderColor, width: 1),
          padding: EdgeInsets.fromLTRB(6, 3, 3, 8),
        ));
  }

  static ContentAreaThemeData contentAreaTheme(
      {required Color borderColor, required Color backgroundColor}) {
    // The border is now defined by a single BorderSide, allowing the
    // ContentArea to build the correct border for any TabBarPosition.
    BorderSide borderSide = BorderSide(width: 1, color: borderColor);
    BoxDecoration decoration = BoxDecoration(color: backgroundColor);
    BoxDecoration decorationNoTabsArea = BoxDecoration(
        color: backgroundColor,
        border: Border.all(width: 1, color: borderColor));
    return ContentAreaThemeData(
        decoration: decoration,
        decorationNoTabsArea: decorationNoTabsArea,
        border: borderSide);
  }

  static HiddenTabsMenuThemeData menuTheme({
    required Color fontColor,
    required double fontSize,
    required Color color, // background color
    required Color borderColor,
    /* Color? hoverColor - not used */
  }) {
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
