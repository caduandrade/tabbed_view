import 'package:meta/meta.dart';

import '../tab_data.dart';
import '../tabbed_view_controller.dart';
import '../typedefs/on_tab_close.dart';
import '../typedefs/on_tab_move.dart';
import '../typedefs/on_tab_select.dart';

/// A facade for internal widgets to abstract whether
/// the [TabbedView] is imperative or declarative.
@internal
abstract class TabbedViewDelegate {
  void closeTab({required TabData tab});

  void moveTab(
      {required TabData sourceTab,
      required TabMoveType type,
      required TabData? targetTab});

  List<TabData> get tabs;

  void selectTab({required TabData tab});

  int? get selectedIndex;
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
  void moveTab(
      {required TabData sourceTab,
      required TabMoveType type,
      required TabData? targetTab}) {
    final int? sourceIndex = _indexFromId(sourceTab.id);
    final int? targetIndex =
        targetTab != null ? _indexFromId(targetTab.id) : null;
    if (type == TabMoveType.reorder && sourceIndex != null) {
      controller.reorderTab(sourceIndex, targetIndex ?? controller.length);
    } else if (type == TabMoveType.attach) {
      if (targetIndex == null) {
        controller.insertTab(controller.length, sourceTab);
      } else {
        controller.insertTab(targetIndex, sourceTab);
      }
    } else if (type == TabMoveType.detach && sourceIndex != null) {
      controller.removeTab(sourceIndex);
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
  DeclarativeTabbedViewDelegate(
      {required this.tabs,
      required Object? selectedTabId,
      required this.onTabClose,
      required this.onTabMove,
      required this.onTabSelect}) {
    selectedIndex = selectedTabId == null
        ? null
        : tabs.indexWhere((tab) => tab.id == selectedTabId);
  }

  @override
  final List<TabData> tabs;
  final OnTabClose? onTabClose;
  final OnTabMove? onTabMove;
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
  void moveTab(
      {required TabData sourceTab,
      required TabMoveType type,
      required TabData? targetTab}) {
    onTabMove?.call(sourceTab.id, type, targetTab?.id);
  }
}
