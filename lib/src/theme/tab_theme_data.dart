import 'package:flutter/material.dart';
import 'package:tabbed_view/src/icon_provider.dart';
import 'package:tabbed_view/src/tab_status.dart';
import 'package:tabbed_view/src/tabbed_view_icons.dart';
import 'package:tabbed_view/src/theme/tab_status_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_constants.dart';
import 'package:tabbed_view/src/theme/vertical_alignment.dart';
import 'package:tabbed_view/src/theme/vertical_tab_layout_style.dart';

/// Theme for tab.
class TabThemeData {
  TabThemeData(
      // Removed const keyword
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
      this.draggingDecoration,
      this.draggingOpacity = 0.3,
      this.innerBottomBorder,
      this.innerTopBorder,
      this.textStyle = const TextStyle(fontSize: 13),
      this.padding,
      this.paddingWithoutButton,
      this.margin,
      TabStatusThemeData? selectedStatus,
      this.verticalLayoutStyle = VerticalTabLayoutStyle.inline,
      this.rotateCharactersInVerticalTabs = false,
      TabStatusThemeData? highlightedStatus,
      TabStatusThemeData? disabledStatus})
      : this.buttonsOffset = buttonsOffset >= 0 ? buttonsOffset : 0,
        this.buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize =
            TabbedViewThemeConstants.normalize(buttonIconSize),
        this.closeIcon = closeIcon ?? IconProvider.path(TabbedViewIcons.close),
        this.selectedStatus = selectedStatus ?? const TabStatusThemeData(),
        this.highlightedStatus =
            highlightedStatus ?? const TabStatusThemeData(),
        this.disabledStatus = disabledStatus ?? const TabStatusThemeData();
  TabThemeData copyWith({
    IconProvider? closeIcon,
    Color? normalButtonColor,
    Color? hoverButtonColor,
    Color? disabledButtonColor,
    BoxDecoration? normalButtonBackground,
    BoxDecoration? hoverButtonBackground,
    BoxDecoration? disabledButtonBackground,
    double? buttonIconSize,
    VerticalAlignment? verticalAlignment,
    double? buttonsOffset,
    EdgeInsetsGeometry? buttonPadding,
    double? buttonsGap,
    BoxDecoration? decoration,
    BoxDecoration? draggingDecoration,
    double? draggingOpacity,
    BorderSide? innerBottomBorder,
    BorderSide? innerTopBorder,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? paddingWithoutButton,
    EdgeInsetsGeometry? margin,
    TabStatusThemeData? selectedStatus,
    VerticalTabLayoutStyle? verticalLayoutStyle,
    bool? rotateCharactersInVerticalTabs,
    TabStatusThemeData? highlightedStatus,
    TabStatusThemeData? disabledStatus,
  }) {
    return TabThemeData(
      closeIcon: closeIcon ?? this.closeIcon,
      normalButtonColor: normalButtonColor ?? this.normalButtonColor,
      hoverButtonColor: hoverButtonColor ?? this.hoverButtonColor,
      disabledButtonColor: disabledButtonColor ?? this.disabledButtonColor,
      normalButtonBackground:
          normalButtonBackground ?? this.normalButtonBackground,
      hoverButtonBackground:
          hoverButtonBackground ?? this.hoverButtonBackground,
      disabledButtonBackground:
          disabledButtonBackground ?? this.disabledButtonBackground,
      buttonIconSize: buttonIconSize ?? this.buttonIconSize,
      verticalAlignment: verticalAlignment ?? this.verticalAlignment,
      buttonsOffset: buttonsOffset ?? this.buttonsOffset,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      buttonsGap: buttonsGap ?? this.buttonsGap,
      decoration: decoration ?? this.decoration,
      draggingDecoration: draggingDecoration ?? this.draggingDecoration,
      draggingOpacity: draggingOpacity ?? this.draggingOpacity,
      innerBottomBorder: innerBottomBorder ?? this.innerBottomBorder,
      innerTopBorder: innerTopBorder ?? this.innerTopBorder,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      paddingWithoutButton: paddingWithoutButton ?? this.paddingWithoutButton,
      margin: margin ?? this.margin,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      verticalLayoutStyle: verticalLayoutStyle ?? this.verticalLayoutStyle,
      rotateCharactersInVerticalTabs:
          rotateCharactersInVerticalTabs ?? this.rotateCharactersInVerticalTabs,
      highlightedStatus: highlightedStatus ?? this.highlightedStatus,
      disabledStatus: disabledStatus ?? this.disabledStatus,
    );
  }

  /// If `true`, characters within vertical tab text will also be rotated
  /// along with the tab. If `false` (default), characters will remain upright
  /// while the text flows vertically.
  ///
  /// This property is only effective when [verticalLayoutStyle] is
  /// [VerticalTabLayoutStyle.inline].
  final bool rotateCharactersInVerticalTabs;

  /// Defines the layout style for a tab in a vertical [TabBar].
  ///
  /// [VerticalTabLayoutStyle.inline] will arrange the tab's internal components
  /// (leading, text, and buttons) in a row.
  ///
  /// [VerticalTabLayoutStyle.stacked] will arrange the tab's internal components
  /// in a column.
  final VerticalTabLayoutStyle verticalLayoutStyle;
  final TabStatusThemeData selectedStatus;
  final TabStatusThemeData highlightedStatus;
  final TabStatusThemeData disabledStatus;

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? paddingWithoutButton;

  final EdgeInsetsGeometry? margin;

  final VerticalAlignment verticalAlignment;

  final double buttonsOffset;

  final BoxDecoration? decoration;
  final BoxDecoration? draggingDecoration;
  final double draggingOpacity;
  final BorderSide? innerBottomBorder;
  final BorderSide? innerTopBorder;

  final TextStyle? textStyle;

  final double buttonIconSize;
  final Color normalButtonColor;
  final Color hoverButtonColor;
  final Color disabledButtonColor;
  final BoxDecoration? normalButtonBackground;
  final BoxDecoration? hoverButtonBackground;
  final BoxDecoration? disabledButtonBackground;

  /// Icon for the close button.
  final IconProvider closeIcon;

  final EdgeInsetsGeometry? buttonPadding;

  final double buttonsGap;

  /// Gets the theme of a tab according to its status.
  TabStatusThemeData getTabThemeFor(TabStatus status) {
    switch (status) {
      case TabStatus.normal:
        return TabStatusThemeData.empty;
      case TabStatus.selected:
        return selectedStatus;
      case TabStatus.highlighted:
        return highlightedStatus;
    }
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
          draggingDecoration == other.draggingDecoration &&
          draggingOpacity == other.draggingOpacity &&
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
          disabledStatus == other.disabledStatus &&
          buttonsOffset == other.buttonsOffset &&
          buttonPadding == other.buttonPadding &&
          buttonsGap == other.buttonsGap &&
          rotateCharactersInVerticalTabs ==
              other.rotateCharactersInVerticalTabs &&
          verticalLayoutStyle == other.verticalLayoutStyle;

  @override
  int get hashCode =>
      padding.hashCode ^
      paddingWithoutButton.hashCode ^
      margin.hashCode ^
      verticalAlignment.hashCode ^
      decoration.hashCode ^
      draggingDecoration.hashCode ^
      draggingOpacity.hashCode ^
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
      disabledStatus.hashCode ^
      buttonsOffset.hashCode ^
      buttonPadding.hashCode ^
      buttonsGap.hashCode ^
      rotateCharactersInVerticalTabs.hashCode ^
      verticalLayoutStyle.hashCode;
}
