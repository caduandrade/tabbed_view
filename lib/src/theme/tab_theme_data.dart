import 'package:flutter/material.dart';

import '../icon_provider.dart';
import '../tab_bar_position.dart';
import '../tab_status.dart';
import '../tabbed_view_icons.dart';
import 'tab_decoration_builder.dart';
import 'tab_status_theme_data.dart';
import 'tab_style_context.dart';
import 'tab_style_resolver.dart';
import 'tabbed_view_theme_constants.dart';
import 'vertical_alignment.dart';

/// Theme for tab.
class TabThemeData {
  static TabDecoration defaultBorderBuilder(
      {required TabBarPosition tabBarPosition,
      required TabStyleContext styleContext}) {
    return const TabDecoration();
  }

  TabThemeData(
      {IconProvider? closeIcon,
      this.buttonColor = Colors.black,
      this.hoveredButtonColor,
      this.disabledButtonColor = Colors.black12,
      this.buttonBackground,
      this.hoveredButtonBackground,
      this.disabledButtonBackground,
      double buttonIconSize = TabbedViewThemeConstants.defaultIconSize,
      this.verticalAlignment = VerticalAlignment.center,
      double buttonsOffset = 0,
      this.buttonPadding,
      double buttonsGap = 0,
      this.decorationBuilder = TabThemeData.defaultBorderBuilder,
      this.draggingDecoration,
      this.draggingOpacity = 0.3,
      this.textStyle = const TextStyle(fontSize: 13),
      this.maxMainSize,
      this.maxLines,
      this.padding,
      this.paddingWithoutButton,
      this.styleResolver,
      required this.selectedStatus,
      required this.hoveredStatus})
      : this.buttonsOffset = buttonsOffset >= 0 ? buttonsOffset : 0,
        this.buttonsGap = buttonsGap >= 0 ? buttonsGap : 0,
        this.buttonIconSize =
            TabbedViewThemeConstants.normalize(buttonIconSize),
        this.closeIcon = closeIcon ?? IconProvider.path(TabbedViewIcons.close);

  /// A builder for creating complex and composable tab decorators.
  TabDecorationBuilder decorationBuilder;

  /// The maximum main size of the tab.
  ///
  /// This will be its width when the tab is displayed horizontally,
  /// and its height when displayed vertically.
  double? maxMainSize;

  /// The maximum number of lines for the tab label.
  ///
  /// If [maxMainSize] is set, the text will wrap to a new line before
  /// truncating with an ellipsis. If [maxMainSize] is null, this
  /// parameter may have no visible effect as the tab expands to fit the text.
  int? maxLines;

  TabStatusThemeData selectedStatus;
  TabStatusThemeData hoveredStatus;

  /// Padding for tab content
  EdgeInsetsGeometry? padding;

  EdgeInsetsGeometry? paddingWithoutButton;

  VerticalAlignment verticalAlignment;

  double buttonsOffset;

  BoxDecoration? draggingDecoration;
  double draggingOpacity;

  TextStyle? textStyle;

  double buttonIconSize;
  Color buttonColor;
  Color? hoveredButtonColor;
  Color disabledButtonColor;
  BoxDecoration? buttonBackground;
  BoxDecoration? hoveredButtonBackground;
  BoxDecoration? disabledButtonBackground;

  /// Icon for the close button.
  IconProvider closeIcon;

  EdgeInsetsGeometry? buttonPadding;

  double buttonsGap;

  /// Optional resolver used to override the visual styling of individual tabs.
  ///
  /// By default, the theme applies a uniform style to all tabs. When a
  /// [TabStyleResolver] is provided, it is consulted during style resolution
  /// for each tab and [TabStatus], allowing per-tab customization without
  /// affecting the global theme.
  ///
  /// The resolver operates on top of the theme defaults. For each property,
  /// returning `null` indicates that the theme’s default value should be used.
  ///
  /// This mechanism is intended for **superficial styling overrides** (e.g.,
  /// colors, padding, decorations). Structural or layout differences remain
  /// the responsibility of the theme implementation itself.
  ///
  /// Concrete themes may provide specialized subclasses of [TabStyleResolver]
  /// with additional capabilities specific to their rendering model.
  TabStyleResolver? styleResolver;

  /// Gets an optional theme for a tab based on its [status].
  ///
  /// If a theme is returned (for [TabStatus.selected] or [TabStatus.hovered]),
  /// its non-null properties will override the corresponding properties of the main tab theme.
  /// For [TabStatus.normal], it returns `null` as there is no specific theme to apply.
  TabStatusThemeData? getTabThemeFor(TabStatus status) {
    switch (status) {
      case TabStatus.normal:
        return null;
      case TabStatus.selected:
        return selectedStatus;
      case TabStatus.hovered:
        return hoveredStatus;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabThemeData &&
          runtimeType == other.runtimeType &&
          decorationBuilder == other.decorationBuilder &&
          maxMainSize == other.maxMainSize &&
          maxLines == other.maxLines &&
          selectedStatus == other.selectedStatus &&
          hoveredStatus == other.hoveredStatus &&
          padding == other.padding &&
          paddingWithoutButton == other.paddingWithoutButton &&
          verticalAlignment == other.verticalAlignment &&
          buttonsOffset == other.buttonsOffset &&
          draggingDecoration == other.draggingDecoration &&
          draggingOpacity == other.draggingOpacity &&
          textStyle == other.textStyle &&
          buttonIconSize == other.buttonIconSize &&
          buttonColor == other.buttonColor &&
          hoveredButtonColor == other.hoveredButtonColor &&
          disabledButtonColor == other.disabledButtonColor &&
          buttonBackground == other.buttonBackground &&
          hoveredButtonBackground == other.hoveredButtonBackground &&
          disabledButtonBackground == other.disabledButtonBackground &&
          closeIcon == other.closeIcon &&
          buttonPadding == other.buttonPadding &&
          buttonsGap == other.buttonsGap &&
          styleResolver == other.styleResolver;

  @override
  int get hashCode =>
      decorationBuilder.hashCode ^
      maxMainSize.hashCode ^
      maxLines.hashCode ^
      selectedStatus.hashCode ^
      hoveredStatus.hashCode ^
      padding.hashCode ^
      paddingWithoutButton.hashCode ^
      verticalAlignment.hashCode ^
      buttonsOffset.hashCode ^
      draggingDecoration.hashCode ^
      draggingOpacity.hashCode ^
      textStyle.hashCode ^
      buttonIconSize.hashCode ^
      buttonColor.hashCode ^
      hoveredButtonColor.hashCode ^
      disabledButtonColor.hashCode ^
      buttonBackground.hashCode ^
      hoveredButtonBackground.hashCode ^
      disabledButtonBackground.hashCode ^
      closeIcon.hashCode ^
      buttonPadding.hashCode ^
      buttonsGap.hashCode ^
      styleResolver.hashCode;
}
