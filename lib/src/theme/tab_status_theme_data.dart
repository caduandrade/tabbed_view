import 'package:flutter/widgets.dart';

/// Theme for tab in a given status.
/// Allows you to overwrite [TabThemeData] properties.
class TabStatusThemeData {
  TabStatusThemeData(
      {this.decoration,
      this.innerTopBorder,
      this.innerBottomBorder,
      this.fontColor,
      this.padding,
      this.margin,
      this.normalButtonColor,
      this.hoverButtonColor,
      this.disabledButtonColor,
      this.normalButtonBackground,
      this.hoverButtonBackground,
      this.disabledButtonBackground});

  static final TabStatusThemeData empty = TabStatusThemeData();

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;

  /// Empty space to surround the [decoration] and tab.
  EdgeInsetsGeometry? margin;

  /// The decoration to paint behind the tab.
  BoxDecoration? decoration;
  BorderSide? innerBottomBorder;
  BorderSide? innerTopBorder;
  Color? fontColor;
  Color? normalButtonColor;
  Color? hoverButtonColor;
  Color? disabledButtonColor;
  BoxDecoration? normalButtonBackground;
  BoxDecoration? hoverButtonBackground;
  BoxDecoration? disabledButtonBackground;
}
