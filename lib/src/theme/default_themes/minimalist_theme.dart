import 'package:flutter/material.dart';
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
    return TabbedViewThemeData(
        tabsArea: tabsAreaTheme(colorSet: colorSet),
        tab: tabTheme(colorSet: colorSet),
        contentArea: contentAreaTheme(colorSet: colorSet),
        menu: menuTheme(colorSet: colorSet));
  }

  static TabsAreaThemeData tabsAreaTheme({required MaterialColor colorSet}) {
    return TabsAreaThemeData(
        buttonsAreaDecoration: BoxDecoration(color: colorSet[50]!),
        normalButtonColor: colorSet[700]!,
        hoverButtonColor: colorSet[700]!,
        disabledButtonColor: colorSet[300]!,
        buttonsAreaPadding: EdgeInsets.all(2),
        buttonPadding: const EdgeInsets.all(2),
        hoverButtonBackground: BoxDecoration(color: colorSet[300]!),
        equalHeights: EqualHeights.all,
        border: Border(bottom: BorderSide(color: colorSet[700]!, width: 1)));
  }

  static TabThemeData tabTheme({required MaterialColor colorSet}) {
    return TabThemeData(
      buttonsOffset: 4,
      textStyle: TextStyle(color: colorSet[900]!, fontSize: 13),
      padding: EdgeInsets.fromLTRB(6, 3, 3, 3),
      paddingWithoutButton: EdgeInsets.fromLTRB(6, 3, 6, 3),
      decoration: BoxDecoration(color: colorSet[50]!),
      normalButtonColor: colorSet[900]!,
      hoverButtonColor: colorSet[900]!,
      disabledButtonColor: colorSet[400]!,
      buttonPadding: const EdgeInsets.all(2),
      hoverButtonBackground: BoxDecoration(color: colorSet[300]!),
      highlightedStatus:
          TabStatusThemeData(decoration: BoxDecoration(color: colorSet[300]!)),
      selectedStatus: TabStatusThemeData(
          normalButtonColor: colorSet[50]!,
          hoverButtonColor: colorSet[50]!,
          disabledButtonColor: colorSet[500]!,
          hoverButtonBackground: BoxDecoration(color: colorSet[600]!),
          fontColor: colorSet[50]!,
          decoration: BoxDecoration(color: colorSet[700]!)),
    );
  }

  static ContentAreaThemeData contentAreaTheme(
      {required MaterialColor colorSet}) {
    BorderSide borderSide = BorderSide(width: 1, color: colorSet[900]!);
    BoxDecoration decoration = BoxDecoration(
        color: colorSet[50]!,
        border:
            Border(bottom: borderSide, left: borderSide, right: borderSide));
    BoxDecoration decorationNoTabsArea = BoxDecoration(
        color: colorSet[50]!,
        border: Border.all(width: 1, color: colorSet[900]!));
    return ContentAreaThemeData(
        decoration: decoration, decorationNoTabsArea: decorationNoTabsArea);
  }

  static TabbedViewMenuThemeData menuTheme({required MaterialColor colorSet}) {
    return TabbedViewMenuThemeData(
        border: Border.all(width: 1, color: colorSet[900]!),
        margin: EdgeInsets.all(8),
        menuItemPadding: EdgeInsets.all(8),
        textStyle: TextStyle(color: colorSet[900]!, fontSize: 13),
        color: colorSet[50]!,
        hoverColor: colorSet[200]!,
        dividerColor: colorSet[400]!,
        dividerThickness: 1);
  }
}
