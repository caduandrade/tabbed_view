import 'package:flutter/rendering.dart';

/// Path to draw a icon
abstract class IconPath {
  const IconPath();

  /// Builds a responsive path given a size.
  Path build(Size size);
}
