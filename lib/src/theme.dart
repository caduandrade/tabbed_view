import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

enum EqualHeights { none, tabs, all }

enum VerticalAlignment { top, center, bottom }

class TabbedViewTheme {
  const TabbedViewTheme(
      {this.tabsArea = const TabsAreaTheme(),
      this.contentArea = const ContentAreaTheme()});

  final TabsAreaTheme tabsArea;
  final ContentAreaTheme contentArea;

  factory TabbedViewTheme.dark() {
    return _Dark.build();
  }

  factory TabbedViewTheme.light() {
    return _Light.build();
  }

  factory TabbedViewTheme.mobile() {
    return _Mobile.build();
  }

  factory TabbedViewTheme.minimalist() {
    return _Minimalist.build();
  }

  /// Creates a copy of this theme but with the values replaced by the non-null properties from the given theme.
  TabbedViewTheme copyWith(TabbedViewTheme theme) {
    return TabbedViewTheme(
        tabsArea: this.tabsArea.copyWith(theme.tabsArea),
        contentArea: this.contentArea.copyWith(theme.contentArea));
  }
}

class ButtonsAreaTheme {
  const ButtonsAreaTheme(
      {this.decoration,
      this.padding,
      double offset = 0,
      this.button = const TabButtonTheme(),
      this.menuTabsButtonIcon = Icons.more_vert})
      : this.offset = offset >= 0 ? offset : 0;

  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final double offset;
  final TabButtonTheme button;
  final IconData menuTabsButtonIcon;

  /// Creates a copy of this theme but with the values replaced by the non-null properties from the given theme.
  ButtonsAreaTheme copyWith(ButtonsAreaTheme theme) {
    return ButtonsAreaTheme(
        decoration:
            theme.decoration == null ? this.decoration : theme.decoration,
        offset: theme.offset == this.offset ? this.offset : theme.offset,
        button: this.button.copyWith(theme.button),
        padding: theme.padding == null ? this.padding : theme.padding,
        menuTabsButtonIcon: theme.menuTabsButtonIcon == this.menuTabsButtonIcon
            ? this.menuTabsButtonIcon
            : theme.menuTabsButtonIcon);
  }
}

class TabsAreaTheme {
  const TabsAreaTheme(
      {this.closeButtonIcon = Icons.clear,
      this.tab = const TabTheme(),
      this.tabGap = const TabGapTheme(),
      this.buttonsArea = const ButtonsAreaTheme(),
      this.decoration,
      double tabsOffset = 0,
      this.equalHeights = EqualHeights.none})
      : this.tabsOffset = tabsOffset >= 0 ? tabsOffset : 0;

  final Decoration? decoration;
  final TabTheme tab;
  final double tabsOffset;
  final TabGapTheme tabGap;

  final ButtonsAreaTheme buttonsArea;
  final IconData closeButtonIcon;
  final EqualHeights equalHeights;

  /// Creates a copy of this theme but with the values replaced by the non-null properties from the given theme.
  TabsAreaTheme copyWith(TabsAreaTheme theme) {
    return TabsAreaTheme(
        decoration:
            theme.decoration == null ? this.decoration : theme.decoration,
        tab: this.tab.copyWith(theme.tab),
        tabsOffset: theme.tabsOffset == this.tabsOffset
            ? this.tabsOffset
            : theme.tabsOffset,
        tabGap: this.tabGap.copyWith(theme.tabGap),
        buttonsArea: this.buttonsArea.copyWith(theme.buttonsArea),
        closeButtonIcon: theme.closeButtonIcon == this.closeButtonIcon
            ? this.closeButtonIcon
            : theme.closeButtonIcon,
        equalHeights: theme.equalHeights == this.equalHeights
            ? this.equalHeights
            : theme.equalHeights);
  }
}

class TabTheme {
  const TabTheme(
      {this.button = const TabButtonTheme(),
      this.verticalAlignment = VerticalAlignment.center,
      double buttonsOffset = 0,
      double buttonsGap = 0,
      this.color,
      this.textStyle = const TextStyle(fontSize: 13),
      this.padding,
      this.verticalBorder = BorderSide.none,
      this.topBorder = BorderSide.none,
      this.bottomBorder = BorderSide.none,
      this.selected = const TabStatusTheme(),
      this.highlighted = const TabStatusTheme(),
      this.normal = const TabStatusTheme(),
      this.disabled = const TabStatusTheme()})
      : this.buttonsOffset = buttonsOffset >= 0 ? buttonsOffset : 0,
        this.buttonsGap = buttonsGap >= 0 ? buttonsGap : 0;

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  final VerticalAlignment verticalAlignment;

  final Color? color;
  final TextStyle? textStyle;

  final BorderSide verticalBorder;
  final BorderSide topBorder;
  final BorderSide bottomBorder;

  final TabButtonTheme button;
  final double buttonsOffset;
  final double buttonsGap;

  final TabStatusTheme selected;
  final TabStatusTheme highlighted;
  final TabStatusTheme normal;
  final TabStatusTheme disabled;

