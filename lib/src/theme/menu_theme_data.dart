import 'package:flutter/material.dart';

/// Theme for menu.
class TabbedViewMenuThemeData {
  TabbedViewMenuThemeData({
    this.padding,
    this.margin,
    this.menuItemPadding,
    this.textStyle = const TextStyle(fontSize: 13),
    this.decoration,
    this.blur = true,
    this.ellipsisOverflowText = false,
    double dividerThickness = 0,
    double maxWidth = 200,
    this.dividerColor,
    this.hoverColor,
  })  : _dividerThickness = dividerThickness >= 0 ? dividerThickness : 0,
        _maxWidth = maxWidth >= 0 ? maxWidth : 0;

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

  Color? hoverColor;

  /// Indicates whether to apply a blur effect on the content.
  bool blur;

  Color? dividerColor;

  BoxDecoration? decoration;

  /// Use an ellipsis to indicate that the text has overflowed.
  bool ellipsisOverflowText;

  double _dividerThickness;

  double get dividerThickness => _dividerThickness;

  set dividerThickness(double value) {
    _dividerThickness = value >= 0 ? value : 0;
  }

  double _maxWidth;

  double get maxWidth => _maxWidth;

  set maxWidth(double value) {
    _maxWidth = value >= 0 ? value : 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabbedViewMenuThemeData &&
          runtimeType == other.runtimeType &&
          margin == other.margin &&
          padding == other.padding &&
          menuItemPadding == other.menuItemPadding &&
          textStyle == other.textStyle &&
          decoration == other.decoration &&
          hoverColor == other.hoverColor &&
          blur == other.blur &&
          dividerColor == other.dividerColor &&
          ellipsisOverflowText == other.ellipsisOverflowText &&
          _dividerThickness == other._dividerThickness &&
          _maxWidth == other._maxWidth;

  @override
  int get hashCode =>
      margin.hashCode ^
      padding.hashCode ^
      menuItemPadding.hashCode ^
      textStyle.hashCode ^
      decoration.hashCode ^
      hoverColor.hashCode ^
      blur.hashCode ^
      dividerColor.hashCode ^
      ellipsisOverflowText.hashCode ^
      _dividerThickness.hashCode ^
      _maxWidth.hashCode;
}
