import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/theme/button_colors.dart';

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
      this.buttonColors});

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
  ButtonColors? buttonColors;
}
