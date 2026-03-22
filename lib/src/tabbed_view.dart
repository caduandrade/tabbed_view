import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'internal/content_area.dart';
import 'internal/tabbed_view_delegate.dart';
import 'internal/tabbed_view_provider.dart';
import 'internal/tabbed_view_source.dart';
import 'internal/tabs_area/tabs_area.dart';
import 'tab_bar_position.dart';
import 'tab_data.dart';
import 'tabbed_view_controller.dart';
import 'theme/tabbed_view_theme_data.dart';
import 'theme/theme_widget.dart';
import 'typedefs/can_drop.dart';
import 'typedefs/on_before_drop_accept.dart';
import 'typedefs/on_draggable_build.dart';
import 'typedefs/on_tab_close.dart';
import 'typedefs/on_tab_move.dart';
import 'typedefs/on_tab_secondary_tap.dart';
import 'typedefs/on_tab_select.dart';
import 'typedefs/tab_remove_interceptor.dart';
import 'typedefs/tabs_area_buttons_builder.dart';
import 'unselected_tab_buttons_behavior.dart';

/// Widget inspired by the classic Desktop-style tab component.
///
/// Supports customizable themes.
class TabbedView extends StatefulWidget {
  static const bool _defaultTabReorderEnabled = true;
  static const UnselectedTabButtonsBehavior _defaultUnselectedBehavior =
      UnselectedTabButtonsBehavior.allDisabled;
  static const bool _defaultContentClip = true;

  TabbedView._({
    required this.delegate,
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
      delegate: ImperativeTabbedViewDelegate(controller: controller),
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

  /// Creates a [TabbedView] using a declarative configuration.
  ///
  /// In this mode, the state of the tabs (including order, selection, insertion,
  /// and removal) is fully controlled by the caller. The widget reflects the
  /// provided data and emits intent callbacks when user interactions occur.
  ///
  /// The [tabs] collection defines the current tabs to be displayed.
  ///
  /// The [tabs] collection must be treated as immutable.
  ///
  /// Any change to the tab list must trigger a rebuild of [TabbedView].
  /// Mutating the collection without rebuilding may lead to inconsistent state.
  ///
  /// Each [TabData] must have a unique and stable [TabData.id]. This identifier
  /// is used to track tabs across rebuilds, including selection, reordering,
  /// and state preservation.
  ///
  /// The [selectedTabId] defines which tab is currently selected.
  ///
  /// If `null`, no tab is selected. If the provided id does not match any tab
  /// in [tabs], no tab will be selected.
  ///
  /// This value must be kept in sync with [tabs]. When the selected tab changes,
  /// the caller is responsible for updating [selectedTabId] and rebuilding the
  /// widget accordingly.
  ///
  /// The [onTabSelect] callback is triggered when the user requests to select
  /// a tab. This represents an intent only — the selection will not change
  /// unless the caller updates [selectedTabId].
  ///
  /// The [onTabClose] callback is triggered when the user requests to close
  /// a tab. The caller is responsible for removing the corresponding tab
  /// from [tabs] and rebuilding the widget.
  ///
  /// The [onTabMove] callback is triggered when the user requests to move
  /// a tab, either within the same [TabbedView] or across different instances.
  /// The caller must update the tab list accordingly (reorder, insert, or remove)
  /// and rebuild the widget.
  ///
  /// All callbacks in this constructor represent user intent. The widget does
  /// not modify the tab state internally.
  ///
  /// See also:
  ///
  /// * [TabbedView] for the controller-based (imperative) configuration.
  factory TabbedView.declarative({
    required List<TabData> tabs,
    Object? selectedTabId,
    OnTabClose? onTabClose,
    OnTabMove? onTabMove,
    OnTabSelect? onTabSelect,
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
      delegate: DeclarativeTabbedViewDelegate(
          tabs: tabs,
          selectedTabId: selectedTabId,
          onTabClose: onTabClose,
          onTabMove: onTabMove,
          onTabSelect: onTabSelect),
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

/// The [TabbedView] state.
class _TabbedViewState extends State<TabbedView> {
  final TabbedViewSource _source = TabbedViewSource();
  int? _draggingTabIndex;

  @override
  void initState() {
    super.initState();
    final TabbedViewDelegate delegate = widget.delegate;
    if (delegate is ImperativeTabbedViewDelegate) {
      delegate.controller.addListener(_rebuildByTabOrSelection);
    }
  }

  @override
  void didUpdateWidget(covariant TabbedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    TabbedViewController? oldController;
    final TabbedViewDelegate oldDelegate = oldWidget.delegate;
    if (oldDelegate is ImperativeTabbedViewDelegate) {
      oldController = oldDelegate.controller;
    }

    TabbedViewController? newController;
    final TabbedViewDelegate newDelegate = widget.delegate;
    if (newDelegate is ImperativeTabbedViewDelegate) {
      newController = newDelegate.controller;
    }

    if (newController != oldController) {
      oldController?.removeListener(_rebuildByTabOrSelection);
      newController?.addListener(_rebuildByTabOrSelection);
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
    final TabbedViewDelegate delegate = widget.delegate;
    if (delegate is ImperativeTabbedViewDelegate) {
      delegate.controller.removeListener(_rebuildByTabOrSelection);
    }
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
