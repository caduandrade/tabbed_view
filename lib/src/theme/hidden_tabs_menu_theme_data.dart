import 'package:flutter/material.dart';

/// Theme for the hidden tabs menu.
class HiddenTabsMenuThemeData {
  HiddenTabsMenuThemeData(
      {this.color = Colors.white,
      this.boxShadow,
      this.borderRadius,
      this.border,
      this.margin,
      this.padding,
      this.menuItemPadding =
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      this.maxWidth = 200,
      this.maxHeight = 400,
      this.textStyle,
      this.ellipsisOverflowText = false,
      this.blur = true,
      this.dividerThickness = 0,
      this.dividerColor,
      this.hoverColor,
      this.highlightColor,
      this.colorDark = const Color(0xFF424242), // Colors.grey[800]
      this.textStyleDark,
      this.dividerColorDark,
      this.hoverColorDark,
      this.highlightColorDark});

  /// The color of the menu.
  Color? color;

  /// The color of the menu for dark theme.
  final Color? colorDark;

  /// A list of shadows cast by this box behind the menu.
  List<BoxShadow>? boxShadow;

  /// The border radius of the menu.
  BorderRadius? borderRadius;

  /// The border of the menu.
  final Border? border;

  /// The margin of the menu.
  final EdgeInsetsGeometry? margin;

  /// The padding of the menu.
  final EdgeInsetsGeometry? padding;

  /// The padding of the menu item.
  EdgeInsetsGeometry menuItemPadding;

  /// The maximum width of the menu.
  final double maxWidth;

  /// The maximum height of the menu.
  final double maxHeight;

  /// The [TextStyle] of the menu item.
  TextStyle? textStyle;

  /// The [TextStyle] of the menu item for dark theme.
  final TextStyle? textStyleDark;

  /// Whether to apply an ellipsis to long text.
  final bool ellipsisOverflowText;

  /// The blur effect.
  final bool blur;

  /// The thickness of the divider.
  final double dividerThickness;

  /// The color of the divider.
  final Color? dividerColor;

  /// The color of the divider for dark theme.
  final Color? dividerColorDark;

  /// The color of the menu item when the mouse is over it.
  final Color? hoverColor;

  /// The color of the menu item when the mouse is over it for dark theme.
  final Color? hoverColorDark;

  /// The highlight color of the menu item when pressed.
  final Color? highlightColor;

  /// The highlight color of the menu item when pressed for dark theme.
  final Color? highlightColorDark;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiddenTabsMenuThemeData &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          boxShadow == other.boxShadow &&
          borderRadius == other.borderRadius &&
          border == other.border &&
          margin == other.margin &&
          padding == other.padding &&
          menuItemPadding == other.menuItemPadding &&
          maxWidth == other.maxWidth &&
          maxHeight == other.maxHeight &&
          textStyle == other.textStyle &&
          ellipsisOverflowText == other.ellipsisOverflowText &&
          blur == other.blur &&
          dividerThickness == other.dividerThickness &&
          dividerColor == other.dividerColor &&
          hoverColor == other.hoverColor &&
          highlightColor == other.highlightColor &&
          colorDark == other.colorDark &&
          textStyleDark == other.textStyleDark &&
          dividerColorDark == other.dividerColorDark &&
          hoverColorDark == other.hoverColorDark &&
          highlightColorDark == other.highlightColorDark;

  @override
  int get hashCode =>
      color.hashCode ^
      boxShadow.hashCode ^
      borderRadius.hashCode ^
      border.hashCode ^
      margin.hashCode ^
      padding.hashCode ^
      menuItemPadding.hashCode ^
      maxWidth.hashCode ^
      maxHeight.hashCode ^
      textStyle.hashCode ^
      ellipsisOverflowText.hashCode ^
      blur.hashCode ^
      dividerThickness.hashCode ^
      dividerColor.hashCode ^
      hoverColor.hashCode ^
      highlightColor.hashCode ^
      colorDark.hashCode ^
      textStyleDark.hashCode ^
      dividerColorDark.hashCode ^
      hoverColorDark.hashCode ^
      highlightColorDark.hashCode;
}
