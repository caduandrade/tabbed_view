import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'tab_data.dart';
import 'typedefs/on_tab_remove.dart';
import 'typedefs/on_tab_reorder.dart';
import 'typedefs/on_tab_selected.dart';

/// The [TabbedView] controller.
///
/// Stores tabs and selection tab index.
///
/// When a property is changed, the [TabbedView] is notified and updated appropriately.
///
/// Remember to dispose of the [TabbedView] when it is no longer needed. This will ensure we discard any resources used by the object.
class TabbedViewController extends ChangeNotifier {
  TabbedViewController(this._tabs,
      {this.data, this.onTabSelected, this.onTabRemove, this.onTabReorder}) {
    if (_tabs.isNotEmpty) {
      _selection = TabSelection(tab: _tabs.first, index: 0);
    }
    for (TabData tab in _tabs) {
      tab.addListener(notifyListeners);
    }
    _updateIndexes(false);

    if (!kReleaseMode) {
      assert(TabDataHelper.assertUniqueIds(tabs));
    }
  }

  /// Callback triggered when a tab is removed.
  OnTabRemove? onTabRemove;

  /// Callback triggered when a tab is reordered.
  OnTabReorder? onTabReorder;
  OnTabSelected? onTabSelected;

  final List<TabData> _tabs;

  UnmodifiableListView<TabData> get tabs => UnmodifiableListView(_tabs);

  final dynamic data;

  TabSelection? _selection;

  /// The selected tab index
  int? get selectedIndex => _selection?.index;

  void _updateSelection(int? tabIndex) {
    final TabSelection? oldSelection = _selection;
    _selection = tabIndex != null
        ? TabSelection(index: tabIndex, tab: _tabs[tabIndex])
        : null;
    if (oldSelection != _selection) {
      onTabSelected?.call(_selection);
    }
  }

  /// Changes the index of the selection and notifies.
  set selectedIndex(int? tabIndex) {
    if (tabIndex != null) {
      _validateIndex(tabIndex);
    }
    _updateSelection(tabIndex);
    notifyListeners();
  }

  /// Gets the selected tab.
  TabData? get selectedTab =>
      selectedIndex != null ? _tabs[selectedIndex!] : null;

  /// Reorders a tab.
  bool reorderTab(int oldIndex, int newIndex) {
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
      return false;
    }
    if (oldIndex == newIndex - 1) {
      return false;
    }

    TabData? selectedTab;
    if (selectedIndex != null) {
      selectedTab = _tabs[selectedIndex!];
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
      _updateSelection(_tabs.indexOf(selectedTab));
    }
    notifyListeners();
    onTabReorder?.call(oldIndex, newIndex);
    return true;
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

    if (!kReleaseMode) {
      assert(TabDataHelper.assertUniqueIds(tabs));
    }
  }

  /// Replaces all tabs.
  void setTabs(Iterable<TabData> iterable) {
    for (TabData tab in _tabs) {
      tab.removeListener(notifyListeners);
    }
    _updateIndexes(true);
    _tabs.clear();
    _updateSelection(null);
    addTabs(iterable);

    if (!kReleaseMode) {
      assert(TabDataHelper.assertUniqueIds(tabs));
    }
  }

  /// Adds multiple [TabData].
  void addTabs(Iterable<TabData> iterable) {
    _tabs.addAll(iterable);
    for (TabData tab in iterable) {
      tab.addListener(notifyListeners);
    }
    _updateIndexes(false);
    _afterIncTabs();

    if (!kReleaseMode) {
      assert(TabDataHelper.assertUniqueIds(tabs));
    }
  }

  /// Adds a [TabData].
  void addTab(TabData tab) {
    _tabs.add(tab);
    tab.addListener(notifyListeners);
    TabDataHelper.setIndex(tab, _tabs.length - 1);
    _afterIncTabs();

    if (!kReleaseMode) {
      assert(TabDataHelper.assertUniqueIds(tabs));
    }
  }

  /// Method that should be used after adding a tab.
  /// Updates the status and notifies.
  void _afterIncTabs() {
    if (_tabs.length == 1) {
      _updateSelection(0);
    }
    notifyListeners();
  }

  /// Removes a tab.
  TabData removeTab(int tabIndex) {
    _validateIndex(tabIndex);
    final int? originalSelectedIndex = selectedIndex;
    final TabData? originalSelectedTab = selectedTab;

    TabData tabData = _tabs.removeAt(tabIndex);
    tabData.removeListener(notifyListeners);
    TabDataHelper.setIndex(tabData, -1);
    _updateIndexes(false);
    if (_tabs.isEmpty) {
      _updateSelection(null);
    } else {
      if (originalSelectedTab != null) {
        final int newIndex = _tabs.indexOf(originalSelectedTab);
        if (newIndex != -1) {
          // The selected tab was not removed, so we keep it selected.
          _updateSelection(newIndex);
        } else if (originalSelectedIndex != null) {
          // The selected tab was removed. Let's select the tab at the same index
          // if possible, or the new last tab.
          _updateSelection((originalSelectedIndex < _tabs.length)
              ? originalSelectedIndex
              : _tabs.length - 1);
        }
      }
    }
    notifyListeners();
    onTabRemove?.call(tabData);
    return tabData;
  }

  /// Removes all tabs.
  void removeTabs() {
    final removedTabs = List<TabData>.from(_tabs);
    for (TabData tab in _tabs) {
      tab.removeListener(notifyListeners);
    }
    _updateIndexes(true);
    _tabs.clear();
    _updateSelection(null);
    notifyListeners();
    for (final tab in removedTabs) {
      onTabRemove?.call(tab);
    }
  }

  /// Selects a tab.
  void selectTab(TabData tab) {
    selectedIndex = TabDataHelper.indexFrom(tab);
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
      TabDataHelper.setIndex(tab, clear ? -1 : i);
    }
  }
}
