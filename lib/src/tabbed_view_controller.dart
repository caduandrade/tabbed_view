import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_menu_builder.dart';

/// The [TabbedView] controller.
///
/// Stores tabs and selection tab index.
///
/// When a property is changed, the [TabbedView] is notified and updated appropriately.
///
/// Remember to dispose of the [TabbedView] when it is no longer needed. This will ensure we discard any resources used by the object.
class TabbedViewController extends ChangeNotifier {
  factory TabbedViewController(List<TabData> tabs) {
    return TabbedViewController._(tabs);
  }

  TabbedViewController._(this._tabs) {
    if (_tabs.length > 0) {
      _selectedIndex = 0;
    }
  }

  final List<TabData> _tabs;

  int? _selectedIndex;

  /// The menu builder.
  TabbedViewMenuBuilder? _menuBuilder;

  /// Get the current menu.
  TabbedViewMenuBuilder? get menuBuilder => _menuBuilder;

  UnmodifiableListView<TabData> get tabs => UnmodifiableListView(_tabs);

  /// The selected tab index
  int? get selectedIndex => _selectedIndex;

  /// Updates the menu.
  void updateMenu(TabbedViewMenuBuilder menuBuilder) {
    _menuBuilder = menuBuilder;
    notifyListeners();
  }

  /// Indicates whether there is a menu.
  bool hasMenu() {
    return _menuBuilder != null;
  }

  /// Removes the menu.
  void removeMenu() {
    _menuBuilder = null;
    notifyListeners();
  }

  /// Changes the index of the selection and notifies.
  set selectedIndex(int? tabIndex) {
    if (tabIndex != null) {
      _validateIndex(tabIndex);
    }
    _selectedIndex = tabIndex;
    _menuBuilder = null;
    notifyListeners();
  }

  /// Inserts [TabData] at position [index] in the [tabs].
  ///
  /// The [index] value must be non-negative and no greater than [tabs.length].
  void insertTab(int index, TabData tab) {
    _tabs.insert(index, tab);
    _afterIncTabs();
  }

  /// Adds multiple [TabData].
  addTabs(Iterable<TabData> iterable) {
    _tabs.addAll(iterable);
    _afterIncTabs();
  }

  /// Adds a [TabData].
  addTab(TabData tab) {
    _tabs.add(tab);
    _afterIncTabs();
  }

  /// Method that should be used after adding a tab.
  /// Updates the status and notifies.
  _afterIncTabs() {
    if (_tabs.length == 1) {
      _selectedIndex = 0;
    }
    _menuBuilder = null;
    notifyListeners();
  }

  /// Removes a tab.
  removeTab(int tabIndex) {
    _validateIndex(tabIndex);
    _tabs.removeAt(tabIndex);
    if (_tabs.isEmpty) {
      _selectedIndex = null;
    } else if (_selectedIndex != null &&
        (_selectedIndex == tabIndex || _selectedIndex! >= _tabs.length)) {
      _selectedIndex = 0;
    }
    _menuBuilder = null;
    notifyListeners();
  }

  /// Removes all tabs.
  removeTabs() {
    _tabs.clear();
    _selectedIndex = null;
    _menuBuilder = null;
    notifyListeners();
  }

  _validateIndex(int tabIndex) {
    if (tabIndex < 0 || tabIndex >= _tabs.length) {
      throw IndexError(tabIndex, _tabs, 'tabIndex');
    }
  }
}
