// Theme for tab content container.
import 'package:flutter/widgets.dart';

class ContentAreaThemeData {
  ContentAreaThemeData(
      {this.decoration, this.padding, this.decorationNoTabsArea, this.border});

  /// The decoration to paint behind the content.
  BoxDecoration? decoration;

  /// The decoration to paint behind the content when there is no tab area.
  BoxDecoration? decorationNoTabsArea;

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
          decoration == other.decoration &&
          border == other.border &&
          decorationNoTabsArea == other.decorationNoTabsArea &&
          padding == other.padding;

  @override
  int get hashCode =>
      decoration.hashCode ^
      border.hashCode ^
      decorationNoTabsArea.hashCode ^
      padding.hashCode;
}
