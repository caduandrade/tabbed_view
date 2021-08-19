import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tabbed_view.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';

/// Propagates parameters to internal widgets.
class TabbedViewData {
  TabbedViewData(
      {required this.controller,
      this.contentBuilder,
      this.onTabClose,
      this.tabCloseInterceptor,
      required this.contentClip,
      this.onTabSelection,
      required this.selectToEnableButtons,
      this.closeButtonTooltip,
      this.tabsAreaButtonsBuilder,
      this.draggableTabBuilder});

  final TabbedViewController controller;
  final bool contentClip;
  final IndexedWidgetBuilder? contentBuilder;
  final OnTabClose? onTabClose;
  final TabCloseInterceptor? tabCloseInterceptor;
  final OnTabSelection? onTabSelection;
  final bool selectToEnableButtons;
  final String? closeButtonTooltip;
  final TabsAreaButtonsBuilder? tabsAreaButtonsBuilder;
  final DraggableTabBuilder? draggableTabBuilder;
}
