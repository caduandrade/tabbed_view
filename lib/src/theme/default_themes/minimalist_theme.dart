import 'package:flutter/material.dart';
import 'package:tabbed_view/src/theme/content_area_theme_data.dart';
import 'package:tabbed_view/src/theme/equal_heights.dart';
import 'package:tabbed_view/src/theme/hidden_tabs_menu_theme_data.dart';
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
        equalHeights: EqualHeights.all);
  }

  static TabThemeData tabTheme({required MaterialColor colorSet}) {
    return TabThemeData(
        buttonsOffset: 4,
        textStyle: TextStyle(color: colorSet[900]!, fontSize: 13),
        padding: EdgeInsets.fromLTRB(6, 3, 3, 3),
        paddingWithoutButton: EdgeInsets.fromLTRB(6, 3, 6, 3),
        decoration: BoxDecoration(color: colorSet[50]!),
        draggingDecoration: BoxDecoration(color: colorSet[50]!),
        normalButtonColor: colorSet[900]!,
        hoverButtonColor: colorSet[900]!,
        disabledButtonColor: colorSet[400]!,
        buttonPadding: const EdgeInsets.all(2),
        hoverButtonBackground: BoxDecoration(color: colorSet[300]!),
        highlightedStatus: TabStatusThemeData(
            border: BorderSide(color: colorSet[300]!, width: 1)),
        selectedStatus: TabStatusThemeData(
            border: BorderSide(color: colorSet[700]!, width: 1)));
  }

  static ContentAreaThemeData contentAreaTheme(
      {required MaterialColor colorSet}) {
    BorderSide borderSide = BorderSide(width: 1, color: colorSet[900]!);
    BoxDecoration decoration = BoxDecoration(color: colorSet[50]!);
    BoxDecoration decorationNoTabsArea = BoxDecoration(
        color: colorSet[50]!,
        border: Border.all(width: 1, color: colorSet[900]!));
    return ContentAreaThemeData(
        decoration: decoration,
        decorationNoTabsArea: decorationNoTabsArea,
        border: borderSide);
  }

  static HiddenTabsMenuThemeData menuTheme({required MaterialColor colorSet}) {
    return HiddenTabsMenuThemeData(
        textStyle: TextStyle(color: colorSet[900]!, fontSize: 13),
        color: colorSet[50]!,
        menuItemPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        boxShadow: [
          BoxShadow(
              color: colorSet[900]!.withAlpha(100),
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
        borderRadius: BorderRadius.circular(4));
  }
}
