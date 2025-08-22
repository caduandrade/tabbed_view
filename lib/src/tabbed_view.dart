import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tabbed_view/src/content_area.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/tabbed_view_menu_item.dart';
import 'package:tabbed_view/src/tabs_area.dart';
import 'package:tabbed_view/src/typedefs/on_tab_secondary_tap.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/theme_widget.dart';
import 'package:tabbed_view/src/typedefs/on_before_drop_accept.dart';
import 'package:tabbed_view/src/typedefs/on_draggable_build.dart';
import 'package:tabbed_view/src/typedefs/can_drop.dart';

/// Defines the position of the tab bar.
enum TabBarPosition {
  /// Positions the tab bar above the content.
  top(true),

  /// Positions the tab bar below the content.
  bottom(true),

  /// Positions the tab bar on the left of the content.
  left(false),

  /// Positions the tab bar on the right of the content.
  right(false);

  const TabBarPosition(this.isHorizontal);

  final bool isHorizontal;

  bool get isVertical => !isHorizontal;
}

/// Tabs area buttons builder
typedef TabsAreaButtonsBuilder = List<TabButton> Function(
    BuildContext context, int tabsCount);

/// The event that will be triggered after the tab close.
typedef OnTabClose = void Function(int tabIndex, TabData tabData);

/// Intercepts a close event to indicates whether the tab can be closed.
typedef TabCloseInterceptor = FutureOr<bool> Function(
    int tabIndex, TabData tabData);

/// Intercepts a select event to indicate whether the tab can be selected.
typedef TabSelectInterceptor = bool Function(int newTabIndex);

/// Event that will be triggered when the tab selection is changed.
typedef OnTabSelection = void Function(TabData? tabData);

/// Widget inspired by the classic Desktop-style tab component.
///
/// Supports customizable themes.
///
/// Parameters:
/// * [selectToEnableButtons]: allows buttons to be clicked only if the tab is
///   selected. The default value is [TRUE].
/// * [closeButtonTooltip]: optional tooltip for the close button.
class TabbedView extends StatefulWidget {
  TabbedView({
    required this.controller,
    this.contentBuilder,
    this.onTabClose,
    this.tabCloseInterceptor,
    this.onTabSelection,
    this.tabSelectInterceptor,
    this.onTabSecondaryTap,
    this.selectToEnableButtons = true,
    this.contentClip = true,
    this.closeButtonTooltip,
    this.tabsAreaButtonsBuilder,
    this.tabsAreaVisible,
    this.onDraggableBuild,
    this.canDrop,
    this.onBeforeDropAccept,
    this.dragScope,
    this.tabBarPosition = TabBarPosition.top,
    this.hiddenTabsMenuItemBuilder,
    this.trailing,
  });

  final TabbedViewController controller;
  final bool contentClip;
  final IndexedWidgetBuilder? contentBuilder;
  final OnTabClose? onTabClose;
  final TabCloseInterceptor? tabCloseInterceptor;
  final OnTabSelection? onTabSelection;
  final TabSelectInterceptor? tabSelectInterceptor;
  final OnTabSecondaryTap? onTabSecondaryTap;
  final bool selectToEnableButtons;
  final String? closeButtonTooltip;
  final TabsAreaButtonsBuilder? tabsAreaButtonsBuilder;
  final bool? tabsAreaVisible;
  final OnDraggableBuild? onDraggableBuild;
  final CanDrop? canDrop;
  final OnBeforeDropAccept? onBeforeDropAccept;
  final String? dragScope;

  final HiddenTabsMenuItemBuilder? hiddenTabsMenuItemBuilder;
  final Widget? trailing;

  /// Defines the position of the tab bar. Defaults to [TabBarPosition.top].
  final TabBarPosition tabBarPosition;

  @override
  State<StatefulWidget> createState() => _TabbedViewState();
}

