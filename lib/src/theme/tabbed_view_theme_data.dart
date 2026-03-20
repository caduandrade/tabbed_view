import 'package:flutter/material.dart';
import 'package:tabbed_view/src/theme/tab_style_resolver.dart';

import 'content_area_theme_data.dart';
import 'default_themes/classic_theme.dart';
import 'default_themes/folder_theme.dart';
import 'default_themes/minimalist_theme.dart';
import 'default_themes/underline_theme.dart';
import 'tab_status_theme_data.dart';
import 'tab_theme_data.dart';
import 'tabbed_view_menu_theme_data.dart';
import 'tabs_area_theme_data.dart';

/// The [TabbedView] theme.
/// Defines the configuration of the overall visual [Theme] for a widget subtree within the app.
class TabbedViewThemeData {
  TabbedViewThemeData(
      {TabsAreaThemeData? tabsArea,
      TabThemeData? tab,
      ContentAreaThemeData? contentArea,
      TabbedViewMenuThemeData? menu})
      : tab = tab ??
            TabThemeData(
                selectedStatus: TabStatusThemeData(),
                hoveredStatus: TabStatusThemeData()),
        tabsArea = tabsArea ?? TabsAreaThemeData(),
        contentArea = contentArea ?? ContentAreaThemeData(),
        menu = menu ?? TabbedViewMenuThemeData();

  TabsAreaThemeData tabsArea;
  TabThemeData tab;
  ContentAreaThemeData contentArea;
  TabbedViewMenuThemeData menu;

  /// The border that separates the content area from the tab bar.
  ///
  /// If [isDividerWithinTabArea] is set to `true`, this border is drawn **inside**
  /// the tab area, touching the sides of the tabs but not extending underneath them.
  ///
  /// If `false`, the border is drawn **outside** the tab area and acts like a
  /// standard border, extending fully across the width of the pane.
  BorderSide? divider;

  /// Whether the [divider] should remain visible even when there are no tabs.
  ///
  /// If set to `true`, the divider is always displayed regardless of the
  /// presence of tabs. If `false`, the divider is only shown when at least
  /// one tab is present.
  bool alwaysShowDivider = true;

  /// If `true`, the [divider] will be drawn within the bounds of the tab area.
  /// If `false`, the divider will act as a standard border, drawn outside the tab area.
  bool isDividerWithinTabArea = false;

  /// Builds the predefined classic theme.
  factory TabbedViewThemeData.classic({
    Brightness? brightness,
    MaterialColor? colorSet,
    double? fontSize,
    Color? borderColor,
    double? tabRadius,
    TabStyleResolver? tabStyleResolver,
  }) {
    return ClassicTheme(
      brightness: brightness ?? Brightness.light,
      colorSet: colorSet ?? Colors.grey,
      fontSize: fontSize ?? 13,
      borderColor: borderColor,
      tabRadius: tabRadius,
      tabStyleResolver: tabStyleResolver,
    );
  }

  /// Builds the predefined underline theme.
  factory TabbedViewThemeData.underline({
    Brightness? brightness,
    MaterialColor? colorSet,
    MaterialColor? underlineColorSet,
    double? fontSize,
    UnderlineTabStyleResolver? tabStyleResolver,
  }) {
    return UnderlineTheme(
      brightness: brightness ?? Brightness.light,
      colorSet: colorSet ?? Colors.grey,
      underlineColorSet: underlineColorSet ?? Colors.blue,
      fontSize: fontSize ?? 13,
      tabStyleResolver: tabStyleResolver,
    );
  }

  /// Builds the predefined minimalist theme.
  factory TabbedViewThemeData.minimalist({
    Brightness? brightness,
    MaterialColor? colorSet,
    double? fontSize,
    double? initialGap,
    double? gap,
    double? tabRadius,
    MinimalistTabStyleResolver? tabStyleResolver,
  }) {
    return MinimalistTheme(
      brightness: brightness ?? Brightness.light,
      colorSet: colorSet ?? Colors.grey,
      fontSize: fontSize ?? 13,
      initialGap: initialGap ?? 16,
      gap: gap ?? 4,
      tabRadius: tabRadius ?? 10,
      tabStyleResolver: tabStyleResolver,
    );
  }

  /// Builds the predefined folder theme.
  factory TabbedViewThemeData.folder({
    Brightness? brightness,
    MaterialColor? colorSet,
    double? fontSize,
    double? initialGap,
    FolderTabStyleResolver? tabStyleResolver,
  }) {
    return FolderTheme(
      brightness: brightness ?? Brightness.light,
      colorSet: colorSet ?? Colors.grey,
      fontSize: fontSize ?? 13,
      initialGap: initialGap ?? 16,
      tabStyleResolver: tabStyleResolver,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabbedViewThemeData &&
          runtimeType == other.runtimeType &&
          tabsArea == other.tabsArea &&
          tab == other.tab &&
          contentArea == other.contentArea &&
          menu == other.menu &&
          divider == other.divider &&
          alwaysShowDivider == other.alwaysShowDivider &&
          isDividerWithinTabArea == other.isDividerWithinTabArea;

  @override
  int get hashCode => Object.hash(tabsArea, tab, contentArea, menu, divider,
      alwaysShowDivider, isDividerWithinTabArea);
}
