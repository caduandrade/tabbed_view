import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

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
    return _Dark.build(colorSet: colorSet, fontSize: 13);
  }

  /// Builds the predefined classic theme.
  factory TabbedViewThemeData.classic(
      {MaterialColor colorSet = Colors.grey,
      double fontSize = 13,
      Color borderColor = Colors.black}) {
    return _Classic.build(
        colorSet: colorSet, fontSize: fontSize, borderColor: borderColor);
  }

  /// Builds the predefined mobile theme.
  factory TabbedViewThemeData.mobile(
      {MaterialColor colorSet = Colors.grey,
      Color highlightedTabColor = Colors.blue,
      double fontSize = 13}) {
    return _Mobile.build(
        colorSet: colorSet,
        highlightedTabColor: highlightedTabColor,
        fontSize: fontSize);
  }

  /// Builds the predefined minimalist theme.
  factory TabbedViewThemeData.minimalist(
      {MaterialColor colorSet = Colors.grey}) {
    return _Minimalist.build(colorSet: colorSet);
  }

  static const double minimalIconSize = 8;
  static const double defaultIconSize = 16;
}

/// Theme for buttons area.
class ButtonsAreaThemeData {
  ButtonsAreaThemeData(
      {this.decoration,
      this.padding,
      double offset = 0,
      double buttonIconSize = TabbedViewThemeData.defaultIconSize,
      this.buttonColors = const ButtonColors(),
      this.hiddenTabsMenuButtonIcon = Icons.arrow_drop_down})
      : this._offset = offset >= 0 ? offset : 0,
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
  double _offset;
  double buttonIconSize;
  ButtonColors buttonColors;

  /// Icon for the hidden tabs menu.
  IconData hiddenTabsMenuButtonIcon;

  double get offset => _offset;

  set offset(double value) {
    _offset = value >= 0 ? value : 0;
  }
}

///Theme for tabs and buttons area.
class TabsAreaThemeData {
  TabsAreaThemeData(
      {this.closeButtonIcon = Icons.clear,
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
  double _buttonsGap;

  TabStatusThemeData selectedStatus;
  TabStatusThemeData highlightedStatus;

  double get buttonsOffset => _buttonsOffset;

  set buttonsOffset(double value) {
    _buttonsOffset = value >= 0 ? value : 0;
  }

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

/// Predefined classic theme builder.
class _Classic {
  static TabbedViewThemeData build(
      {required MaterialColor colorSet,
      required double fontSize,
      required Color borderColor}) {
    Color backgroundColor = colorSet[50]!;
    Color highlightedTabColor = colorSet[300]!;
    Color fontColor = colorSet[900]!;
    Color menuHoverColor = colorSet[200]!;
    ButtonColors buttonColors = ButtonColors(
        normal: colorSet[600]!,
        disabled: colorSet[400]!,
        hover: colorSet[900]!);

    return TabbedViewThemeData(
        tabsArea: _tabsAreaTheme(
            backgroundColor: backgroundColor,
            highlightedTabColor: highlightedTabColor,
            buttonColors: buttonColors,
            borderColor: borderColor,
            fontSize: fontSize,
            fontColor: fontColor),
        contentArea: _contentAreaTheme(
            borderColor: borderColor, backgroundColor: backgroundColor),
        menu: _menuTheme(
            hoverColor: menuHoverColor,
            color: backgroundColor,
            borderColor: borderColor,
            fontSize: fontSize,
            fontColor: fontColor));
  }

  static TabsAreaThemeData _tabsAreaTheme(
      {required Color borderColor,
      required Color fontColor,
      required double fontSize,
      required Color backgroundColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors}) {
    return TabsAreaThemeData(
        tab: _tabTheme(
            borderColor: borderColor,
            buttonColors: buttonColors,
            fontColor: fontColor,
            fontSize: fontSize,
            backgroundColor: backgroundColor,
            highlightedTabColor: highlightedTabColor),
        buttonsArea: ButtonsAreaThemeData(
            buttonColors: buttonColors,
            decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor, width: 1)),
            padding: EdgeInsets.only(bottom: 2)),
        middleGap: -1,
        gapBottomBorder: BorderSide(color: borderColor, width: 1));
  }

  static TabThemeData _tabTheme(
      {required Color borderColor,
      required Color fontColor,
      required double fontSize,
      required Color backgroundColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors}) {
    return TabThemeData(
        textStyle: TextStyle(fontSize: fontSize, color: fontColor),
        buttonColors: buttonColors,
        buttonsOffset: 4,
        padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1)),
        highlightedStatus: TabStatusThemeData(
            decoration: BoxDecoration(
                color: highlightedTabColor,
                border: Border.all(color: borderColor, width: 1))),
        selectedStatus: TabStatusThemeData(
          decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                  left: BorderSide(color: borderColor, width: 1),
                  top: BorderSide(color: borderColor, width: 1),
                  right: BorderSide(color: borderColor, width: 1))),
          padding: EdgeInsets.fromLTRB(6, 2, 6, 8),
        ));
  }

  static ContentAreaThemeData _contentAreaTheme(
      {required Color borderColor, required Color backgroundColor}) {
    BorderSide borderSide = BorderSide(width: 1, color: borderColor);
    BoxBorder border =
        Border(bottom: borderSide, left: borderSide, right: borderSide);
    BoxDecoration decoration =
        BoxDecoration(color: backgroundColor, border: border);
    return ContentAreaThemeData(decoration: decoration);
  }

  static MenuThemeData _menuTheme(
      {required Color fontColor,
      required double fontSize,
      required Color color,
      required hoverColor,
      required borderColor}) {
    return MenuThemeData(
        textStyle: TextStyle(fontSize: fontSize, color: fontColor),
        border: Border.all(width: 1, color: borderColor),
        margin: EdgeInsets.all(8),
        menuItemPadding: EdgeInsets.all(8),
        color: color,
        hoverColor: hoverColor,
        dividerColor: borderColor,
        dividerThickness: 1);
  }
}

