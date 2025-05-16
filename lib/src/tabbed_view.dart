import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tabbed_view/src/content_area.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/tabbed_view_menu_item.dart';
import 'package:tabbed_view/src/tabs_area.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/theme_widget.dart';
import 'package:tabbed_view/src/typedefs/on_before_drop_accept.dart';
import 'package:tabbed_view/src/typedefs/on_draggable_build.dart';
import 'package:tabbed_view/src/typedefs/can_drop.dart';

typedef TabsAreaButtonsBuilder = List<TabButton> Function(
    BuildContext context, int tabsCount);

typedef OnTabClose = void Function(int tabIndex, TabData tabData);

typedef TabCloseInterceptor = bool Function(int tabIndex);

typedef TabCloseConfirmationDialogBuilder = Widget Function(
    BuildContext context, int tabIndex, TabData tabData);

typedef TabSelectInterceptor = bool Function(int newTabIndex);

typedef OnTabSelection = Function(int? newTabIndex);

class TabbedView extends StatefulWidget {
  /// Widget inspired by the classic Desktop-style tab component.
  ///
  /// Supports customizable themes.
  ///
  /// Parameters:
  /// * [selectToEnableButtons]: allows buttons to be clicked only if the tab is
  ///   selected. The default value is [TRUE].
  /// * [closeButtonTooltip]: optional tooltip for the close button.
  TabbedView(
      {required this.controller,
      this.contentBuilder,
      this.onTabClose,
      this.tabCloseInterceptor,
      this.onTabSelection,
      this.tabSelectInterceptor,
      this.tabCloseConfirmationDialogBuilder,
      this.selectToEnableButtons = true,
      this.contentClip = true,
      this.closeButtonTooltip,
      this.tabsAreaButtonsBuilder,
      this.tabsAreaVisible,
      this.onDraggableBuild,
      this.canDrop,
      this.onBeforeDropAccept});

  final TabbedViewController controller;
  final bool contentClip;
  final IndexedWidgetBuilder? contentBuilder;

  /// The event that will be triggered after the tab close.
  final OnTabClose? onTabClose;

  /// Intercepts a close event to indicates whether the tab can be closed.
  ///
  /// if [tabCloseConfirmationDialogBuilder] is not null, then thisfunction iscalled after the dialog is dismissed.
  final TabCloseInterceptor? tabCloseInterceptor;

  /// a function that returns a widget that will be displayed as a non-dismissable dialog when attempting to close a tab.
  ///
  /// the dialog widget should call `navigator.of(context).pop<bool>()` at some point to exit the dialog and return a response to the tab widget, returning `false` will dissmiss the close action.
  ///
  /// asynchrenous workflows can be used inside the dialog widget, but ensure that they are awaited before navigating back.
  final TabCloseConfirmationDialogBuilder? tabCloseConfirmationDialogBuilder;

  /// Event that will be triggered when the tab selection is changed.
  final OnTabSelection? onTabSelection;

  /// Intercepts a select event to indicate whether the tab can be selected.
  final TabSelectInterceptor? tabSelectInterceptor;
  final bool selectToEnableButtons;
  final String? closeButtonTooltip;

  /// Tabs area buttons builder
  final TabsAreaButtonsBuilder? tabsAreaButtonsBuilder;
  final bool? tabsAreaVisible;
  final OnDraggableBuild? onDraggableBuild;
  final CanDrop? canDrop;
  final OnBeforeDropAccept? onBeforeDropAccept;

  @override
  State<StatefulWidget> createState() => _TabbedViewState();
}

class _TabbedViewState extends State<TabbedView> {
  int? _lastSelectedIndex;
  List<TabbedViewMenuItem> _menuItems = [];
  int? _draggingTabIndex;

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
    TabbedViewThemeData theme = TabbedViewTheme.of(context);

    TabbedViewProvider provider = TabbedViewProvider(
        controller: widget.controller,
        contentBuilder: widget.contentBuilder,
        onTabClose: widget.onTabClose,
        tabCloseInterceptor: widget.tabCloseInterceptor,
        tabCloseConfirmationDialogBuilder:
            widget.tabCloseConfirmationDialogBuilder,
        onTabSelection: widget.onTabSelection,
        contentClip: widget.contentClip,
        tabSelectInterceptor: widget.tabSelectInterceptor,
        selectToEnableButtons: widget.selectToEnableButtons,
        closeButtonTooltip: widget.closeButtonTooltip,
        tabsAreaButtonsBuilder: widget.tabsAreaButtonsBuilder,
        onDraggableBuild: widget.onDraggableBuild,
        menuItemsUpdater: _setMenuItems,
        menuItems: _menuItems,
        onTabDrag: _onTabDrag,
        draggingTabIndex: _draggingTabIndex,
        canDrop: widget.canDrop,
        onBeforeDropAccept: widget.onBeforeDropAccept);

    final bool tabsAreaVisible =
        widget.tabsAreaVisible ?? theme.tabsArea.visible;
    List<LayoutId> children = [];
    if (tabsAreaVisible) {
      Widget tabArea = TabsArea(provider: provider);
      children.add(LayoutId(id: 1, child: tabArea));
    }
    ContentArea contentArea =
        ContentArea(provider: provider, tabsAreaVisible: tabsAreaVisible);
    children.add(LayoutId(id: 2, child: contentArea));
    return CustomMultiChildLayout(
        children: children, delegate: _TabbedViewLayout());
  }

  void _onTabDrag(int? tabIndex) {
    if (mounted) {
      setState(() {
        _draggingTabIndex = tabIndex;
      });
    }
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
