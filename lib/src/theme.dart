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
class TabbedViewTheme {
  TabbedViewTheme(
      {TabsAreaTheme? tabsArea, ContentAreaTheme? contentArea, MenuTheme? menu})
      : this.tabsArea = tabsArea != null ? tabsArea : TabsAreaTheme(),
        this.contentArea =
            contentArea != null ? contentArea : ContentAreaTheme(),
        this.menu = menu != null ? menu : MenuTheme();

  TabsAreaTheme tabsArea;
  ContentAreaTheme contentArea;
  MenuTheme menu;

  /// Builds the predefined dark theme.
  factory TabbedViewTheme.dark() {
    return _Dark.build();
  }

  /// Builds the predefined light theme.
  factory TabbedViewTheme.light() {
    return _Light.build();
  }

  /// Builds the predefined mobile theme.
  factory TabbedViewTheme.mobile() {
    return _Mobile.build();
  }

  /// Builds the predefined minimalist theme.
  factory TabbedViewTheme.minimalist({MaterialColor colors = Colors.grey}) {
    return _Minimalist.build(colors: colors);
  }

  static const double minimalIconSize = 8;
  static const double defaultIconSize = 16;
}

/// Theme for buttons area.
class ButtonsAreaTheme {
  ButtonsAreaTheme(
      {this.decoration,
      this.padding,
      double offset = 0,
      double buttonIconSize = TabbedViewTheme.defaultIconSize,
      this.buttonColors = const ButtonColors(),
      this.hiddenTabsMenuButtonIcon = Icons.arrow_drop_down})
      : this._offset = offset >= 0 ? offset : 0,
        this.buttonIconSize = buttonIconSize >= TabbedViewTheme.minimalIconSize
            ? buttonIconSize
            : TabbedViewTheme.minimalIconSize;

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
class TabsAreaTheme {
  TabsAreaTheme(
      {this.closeButtonIcon = Icons.clear,
      TabTheme? tab,
      ButtonsAreaTheme? buttonsArea,
      this.color,
      this.border,
      this.initialGap = 0,
      this.middleGap = 0,
      double minimalFinalGap = 0,
      this.gapBottomBorder = BorderSide.none,
      this.equalHeights = EqualHeights.none})
      : this.tab = tab != null ? tab : TabTheme(),
        this.buttonsArea =
            buttonsArea != null ? buttonsArea : ButtonsAreaTheme(),
        this._minimalFinalGap = minimalFinalGap >= 0 ? minimalFinalGap : 0;

  Color? color;
  Border? border;
  TabTheme tab;
  double initialGap;
  double middleGap;
  double _minimalFinalGap;
  BorderSide gapBottomBorder;

  ButtonsAreaTheme buttonsArea;
  IconData closeButtonIcon;
  EqualHeights equalHeights;

  double get minimalFinalGap => _minimalFinalGap;

  set minimalFinalGap(double value) {
    _minimalFinalGap = value >= 0 ? value : 0;
  }
}

/// Theme for tab.
class TabTheme {
  TabTheme(
      {this.buttonColors = const ButtonColors(),
      double buttonIconSize = TabbedViewTheme.defaultIconSize,
      this.verticalAlignment = VerticalAlignment.center,
      double buttonsOffset = 0,
      double buttonsGap = 0,
      this.decoration,
      this.textStyle = const TextStyle(fontSize: 13),
      this.padding,
      TabStatusTheme? selectedStatus,
      TabStatusTheme? highlightedStatus,
      TabStatusTheme? normalStatus,
      TabStatusTheme? disabledStatus})
      : this._buttonsOffset = buttonsOffset >= 0 ? buttonsOffset : 0,
        this._buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize = buttonIconSize >= TabbedViewTheme.minimalIconSize
            ? buttonIconSize
            : TabbedViewTheme.minimalIconSize,
        this.selectedStatus =
            selectedStatus != null ? selectedStatus : TabStatusTheme(),
        this.highlightedStatus =
            highlightedStatus != null ? highlightedStatus : TabStatusTheme(),
        this.normalStatus =
            normalStatus != null ? normalStatus : TabStatusTheme(),
        this.disabledStatus =
            disabledStatus != null ? disabledStatus : TabStatusTheme();

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;

