import 'package:flutter/material.dart';
import 'package:tabbed_view/src/icon_provider.dart';
import 'package:tabbed_view/src/tabbed_view_icons.dart';
import 'package:tabbed_view/src/theme/equal_heights.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_constants.dart';
import 'package:tabbed_view/tabbed_view.dart';

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
      this.dropColor = const Color.fromARGB(150, 0, 0, 0)})
      : this._minimalFinalGap = minimalFinalGap >= 0 ? minimalFinalGap : 0,
        this._buttonsOffset = buttonsOffset >= 0 ? buttonsOffset : 0,
        this._buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize = TabbedViewThemeConstants.normalize(buttonIconSize),
        this.menuIcon = menuIcon == null ? IconProvider.path(TabbedViewIcons.menu) : menuIcon;

  bool visible;

  Color? color;
  Border? border;
  double initialGap;
  double middleGap;
  BorderSide gapBottomBorder;
  EqualHeights equalHeights;

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

  /// custom drop over painter
  CustomPainter? dropOverPainter;

  /// Icon for the add tab
  TabButton? addButton;

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
          _buttonsGap == other._buttonsGap &&
          _buttonsOffset == other._buttonsOffset &&
          buttonPadding == other.buttonPadding &&
          dropOverPainter == other.dropOverPainter &&
          addButton == other.addButton;

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
      _buttonsGap.hashCode ^
      _buttonsOffset.hashCode ^
      buttonPadding.hashCode ^
      dropOverPainter.hashCode ^
      addButton.hashCode ^
      buttonPadding.hashCode;

  double get buttonsOffset => _buttonsOffset;

  set buttonsOffset(double value) {
    _buttonsOffset = value >= 0 ? value : 0;
  }

  EdgeInsetsGeometry? buttonPadding;
}