/// Predefined dark theme builder.
class _Dark {
  static TabbedViewThemeData build(
      {required MaterialColor colorSet, required double fontSize}) {
    Color tabColor = colorSet[900]!;
    Color selectedTabColor = colorSet[800]!;
    Color highlightedTabColor = colorSet[700]!;
    ButtonColors buttonColors = ButtonColors(
        normal: colorSet[400]!,
        disabled: colorSet[600]!,
        hover: colorSet[100]!);
    Color menuColor = colorSet[700]!;
    Color menuHoverColor = colorSet[600]!;
    Color menuDividerColor = colorSet[500]!;
    Color fontColor = colorSet[100]!;
    Color buttonsAreaColor = colorSet[800]!;

    return TabbedViewThemeData(
        tabsArea: _tabsAreaTheme(
            buttonsAreaColor: buttonsAreaColor,
            fontSize: fontSize,
            fontColor: fontColor,
            tabColor: tabColor,
            selectedTabColor: selectedTabColor,
            highlightedTabColor: highlightedTabColor,
            buttonColors: buttonColors),
        contentArea: _contentAreaTheme(selectedTabColor: selectedTabColor),
        menu: _menuTheme(
            fontColor: fontColor,
            fontSize: fontSize,
            color: menuColor,
            hoverColor: menuHoverColor,
            dividerColor: menuDividerColor));
  }

  static TabsAreaThemeData _tabsAreaTheme(
      {required Color buttonsAreaColor,
      required Color fontColor,
      required double fontSize,
      required Color tabColor,
      required Color selectedTabColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors}) {
    return TabsAreaThemeData(
        tab: _tabTheme(
            fontSize: fontSize,
            fontColor: fontColor,
            tabColor: tabColor,
            selectedTabColor: selectedTabColor,
            highlightedTabColor: highlightedTabColor,
            buttonColors: buttonColors),
        equalHeights: EqualHeights.all,
        middleGap: 4,
        buttonsArea: _buttonsAreaTheme(
            buttonsAreaColor: buttonsAreaColor, buttonColors: buttonColors));
  }

  static ButtonsAreaThemeData _buttonsAreaTheme(
      {required Color buttonsAreaColor, required ButtonColors buttonColors}) {
    return ButtonsAreaThemeData(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(color: buttonsAreaColor),
        buttonColors: buttonColors);
  }

  static TabThemeData _tabTheme(
      {required Color fontColor,
      required double fontSize,
      required Color tabColor,
      required Color selectedTabColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors}) {
    double bottomWidth = 3;
    EdgeInsetsGeometry padding = EdgeInsets.fromLTRB(6, 2, 6, 2);
    return TabThemeData(
        buttonsOffset: 4,
        textStyle: TextStyle(fontSize: fontSize, color: fontColor),
        decoration: BoxDecoration(color: tabColor),
        margin: EdgeInsets.only(bottom: bottomWidth),
        padding: padding,
        selectedStatus: TabStatusThemeData(
            decoration: BoxDecoration(
                color: selectedTabColor,
                border: Border(
                    bottom: BorderSide(
                        width: bottomWidth, color: selectedTabColor))),
            margin: EdgeInsets.zero,
            padding: padding),
        highlightedStatus: TabStatusThemeData(
            decoration: BoxDecoration(color: highlightedTabColor),
            padding: padding),
        buttonColors: buttonColors);
  }