  VerticalAlignment verticalAlignment;

  BoxDecoration? decoration;

  TextStyle? textStyle;

  double buttonIconSize;
  ButtonColors buttonColors;
  double _buttonsOffset;
  double _buttonsGap;

  TabStatusTheme selectedStatus;
  TabStatusTheme highlightedStatus;
  TabStatusTheme normalStatus;
  TabStatusTheme disabledStatus;

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
class TabStatusTheme {
  TabStatusTheme(
      {this.decoration, this.fontColor, this.padding, this.buttonColors});

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;
  BoxDecoration? decoration;
  Color? fontColor;
  ButtonColors? buttonColors;
}

// Theme for tab content container.
class ContentAreaTheme {
  ContentAreaTheme({this.decoration, this.padding});

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
class MenuTheme {
  MenuTheme(
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

/// Predefined light theme builder.
class _Light {
  static TabbedViewTheme build() {
    return TabbedViewTheme(
        tabsArea: _tabsAreaTheme(),
        contentArea: _contentAreaTheme(),
        menu: _menuTheme());
  }

  static TabsAreaTheme _tabsAreaTheme() {
    return TabsAreaTheme(
        tab: _tabTheme(),
        buttonsArea: ButtonsAreaTheme(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.black, width: 1))),
            padding: EdgeInsets.only(bottom: 2)),
        middleGap: -1,
        gapBottomBorder: BorderSide(color: Colors.black, width: 1));
  }

  static TabTheme _tabTheme() {
    return TabTheme(
        buttonsOffset: 4,
        padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
        highlightedStatus: TabStatusTheme(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(230, 230, 230, 1),
                border: Border.all(color: Colors.black, width: 1))),
        selectedStatus: TabStatusTheme(
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: Colors.black, width: 1),
                  top: BorderSide(color: Colors.black, width: 1),
                  right: BorderSide(color: Colors.black, width: 1))),
          padding: EdgeInsets.fromLTRB(6, 2, 6, 8),
        ));
  }

  static ContentAreaTheme _contentAreaTheme() {
    BorderSide borderSide = BorderSide(width: 1, color: Colors.black);
    BoxBorder border =
        Border(bottom: borderSide, left: borderSide, right: borderSide);
    BoxDecoration decoration = BoxDecoration(border: border);
    return ContentAreaTheme(decoration: decoration);
  }

  static MenuTheme _menuTheme() {
    return MenuTheme(
        border: Border.all(width: 1, color: Colors.grey),
        margin: EdgeInsets.all(8),
        menuItemPadding: EdgeInsets.all(8),
        color: Colors.white,
        hoverColor: Colors.grey[200],
        dividerColor: Colors.grey,
        dividerThickness: 1);
  }
}

/// Predefined dark theme builder.
class _Dark {
  static TabbedViewTheme build() {
    return TabbedViewTheme(
        tabsArea: _tabsAreaTheme(),
        contentArea: _contentAreaTheme(),
        menu: _menuTheme());
  }

  static TabsAreaTheme _tabsAreaTheme() {
    return TabsAreaTheme(
        tab: _tabTheme(),
        equalHeights: EqualHeights.all,
        middleGap: 4,
        buttonsArea: _buttonsAreaTheme());
  }

  static ButtonsAreaTheme _buttonsAreaTheme() {
    return ButtonsAreaTheme(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(color: Colors.grey[800]),
        buttonColors: ButtonColors(
            normal: Colors.grey[400]!,
            disabled: Colors.grey[600]!,
            hover: Colors.grey[100]!));
  }

