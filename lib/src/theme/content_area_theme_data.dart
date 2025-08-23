// Theme for tab content container.
import 'package:flutter/widgets.dart';

class ContentAreaThemeData {
  ContentAreaThemeData(
      {this.color, this.padding, this.borderRadius = 0, this.border});

  /// The background color.
  final Color? color;

  /// The radius used to round the corners of a border.
  /// A value of zero represents a completely rectangular border,
  /// while a larger value creates more rounded corners.
  final double borderRadius;

  /// The  border around the outer side of the tab content area,
  /// excluding the side adjacent to the tabs.
  /// If the tabs area is hidden, this border also covers the side where
  /// the tabs would normally be.
  BorderSide? border;

  /// Empty space to inscribe inside the [decoration]. The content child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentAreaThemeData &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          borderRadius == other.borderRadius &&
          border == other.border &&
          padding == other.padding;

  @override
  int get hashCode =>
      color.hashCode ^
      borderRadius.hashCode ^
      border.hashCode ^
      padding.hashCode;
}
