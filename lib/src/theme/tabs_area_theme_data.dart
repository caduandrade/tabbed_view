import 'package:flutter/material.dart';
import 'package:tabbed_view/src/icon_provider.dart';
import 'package:tabbed_view/src/tabbed_view_icons.dart';
import 'package:tabbed_view/src/theme/equal_heights.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_constants.dart';

///Theme for tabs and buttons area.
class TabsAreaThemeData {
  TabsAreaThemeData(
      {this.visible = true,
      this.color,
      this.border,
      this.initialGap = 0,
      this.middleGap = 0,
      double minimalFinalGap = 0,
      this.gapBottomBorder = BorderSide.none,
      this.equalHeights = EqualHeights.none,
      this.buttonsAreaDecoration,
      this.buttonsAreaPadding,
      this.buttonPadding,
      double buttonsGap = 0,
      double buttonsOffset = 0,
      double buttonIconSize = TabbedViewThemeConstants.defaultIconSize,
      this.normalButtonColor = Colors.black,
      this.hoverButtonColor = Colors.black,
      this.disabledButtonColor = Colors.black12,
      this.normalButtonBackground,
      this.hoverButtonBackground,
      this.disabledButtonBackground,
      IconProvider? menuIcon,
      IconProvider? menuIconOpen,
      IconProvider? menuIconLeft,
      IconProvider? menuIconRight,
      this.dropColor = const Color.fromARGB(150, 0, 0, 0)})
      : this._minimalFinalGap = minimalFinalGap >= 0 ? minimalFinalGap : 0,
        this._buttonsOffset = buttonsOffset >= 0 ? buttonsOffset : 0,
        this._buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize =
            TabbedViewThemeConstants.normalize(buttonIconSize),
        this.menuIcon = menuIcon ?? IconProvider.path(TabbedViewIcons.menu),
        this.menuIconOpen =
            menuIconOpen ?? IconProvider.path(TabbedViewIcons.menuUp),
        this.menuIconLeft =
            menuIconLeft ?? IconProvider.path(TabbedViewIcons.menuLeft),
        this.menuIconRight =
            menuIconRight ?? IconProvider.path(TabbedViewIcons.menuRight);

  bool visible;

  Color? color;
  Border? border;
  double initialGap;
  double middleGap;
  BorderSide gapBottomBorder;
  EqualHeights equalHeights;

  /// Icon for the hidden tabs menu when it is open.
  final IconProvider menuIconOpen;

  /// Icon for the hidden tabs menu for a left tab bar.
  final IconProvider menuIconLeft;

  /// Icon for the hidden tabs menu for a right tab bar.
  final IconProvider menuIconRight;

  Color dropColor;

  double _minimalFinalGap;

  double get minimalFinalGap => _minimalFinalGap;

  set minimalFinalGap(double value) {
    _minimalFinalGap = value >= 0 ? value : 0;
  }

  /// The decoration to paint behind the buttons.
  BoxDecoration? buttonsAreaDecoration;

  /// Empty space to inscribe inside the [buttonsAreaDecoration]. The buttons, if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [buttonsAreaDecoration];
  /// see [Decoration.padding].
  EdgeInsetsGeometry? buttonsAreaPadding;
  double buttonIconSize;
  Color normalButtonColor;
  Color hoverButtonColor;
  Color disabledButtonColor;
  BoxDecoration? normalButtonBackground;
  BoxDecoration? hoverButtonBackground;
  BoxDecoration? disabledButtonBackground;

  /// Icon for the hidden tabs menu.
  IconProvider menuIcon;

