import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tabbed_view/src/tabbed_view_icons.dart';
import 'package:tabbed_view/src/theme/button_colors.dart';
import 'package:tabbed_view/src/theme/equal_heights.dart';
import 'package:tabbed_view/src/theme/tab_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_constants.dart';

/// Theme for buttons area.
class ButtonsAreaThemeData {
  ButtonsAreaThemeData(
      {this.decoration,
      this.padding,
      double buttonsGap = 0,
      double offset = 0,
      double buttonIconSize = TabbedViewThemeConstants.defaultIconSize,
      this.buttonColors = const ButtonColors(),
      this.hiddenTabsMenuButtonIcon = TabbedViewIcons.menu})
      : this._offset = offset >= 0 ? offset : 0,
        this._buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize =
            buttonIconSize >= TabbedViewThemeConstants.minimalIconSize
                ? buttonIconSize
                : TabbedViewThemeConstants.minimalIconSize;

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