  static TabTheme _tabTheme() {
    return TabTheme(
        buttonsOffset: 4,
        decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border(bottom: BorderSide(width: 3, color: Colors.black))),
        padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
        selectedStatus: TabStatusTheme(
            decoration: BoxDecoration(
                color: Colors.grey[800],
                border: Border(
                    bottom: BorderSide(width: 3, color: Colors.grey[800]!))),
            padding: EdgeInsets.fromLTRB(6, 2, 6, 2)),
        highlightedStatus: TabStatusTheme(
            decoration: BoxDecoration(
                color: Colors.grey[700],
                border:
                    Border(bottom: BorderSide(width: 3, color: Colors.black))),
            padding: EdgeInsets.fromLTRB(6, 2, 6, 2)),
        buttonColors: ButtonColors(
            normal: Colors.grey[400]!,
            disabled: Colors.grey[600]!,
            hover: Colors.grey[100]!));
  }

  static ContentAreaTheme _contentAreaTheme({EdgeInsetsGeometry? padding}) {
    if (padding == null) {
      padding = EdgeInsets.all(8);
    }
    return ContentAreaTheme(
        decoration: BoxDecoration(color: Colors.grey[800]), padding: padding);
  }

  static MenuTheme _menuTheme() {
    return MenuTheme(
        textStyle: TextStyle(fontSize: 13, color: Colors.grey[100]),
        border: Border.all(width: 1, color: Colors.grey[600]!),
        margin: EdgeInsets.all(8),
        menuItemPadding: EdgeInsets.all(8),
        color: Colors.grey[700],
        hoverColor: Colors.grey[600],
        dividerColor: Colors.grey[500],
        dividerThickness: 1);
  }
}

/// Predefined mobile theme builder.
class _Mobile {
  static TabbedViewTheme build({Color borderColor = Colors.grey}) {
    return TabbedViewTheme(
        tabsArea: _tabsAreaTheme(borderColor),
        contentArea: _contentAreaTheme(borderColor),
        menu: _menuTheme());
  }

  static TabsAreaTheme _tabsAreaTheme(Color borderColor) {
    return TabsAreaTheme(
        tab: _tabTheme(borderColor),
        equalHeights: EqualHeights.all,
        initialGap: -1,
        middleGap: -1,
        border: Border.all(color: borderColor, width: 1),
        buttonsArea: ButtonsAreaTheme(
            decoration: BoxDecoration(color: Colors.grey[300]!)));
  }

  static TabTheme _tabTheme(Color borderColor) {
    BorderSide verticalBorder = BorderSide(color: borderColor, width: 1);
    double markHeight = 3;
    return TabTheme(
        buttonsOffset: 4,
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.white, width: markHeight),
                left: verticalBorder,
                right: verticalBorder)),
        highlightedStatus: TabStatusTheme(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey, width: markHeight),
                    left: verticalBorder,
                    right: verticalBorder))),
        selectedStatus: TabStatusTheme(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.blue, width: markHeight),
                    left: verticalBorder,
                    right: verticalBorder))));
  }

  static ContentAreaTheme _contentAreaTheme(Color borderColor) {
    BorderSide borderSide = BorderSide(width: 1, color: borderColor);
    BoxBorder border =
        Border(bottom: borderSide, left: borderSide, right: borderSide);
    BoxDecoration decoration = BoxDecoration(border: border);
    return ContentAreaTheme(decoration: decoration);
  }

  static MenuTheme _menuTheme() {
    return MenuTheme(
        border: Border.all(width: 1, color: Colors.grey),
        margin: EdgeInsets.all(8),
        menuItemPadding: EdgeInsets.all(8),
        color: Colors.white,
        hoverColor: Colors.grey[200],
        dividerColor: Colors.grey,
        dividerThickness: 1);
  }
}

