import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Theme for tab.
class TabThemeData {
  static TabBorder defaultBorderBuilder(
      {required TabBarPosition tabBarPosition, required TabStatus status}) {
    return TabBorder();
  }

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
      this.borderBuilder = TabThemeData.defaultBorderBuilder,
      this.draggingDecoration,
      this.draggingOpacity = 0.3,
      this.innerBottomBorder,
      this.innerTopBorder,
      this.innerLeftBorder,
      this.innerRightBorder,
      this.textStyle = const TextStyle(fontSize: 13),
      this.maxTextWidth,
      this.maxWidth,
      this.padding,
      this.paddingWithoutButton,
      this.margin,
      TabStatusThemeData? selectedStatus,
      this.verticalLayoutStyle = VerticalTabLayoutStyle.inline,
      this.rotateCaptionsInVerticalTabs = false,
      this.showCloseIconWhenNotFocused = false,
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

  TabBorderBuilder borderBuilder;

  /// The maximum width for the tab text. If the text exceeds this width, it
  /// will be truncated with an ellipsis.
  double? maxTextWidth;

  /// The maximum width for the tab. For vertical tabs, this will be the maximum
  /// height.
  double? maxWidth;

  /// If `true`, characters within vertical tab text will also be rotated
  /// along with the tab. If `false` (default), characters will remain upright
  /// while the text flows vertically.
  ///
  /// This property is only effective when [verticalLayoutStyle] is
  /// [VerticalTabLayoutStyle.inline].
  bool rotateCaptionsInVerticalTabs;

  bool showCloseIconWhenNotFocused;

  /// Defines the layout style for a tab in a vertical [TabBar].
  ///
  /// [VerticalTabLayoutStyle.inline] will arrange the tab's internal components
  /// (leading, text, and buttons) in a row.
  ///
  /// [VerticalTabLayoutStyle.stacked] will arrange the tab's internal components
  /// in a column.
  VerticalTabLayoutStyle verticalLayoutStyle;
  TabStatusThemeData selectedStatus;
  TabStatusThemeData highlightedStatus;
  final TabStatusThemeData disabledStatus;

  /// Empty space to inscribe inside the [decoration]. The tab child, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? padding;

  EdgeInsetsGeometry? paddingWithoutButton;

  EdgeInsetsGeometry? margin;

  VerticalAlignment verticalAlignment;

  double buttonsOffset;

  BoxDecoration? decoration;
  BoxDecoration? draggingDecoration;
  double draggingOpacity;

  BorderSide? innerBottomBorder;
  BorderSide? innerTopBorder;
  BorderSide? innerLeftBorder;
  BorderSide? innerRightBorder;

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

  EdgeInsetsGeometry? buttonPadding;

  double buttonsGap;

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
          borderBuilder == other.borderBuilder &&
          draggingDecoration == other.draggingDecoration &&
          draggingOpacity == other.draggingOpacity &&
          innerBottomBorder == other.innerBottomBorder &&
          innerTopBorder == other.innerTopBorder &&
          innerLeftBorder == other.innerLeftBorder &&
          innerRightBorder == other.innerRightBorder &&
          textStyle == other.textStyle &&
          maxTextWidth == other.maxTextWidth &&
          maxWidth == other.maxWidth &&
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
          showCloseIconWhenNotFocused == other.showCloseIconWhenNotFocused &&
          rotateCaptionsInVerticalTabs == other.rotateCaptionsInVerticalTabs &&
          verticalLayoutStyle == other.verticalLayoutStyle;

  @override
  int get hashCode =>
      padding.hashCode ^
      paddingWithoutButton.hashCode ^
      margin.hashCode ^
      verticalAlignment.hashCode ^
      decoration.hashCode ^
      borderBuilder.hashCode ^
      draggingDecoration.hashCode ^
      draggingOpacity.hashCode ^
      innerBottomBorder.hashCode ^
      innerTopBorder.hashCode ^
      innerLeftBorder.hashCode ^
      innerRightBorder.hashCode ^
      textStyle.hashCode ^
      maxTextWidth.hashCode ^
      maxWidth.hashCode ^
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
      showCloseIconWhenNotFocused.hashCode ^
      rotateCaptionsInVerticalTabs.hashCode ^
      verticalLayoutStyle.hashCode;
}