  /// Creates a copy of this theme but with the values replaced by the non-null properties from the given theme.
  TabTheme copyWith(TabTheme theme) {
    return TabTheme(
        verticalAlignment: theme.verticalAlignment == this.verticalAlignment
            ? this.verticalAlignment
            : theme.verticalAlignment,
        padding: theme.padding == null ? this.padding : theme.padding,
        color: theme.color == null ? this.color : theme.color,
        textStyle: theme.textStyle == null ? this.textStyle : theme.textStyle,
        verticalBorder: this.verticalBorder == theme.verticalBorder
            ? this.verticalBorder
            : theme.verticalBorder,
        topBorder: this.topBorder == theme.topBorder
            ? this.topBorder
            : theme.topBorder,
        bottomBorder: this.bottomBorder == theme.bottomBorder
            ? this.bottomBorder
            : theme.bottomBorder,
        button: this.button.copyWith(theme.button),
        buttonsOffset: theme.buttonsOffset == this.buttonsOffset
            ? this.buttonsOffset
            : theme.buttonsOffset,
        buttonsGap: theme.buttonsGap == this.buttonsGap
            ? this.buttonsGap
            : theme.buttonsGap,
        selected: this.selected.copyWith(theme.selected),
        highlighted: this.highlighted.copyWith(theme.highlighted),
        normal: this.normal.copyWith(theme.normal),
        disabled: this.disabled.copyWith(theme.disabled));
  }
}

class TabStatusTheme {
  const TabStatusTheme(
      {this.color,
      this.fontColor,
      this.topBorder,
      this.bottomBorder,
      this.padding});

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  final Color? color;
  final Color? fontColor;
  final BorderSide? topBorder;
  final BorderSide? bottomBorder;

  /// Creates a copy of this theme but with the values replaced by the non-null properties from the given theme.
  TabStatusTheme copyWith(TabStatusTheme theme) {
    return TabStatusTheme(
        color: theme.color == null ? this.color : theme.color,
        fontColor: theme.fontColor == null ? this.fontColor : theme.fontColor,
        topBorder: this.topBorder == theme.topBorder
            ? this.topBorder
            : theme.topBorder,
        bottomBorder: this.bottomBorder == theme.bottomBorder
            ? this.bottomBorder
            : theme.bottomBorder);
  }
}

class TabButtonTheme {
  static const double minimalIconSize = 8;

  const TabButtonTheme(
      {double iconSize = 16,
      this.color = Colors.black54,
      this.hoverColor = Colors.black,
      this.disabledColor = Colors.black12})
      : this.iconSize = iconSize >= TabButtonTheme.minimalIconSize
            ? iconSize
            : TabButtonTheme.minimalIconSize;

  final double iconSize;
  final Color color;
  final Color hoverColor;
  final Color disabledColor;

  /// Creates a copy of this theme but with the values replaced by the positive and non-default properties from the given theme.
  TabButtonTheme copyWith(TabButtonTheme theme) {
    return TabButtonTheme(
        iconSize:
            theme.iconSize == this.iconSize ? this.iconSize : theme.iconSize,
        color: theme.color == this.color ? this.color : theme.color,
        hoverColor: theme.hoverColor == this.hoverColor
            ? this.hoverColor
            : theme.hoverColor,
        disabledColor: theme.disabledColor == this.disabledColor
            ? this.disabledColor
            : theme.disabledColor);
  }
}

class TabGapTheme {
  const TabGapTheme({this.color, double width = 0, double height = 1})
      : this.width = width >= 0 ? width : 0,
        this.height = height >= 0 ? height : 0;

  final Color? color;
  final double width;
  final double height;

  /// Creates a copy of this theme but with the values replaced by the positive and non-null properties from the given theme.
  TabGapTheme copyWith(TabGapTheme theme) {
    return TabGapTheme(
        color: theme.color == null ? this.color : theme.color,
        width: theme.width == this.width ? this.width : theme.width,
        height: theme.height == this.height ? this.height : theme.height);
  }
}

class ContentAreaTheme {
  const ContentAreaTheme({this.decoration, this.padding});

  final Decoration? decoration;

  /// Empty space to inscribe inside the [decoration]. The content child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  /// Creates a copy of this theme but with the values replaced by the non-null properties from the given theme.
  ContentAreaTheme copyWith(ContentAreaTheme theme) {
    return ContentAreaTheme(
        decoration:
            theme.decoration == null ? this.decoration : theme.decoration,
        padding: theme.padding == null ? this.padding : theme.padding);
  }
}

class _Light {
  static TabbedViewTheme build() {
    return TabbedViewTheme(
        tabsArea: _tabsAreaTheme(), contentArea: _contentAreaTheme());
  }

