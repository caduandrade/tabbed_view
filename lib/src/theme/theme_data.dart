import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tabbed_view/src/tabbed_view_icons.dart';
import 'package:tabbed_view/src/theme/default_themes/classic_theme.dart';
import 'package:tabbed_view/src/theme/default_themes/dark_theme.dart';
import 'package:tabbed_view/src/theme/default_themes/minimalist_theme.dart';
import 'package:tabbed_view/src/theme/default_themes/mobile_theme.dart';

enum EqualHeights { none, tabs, all }

/// Sets the alignment in the tab.
enum VerticalAlignment { top, center, bottom }

/// Sets the normal, hover and disabled color for the tab button.
class ButtonColors {
  final Color normal;
  final Color hover;
  final Color disabled;

  const ButtonColors(
      {this.normal = Colors.black54,
      this.hover = Colors.black,
      this.disabled = Colors.black12});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ButtonColors &&
          runtimeType == other.runtimeType &&
          normal == other.normal &&
          hover == other.hover &&
          disabled == other.disabled;

  @override
  int get hashCode => normal.hashCode ^ hover.hashCode ^ disabled.hashCode;
}

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

  static const double minimalIconSize = 8;
  static const double defaultIconSize = 10;
}

/// Theme for buttons area.
class ButtonsAreaThemeData {
  ButtonsAreaThemeData(
      {this.decoration,
      this.padding,
      double buttonsGap = 0,
      double offset = 0,
      double buttonIconSize = TabbedViewThemeData.defaultIconSize,
      this.buttonColors = const ButtonColors(),
      this.hiddenTabsMenuButtonIcon = TabbedViewIcons.menu})
      : this._offset = offset >= 0 ? offset : 0,
        this._buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize =
            buttonIconSize >= TabbedViewThemeData.minimalIconSize
                ? buttonIconSize
                : TabbedViewThemeData.minimalIconSize;

  /// The decoration to paint behind the buttons.
  BoxDecoration? decoration;

  /// Empty space to inscribe inside the [decoration]. The buttons, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;
  double buttonIconSize;
  ButtonColors buttonColors;

  /// Icon for the hidden tabs menu.
  IconData hiddenTabsMenuButtonIcon;

  double _buttonsGap;
  double get buttonsGap => _buttonsGap;
  set buttonsGap(double value) {
    _buttonsGap = value >= 0 ? value : 0;
  }

  double _offset;
  double get offset => _offset;
  set offset(double value) {
    _offset = value >= 0 ? value : 0;
  }
}

///Theme for tabs and buttons area.
class TabsAreaThemeData {
  TabsAreaThemeData(
      {this.closeButtonIcon = TabbedViewIcons.close,
      TabThemeData? tab,
      ButtonsAreaThemeData? buttonsArea,
      this.color,
      this.border,
      this.initialGap = 0,
      this.middleGap = 0,
      double minimalFinalGap = 0,
      this.gapBottomBorder = BorderSide.none,
      this.equalHeights = EqualHeights.none})
      : this.tab = tab != null ? tab : TabThemeData(),
        this.buttonsArea =
            buttonsArea != null ? buttonsArea : ButtonsAreaThemeData(),
        this._minimalFinalGap = minimalFinalGap >= 0 ? minimalFinalGap : 0;

  Color? color;
  Border? border;
  TabThemeData tab;
  double initialGap;
  double middleGap;
  double _minimalFinalGap;
  BorderSide gapBottomBorder;

  ButtonsAreaThemeData buttonsArea;
  IconData closeButtonIcon;
  EqualHeights equalHeights;

  double get minimalFinalGap => _minimalFinalGap;

  set minimalFinalGap(double value) {
    _minimalFinalGap = value >= 0 ? value : 0;
  }
}