/// The [TabbedView] state.
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
        onTabSelection: widget.onTabSelection,
        contentClip: widget.contentClip,
        tabSelectInterceptor: widget.tabSelectInterceptor,
        onTabSecondaryTap: widget.onTabSecondaryTap,
        selectToEnableButtons: widget.selectToEnableButtons,
        closeButtonTooltip: widget.closeButtonTooltip,
        tabsAreaButtonsBuilder: widget.tabsAreaButtonsBuilder,
        onDraggableBuild: widget.onDraggableBuild,
        menuItemsUpdater: _setMenuItems,
        menuItems: _menuItems,
        onTabDrag: _onTabDrag,
        draggingTabIndex: _draggingTabIndex,
        canDrop: widget.canDrop,
        onBeforeDropAccept: widget.onBeforeDropAccept,
        dragScope: widget.dragScope,
        tabBarPosition: widget.tabBarPosition,
        hiddenTabsMenuItemBuilder: widget.hiddenTabsMenuItemBuilder,
        trailing: widget.trailing);
    final bool tabsAreaVisible =
        widget.tabsAreaVisible ?? theme.tabsArea.visible;
    List<LayoutId> children = [];
    if (tabsAreaVisible) {
      Widget tabArea = TabsArea(provider: provider);
      children.add(LayoutId(id: 1, child: tabArea));
    }
    Widget contentArea =
        ContentArea(provider: provider, tabsAreaVisible: tabsAreaVisible);
    children.add(LayoutId(id: 2, child: contentArea));
    return CustomMultiChildLayout(
        children: children,
        delegate: _TabbedViewLayout(tabBarPosition: widget.tabBarPosition));
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
        widget.onTabSelection!(widget.controller.selectedTab);
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
  _TabbedViewLayout({required this.tabBarPosition});

  final TabBarPosition tabBarPosition;

  @override
  void performLayout(Size size) {
    if (tabBarPosition == TabBarPosition.top ||
        tabBarPosition == TabBarPosition.bottom) {
      _performHorizontalLayout(size);
    } else {
      _performVerticalLayout(size);
    }
  }

  void _performHorizontalLayout(Size size) {
    double tabsAreaHeight = 0;
    if (hasChild(1)) {
      final tabsAreaSize = layoutChild(
          1, BoxConstraints(maxWidth: size.width, maxHeight: size.height));
      tabsAreaHeight = tabsAreaSize.height;
    }

    final double contentAreaHeight = math.max(0, size.height - tabsAreaHeight);
    final contentAreaSize = Size(size.width, contentAreaHeight);
    layoutChild(2, BoxConstraints.tight(contentAreaSize));

    if (tabBarPosition == TabBarPosition.bottom) {
      positionChild(2, Offset.zero);
      if (hasChild(1)) {
        positionChild(1, Offset(0, contentAreaHeight));
      }
    } else {
      // top
      if (hasChild(1)) {
        positionChild(1, Offset.zero);
      }
      positionChild(2, Offset(0, tabsAreaHeight));
    }
  }

  void _performVerticalLayout(Size size) {
    double tabsAreaWidth = 0;
    if (hasChild(1)) {
      final tabsAreaSize = layoutChild(
          1, BoxConstraints(maxWidth: size.width, maxHeight: size.height));
      tabsAreaWidth = tabsAreaSize.width;
    }

    final double contentAreaWidth = math.max(0, size.width - tabsAreaWidth);
    final contentAreaSize = Size(contentAreaWidth, size.height);
    layoutChild(2, BoxConstraints.tight(contentAreaSize));

    if (tabBarPosition == TabBarPosition.right) {
      positionChild(2, Offset.zero);
      if (hasChild(1)) {
        positionChild(1, Offset(contentAreaWidth, 0));
      }
    } else {
      // left
      if (hasChild(1)) {
        positionChild(1, Offset.zero);
      }
      positionChild(2, Offset(tabsAreaWidth, 0));
    }
  }

  @override
  bool shouldRelayout(covariant _TabbedViewLayout oldDelegate) {
    return oldDelegate.tabBarPosition != tabBarPosition;
  }
}
