import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tabbed_view/src/content_area.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/tabbed_view_data.dart';
import 'package:tabbed_view/src/tabs_area.dart';
import 'package:tabbed_view/src/theme.dart';

/// Defines a draggable builder for each tab.
typedef DraggableTabBuilder = Draggable Function(
    int tabIndex, TabData tab, Widget tabWidget);

/// Tabs area buttons builder
typedef TabsAreaButtonsBuilder = List<TabButton> Function(
    BuildContext context, int tabsCount);

/// Event that will be triggered when starting the tab closing.
/// The return indicates whether the tab can be closed.
typedef OnTabClosing = bool Function(int tabIndex);

/// Event that will be triggered when the tab selection is changed.
typedef OnTabSelection = Function(int? newTabIndex);

/// Widget inspired by the classic Desktop-style tab component.
///
/// Supports customizable themes.
///
/// Parameters:
/// * [selectToEnableButtons]: allows buttons to be clicked only if the tab is
///   selected. The default value is [TRUE].
/// * [closeButtonTooltip]: optional tooltip for the close button.
class TabbedView extends StatefulWidget {
  TabbedView(
      {required TabbedViewController controller,
      TabbedViewTheme? theme,
      IndexedWidgetBuilder? contentBuilder,
      OnTabClosing? onTabClosing,
      OnTabSelection? onTabSelection,
      bool selectToEnableButtons = true,
      bool contentClip = true,
      String? closeButtonTooltip,
      TabsAreaButtonsBuilder? tabsAreaButtonsBuilder,
      DraggableTabBuilder? draggableTabBuilder})
      : this._data = TabbedViewData(
            controller: controller,
            theme: theme == null ? TabbedViewTheme.classic() : theme,
            contentBuilder: contentBuilder,
            onTabClosing: onTabClosing,
            onTabSelection: onTabSelection,
            contentClip: contentClip,
            selectToEnableButtons: selectToEnableButtons,
            closeButtonTooltip: closeButtonTooltip,
            tabsAreaButtonsBuilder: tabsAreaButtonsBuilder,
            draggableTabBuilder: draggableTabBuilder);

  final TabbedViewData _data;

  @override
  State<StatefulWidget> createState() => _TabbedViewState();
}

/// The [TabbedView] state.
class _TabbedViewState extends State<TabbedView> {
  int? _lastSelectedIndex;

  @override
  void initState() {
    super.initState();
    widget._data.controller.addListener(_rebuild);
    _lastSelectedIndex = widget._data.controller.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant TabbedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._data.controller != oldWidget._data.controller) {
      oldWidget._data.controller.removeListener(_rebuild);
      widget._data.controller.addListener(_rebuild);
      _lastSelectedIndex = widget._data.controller.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget tabArea = TabsArea(data: widget._data);
    ContentArea contentArea = ContentArea(data: widget._data);
    return CustomMultiChildLayout(children: [
      LayoutId(id: 1, child: tabArea),
      LayoutId(id: 2, child: contentArea)
    ], delegate: _TabbedViewLayout());
  }

  _rebuild() {
    int? newTabIndex = widget._data.controller.selectedIndex;
    if (_lastSelectedIndex != newTabIndex) {
      _lastSelectedIndex = newTabIndex;
      if (widget._data.onTabSelection != null) {
        widget._data.onTabSelection!(newTabIndex);
      }
    }

    setState(() {
      // rebuild
    });
  }

  @override
  void dispose() {
    widget._data.controller.removeListener(_rebuild);
    super.dispose();
  }
}

// Layout delegate for [TabbedView]
class _TabbedViewLayout extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    Size childSize = layoutChild(1, BoxConstraints.tightFor(width: size.width));
    positionChild(1, Offset.zero);
    double height = math.max(0, size.height - childSize.height);
    layoutChild(2, BoxConstraints.tightFor(width: size.width, height: height));
    positionChild(2, Offset(0, childSize.height));
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}
