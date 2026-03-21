import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'internal/content_area.dart';
import 'internal/tabbed_view_provider.dart';
import 'internal/tabbed_view_source.dart';
import 'internal/tabs_area/tabs_area.dart';
import 'tab_bar_position.dart';
import 'tabbed_view_controller.dart';
import 'theme/tabbed_view_theme_data.dart';
import 'tab_data.dart';
import 'theme/theme_widget.dart';
import 'typedefs/can_drop.dart';
import 'typedefs/on_before_drop_accept.dart';
import 'typedefs/on_draggable_build.dart';
import 'typedefs/on_tab_secondary_tap.dart';
import 'typedefs/tab_remove_interceptor.dart';
import 'typedefs/tabs_area_buttons_builder.dart';
import 'unselected_tab_buttons_behavior.dart';

/// Widget inspired by the classic Desktop-style tab component.
///
/// Supports customizable themes.
///
/// Parameters:
/// * [closeButtonTooltip]: optional tooltip for the close button.
class TabbedView extends StatefulWidget {
  static const bool _defaultTabReorderEnabled = true;
  static const UnselectedTabButtonsBehavior _defaultUnselectedBehavior =
      UnselectedTabButtonsBehavior.allDisabled;
  static const bool _defaultContentClip = true;

  TabbedView._({
    required this.delegate,
    required this.controller,
    required this.contentBuilder,
    required this.tabReorderEnabled,
    required this.onTabSecondaryTap,
    required this.unselectedTabButtonsBehavior,
    required this.contentClip,
    required this.closeButtonTooltip,
    required this.tabsAreaButtonsBuilder,
    required this.tabsAreaVisible,
    required this.onDraggableBuild,
    required this.canDrop,
    required this.onBeforeDropAccept,
    required this.dragScope,
    required this.tabRemoveInterceptor,
    required this.trailing,
  });

  factory TabbedView({
    required TabbedViewController controller,
    IndexedWidgetBuilder? contentBuilder,
    bool? tabReorderEnabled,
    OnTabSecondaryTap? onTabSecondaryTap,
    UnselectedTabButtonsBehavior? unselectedTabButtonsBehavior,
    bool? contentClip,
    String? closeButtonTooltip,
    TabsAreaButtonsBuilder? tabsAreaButtonsBuilder,
    bool? tabsAreaVisible,
    OnDraggableBuild? onDraggableBuild,
    CanDrop? canDrop,
    OnBeforeDropAccept? onBeforeDropAccept,
    String? dragScope,
    TabRemoveInterceptor? tabRemoveInterceptor,
    Widget? trailing,
  }) {
    return TabbedView._(
      delegate: _ImperativeTabbedViewDelegate(controller: controller),
      controller: controller,
      contentBuilder: contentBuilder,
      tabReorderEnabled: tabReorderEnabled ?? _defaultTabReorderEnabled,
      onTabSecondaryTap: onTabSecondaryTap,
      unselectedTabButtonsBehavior:
          unselectedTabButtonsBehavior ?? _defaultUnselectedBehavior,
      contentClip: contentClip ?? _defaultContentClip,
      closeButtonTooltip: closeButtonTooltip,
      tabsAreaButtonsBuilder: tabsAreaButtonsBuilder,
      tabsAreaVisible: tabsAreaVisible,
      onDraggableBuild: onDraggableBuild,
      canDrop: canDrop,
      onBeforeDropAccept: onBeforeDropAccept,
      dragScope: dragScope,
      tabRemoveInterceptor: tabRemoveInterceptor,
      trailing: trailing,
    );
  }

