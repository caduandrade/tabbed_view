import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/tabbed_view.dart'
    show
        OnTabClose,
        OnTabSelection,
        TabBarPosition,
        TabCloseInterceptor,
        TabSelectInterceptor,
        TabsAreaButtonsBuilder;
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/tabbed_view_menu_item.dart';
import 'package:tabbed_view/src/typedefs/on_before_drop_accept.dart';
import 'package:tabbed_view/src/typedefs/on_draggable_build.dart';
import 'package:tabbed_view/src/typedefs/can_drop.dart';

/// Propagates parameters to internal widgets.
@internal
class TabbedViewProvider {
  TabbedViewProvider(
      {required this.controller,
      this.contentBuilder,
      this.onTabClose,
      this.tabCloseInterceptor,
      required this.contentClip,
      this.onTabSelection,
      this.tabSelectInterceptor,
      required this.selectToEnableButtons,
      this.closeButtonTooltip,
      this.tabsAreaButtonsBuilder,
      required this.menuItems,
      required this.menuItemsUpdater,
      required this.onTabDrag,
      required this.draggingTabIndex,
      required this.onDraggableBuild,
      required this.canDrop,
      required this.onBeforeDropAccept,
      required this.dragScope,
      required this.tabBarPosition});

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
  final List<TabbedViewMenuItem> menuItems;
  final MenuItemsUpdater menuItemsUpdater;
  final OnTabDrag onTabDrag;
  final int? draggingTabIndex;
  final OnDraggableBuild? onDraggableBuild;
  final CanDrop? canDrop;
  final OnBeforeDropAccept? onBeforeDropAccept;
  final String? dragScope;
  final TabBarPosition tabBarPosition;
}

/// Updater for menu items
typedef MenuItemsUpdater = void Function(List<TabbedViewMenuItem>);

/// Event that will be triggered when the tab drag start or end.
typedef OnTabDrag = Function(int? tabIndex);
