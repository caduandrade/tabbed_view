import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tab_data.dart';

/// Event that will be triggered when the tab is reorder.
typedef OnReorder = void Function(int oldIndex, int newIndex);

/// Interceptor for a tab closing event.
/// The tab will be closed only if the function returns `true`.
typedef TabCloseInterceptor = FutureOr<bool> Function(
    int tabIndex, TabData tabData);

/// Event that will be triggered when a tab is closed.
typedef OnTabClose = void Function(int tabIndex, TabData tabData);

/// Builder for hidden tabs menu item.
typedef HiddenTabsMenuItemBuilder = Widget Function(
    BuildContext context, int tabIndex, TabData tabData);

/// The [TabbedView] controller.
///
/// Stores tabs and selection tab index.
///
/// When a property is changed, the [TabbedView] is notified and updated appropriately.
///
/// Remember to dispose of the [TabbedView] when it is no longer needed. This will ensure we discard any resources used by the object.
class TabbedViewController extends ChangeNotifier {
  TabbedViewController(this._tabs,
      {this.onReorder, this.data, bool reorderEnable = true})
      : this._reorderEnable = reorderEnable {
    if (_tabs.isNotEmpty) {
      _selectedIndex = 0;
    }
    for (TabData tab in _tabs) {
      tab.addListener(notifyListeners);
    }
    _updateIndexes(false);
  }

  final List<TabData> _tabs;
  UnmodifiableListView<TabData> get tabs => UnmodifiableListView(_tabs);

  final dynamic data;

  int? _selectedIndex;

  final OnReorder? onReorder;

  /// The interceptor for a tab closing event.
  TabCloseInterceptor? tabCloseInterceptor;

  /// The callback for a tab closed event.
  OnTabClose? onTabClose;

  bool _reorderEnable;
  bool get reorderEnable => _reorderEnable;
  set reorderEnable(bool value) {
    if (_reorderEnable != value) {
      _reorderEnable = value;
      notifyListeners();
    }
  }

  /// The selected tab index
  int? get selectedIndex => _selectedIndex;

  /// Changes the index of the selection and notifies.
  set selectedIndex(int? tabIndex) {
    if (tabIndex != null) {
      _validateIndex(tabIndex);
    }
    _selectedIndex = tabIndex;
    notifyListeners();
  }

  /// Gets the selected tab.
  TabData? get selectedTab =>
      _selectedIndex != null ? _tabs[_selectedIndex!] : null;

  /// Reorders a tab.
  void reorderTab(int oldIndex, int newIndex) {
    if (!reorderEnable) {
      return;
    }
    if (_tabs.isEmpty) {
      throw ArgumentError('There are no tabs.');
    }
    if (oldIndex < 0 || oldIndex >= _tabs.length) {
      throw ArgumentError('Index out of range.', 'oldIndex');
    }
    if (newIndex < 0) {
      newIndex = 0;
    }
    final bool append = newIndex >= _tabs.length;

    if (oldIndex == newIndex) {
      return;
    }
    if (oldIndex == newIndex - 1) {
      return;
    }

    TabData? selectedTab;
    if (_selectedIndex != null) {
      selectedTab = _tabs[_selectedIndex!];
    }

    TabData tabToReorder = _tabs.removeAt(oldIndex);
    if (append) {
      _tabs.add(tabToReorder);
      newIndex = _tabs.length - 1;
    } else if (oldIndex > newIndex) {
      _tabs.insert(newIndex, tabToReorder);
    } else {
      _tabs.insert(newIndex - 1, tabToReorder);
    }
    _updateIndexes(false);
    if (selectedTab != null) {
      _selectedIndex = _tabs.indexOf(selectedTab);
    }
    notifyListeners();
    if (onReorder != null) {
      onReorder!(oldIndex, newIndex);
    }
  }

  int get length => _tabs.length;