  TabsAreaThemeData copyWith(
      {bool? visible,
      Color? color,
      Border? border,
      double? initialGap,
      double? middleGap,
      double? minimalFinalGap,
      BorderSide? gapBottomBorder,
      EqualHeights? equalHeights,
      BoxDecoration? buttonsAreaDecoration,
      EdgeInsetsGeometry? buttonsAreaPadding,
      EdgeInsetsGeometry? buttonPadding,
      double? buttonsGap,
      double? buttonsOffset,
      double? buttonIconSize,
      Color? normalButtonColor,
      Color? hoverButtonColor,
      Color? disabledButtonColor,
      BoxDecoration? normalButtonBackground,
      BoxDecoration? hoverButtonBackground,
      BoxDecoration? disabledButtonBackground,
      IconProvider? menuIcon,
      IconProvider? menuIconOpen,
      IconProvider? menuIconLeft,
      IconProvider? menuIconRight,
      Color? dropColor}) {
    return TabsAreaThemeData(
        visible: visible ?? this.visible,
        color: color ?? this.color,
        border: border ?? this.border,
        initialGap: initialGap ?? this.initialGap,
        middleGap: middleGap ?? this.middleGap,
        minimalFinalGap: minimalFinalGap ?? this.minimalFinalGap,
        gapBottomBorder: gapBottomBorder ?? this.gapBottomBorder,
        equalHeights: equalHeights ?? this.equalHeights,
        buttonsAreaDecoration:
            buttonsAreaDecoration ?? this.buttonsAreaDecoration,
        buttonsAreaPadding: buttonsAreaPadding ?? this.buttonsAreaPadding,
        buttonPadding: buttonPadding ?? this.buttonPadding,
        buttonsGap: buttonsGap ?? this.buttonsGap,
        buttonsOffset: buttonsOffset ?? this.buttonsOffset,
        buttonIconSize: buttonIconSize ?? this.buttonIconSize,
        normalButtonColor: normalButtonColor ?? this.normalButtonColor,
        hoverButtonColor: hoverButtonColor ?? this.hoverButtonColor,
        disabledButtonColor: disabledButtonColor ?? this.disabledButtonColor,
        normalButtonBackground:
            normalButtonBackground ?? this.normalButtonBackground,
        hoverButtonBackground:
            hoverButtonBackground ?? this.hoverButtonBackground,
        disabledButtonBackground:
            disabledButtonBackground ?? this.disabledButtonBackground,
        menuIcon: menuIcon ?? this.menuIcon,
        menuIconOpen: menuIconOpen ?? this.menuIconOpen,
        menuIconLeft: menuIconLeft ?? this.menuIconLeft,
        menuIconRight: menuIconRight ?? this.menuIconRight,
        dropColor: dropColor ?? this.dropColor);
  }

  double _buttonsGap;

  double get buttonsGap => _buttonsGap;

  set buttonsGap(double value) {
    _buttonsGap = value >= 0 ? value : 0;
  }

  double _buttonsOffset;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabsAreaThemeData &&
          runtimeType == other.runtimeType &&
          visible == other.visible &&
          color == other.color &&
          border == other.border &&
          initialGap == other.initialGap &&
          middleGap == other.middleGap &&
          gapBottomBorder == other.gapBottomBorder &&
          equalHeights == other.equalHeights &&
          dropColor == other.dropColor &&
          _minimalFinalGap == other._minimalFinalGap &&
          buttonsAreaDecoration == other.buttonsAreaDecoration &&
          buttonsAreaPadding == other.buttonsAreaPadding &&
          buttonIconSize == other.buttonIconSize &&
          normalButtonColor == other.normalButtonColor &&
          hoverButtonColor == other.hoverButtonColor &&
          disabledButtonColor == other.disabledButtonColor &&
          normalButtonBackground == other.normalButtonBackground &&
          hoverButtonBackground == other.hoverButtonBackground &&
          disabledButtonBackground == other.disabledButtonBackground &&
          menuIcon == other.menuIcon &&
          menuIconOpen == other.menuIconOpen &&
          menuIconLeft == other.menuIconLeft &&
          menuIconRight == other.menuIconRight &&
          _buttonsGap == other._buttonsGap &&
          _buttonsOffset == other._buttonsOffset &&
          buttonPadding == other.buttonPadding;

  @override
  int get hashCode =>
      visible.hashCode ^
      color.hashCode ^
      border.hashCode ^
      initialGap.hashCode ^
      middleGap.hashCode ^
      gapBottomBorder.hashCode ^
      equalHeights.hashCode ^
      dropColor.hashCode ^
      _minimalFinalGap.hashCode ^
      buttonsAreaDecoration.hashCode ^
      buttonsAreaPadding.hashCode ^
      buttonIconSize.hashCode ^
      normalButtonColor.hashCode ^
      hoverButtonColor.hashCode ^
      disabledButtonColor.hashCode ^
      normalButtonBackground.hashCode ^
      hoverButtonBackground.hashCode ^
      disabledButtonBackground.hashCode ^
      menuIcon.hashCode ^
      menuIconOpen.hashCode ^
      menuIconLeft.hashCode ^
      menuIconRight.hashCode ^
      _buttonsGap.hashCode ^
      _buttonsOffset.hashCode ^
      buttonPadding.hashCode;

  double get buttonsOffset => _buttonsOffset;

  set buttonsOffset(double value) {
    _buttonsOffset = value >= 0 ? value : 0;
  }

  EdgeInsetsGeometry? buttonPadding;
}
