import 'package:flutter/material.dart';

/// Defines the border theme for a single tab,
/// oriented around the content area in the center.
class TabBordersThemeData {
  const TabBordersThemeData({
    this.nearContent = const NearContentBorders(),
    this.farContent = const FarContentBorders(),
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.borderRadius=0,
    this.contentBorderColor = Colors.transparent
  });

  /// Borders located between the tab label and the content area.
  final NearContentBorders nearContent;

  /// Borders located on the side opposite to the content area.
  final FarContentBorders farContent;

  /// Color of the border around the tab label,
  /// excluding the side that touches the main content.
  final Color borderColor;

  /// Width of the border around the tab label,
  /// excluding the side that touches the main content.
  final double borderWidth;

  /// Width of the border around the tab label,
  /// excluding the side that touches the main content.
  final double borderRadius;

  /// The border around the tab label,
  /// excluding the side that touches the content.
  BorderSide get border => borderWidth > 0
      ? BorderSide(color: borderColor, width: borderWidth)
      : BorderSide.none;


  /// The border color along the edge separating the tab from the content area.
  final Color contentBorderColor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabBordersThemeData &&
          runtimeType == other.runtimeType &&
          nearContent == other.nearContent &&
          farContent == other.farContent &&
          borderColor == other.borderColor &&
          borderWidth == other.borderWidth &&
          borderRadius == other.borderRadius &&
          contentBorderColor == other.contentBorderColor;

  @override
  int get hashCode =>
      nearContent.hashCode ^
      farContent.hashCode ^
      borderColor.hashCode ^
      borderWidth.hashCode ^
      borderRadius.hashCode ^
      contentBorderColor.hashCode;
}

/// Borders on the side facing the main content.
class NearContentBorders {
  const NearContentBorders({
    this.label = BorderSide.none,
    this.middle=BorderSide.none
  });

  /// Border adjacent to the tab label.
  final BorderSide label;

  /// Border between the label and the main content.
  final BorderSide middle;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NearContentBorders &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          middle == other.middle;

  @override
  int get hashCode => label.hashCode ^ middle.hashCode;
}

/// Borders on the side away from the main content.
class FarContentBorders {
  const FarContentBorders({
    this.outer = BorderSide.none,
    this.label = BorderSide.none,
  });

  /// Border adjacent to the outer container of the tab.
  final BorderSide outer;

  /// Border adjacent to the tab label (opposite side from content).
  final BorderSide label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FarContentBorders &&
          runtimeType == other.runtimeType &&
          outer == other.outer &&
          label == other.label;

  @override
  int get hashCode => outer.hashCode ^ label.hashCode;
}
