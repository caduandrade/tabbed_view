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
  TabbedViewTheme({TabsAreaTheme? tabsArea, ContentAreaTheme? contentArea})
      : this.tabsArea = tabsArea != null ? tabsArea : TabsAreaTheme(),
        this.contentArea =
            contentArea != null ? contentArea : ContentAreaTheme();

  TabsAreaTheme tabsArea;
  ContentAreaTheme contentArea;

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
}

class ButtonsAreaTheme {
  ButtonsAreaTheme(
      {this.decoration,
      this.padding,
      double offset = 0,
      double buttonIconSize = TabbedViewTheme.defaultIconSize,
      this.buttonColors = const ButtonColors(),
      this.menuTabsButtonIcon = Icons.more_vert})
      : this._offset = offset >= 0 ? offset : 0,
        this.buttonIconSize = buttonIconSize >= TabbedViewTheme.minimalIconSize
            ? buttonIconSize
            : TabbedViewTheme.minimalIconSize;

  BoxDecoration? decoration;
  EdgeInsetsGeometry? padding;
  double _offset;
  double buttonIconSize;
  ButtonColors buttonColors;

  IconData menuTabsButtonIcon;

  double get offset => _offset;

  set offset(double value) {
    _offset = value >= 0 ? value : 0;
  }
}

class TabsAreaTheme {
  TabsAreaTheme(
      {this.closeButtonIcon = Icons.clear,
      TabTheme? tab,
      ButtonsAreaTheme? buttonsArea,
      this.color,
      this.border,
      this.initialGap = 0,
      this.middleGap = 0,
      this.minimalFinalGap = 0,
      this.gapBottomBorder = BorderSide.none,
      this.equalHeights = EqualHeights.none})
      : this.tab = tab != null ? tab : TabTheme(),
        this.buttonsArea =
            buttonsArea != null ? buttonsArea : ButtonsAreaTheme();

  Color? color;
  Border? border;
  TabTheme tab;
  double initialGap;
  double middleGap;
  double minimalFinalGap;
  BorderSide gapBottomBorder;

  ButtonsAreaTheme buttonsArea;
  IconData closeButtonIcon;
  EqualHeights equalHeights;
}

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

class ContentAreaTheme {
  ContentAreaTheme({this.decoration, this.padding});

  BoxDecoration? decoration;

  /// Empty space to inscribe inside the [decoration]. The content child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;
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
        selectedStatus: TabStatusTheme(
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
