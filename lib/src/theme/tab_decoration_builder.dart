import 'package:flutter/material.dart';

import '../tab_bar_position.dart';
import '../tab_status.dart';

/// A builder function that creates a [TabDecoration] based on the tab's position and status.
typedef TabDecorationBuilder = TabDecoration Function(
    {required TabBarPosition tabBarPosition, required TabStatus status});

/// Defines the decoration of a tab, which can include a border, a color,
/// a border radius, and a wrapper builder for creating nested decorators.
class TabDecoration {
  TabDecoration(
      {this.borderRadius,
      this.color,
      this.border,
      this.shape,
      this.wrapperBorderBuilder})
      : assert(border == null || shape == null);

  /// The radius to be applied to the corners.
  final BorderRadius? borderRadius;

  /// The border of the tab.
  final Border? border;

  /// The color of the tab.
  final Color? color;

  /// The shape of the tab. It is an alternative to [border].
  final ShapeBorder? shape;

  /// An optional builder that can be used to wrap this decoration with another
  /// [TabDecoration], allowing for the creation of composable decorators.
  final TabDecorationBuilder? wrapperBorderBuilder;
}
