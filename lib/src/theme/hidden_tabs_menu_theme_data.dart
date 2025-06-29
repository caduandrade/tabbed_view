import 'package:flutter/material.dart';

/// Theme for the hidden tabs menu.
class HiddenTabsMenuThemeData {
  HiddenTabsMenuThemeData(
      {this.color,
      this.boxShadow,
      this.borderRadius,
      this.menuItemPadding =
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      this.maxWidth = 200,
      this.maxHeight = 400,
      this.textStyle,
      this.ellipsisOverflowText = false});

  /// The color of the menu.
  final Color? color;

  /// A list of shadows cast by this box behind the menu.
  final List<BoxShadow>? boxShadow;

  /// The border radius of the menu.
  final BorderRadius? borderRadius;

  /// The padding of the menu item.
  final EdgeInsetsGeometry menuItemPadding;

  /// The maximum width of the menu.
  final double maxWidth;

  /// The maximum height of the menu.
  final double maxHeight;

  /// The [TextStyle] of the menu item.
  final TextStyle? textStyle;

  /// Whether to apply an ellipsis to long text.
  final bool ellipsisOverflowText;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  HiddenTabsMenuThemeData copyWith(
      {Color? color,
      List<BoxShadow>? boxShadow,
      BorderRadius? borderRadius,
      EdgeInsetsGeometry? menuItemPadding,
      double? maxWidth,
      double? maxHeight,
      TextStyle? textStyle,
      bool? ellipsisOverflowText}) {
    return HiddenTabsMenuThemeData(
        color: color ?? this.color,
        boxShadow: boxShadow ?? this.boxShadow,
        borderRadius: borderRadius ?? this.borderRadius,
        menuItemPadding: menuItemPadding ?? this.menuItemPadding,
        maxWidth: maxWidth ?? this.maxWidth,
        maxHeight: maxHeight ?? this.maxHeight,
        textStyle: textStyle ?? this.textStyle,
        ellipsisOverflowText:
            ellipsisOverflowText ?? this.ellipsisOverflowText);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiddenTabsMenuThemeData &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          boxShadow == other.boxShadow &&
          borderRadius == other.borderRadius &&
          menuItemPadding == other.menuItemPadding &&
          maxWidth == other.maxWidth &&
          maxHeight == other.maxHeight &&
          textStyle == other.textStyle &&
          ellipsisOverflowText == other.ellipsisOverflowText;

  @override
  int get hashCode =>
      color.hashCode ^
      boxShadow.hashCode ^
      borderRadius.hashCode ^
      menuItemPadding.hashCode ^
      maxWidth.hashCode ^
      maxHeight.hashCode ^
      textStyle.hashCode ^
      ellipsisOverflowText.hashCode;
}