  /// Inserts [TabData] at position [index] in the [tabs].
  ///
  /// The [index] value must be non-negative and no greater than [tabs.length].
  void insertTab(int index, TabData tab) {
    _tabs.insert(index, tab);
    tab.addListener(notifyListeners);
    _updateIndexes(false);
    _afterIncTabs();
  }

  /// Replaces all tabs.
  void setTabs(Iterable<TabData> iterable) {
    for (TabData tab in _tabs) {
      tab.removeListener(notifyListeners);
    }
    _updateIndexes(true);
    _tabs.clear();
    _selectedIndex = null;
    addTabs(iterable);
  }

  /// Adds multiple [TabData].
  void addTabs(Iterable<TabData> iterable) {
    _tabs.addAll(iterable);
    for (TabData tab in iterable) {
      tab.addListener(notifyListeners);
    }
    _updateIndexes(false);
    _afterIncTabs();
  }

  /// Adds a [TabData].
  void addTab(TabData tab) {
    _tabs.add(tab);
    tab.addListener(notifyListeners);
    tab._setIndex(_tabs.length - 1);
    _afterIncTabs();
  }

  /// Method that should be used after adding a tab.
  /// Updates the status and notifies.
  void _afterIncTabs() {
    if (_tabs.length == 1) {
      _selectedIndex = 0;
    }
    notifyListeners();
  }

  /// Removes a tab.
  TabData removeTab(int tabIndex) {
    _validateIndex(tabIndex);
    final int? originalSelectedIndex = _selectedIndex;
    final TabData? originalSelectedTab = selectedTab;

    TabData tabData = _tabs.removeAt(tabIndex);
    tabData.removeListener(notifyListeners);
    tabData._setIndex(-1);
    _updateIndexes(false);
    if (_tabs.isEmpty) {
      _selectedIndex = null;
    } else {
      if (originalSelectedTab != null) {
        final int newIndex = _tabs.indexOf(originalSelectedTab);
        if (newIndex != -1) {
          // The selected tab was not removed, so we keep it selected.
          _selectedIndex = newIndex;
        } else if (originalSelectedIndex != null) {
          // The selected tab was removed. Let's select the tab at the same index
          // if possible, or the new last tab.
          _selectedIndex = (originalSelectedIndex < _tabs.length)
              ? originalSelectedIndex
              : _tabs.length - 1;
        }
      }
    }
    notifyListeners();
    return tabData;
  }

  /// Removes all tabs.
  void removeTabs() {
    for (TabData tab in _tabs) {
      tab.removeListener(notifyListeners);
    }
    _updateIndexes(true);
    _tabs.clear();
    _selectedIndex = null;
    notifyListeners();
  }

  /// Closes all tabs except the one at [tabIndex].
  ///
  /// This method respects the `closable` property of each tab and the
  /// [tabCloseInterceptor]. It will only close tabs that are marked as
  /// closable and not vetoed by the interceptor.
  Future<void> closeOtherTabs(int tabIndex) async {
    _validateIndex(tabIndex);
    final tabsToRemove = await _getClosableTabs((i, tab) => i != tabIndex);
    await _closeTabs(tabsToRemove);
  }

  /// Closes all tabs to the right of the tab at [tabIndex].
  ///
  /// This method respects the `closable` property of each tab and the
  /// [tabCloseInterceptor]. It will only close tabs that are marked as
  /// closable and not vetoed by the interceptor.
  Future<void> closeTabsToTheRight(int tabIndex) async {
    _validateIndex(tabIndex);
    final tabsToRemove = await _getClosableTabs((i, tab) => i > tabIndex);
    await _closeTabs(tabsToRemove);
  }

  /// Collects a list of closable tabs based on a predicate.
  Future<List<MapEntry<int, TabData>>> _getClosableTabs(
      bool Function(int index, TabData tab) predicate) async {
    final List<MapEntry<int, TabData>> tabsToRemove = [];
    for (int i = 0; i < _tabs.length; i++) {
      final tab = _tabs[i];
      if (predicate(i, tab) && tab.closable) {
        bool canClose = await _canClose(i, tab);
        if (canClose) {
          tabsToRemove.add(MapEntry(i, tab));
        }
      }
    }
    return tabsToRemove;
  }

