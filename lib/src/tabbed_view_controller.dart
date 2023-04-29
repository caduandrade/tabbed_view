import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tab_data.dart';

/// Event that will be triggered when the tab is reorder.
typedef OnReorder = void Function(int oldIndex, int newIndex);

/// The [TabbedView] controller.
///
/// Stores tabs and selection tab index.
///
/// When a property is changed, the [TabbedView] is notified and updated appropriately.
///
/// Remember to dispose of the [TabbedView] when it is no longer needed. This will ensure we discard any resources used by the object.
class TabbedViewController extends ChangeNotifier {
  factory TabbedViewController(List<TabData> tabs, {OnReorder? onReorder}) {
    return TabbedViewController._(tabs, onReorder);
  }

  TabbedViewController._(this._tabs, this.onReorder) {
    if (_tabs.length > 0) {
      _selectedIndex = 0;
    }
    for (TabData tab in _tabs) {
      tab.addListener(notifyListeners);
    }
  }

  final List<TabData> _tabs;

  int? _selectedIndex;

  final OnReorder? onReorder;

  UnmodifiableListView<TabData> get tabs => UnmodifiableListView(_tabs);

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
    if (_tabs.isEmpty) {
      throw ArgumentError('There are no tabs.');
    }
    if (oldIndex < 0 || oldIndex >= _tabs.length) {
      throw ArgumentError('Index out of range.', 'oldIndex');
    }
    if (newIndex < 0 || newIndex >= _tabs.length) {
      throw ArgumentError('Index out of range.', 'newIndex');
    }
    if (oldIndex != newIndex) {
      TabData? selectedTab;
      if (_selectedIndex != null) {
        selectedTab = _tabs[_selectedIndex!];
      }

      TabData tab = _tabs.removeAt(oldIndex);
      _tabs.insert(newIndex, tab);
      if (selectedTab != null) {
        _selectedIndex = _tabs.indexOf(selectedTab);
      }
      notifyListeners();
      if (onReorder != null) {
        onReorder!(oldIndex, newIndex);
      }
    }
  }

  /// Inserts [TabData] at position [index] in the [tabs].
  ///
  /// The [index] value must be non-negative and no greater than [tabs.length].
  void insertTab(int index, TabData tab) {
    _tabs.insert(index, tab);
    tab.addListener(notifyListeners);
    _afterIncTabs();
  }

  /// Replaces all tabs.
  void setTabs(Iterable<TabData> iterable) {
    for (TabData tab in _tabs) {
      tab.removeListener(notifyListeners);
    }
    _tabs.clear();
    _selectedIndex = null;
    _tabs.addAll(iterable);
    for (TabData tab in iterable) {
      tab.addListener(notifyListeners);
    }
    _afterIncTabs();
  }

  /// Adds multiple [TabData].
  void addTabs(Iterable<TabData> iterable) {
    _tabs.addAll(iterable);
    for (TabData tab in iterable) {
      tab.addListener(notifyListeners);
    }
    _afterIncTabs();
  }

  /// Adds a [TabData].
  void addTab(TabData tab) {
    _tabs.add(tab);
    tab.addListener(notifyListeners);
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
    TabData tabData = _tabs.removeAt(tabIndex);
    tabData.removeListener(notifyListeners);
    if (_tabs.isEmpty) {
      _selectedIndex = null;
    } else if (_selectedIndex != null &&
        (_selectedIndex == tabIndex || _selectedIndex! >= _tabs.length)) {
      _selectedIndex = 0;
    }
    notifyListeners();
    return tabData;
  }

  /// Removes all tabs.
  void removeTabs() {
    for (TabData tab in _tabs) {
      tab.removeListener(notifyListeners);
    }
    _tabs.clear();
    _selectedIndex = null;
    notifyListeners();
  }

  void _validateIndex(int tabIndex) {
    if (tabIndex < 0 || tabIndex >= _tabs.length) {
      throw IndexError.withLength(tabIndex, _tabs.length,
          indexable: _tabs, name: 'tabIndex');
    }
  }

  /// Gets a tab given an index.
  TabData getTabByIndex(int index) {
    return _tabs[index];
  }
}
