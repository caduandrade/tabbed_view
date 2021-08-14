import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tabbed_view.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/theme.dart';

/// Propagates parameters to internal components.
class TabbedViewData {
  TabbedViewData(
      {required this.controller,
      required this.theme,
      this.contentBuilder,
      this.onTabClosing,
      required this.contentClip,
      this.onTabSelection,
      required this.selectToEnableButtons,
      this.closeButtonTooltip,
      this.tabsAreaButtonsBuilder,
      this.draggableTabBuilder});

  final TabbedViewController controller;
  final TabbedViewTheme theme;
  final bool contentClip;
  final IndexedWidgetBuilder? contentBuilder;
  final OnTabClosing? onTabClosing;
  final OnTabSelection? onTabSelection;
  final bool selectToEnableButtons;
  final String? closeButtonTooltip;
  final TabsAreaButtonsBuilder? tabsAreaButtonsBuilder;
  final DraggableTabBuilder? draggableTabBuilder;
}
