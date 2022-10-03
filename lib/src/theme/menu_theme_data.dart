import 'package:flutter/material.dart';

/// Theme for menu.
class TabbedViewMenuThemeData {
  TabbedViewMenuThemeData(
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

  /// Empty space to inscribe inside the [buttonsAreaDecoration]. The menu area, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [buttonsAreaDecoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;

  /// Empty space to inscribe inside the [buttonsAreaDecoration]. The menu item, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [buttonsAreaDecoration];
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
