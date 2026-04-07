import 'package:flutter/material.dart';

import '../tab_bar_position.dart';
import 'last_visible_tab_behavior.dart';
import 'side_tabs_layout.dart';
import 'tab_header_extent_behavior.dart';
import 'tabbed_view_theme_constants.dart';
import 'tabs_area_cross_axis_alignment.dart';
import 'tabs_area_cross_axis_fit.dart';

///Theme for tabs and buttons area.
class TabsAreaThemeData {
  TabsAreaThemeData(
      {this.visible = true,
      this.color,
      this.border,
      this.padding,
      this.borderRadius = 0,
      this.initialGap = 0,
      this.middleGap = 0,
      double minimalFinalGap = 0,
      this.lastVisibleTabBehavior = LastVisibleTabBehavior.hide,
      this.crossAxisFit = TabsAreaCrossAxisFit.none,
      this.crossAxisAlignment = TabsAreaCrossAxisAlignment.inner,
      this.tabHeaderExtentBehavior = TabHeaderExtentBehavior.individual,
      this.position = TabBarPosition.top,
      this.sideTabsLayout = SideTabsLayout.rotated,
      this.buttonsAreaDecoration,
      this.buttonsAreaPadding,
      this.buttonPadding,
      double buttonsGap = 0,
      double buttonsOffset = 0,
      double buttonIconSize = TabbedViewThemeConstants.defaultIconSize,
      this.buttonColor = Colors.black,
      this.hoveredButtonColor,
      this.disabledButtonColor = Colors.black12,
      this.buttonBackground,
      this.hoveredButtonBackground,
      this.disabledButtonBackground,
      this.dropColor = const Color.fromARGB(150, 0, 0, 0)})
      : this._minimalFinalGap = minimalFinalGap >= 0 ? minimalFinalGap : 0,
        this._buttonsOffset = buttonsOffset >= 0 ? buttonsOffset : 0,
        this._buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize =
            TabbedViewThemeConstants.normalize(buttonIconSize);

  bool visible;

  EdgeInsetsGeometry? padding;

  /// The background color.
  Color? color;

  /// The radius used to round the corners of a border.
  /// A value of zero represents a completely rectangular border,
  /// while a larger value creates more rounded corners.
  final double borderRadius;

  /// The border around the outer edges of the entire area,
  /// excluding the side adjacent to the tab content.
  BorderSide? border;

  double initialGap;
  double middleGap;

  /// Defines how the cross axis will fit within the tabs area.
  TabsAreaCrossAxisFit crossAxisFit;

  /// Defines the alignment of tabs in relation to the main content.
  TabsAreaCrossAxisAlignment crossAxisAlignment;

  /// Defines the position of the tab bar. Defaults to [TabBarPosition.top].
  TabBarPosition position;

  /// Defines how side-positioned tabs (left or right) are laid out.
  SideTabsLayout sideTabsLayout;

  /// Defines how tab headers are sized relative to each other in the cross axis.
  TabHeaderExtentBehavior tabHeaderExtentBehavior;

  Color dropColor;

  double _minimalFinalGap;

  double get minimalFinalGap => _minimalFinalGap;

  set minimalFinalGap(double value) {
    _minimalFinalGap = value >= 0 ? value : 0;
  }

  LastVisibleTabBehavior lastVisibleTabBehavior;

  /// The decoration to paint behind the buttons.
  BoxDecoration? buttonsAreaDecoration;

  /// Empty space to inscribe inside the [buttonsAreaDecoration]. The buttons, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [buttonsAreaDecoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? buttonsAreaPadding;
  double buttonIconSize;
  Color buttonColor;
  Color? hoveredButtonColor;
  Color disabledButtonColor;
  BoxDecoration? buttonBackground;
  BoxDecoration? hoveredButtonBackground;
  BoxDecoration? disabledButtonBackground;

  double _buttonsGap;

  double get buttonsGap => _buttonsGap;

  set buttonsGap(double value) {
    _buttonsGap = value >= 0 ? value : 0;
  }

  double _buttonsOffset;

  double get buttonsOffset => _buttonsOffset;

  set buttonsOffset(double value) {
    _buttonsOffset = value >= 0 ? value : 0;
  }

  EdgeInsetsGeometry? buttonPadding;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabsAreaThemeData &&
          runtimeType == other.runtimeType &&
          visible == other.visible &&
          color == other.color &&
          borderRadius == other.borderRadius &&
          border == other.border &&
          initialGap == other.initialGap &&
          middleGap == other.middleGap &&
          crossAxisFit == other.crossAxisFit &&
          crossAxisAlignment == other.crossAxisAlignment &&
          position == other.position &&
          sideTabsLayout == other.sideTabsLayout &&
          tabHeaderExtentBehavior == other.tabHeaderExtentBehavior &&
          dropColor == other.dropColor &&
          _minimalFinalGap == other._minimalFinalGap &&
          buttonsAreaDecoration == other.buttonsAreaDecoration &&
          buttonsAreaPadding == other.buttonsAreaPadding &&
          buttonIconSize == other.buttonIconSize &&
          buttonColor == other.buttonColor &&
          hoveredButtonColor == other.hoveredButtonColor &&
          disabledButtonColor == other.disabledButtonColor &&
          buttonBackground == other.buttonBackground &&
          hoveredButtonBackground == other.hoveredButtonBackground &&
          disabledButtonBackground == other.disabledButtonBackground &&
          _buttonsGap == other._buttonsGap &&
          _buttonsOffset == other._buttonsOffset &&
          buttonPadding == other.buttonPadding &&
          padding == other.padding &&
          lastVisibleTabBehavior == other.lastVisibleTabBehavior;

  @override
  int get hashCode => Object.hashAll([
        visible,
        color,
        borderRadius,
        border,
        initialGap,
        middleGap,
        crossAxisFit,
        crossAxisAlignment,
        position,
        sideTabsLayout,
        tabHeaderExtentBehavior,
        dropColor,
        _minimalFinalGap,
        buttonsAreaDecoration,
        buttonsAreaPadding,
        buttonIconSize,
        buttonColor,
        hoveredButtonColor,
        disabledButtonColor,
        buttonBackground,
        hoveredButtonBackground,
        disabledButtonBackground,
        _buttonsGap,
        _buttonsOffset,
        buttonPadding,
        padding,
        lastVisibleTabBehavior
      ]);
}
