// Theme for tab content container.
import 'package:flutter/widgets.dart';

class ContentAreaThemeData {
  ContentAreaThemeData({this.decoration, this.padding});

  /// The decoration to paint behind the content.
  BoxDecoration? decoration;

  /// Empty space to inscribe inside the [decoration]. The content child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;
}
