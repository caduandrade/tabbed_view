import 'package:meta/meta.dart';

import '../tab_data.dart';
import '../tabbed_view_controller.dart';
import '../typedefs/on_tab_close.dart';
import '../typedefs/on_tab_drag.dart';
import '../typedefs/on_tab_select.dart';

/// A facade for internal widgets to abstract whether
/// the [TabbedView] is imperative or declarative.
@internal
abstract class TabbedViewDelegate {
  List<TabData> get tabs;

  void selectTab({required TabData tab});

  int? get selectedIndex;

  void closeTab({required TabData tab});

  void reorderTab(
    TabData tab,
    TabData? targetTab,
  );

  void detachTab(
    TabData tab,
  );

  void attachTab(
    TabData tab,
    TabData? targetTab,
  );
}

@internal
class ImperativeTabbedViewDelegate extends TabbedViewDelegate {
  ImperativeTabbedViewDelegate({required this.controller});

  final TabbedViewController controller;

  @override
  List<TabData> get tabs => controller.tabs;

  int? _indexFromId(Object tabId) {
    int index = tabs.indexWhere((tab) => tab.id == tabId);
    return index > -1 ? index : null;
  }

  @override
  void closeTab({required TabData tab}) {
    final int? index = _indexFromId(tab.id);
    if (index != null) {
      controller.removeTab(index);
    }
  }

  @override
  void reorderTab(TabData tab, TabData? targetTab) {
    final int? sourceIndex = _indexFromId(tab.id);
    final int? targetIndex =
        targetTab != null ? _indexFromId(targetTab.id) : null;
    if (sourceIndex != null) {
      controller.reorderTab(sourceIndex, targetIndex ?? controller.length);
    }
  }

  @override
  void detachTab(TabData tab) {
    final int? index = _indexFromId(tab.id);
    if (index != null) {
      controller.removeTab(index);
    }
  }

  @override
  void attachTab(TabData tab, TabData? targetTab) {
    final int? targetIndex =
        targetTab != null ? _indexFromId(targetTab.id) : null;
    if (targetIndex == null) {
      controller.insertTab(controller.length, tab);
    } else {
      controller.insertTab(targetIndex, tab);
    }
  }

  @override
  void selectTab({required TabData tab}) {
    final int? index = _indexFromId(tab.id);
    if (index != null) {
      controller.selectedIndex = index;
    }
  }

  @override
  int? get selectedIndex => controller.selectedIndex;
}

@internal
class DeclarativeTabbedViewDelegate extends TabbedViewDelegate {
  DeclarativeTabbedViewDelegate({
    required this.tabs,
    required Object? selectedTabId,
    required this.onTabClose,
    required this.onTabReorder,
    required this.onTabAttach,
    required this.onTabDetach,
    required this.onTabSelect,
  }) {
    selectedIndex = selectedTabId == null
        ? null
        : tabs.indexWhere((tab) => tab.id == selectedTabId);
  }

  @override
  final List<TabData> tabs;
  final OnTabClose? onTabClose;
  final OnTabReorder? onTabReorder;
  final OnTabDetach? onTabDetach;
  final OnTabAttach? onTabAttach;
  final OnTabSelect? onTabSelect;

  @override
  void selectTab({required TabData tab}) {
    onTabSelect?.call(tab.id);
  }

  @override
  late final int? selectedIndex;

  @override
  void closeTab({required TabData tab}) {
    onTabClose?.call(tab.id);
  }

  @override
  void reorderTab(TabData tab, TabData? targetTab) {
    onTabReorder?.call(tab.id, targetTab?.id);
  }

  @override
  void detachTab(TabData tab) {
    onTabDetach?.call(tab.id);
  }

  @override
  void attachTab(TabData tab, TabData? targetTab) {
    onTabAttach?.call(tab.id, targetTab?.id);
  }
}
