import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

enum EqualHeights { none, tabs, all }

enum VerticalAlignment { top, center, bottom }

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

  static const double minimalIconSize = 8;
  static const double defaultIconSize = 16;

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
      double buttonIconSize = TabbedViewTheme.defaultIconSize,
      this.buttonColors = const ButtonColors(),
      this.menuTabsButtonIcon = Icons.more_vert})
      : this.offset = offset >= 0 ? offset : 0,
        this.buttonIconSize = buttonIconSize >= TabbedViewTheme.minimalIconSize
            ? buttonIconSize
            : TabbedViewTheme.minimalIconSize;

  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final double offset;
  final double buttonIconSize;
  final ButtonColors buttonColors;

  final IconData menuTabsButtonIcon;

  /// Creates a copy of this theme but with the values replaced by the non-null properties from the given theme.
  ButtonsAreaTheme copyWith(ButtonsAreaTheme theme) {
    return ButtonsAreaTheme(
        decoration:
            theme.decoration == null ? this.decoration : theme.decoration,
        offset: theme.offset == this.offset ? this.offset : theme.offset,
        buttonIconSize: theme.buttonIconSize == this.buttonIconSize
            ? this.buttonIconSize
            : theme.buttonIconSize,
        buttonColors: theme.buttonColors == this.buttonColors
            ? this.buttonColors
            : theme.buttonColors,
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
      this.buttonsArea = const ButtonsAreaTheme(),
      this.color,
      this.border,
      this.initialGap = 0,
      this.middleGap = 0,
      this.minimalFinalGap = 0,
      this.gapBottomBorder = BorderSide.none,
      this.equalHeights = EqualHeights.none});

  final Color? color;
  final Border? border;
  final TabTheme tab;
  final double initialGap;
  final double middleGap;
  final double minimalFinalGap;
  final BorderSide gapBottomBorder;

  final ButtonsAreaTheme buttonsArea;
  final IconData closeButtonIcon;
  final EqualHeights equalHeights;

  /// Creates a copy of this theme but with the values replaced by the non-null properties from the given theme.
  TabsAreaTheme copyWith(TabsAreaTheme theme) {
    return TabsAreaTheme(
        color: theme.color == null ? this.color : theme.color,
        border: theme.border == null ? this.border : theme.border,
        tab: this.tab.copyWith(theme.tab),
        initialGap: theme.initialGap == this.initialGap
            ? this.initialGap
            : theme.initialGap,
        middleGap: theme.middleGap == this.middleGap
            ? this.middleGap
            : theme.middleGap,
        minimalFinalGap: theme.minimalFinalGap == this.minimalFinalGap
            ? this.minimalFinalGap
            : theme.minimalFinalGap,
        gapBottomBorder: theme.gapBottomBorder == this.gapBottomBorder
            ? this.gapBottomBorder
            : theme.gapBottomBorder,
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
      {this.buttonColors = const ButtonColors(),
      double buttonIconSize = TabbedViewTheme.defaultIconSize,
      this.verticalAlignment = VerticalAlignment.center,
      double buttonsOffset = 0,
      double buttonsGap = 0,
      this.decoration,
      this.textStyle = const TextStyle(fontSize: 13),
      this.padding,
      this.selected = const TabStatusTheme(),
      this.highlighted = const TabStatusTheme(),
      this.normal = const TabStatusTheme(),
      this.disabled = const TabStatusTheme()})
      : this.buttonsOffset = buttonsOffset >= 0 ? buttonsOffset : 0,
        this.buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize = buttonIconSize >= TabbedViewTheme.minimalIconSize
            ? buttonIconSize
            : TabbedViewTheme.minimalIconSize;

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  final VerticalAlignment verticalAlignment;

  final BoxDecoration? decoration;

  final TextStyle? textStyle;

  final double buttonIconSize;
  final ButtonColors buttonColors;
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
        decoration:
            theme.decoration == null ? this.decoration : theme.decoration,
        textStyle: theme.textStyle == null ? this.textStyle : theme.textStyle,
        buttonColors: theme.buttonColors == this.buttonColors
            ? this.buttonColors
            : theme.buttonColors,
        buttonIconSize: theme.buttonIconSize == this.buttonIconSize
            ? this.buttonIconSize
            : theme.buttonIconSize,
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
      {this.decoration, this.fontColor, this.padding, this.buttonColors});

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;
  final Color? fontColor;
  final ButtonColors? buttonColors;

  /// Creates a copy of this theme but with the values replaced by the non-null properties from the given theme.
  TabStatusTheme copyWith(TabStatusTheme theme) {
    return TabStatusTheme(
        decoration:
            theme.decoration == null ? this.decoration : theme.decoration,
        buttonColors: theme.buttonColors == this.buttonColors
            ? this.buttonColors
            : theme.buttonColors,
        fontColor: theme.fontColor == null ? this.fontColor : theme.fontColor);
  }
}

class ContentAreaTheme {
  const ContentAreaTheme({this.decoration, this.padding});

  final BoxDecoration? decoration;

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
        middleGap: -1,
        gapBottomBorder: BorderSide(color: Colors.black, width: 1));
  }

  static TabTheme _tabTheme() {
    return TabTheme(
        padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
        highlighted: TabStatusTheme(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(230, 230, 230, 1),
                border: Border.all(color: Colors.black, width: 1))),
        selected: TabStatusTheme(
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
        decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border(bottom: BorderSide(width: 3, color: Colors.black))),
        padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
        selected: TabStatusTheme(
            decoration: BoxDecoration(
                color: Colors.grey[800],
                border: Border(
                    bottom: BorderSide(width: 3, color: Colors.grey[800]!))),
            padding: EdgeInsets.fromLTRB(6, 2, 6, 2)),
        highlighted: TabStatusTheme(
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
}

class _Mobile {
  static TabbedViewTheme build({Color borderColor = Colors.grey}) {
    return TabbedViewTheme(
        tabsArea: _tabsAreaTheme(borderColor),
        contentArea: _contentAreaTheme(borderColor));
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
        buttonsOffset: 8,
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.white, width: markHeight),
                left: verticalBorder,
                right: verticalBorder)),
        highlighted: TabStatusTheme(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey, width: markHeight),
                    left: verticalBorder,
                    right: verticalBorder))),
        selected: TabStatusTheme(
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
}

class _Minimalist {
  static TabbedViewTheme build({Color? borderColor}) {
    Color bc = borderColor ?? Colors.grey[700]!;
    return TabbedViewTheme(
        tabsArea: _tabsAreaTheme(bc), contentArea: _contentAreaTheme(bc));
  }

  static TabsAreaTheme _tabsAreaTheme(Color borderColor) {
    return TabsAreaTheme(
        tab: _tabTheme(borderColor),
        middleGap: 8,
        equalHeights: EqualHeights.all,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)));
  }

  static TabTheme _tabTheme(Color borderColor) {
    return TabTheme(
        buttonsOffset: 8,
        padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
        selected: TabStatusTheme(
            fontColor: Colors.white,
            decoration: BoxDecoration(color: borderColor)),
        buttonColors: ButtonColors(
            normal: Colors.white60,
            hover: Colors.white,
            disabled: Colors.white24));
  }

  static ContentAreaTheme _contentAreaTheme(Color borderColor) {
    BorderSide borderSide = BorderSide(width: 1, color: borderColor);
    BoxBorder border =
        Border(bottom: borderSide, left: borderSide, right: borderSide);
    BoxDecoration decoration = BoxDecoration(border: border);
    return ContentAreaTheme(decoration: decoration);
  }
}