/// Theme for tab.
class TabThemeData {
  TabThemeData(
      {this.buttonColors = const ButtonColors(),
      double buttonIconSize = TabbedViewThemeData.defaultIconSize,
      this.verticalAlignment = VerticalAlignment.center,
      double buttonsOffset = 0,
      double buttonsGap = 0,
      this.decoration,
      this.innerBottomBorder,
      this.innerTopBorder,
      this.textStyle = const TextStyle(fontSize: 13),
      this.padding,
      this.margin,
      TabStatusThemeData? selectedStatus,
      TabStatusThemeData? highlightedStatus,
      TabStatusThemeData? normalStatus,
      TabStatusThemeData? disabledStatus})
      : this._buttonsOffset = buttonsOffset >= 0 ? buttonsOffset : 0,
        this._buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize =
            buttonIconSize >= TabbedViewThemeData.minimalIconSize
                ? buttonIconSize
                : TabbedViewThemeData.minimalIconSize,
        this.selectedStatus =
            selectedStatus != null ? selectedStatus : TabStatusThemeData(),
        this.highlightedStatus = highlightedStatus != null
            ? highlightedStatus
            : TabStatusThemeData();

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;

  /// Empty space to surround the [decoration] and tab.
  EdgeInsetsGeometry? margin;

  VerticalAlignment verticalAlignment;

  /// The decoration to paint behind the tab.
  BoxDecoration? decoration;

  BorderSide? innerBottomBorder;
  BorderSide? innerTopBorder;

  TextStyle? textStyle;

  double buttonIconSize;
  ButtonColors buttonColors;
  double _buttonsOffset;

  TabStatusThemeData selectedStatus;
  TabStatusThemeData highlightedStatus;

  double get buttonsOffset => _buttonsOffset;

  set buttonsOffset(double value) {
    _buttonsOffset = value >= 0 ? value : 0;
  }

  double _buttonsGap;
  double get buttonsGap => _buttonsGap;
  set buttonsGap(double value) {
    _buttonsGap = value >= 0 ? value : 0;
  }
}

/// Theme for tab in a given status.
/// Allows you to overwrite [TabThemeData] properties.
class TabStatusThemeData {
  TabStatusThemeData(
      {this.decoration,
      this.innerTopBorder,
      this.innerBottomBorder,
      this.fontColor,
      this.padding,
      this.margin,
      this.buttonColors});

  static final TabStatusThemeData empty = TabStatusThemeData();

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;

  /// Empty space to surround the [decoration] and tab.
  EdgeInsetsGeometry? margin;

  /// The decoration to paint behind the tab.
  BoxDecoration? decoration;
  BorderSide? innerBottomBorder;
  BorderSide? innerTopBorder;
  Color? fontColor;
  ButtonColors? buttonColors;
}

// Theme for tab content container.
class ContentAreaThemeData {
  ContentAreaThemeData({this.decoration, this.padding});

  /// The decoration to paint behind the content.
  BoxDecoration? decoration;

  /// Empty space to inscribe inside the [decoration]. The content child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;
}

/// Theme for menu.
class MenuThemeData {
  MenuThemeData(
      {this.padding,
      this.margin,
      this.menuItemPadding,
      this.textStyle = const TextStyle(fontSize: 13),
      this.border,
      this.color,
      this.blur = true,
      this.ellipsisOverflowText = false,
      double dividerThickness = 0,
      double maxWidth = 200,
      this.dividerColor,
      this.hoverColor})
      : this._dividerThickness = dividerThickness >= 0 ? dividerThickness : 0,
        this._maxWidth = maxWidth >= 0 ? maxWidth : 0;

  EdgeInsetsGeometry? margin;

  /// Empty space to inscribe inside the [decoration]. The menu area, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;

  /// Empty space to inscribe inside the [decoration]. The menu item, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? menuItemPadding;

  TextStyle? textStyle;

  Border? border;

  Color? color;

  Color? hoverColor;

  /// Indicates whether to apply a blur effect on the content.
  bool blur;

  double _dividerThickness;

  Color? dividerColor;

  double _maxWidth;

  /// Use an ellipsis to indicate that the text has overflowed.
  bool ellipsisOverflowText;

  double get dividerThickness => _dividerThickness;

  set dividerThickness(double value) {
    _dividerThickness = value >= 0 ? value : 0;
  }

  double get maxWidth => _maxWidth;

  set maxWidth(double value) {
    _maxWidth = value >= 0 ? value : 0;
  }
}
