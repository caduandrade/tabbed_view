import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tabbed_view/src/theme/content_area_theme_data.dart';
import 'package:tabbed_view/src/theme/default_themes/classic_theme.dart';
import 'package:tabbed_view/src/theme/default_themes/dark_theme.dart';
import 'package:tabbed_view/src/theme/default_themes/minimalist_theme.dart';
import 'package:tabbed_view/src/theme/default_themes/mobile_theme.dart';
import 'package:tabbed_view/src/theme/menu_theme_data.dart';
import 'package:tabbed_view/src/theme/tabs_area_theme_data.dart';

/// The [TabbedView] theme.
/// Defines the configuration of the overall visual [Theme] for a widget subtree within the app.
class TabbedViewThemeData {
  TabbedViewThemeData(
      {TabsAreaThemeData? tabsArea,
      ContentAreaThemeData? contentArea,
      MenuThemeData? menu})
      : this.tabsArea = tabsArea != null ? tabsArea : TabsAreaThemeData(),
        this.contentArea =
            contentArea != null ? contentArea : ContentAreaThemeData(),
        this.menu = menu != null ? menu : MenuThemeData();

  TabsAreaThemeData tabsArea;
  ContentAreaThemeData contentArea;
  MenuThemeData menu;

  /// Sets the theme to Material Design patterns: Close and menu icons;
  /// Icons size; Remove the paddings, the Material Design already
  /// defines them in the icons.
  void materialDesign() {
    this.tabsArea.buttonsAreaPadding = null;
    this.tabsArea.buttonIconSize = 15;
    this.tabsArea.buttonsGap = 0;
    this.tabsArea.closeIconData = Icons.close;
    this.tabsArea.closeIconPath = null;
    this.tabsArea.menuIconData = Icons.arrow_drop_down;
    this.tabsArea.menuIconPath = null;

    this.tabsArea.tab.buttonsGap = 0;
    this.tabsArea.tab.buttonIconSize = 15;
  }

  /// Builds the predefined dark theme.
  factory TabbedViewThemeData.dark(
      {MaterialColor colorSet = Colors.grey, double fontSize = 13}) {
    return DarkTheme.build(colorSet: colorSet, fontSize: 13);
  }

  /// Builds the predefined classic theme.
  factory TabbedViewThemeData.classic(
      {MaterialColor colorSet = Colors.grey,
      double fontSize = 13,
      Color borderColor = Colors.black}) {
    return ClassicTheme.build(
        colorSet: colorSet, fontSize: fontSize, borderColor: borderColor);
  }

  /// Builds the predefined mobile theme.
  factory TabbedViewThemeData.mobile(
      {MaterialColor colorSet = Colors.grey,
      Color highlightedTabColor = Colors.blue,
      double fontSize = 13}) {
    return MobileTheme.build(
        colorSet: colorSet,
        highlightedTabColor: highlightedTabColor,
        fontSize: fontSize);
  }

  /// Builds the predefined minimalist theme.
  factory TabbedViewThemeData.minimalist(
      {MaterialColor colorSet = Colors.grey}) {
    return MinimalistTheme.build(colorSet: colorSet);
  }
}