  /// Closes all tabs that are marked as closable.
  ///
  /// A tab is considered closable if its `TabData.closable` property is `true`.
  /// This method provides a convenient way to close multiple tabs at once.
  ///
  /// After removing the tabs, it will update the selection. If the currently
  /// selected tab is removed, the first available tab will be selected. If no
  /// tabs remain, the selection will be cleared.
  Future<void> closeAllClosableTabs() async {
    final tabsToRemove = await _getClosableTabs((i, tab) => true);
    await _closeTabs(tabsToRemove);
  }

  /// Backing method for closing multiple tabs.
  Future<void> _closeTabs(List<MapEntry<int, TabData>> tabsToRemove) async {
    final TabData? originalSelectedTab = selectedTab;
    final int? originalSelectedIndex = _selectedIndex;

    // Remove tabs from the list, from end to start to not mess up indices.
    for (final entry in tabsToRemove.reversed) {
      final tab = _tabs.removeAt(entry.key);
      tab.removeListener(notifyListeners);
      tab._setIndex(-1);
    }

    _updateIndexes(false);

    if (_tabs.isEmpty) {
      _selectedIndex = null;
    } else {
      final int newIndex = (originalSelectedTab != null)
          ? _tabs.indexOf(originalSelectedTab)
          : -1;

      if (newIndex != -1) {
        _selectedIndex = newIndex;
      } else if (originalSelectedIndex != null) {
        // Selected tab was closed.
        final int removedBeforeCount =
            tabsToRemove.where((entry) => entry.key < originalSelectedIndex).length;
        int newSelectedIndex = originalSelectedIndex - removedBeforeCount;
        if (newSelectedIndex >= _tabs.length) {
          newSelectedIndex = _tabs.length - 1;
        }
        if (newSelectedIndex < 0) {
          newSelectedIndex = 0;
        }
        _selectedIndex = newSelectedIndex;
      }
    }
    notifyListeners();

    for (final entry in tabsToRemove) {
      onTabClose?.call(entry.key, entry.value);
    }
  }

  /// Checks if a tab can be closed by running the [tabCloseInterceptor].
  Future<bool> _canClose(int tabIndex, TabData tabData) async {
    if (tabCloseInterceptor != null) {
      return await tabCloseInterceptor!(tabIndex, tabData);
    }
    return true;
  }

  /// Selects a tab.
  void selectTab(TabData tab) {
    selectedIndex = tab.index;
  }

  /// Selects a tab by its value.
  ///
  /// Does nothing if the tab is not found.
  void selectTabByValue(dynamic value) {
    final index = _tabs.indexWhere((tab) => tab.value == value);
    if (index != -1) {
      selectedIndex = index;
    }
  }

  void _validateIndex(int tabIndex) {
    if (tabIndex < 0 || tabIndex >= _tabs.length) {
      throw IndexError.withLength(tabIndex, _tabs.length,
          indexable: _tabs, name: 'tabIndex');
    }
  }

  /// Gets a tab given an index.
  TabData getTabByIndex(int index) {
    _validateIndex(index);
    return _tabs[index];
  }

  /// Gets a tab given its value.
  ///
  /// The search is linear. Returns `null` if not found.
  TabData? getTabByValue(dynamic value) {
    for (final tab in _tabs) {
      if (tab.value == value) {
        return tab;
      }
    }
    return null;
  }

  void _updateIndexes(bool clear) {
    for (int i = 0; i < _tabs.length; i++) {
      TabData tab = _tabs[i];
      tab._setIndex(clear ? -1 : i);
    }
  }
}

mixin TabIndex {
  int _index = -1;

  /// The current index in the controller.
  int get index => _index;

  void _setIndex(int newIndex) {
    _index = newIndex;
  }
}
