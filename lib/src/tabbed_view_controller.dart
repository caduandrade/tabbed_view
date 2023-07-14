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
  TabbedViewController(this._tabs,
      {this.onReorder, this.data, bool reorderEnable = true})
      : this._reorderEnable = reorderEnable {
    if (_tabs.length > 0) {
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
    TabData tabData = _tabs.removeAt(tabIndex);
    tabData.removeListener(notifyListeners);
    tabData._setIndex(-1);
    _updateIndexes(false);
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
    _updateIndexes(true);
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
