import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../tabbed_view.dart';
import '../typedefs/can_drop.dart';
import '../typedefs/on_before_drop_accept.dart';
import '../typedefs/on_draggable_build.dart';
import '../typedefs/on_tab_secondary_tap.dart';
import '../typedefs/tab_remove_interceptor.dart';
import '../typedefs/tabs_area_buttons_builder.dart';
import '../unselected_tab_buttons_behavior.dart';
import 'tabbed_view_source.dart';

/// Propagates parameters to internal widgets.
@internal
class TabbedViewProvider {
  TabbedViewProvider(
      {required this.source,
      required this.delegate,
      required this.contentBuilder,
      required this.tabReorderEnabled,
      required this.contentClip,
      required this.unselectedTabButtonsBehavior,
      required this.closeButtonTooltip,
      required this.tabsAreaButtonsBuilder,
      required this.tabRemoveInterceptor,
      required this.onTabSecondaryTap,
      required this.onTabDrag,
      required this.draggingTabIndex,
      required this.onDraggableBuild,
      required this.canDrop,
      required this.onBeforeDropAccept,
      required this.dragScope,
      required this.trailing});

  final TabbedViewSource source;
  final TabbedViewDelegate delegate;
  final bool contentClip;
  final IndexedWidgetBuilder? contentBuilder;
  final bool tabReorderEnabled;
  final TabRemoveInterceptor? tabRemoveInterceptor;
  final OnTabSecondaryTap? onTabSecondaryTap;
  final UnselectedTabButtonsBehavior unselectedTabButtonsBehavior;
  final String? closeButtonTooltip;
  final TabsAreaButtonsBuilder? tabsAreaButtonsBuilder;
  final OnTabDrag onTabDrag;
  final int? draggingTabIndex;
  final OnDraggableBuild? onDraggableBuild;
  final CanDrop? canDrop;
  final OnBeforeDropAccept? onBeforeDropAccept;
  final String? dragScope;
  final Widget? trailing;
}

/// Event that will be triggered when the tab drag start or end.
typedef OnTabDrag = Function(int? tabIndex);
