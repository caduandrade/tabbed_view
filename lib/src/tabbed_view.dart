import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tabbed_view/src/content_area.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/tabbed_view_data.dart';
import 'package:tabbed_view/src/tabbed_view_menu_item.dart';
import 'package:tabbed_view/src/tabs_area.dart';

/// Defines a draggable builder for each tab.
typedef DraggableTabBuilder = Draggable Function(
    int tabIndex, TabData tab, Widget tabWidget);

/// Tabs area buttons builder
typedef TabsAreaButtonsBuilder = List<TabButton> Function(
    BuildContext context, int tabsCount);

/// The event that will be triggered after the tab close.
typedef OnTabClose = void Function(int tabIndex, TabData tabData);

/// Intercepts a close event to indicates whether the tab can be closed.
typedef TabCloseInterceptor = bool Function(int tabIndex);

/// Intercepts a select event to indicate whether the tab can be selected.
typedef TabSelectInterceptor = bool Function(int newTabIndex);

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
      {required this.controller,
      this.contentBuilder,
      this.onTabClose,
      this.tabCloseInterceptor,
      this.onTabSelection,
      this.tabSelectInterceptor,
      this.selectToEnableButtons = true,
      this.contentClip = true,
      this.closeButtonTooltip,
      this.tabsAreaButtonsBuilder,
      this.draggableTabBuilder,
      this.tabsAreaVisible = true});

  final TabbedViewController controller;
  final bool contentClip;
  final IndexedWidgetBuilder? contentBuilder;
  final OnTabClose? onTabClose;
  final TabCloseInterceptor? tabCloseInterceptor;
  final OnTabSelection? onTabSelection;
  final TabSelectInterceptor? tabSelectInterceptor;
  final bool selectToEnableButtons;
  final String? closeButtonTooltip;
  final TabsAreaButtonsBuilder? tabsAreaButtonsBuilder;
  final DraggableTabBuilder? draggableTabBuilder;
  final bool tabsAreaVisible;

  @override
  State<StatefulWidget> createState() => _TabbedViewState();
}

/// The [TabbedView] state.
class _TabbedViewState extends State<TabbedView> {
  int? _lastSelectedIndex;
  List<TabbedViewMenuItem> _menuItems = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuildByTabOrSelection);
    _lastSelectedIndex = widget.controller.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant TabbedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_rebuildByTabOrSelection);
      widget.controller.addListener(_rebuildByTabOrSelection);
      _lastSelectedIndex = widget.controller.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    TabbedViewData data = TabbedViewData(
        controller: widget.controller,
        contentBuilder: widget.contentBuilder,
        onTabClose: widget.onTabClose,
        tabCloseInterceptor: widget.tabCloseInterceptor,
        onTabSelection: widget.onTabSelection,
        contentClip: widget.contentClip,
        tabSelectInterceptor: widget.tabSelectInterceptor,
        selectToEnableButtons: widget.selectToEnableButtons,
        closeButtonTooltip: widget.closeButtonTooltip,
        tabsAreaButtonsBuilder: widget.tabsAreaButtonsBuilder,
        draggableTabBuilder: widget.draggableTabBuilder,
        menuItemsUpdater: _setMenuItems,
        menuItems: _menuItems);

    Widget tabArea = TabsArea(data: data);
    ContentArea contentArea =
        ContentArea(data: data, tabsAreaVisible: widget.tabsAreaVisible);
    List<LayoutId> children = [];
    if (widget.tabsAreaVisible) {
      children.add(LayoutId(id: 1, child: tabArea));
    }
    children.add(LayoutId(id: 2, child: contentArea));
    return CustomMultiChildLayout(
        children: children, delegate: _TabbedViewLayout());
  }

  /// Set a new menu items.
  void _setMenuItems(List<TabbedViewMenuItem> menuItems) {
    setState(() {
      _menuItems = menuItems;
    });
  }

  /// Rebuilds after any change in tabs or selection.
  void _rebuildByTabOrSelection() {
    int? newTabIndex = widget.controller.selectedIndex;
    if (_lastSelectedIndex != newTabIndex) {
      _lastSelectedIndex = newTabIndex;
      if (widget.onTabSelection != null) {
        widget.onTabSelection!(newTabIndex);
      }
    }

    // rebuild
    setState(() {
      // any change must remove menus
      _menuItems.clear();
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuildByTabOrSelection);
    super.dispose();
  }
}

// Layout delegate for [TabbedView]
class _TabbedViewLayout extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    Size childSize = Size.zero;
    if (hasChild(1)) {
      childSize = layoutChild(
          1,
          BoxConstraints(
              minWidth: size.width,
              maxWidth: size.width,
              minHeight: 0,
              maxHeight: size.height));
      positionChild(1, Offset.zero);
    }
    double height = math.max(0, size.height - childSize.height);
    layoutChild(2, BoxConstraints.tightFor(width: size.width, height: height));
    positionChild(2, Offset(0, childSize.height));
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}
