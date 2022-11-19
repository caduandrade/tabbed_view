import 'package:flutter/material.dart';
import 'package:tabbed_view/src/icon_provider.dart';
import 'package:tabbed_view/src/tabbed_view_icons.dart';
import 'package:tabbed_view/src/theme/tab_status_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_constants.dart';
import 'package:tabbed_view/src/theme/vertical_alignment.dart';

/// Theme for tab.
class TabThemeData {
  TabThemeData(
      {IconProvider? closeIcon,
      this.normalButtonColor = Colors.black,
      this.hoverButtonColor = Colors.black,
      this.disabledButtonColor = Colors.black12,
      this.normalButtonBackground,
      this.hoverButtonBackground,
      this.disabledButtonBackground,
      double buttonIconSize = TabbedViewThemeConstants.defaultIconSize,
      this.verticalAlignment = VerticalAlignment.center,
      double buttonsOffset = 0,
      this.buttonPadding,
      double buttonsGap = 0,
      this.decoration,
      this.innerBottomBorder,
      this.innerTopBorder,
      this.textStyle = const TextStyle(fontSize: 13),
      this.padding,
      this.paddingWithoutButton,
      this.margin,
      TabStatusThemeData? selectedStatus,
      TabStatusThemeData? highlightedStatus,
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

  /// Overrides [padding] when the tab has no buttons.
  EdgeInsetsGeometry? paddingWithoutButton;

  /// Empty space to surround the [decoration] and tab.
  EdgeInsetsGeometry? margin;

  VerticalAlignment verticalAlignment;

  /// The decoration to paint behind the tab.
  BoxDecoration? decoration;

  BorderSide? innerBottomBorder;
  BorderSide? innerTopBorder;

  TextStyle? textStyle;

  double buttonIconSize;
  Color normalButtonColor;
  Color hoverButtonColor;
  Color disabledButtonColor;
  BoxDecoration? normalButtonBackground;
  BoxDecoration? hoverButtonBackground;
  BoxDecoration? disabledButtonBackground;

  /// Icon for the close button.
  IconProvider closeIcon;

  TabStatusThemeData selectedStatus;
  TabStatusThemeData highlightedStatus;

  double _buttonsOffset;
  double get buttonsOffset => _buttonsOffset;
  set buttonsOffset(double value) {
    _buttonsOffset = value >= 0 ? value : 0;
  }

  EdgeInsetsGeometry? buttonPadding;

  double _buttonsGap;
  double get buttonsGap => _buttonsGap;
  set buttonsGap(double value) {
    _buttonsGap = value >= 0 ? value : 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabThemeData &&
          runtimeType == other.runtimeType &&
          padding == other.padding &&
          paddingWithoutButton == other.paddingWithoutButton &&
          margin == other.margin &&
          verticalAlignment == other.verticalAlignment &&
          decoration == other.decoration &&
          innerBottomBorder == other.innerBottomBorder &&
          innerTopBorder == other.innerTopBorder &&
          textStyle == other.textStyle &&
          buttonIconSize == other.buttonIconSize &&
          normalButtonColor == other.normalButtonColor &&
          hoverButtonColor == other.hoverButtonColor &&
          disabledButtonColor == other.disabledButtonColor &&
          normalButtonBackground == other.normalButtonBackground &&
          hoverButtonBackground == other.hoverButtonBackground &&
          disabledButtonBackground == other.disabledButtonBackground &&
          closeIcon == other.closeIcon &&
          selectedStatus == other.selectedStatus &&
          highlightedStatus == other.highlightedStatus &&
          _buttonsOffset == other._buttonsOffset &&
          buttonPadding == other.buttonPadding &&
          _buttonsGap == other._buttonsGap;

  @override
  int get hashCode =>
      padding.hashCode ^
      paddingWithoutButton.hashCode ^
      margin.hashCode ^
      verticalAlignment.hashCode ^
      decoration.hashCode ^
      innerBottomBorder.hashCode ^
      innerTopBorder.hashCode ^
      textStyle.hashCode ^
      buttonIconSize.hashCode ^
      normalButtonColor.hashCode ^
      hoverButtonColor.hashCode ^
      disabledButtonColor.hashCode ^
      normalButtonBackground.hashCode ^
      hoverButtonBackground.hashCode ^
      disabledButtonBackground.hashCode ^
      closeIcon.hashCode ^
      selectedStatus.hashCode ^
      highlightedStatus.hashCode ^
      _buttonsOffset.hashCode ^
      buttonPadding.hashCode ^
      _buttonsGap.hashCode;
}