  final TabbedViewDelegate delegate;
  final TabbedViewController controller;
  final bool contentClip;
  final IndexedWidgetBuilder? contentBuilder;
  final bool tabReorderEnabled;
  final TabRemoveInterceptor? tabRemoveInterceptor;
  final OnTabSecondaryTap? onTabSecondaryTap;
  final UnselectedTabButtonsBehavior unselectedTabButtonsBehavior;
  final String? closeButtonTooltip;
  final TabsAreaButtonsBuilder? tabsAreaButtonsBuilder;
  final bool? tabsAreaVisible;
  final OnDraggableBuild? onDraggableBuild;
  final CanDrop? canDrop;
  final OnBeforeDropAccept? onBeforeDropAccept;
  final String? dragScope;
  final Widget? trailing;

  @override
  State<StatefulWidget> createState() => _TabbedViewState();
}

@internal
abstract class TabbedViewDelegate {
  //TODO tentar simplificar para:
  //tabs
  //selectedTab
  //onTabSelected
  //onTabClosed
  //onTabMoved

  /// Inserts [TabData] at position [index] in the [tabs].
  ///
  /// The [index] value must be non-negative and no greater than [tabs.length].
  void insertTab(int index, TabData tab);

  /// Removes a tab.
  void removeTab(int index);

  /// Reorders a tab.
  bool reorderTab(int oldIndex, int newIndex);

  TabData getTab(int index);

  int indexOf(TabData tab);

  int get tabCount;

  int? get selectedIndex;

  void set selectedIndex(int? value);
}

class _ImperativeTabbedViewDelegate extends TabbedViewDelegate {
  _ImperativeTabbedViewDelegate({required this.controller});

  final TabbedViewController controller;

  @override
  void insertTab(int index, TabData tab) => controller.insertTab(index, tab);

  @override
  void removeTab(int tabIndex) => controller.removeTab(tabIndex);

  @override
  bool reorderTab(int oldIndex, int newIndex) =>
      controller.reorderTab(oldIndex, newIndex);

  @override
  TabData getTab(int index) => controller.tabs[index];

  @override
  int get tabCount => controller.tabs.length;

  @override
  int? get selectedIndex => controller.selectedIndex;

  @override
  set selectedIndex(int? value) => controller.selectedIndex = value;

  @override
  int indexOf(TabData tab) => controller.tabs.indexOf(tab);
}

abstract class _DeclarativeTabbedViewDelegate extends TabbedViewDelegate {}

/// The [TabbedView] state.
class _TabbedViewState extends State<TabbedView> {
  final TabbedViewSource _source = TabbedViewSource();
  int? _draggingTabIndex;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuildByTabOrSelection);
  }

  @override
  void didUpdateWidget(covariant TabbedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_rebuildByTabOrSelection);
      widget.controller.addListener(_rebuildByTabOrSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    TabbedViewThemeData theme = TabbedViewTheme.of(context);

    TabbedViewProvider provider = TabbedViewProvider(
        delegate: widget.delegate,
        source: _source,
        contentBuilder: widget.contentBuilder,
        tabReorderEnabled: widget.tabReorderEnabled,
        tabRemoveInterceptor: widget.tabRemoveInterceptor,
        contentClip: widget.contentClip,
        onTabSecondaryTap: widget.onTabSecondaryTap,
        unselectedTabButtonsBehavior: widget.unselectedTabButtonsBehavior,
        closeButtonTooltip: widget.closeButtonTooltip,
        tabsAreaButtonsBuilder: widget.tabsAreaButtonsBuilder,
        onDraggableBuild: widget.onDraggableBuild,
        onTabDrag: _onTabDrag,
        draggingTabIndex: _draggingTabIndex,
        canDrop: widget.canDrop,
        onBeforeDropAccept: widget.onBeforeDropAccept,
        dragScope: widget.dragScope,
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
        delegate: _TabbedViewLayout(tabBarPosition: theme.tabsArea.position));
  }

  void _onTabDrag(int? tabIndex) {
    if (mounted) {
      setState(() {
        _draggingTabIndex = tabIndex;
      });
    }
  }

  /// Rebuilds after any change in tabs or selection.
  void _rebuildByTabOrSelection() {
    // rebuild
    setState(() {});
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
    return true;
  }
}
