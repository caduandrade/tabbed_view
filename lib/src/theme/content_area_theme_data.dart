// Theme for tab content container.
import 'package:flutter/widgets.dart';

class ContentAreaThemeData {
  ContentAreaThemeData(
      {this.color, this.padding, this.borderRadius = 0, this.border});

  final Color? color;

  final double borderRadius;

  /// The border of the content area. If not NULL, the border of the
  /// [decoration] property will be ignored.
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