  static TabsAreaTheme _tabsAreaTheme() {
    return TabsAreaTheme(
        tab: _tabTheme(),
        buttonsArea: ButtonsAreaTheme(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.black, width: 1))),
            padding: EdgeInsets.only(bottom: 2)),
        tabGap: TabGapTheme(height: 1, color: Colors.black, width: 0),
        tabsOffset: 0);
  }

  static TabTheme _tabTheme() {
    BorderSide horizontalBorder = BorderSide(color: Colors.black, width: 1);
    return TabTheme(
        padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
        verticalBorder: BorderSide(color: Colors.black, width: 1),
        topBorder: horizontalBorder,
        bottomBorder: horizontalBorder,
        highlighted:
            TabStatusTheme(color: const Color.fromRGBO(230, 230, 230, 1)),
        selected: TabStatusTheme(
          bottomBorder: BorderSide.none,
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
}

class _Dark {
  static TabbedViewTheme build() {
    return TabbedViewTheme(
        tabsArea: _tabsAreaTheme(), contentArea: _contentAreaTheme());
  }

  static TabsAreaTheme _tabsAreaTheme() {
    return TabsAreaTheme(
        tab: _tabTheme(),
        equalHeights: EqualHeights.all,
        tabGap: TabGapTheme(width: 4),
        buttonsArea: _buttonsAreaTheme());
  }

  static ButtonsAreaTheme _buttonsAreaTheme() {
    return ButtonsAreaTheme(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(color: Colors.grey[800]),
        button: TabButtonTheme(
            color: Colors.grey[400]!,
            disabledColor: Colors.grey[600]!,
            hoverColor: Colors.grey[100]!));
  }

  static TabTheme _tabTheme() {
    return TabTheme(
        color: Colors.grey[900],
        padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
        bottomBorder: BorderSide(width: 3, color: Colors.black),
        selected: TabStatusTheme(
            color: Colors.grey[800],
            bottomBorder: BorderSide(width: 3, color: Colors.grey[800]!)),
        highlighted: TabStatusTheme(color: Colors.grey[700]),
        button: TabButtonTheme(
            color: Colors.grey[400]!,
            disabledColor: Colors.grey[600]!,
            hoverColor: Colors.grey[100]!));
  }

  static ContentAreaTheme _contentAreaTheme({EdgeInsetsGeometry? padding}) {
    if (padding == null) {
      padding = EdgeInsets.all(8);
    }
    return ContentAreaTheme(
        decoration: BoxDecoration(color: Colors.grey[800]), padding: padding);
  }
}

class _Mobile {
  static TabbedViewTheme build() {
    return TabbedViewTheme(
        tabsArea: _tabsAreaTheme(), contentArea: _contentAreaTheme());
  }

  static TabsAreaTheme _tabsAreaTheme() {
    return TabsAreaTheme(
        tab: _tabTheme(),
        equalHeights: EqualHeights.all,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.grey[600]!, width: 1)),
        buttonsArea: ButtonsAreaTheme(
            decoration: BoxDecoration(color: Colors.grey[600]!),
            button: TabButtonTheme(color: Colors.white)));
  }

  static TabTheme _tabTheme() {
    return TabTheme(
        buttonsOffset: 8,
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        verticalBorder: BorderSide(color: Colors.grey[600]!, width: 1),
        bottomBorder: BorderSide(color: Colors.white, width: 4),
        highlighted: TabStatusTheme(
            bottomBorder: BorderSide(color: Colors.grey, width: 4)),
        selected: TabStatusTheme(
            bottomBorder: BorderSide(color: Colors.blue, width: 4)));
  }

  static ContentAreaTheme _contentAreaTheme() {
    BorderSide borderSide = BorderSide(width: 1, color: Colors.grey[600]!);
    BoxBorder border =
        Border(bottom: borderSide, left: borderSide, right: borderSide);
    BoxDecoration decoration = BoxDecoration(border: border);
    return ContentAreaTheme(decoration: decoration);
  }
}

class _Minimalist {
  static TabbedViewTheme build() {
    return TabbedViewTheme(
        tabsArea: _tabsAreaTheme(), contentArea: _contentAreaTheme());
  }

  static TabsAreaTheme _tabsAreaTheme() {
    return TabsAreaTheme(
        tab: _tabTheme(),
        equalHeights: EqualHeights.all,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.grey[600]!, width: 1)),
        buttonsArea: ButtonsAreaTheme(
            decoration: BoxDecoration(color: Colors.grey[600]!),
            button: TabButtonTheme(color: Colors.white)));
  }

  static TabTheme _tabTheme() {
    return TabTheme(
        buttonsOffset: 8,
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        verticalBorder: BorderSide(color: Colors.grey[600]!, width: 1),
        bottomBorder: BorderSide(color: Colors.white, width: 4),
        highlighted: TabStatusTheme(
            bottomBorder: BorderSide(color: Colors.grey, width: 4)),
        selected: TabStatusTheme(
            bottomBorder: BorderSide(color: Colors.blue, width: 4)));
  }

  static ContentAreaTheme _contentAreaTheme() {
    BorderSide borderSide = BorderSide(width: 1, color: Colors.grey[600]!);
    BoxBorder border =
        Border(bottom: borderSide, left: borderSide, right: borderSide);
    BoxDecoration decoration = BoxDecoration(border: border);
    return ContentAreaTheme(decoration: decoration);
  }
}