/// Predefined minimalist theme builder.
class _Minimalist {
  static TabbedViewTheme build({required MaterialColor colors}) {
    Color borderColor = colors[700]!;
    Color tabColor = colors[50]!;
    Color selectedTabColor = borderColor;
    Color highlightedTabColor = colors[300]!;
    Color menuColor = colors[50]!;
    Color hoverMenuColor = colors[200]!;
    Color dividerMenuColor = colors[400]!;
    ButtonColors buttonColors = ButtonColors(normal: colors[300]!);
    ButtonColors selectedButtonColors = ButtonColors(
        normal: colors[400]!, hover: colors[50]!, disabled: colors[600]!);
    Color fontColor = colors[900]!;
    Color selectedFontColor = colors[50]!;
    Color hiddenTabsMenuButtonColor = borderColor;
    Color menuFontColor = colors[900]!;
    return TabbedViewTheme(
        tabsArea: _tabsAreaTheme(
            borderColor: borderColor,
            tabColor: tabColor,
            selectedTabColor: selectedTabColor,
            highlightedTabColor: highlightedTabColor,
            buttonColors: buttonColors,
            selectedButtonColors: selectedButtonColors,
            fontColor: fontColor,
            selectedFontColor: selectedFontColor,
            hiddenTabsMenuButtonColor: hiddenTabsMenuButtonColor),
        contentArea: _contentAreaTheme(borderColor),
        menu: _menuTheme(
            borderColor: borderColor,
            menuColor: menuColor,
            hoverMenuColor: hoverMenuColor,
            dividerMenuColor: dividerMenuColor,
            menuFontColor: menuFontColor));
  }

  static TabsAreaTheme _tabsAreaTheme(
      {required Color borderColor,
      required Color tabColor,
      required Color selectedTabColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors,
      required ButtonColors selectedButtonColors,
      required Color fontColor,
      required Color selectedFontColor,
      required Color hiddenTabsMenuButtonColor}) {
    return TabsAreaTheme(
        buttonsArea: ButtonsAreaTheme(
            buttonColors: ButtonColors(normal: hiddenTabsMenuButtonColor)),
        tab: _tabTheme(
            borderColor: borderColor,
            tabColor: tabColor,
            selectedTabColor: selectedTabColor,
            highlightedTabColor: highlightedTabColor,
            buttonColors: buttonColors,
            selectedButtonColors: selectedButtonColors,
            fontColor: fontColor,
            selectedFontColor: selectedFontColor),
        equalHeights: EqualHeights.all,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)));
  }

  static TabTheme _tabTheme(
      {required Color borderColor,
      required Color tabColor,
      required Color selectedTabColor,
      required Color highlightedTabColor,
      required ButtonColors buttonColors,
      required ButtonColors selectedButtonColors,
      required Color fontColor,
      required Color selectedFontColor}) {
    return TabTheme(
      buttonsOffset: 4,
      textStyle: TextStyle(color: fontColor, fontSize: 13),
      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
      decoration: BoxDecoration(color: tabColor),
      buttonColors: buttonColors,
      highlightedStatus:
          TabStatusTheme(decoration: BoxDecoration(color: highlightedTabColor)),
      selectedStatus: TabStatusTheme(
          buttonColors: selectedButtonColors,
          fontColor: selectedFontColor,
          decoration: BoxDecoration(color: selectedTabColor)),
    );
  }

  static ContentAreaTheme _contentAreaTheme(borderColor) {
    BorderSide borderSide = BorderSide(width: 1, color: borderColor);
    BoxBorder border =
        Border(bottom: borderSide, left: borderSide, right: borderSide);
    BoxDecoration decoration = BoxDecoration(border: border);
    return ContentAreaTheme(decoration: decoration);
  }

  static MenuTheme _menuTheme(
      {required Color borderColor,
      required Color menuColor,
      required Color hoverMenuColor,
      required Color dividerMenuColor,
      required Color menuFontColor}) {
    return MenuTheme(
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
