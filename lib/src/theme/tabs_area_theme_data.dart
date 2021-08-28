import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tabbed_view/src/icon_path.dart';
import 'package:tabbed_view/src/tabbed_view_icons.dart';
import 'package:tabbed_view/src/theme/button_colors.dart';
import 'package:tabbed_view/src/theme/equal_heights.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_constants.dart';

///Theme for tabs and buttons area.
class TabsAreaThemeData {
  TabsAreaThemeData(
      {this.color,
      this.border,
      this.initialGap = 0,
      this.middleGap = 0,
      double minimalFinalGap = 0,
      this.gapBottomBorder = BorderSide.none,
      this.equalHeights = EqualHeights.none,
      this.buttonsAreaDecoration,
      this.buttonsAreaPadding,
      double buttonsGap = 0,
      double buttonsOffset = 0,
      double buttonIconSize = TabbedViewThemeConstants.defaultIconSize,
      this.buttonColors = const ButtonColors(),
      IconData? menuIconData,
      IconPath? menuIconPath})
      : this._minimalFinalGap = minimalFinalGap >= 0 ? minimalFinalGap : 0,
        this._buttonsOffset = buttonsOffset >= 0 ? buttonsOffset : 0,
        this._buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize =
            TabbedViewThemeConstants.normalize(buttonIconSize),
        this.menuIconData = menuIconData,
        this.menuIconPath = (menuIconData == null && menuIconPath == null)
            ? TabbedViewIcons.menu
            : menuIconPath;

  Color? color;
  Border? border;
  double initialGap;
  double middleGap;
  double _minimalFinalGap;
  BorderSide gapBottomBorder;

  EqualHeights equalHeights;

  double get minimalFinalGap => _minimalFinalGap;

  set minimalFinalGap(double value) {
    _minimalFinalGap = value >= 0 ? value : 0;
  }

  /// The decoration to paint behind the buttons.
  BoxDecoration? buttonsAreaDecoration;

  /// Empty space to inscribe inside the [buttonsAreaDecoration]. The buttons, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [buttonsAreaDecoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? buttonsAreaPadding;
  double buttonIconSize;
  ButtonColors buttonColors;

  /// Icon data for the hidden tabs menu.
  IconData? menuIconData;

  /// Icon path for the hidden tabs menu.
  IconPath? menuIconPath;

  double _buttonsGap;
  double get buttonsGap => _buttonsGap;
  set buttonsGap(double value) {
    _buttonsGap = value >= 0 ? value : 0;
  }

  double _buttonsOffset;
  double get buttonsOffset => _buttonsOffset;
  set buttonsOffset(double value) {
    _buttonsOffset = value >= 0 ? value : 0;
  }
}
