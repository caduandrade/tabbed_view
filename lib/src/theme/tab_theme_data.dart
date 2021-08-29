import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/icon_provider.dart';
import 'package:tabbed_view/src/tabbed_view_icons.dart';
import 'package:tabbed_view/src/theme/button_colors.dart';
import 'package:tabbed_view/src/theme/tab_status_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_constants.dart';
import 'package:tabbed_view/src/theme/vertical_alignment.dart';

/// Theme for tab.
class TabThemeData {
  TabThemeData(
      {IconProvider? closeIcon,
      this.buttonColors = const ButtonColors(),
      double buttonIconSize = TabbedViewThemeConstants.defaultIconSize,
      this.verticalAlignment = VerticalAlignment.center,
      double buttonsOffset = 0,
      double buttonsGap = 0,
      this.decoration,
      this.innerBottomBorder,
      this.innerTopBorder,
      this.textStyle = const TextStyle(fontSize: 13),
      this.padding,
      this.margin,
      TabStatusThemeData? selectedStatus,
      TabStatusThemeData? highlightedStatus,
      TabStatusThemeData? normalStatus,
      TabStatusThemeData? disabledStatus})
      : this._buttonsOffset = buttonsOffset >= 0 ? buttonsOffset : 0,
        this._buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize =
            TabbedViewThemeConstants.normalize(buttonIconSize),
        this.closeIcon = closeIcon == null
            ? IconProvider.path(TabbedViewIcons.close)
            : closeIcon,
        this.selectedStatus =
            selectedStatus != null ? selectedStatus : TabStatusThemeData(),
        this.highlightedStatus = highlightedStatus != null
            ? highlightedStatus
            : TabStatusThemeData();

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;

  /// Empty space to surround the [decoration] and tab.
  EdgeInsetsGeometry? margin;

  VerticalAlignment verticalAlignment;

  /// The decoration to paint behind the tab.
  BoxDecoration? decoration;

  BorderSide? innerBottomBorder;
  BorderSide? innerTopBorder;

  TextStyle? textStyle;

  double buttonIconSize;
  ButtonColors buttonColors;
  double _buttonsOffset;

  /// Icon for the close button.
  IconProvider closeIcon;

  TabStatusThemeData selectedStatus;
  TabStatusThemeData highlightedStatus;

  double get buttonsOffset => _buttonsOffset;

  set buttonsOffset(double value) {
    _buttonsOffset = value >= 0 ? value : 0;
  }

  double _buttonsGap;
  double get buttonsGap => _buttonsGap;
  set buttonsGap(double value) {
    _buttonsGap = value >= 0 ? value : 0;
  }
}