  static ContentAreaThemeData _contentAreaTheme(
      {required Color selectedTabColor}) {
    return ContentAreaThemeData(
        decoration: BoxDecoration(color: selectedTabColor),
        padding: EdgeInsets.all(8));
  }

  static MenuThemeData _menuTheme(
      {required Color fontColor,
      required double fontSize,
      required Color color,
      required hoverColor,
      required dividerColor}) {
    return MenuThemeData(
        textStyle: TextStyle(fontSize: fontSize, color: fontColor),
        margin: EdgeInsets.all(8),
        menuItemPadding: EdgeInsets.all(8),
        color: color,
        hoverColor: hoverColor,
        dividerColor: dividerColor,
        dividerThickness: 1);
  }
}

/// Predefined mobile theme builder.
class _Mobile {
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
        normal: colorSet[500]!,
        disabled: colorSet[300]!,
        hover: colorSet[900]!);
    return TabbedViewThemeData(
        tabsArea: _tabsAreaTheme(
            buttonColors: buttonColors,
            foregroundColor: foregroundColor,
            borderColor: borderColor,
            highlightedTabColor: highlightedTabColor,
            fontSize: fontSize,
            backgroundColor: backgroundColor),
        contentArea: _contentAreaTheme(
            backgroundColor: backgroundColor, borderColor: borderColor),
        menu: _menuTheme(
            hoverColor: menuHoverColor,
            foregroundColor: foregroundColor,
            borderColor: borderColor,
            fontSize: fontSize,
            backgroundColor: menuColor));
  }

  static TabsAreaThemeData _tabsAreaTheme(
      {required ButtonColors buttonColors,
      required double fontSize,
      required Color borderColor,
      required Color highlightedTabColor,
      required Color foregroundColor,
      required Color backgroundColor}) {
    return TabsAreaThemeData(
        tab: _tabTheme(
            buttonColors: buttonColors,
            borderColor: borderColor,
            highlightedColor: highlightedTabColor,
            fontSize: fontSize,
            foregroundColor: foregroundColor),
        equalHeights: EqualHeights.all,
        initialGap: -1,
        middleGap: -1,
        buttonsArea: ButtonsAreaThemeData(buttonColors: buttonColors),
        border: Border.all(color: borderColor, width: 1),
        color: backgroundColor);
  }

  static TabThemeData _tabTheme(
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
        buttonsOffset: 4,
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

  static ContentAreaThemeData _contentAreaTheme(
      {required Color borderColor, required Color backgroundColor}) {
    BorderSide borderSide = BorderSide(width: 1, color: borderColor);
    BoxBorder border =
        Border(bottom: borderSide, left: borderSide, right: borderSide);
    BoxDecoration decoration =
        BoxDecoration(color: backgroundColor, border: border);
    return ContentAreaThemeData(decoration: decoration);
  }

  static MenuThemeData _menuTheme(
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

/// Predefined minimalist theme builder.
class _Minimalist {
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
        tabsArea: _tabsAreaTheme(
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
            _contentAreaTheme(borderColor: borderColor, background: background),
        menu: _menuTheme(
            borderColor: borderColor,
            menuColor: menuColor,
            hoverMenuColor: menuHoverColor,
            dividerMenuColor: menuDividerColor,
            menuFontColor: fontColor));
  }

  static TabsAreaThemeData _tabsAreaTheme(
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
        buttonsArea: ButtonsAreaThemeData(
            decoration: BoxDecoration(color: background),
            buttonColors: ButtonColors(normal: hiddenTabsMenuButtonColor)),
        tab: _tabTheme(
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

  static TabThemeData _tabTheme(
      {required Color borderColor,
      required Color background,
      required Color selectedTabColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors,
      required ButtonColors selectedButtonColors,
      required Color fontColor,
      required Color selectedFontColor}) {
    return TabThemeData(
      buttonsOffset: 4,
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

  static ContentAreaThemeData _contentAreaTheme(
      {required Color borderColor, required Color background}) {
    BorderSide borderSide = BorderSide(width: 1, color: borderColor);
    BoxBorder border =
        Border(bottom: borderSide, left: borderSide, right: borderSide);
    BoxDecoration decoration = BoxDecoration(color: background, border: border);
    return ContentAreaThemeData(decoration: decoration);
  }

  static MenuThemeData _menuTheme(
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
