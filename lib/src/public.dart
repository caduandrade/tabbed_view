import 'dart:collection';

import 'package:flutter/material.dart';

/// The tab data.
///
/// The text displayed on the tab is defined by [text] parameter.
///
/// The optional [value] parameter allows associate the tab to any value.
///
/// The optional [content] parameter defines the content of the tab.
///
/// The [closable] parameter defines whether the close button is visible.
///
/// The [buttons] parameter allows you to define extra buttons in addition
/// to the Close button.
///
/// See also:
///
/// * [TabbedWiew.contentBuilder]
class TabData {
  TabData(
      {this.value,
      required this.text,
      this.buttons,
      this.content,
      this.closable = true});

  final dynamic? value;
  String text;
  List<TabButton>? buttons;
  Widget? content;
  bool closable;
}

/// Configures a tab button.
class TabButton {
  TabButton(
      {required this.icon,
      this.color,
      this.hoverColor,
      this.disabledColor,
      this.onPressed,
      this.popupMenuItemBuilder,
      this.onPopupMenuItemSelected,
      this.toolTip});

  final IconData icon;
  final Color? color;
  final Color? hoverColor;
  final Color? disabledColor;
  final VoidCallback? onPressed;
  final PopupMenuItemBuilder<int>? popupMenuItemBuilder;
  final PopupMenuItemSelected<int>? onPopupMenuItemSelected;
  final String? toolTip;
}

/// The [TabbedWiew] model.
///
/// Stores tabs and selection tab index.
class TabbedWiewModel {
  factory TabbedWiewModel(List<TabData> tabs) {
    return TabbedWiewModel._(tabs);
  }

  TabbedWiewModel._(this._tabs) {
    if (_tabs.length > 0) {
      _selectedIndex = 0;
    }
  }

  final List<TabData> _tabs;

  int? _selectedIndex;

  UnmodifiableListView<TabData> get tabs => UnmodifiableListView(_tabs);

  /// The selected tab index
  int? get selectedIndex => _selectedIndex;

  set selectedIndex(int? tabIndex) {
    if (tabIndex != null) {
      _validateIndex(tabIndex);
    }
    _selectedIndex = tabIndex;
  }

  /// Adds a tab to the model.
  add(TabData tab) {
    _tabs.add(tab);
    if (_tabs.length == 1) {
      _selectedIndex = 0;
    }
  }

  /// Removes a tab from the model.
  remove(int tabIndex) {
    _validateIndex(tabIndex);
    _tabs.removeAt(tabIndex);
    if (_tabs.isEmpty) {
      _selectedIndex = null;
    } else if (_selectedIndex != null &&
        (_selectedIndex == tabIndex || _selectedIndex! >= _tabs.length)) {
      _selectedIndex = 0;
    }
  }

  _validateIndex(int tabIndex) {
    if (tabIndex < 0 || tabIndex >= _tabs.length) {
      throw IndexError(tabIndex, _tabs, 'tabIndex');
    }
  }
}

typedef OnTabClosing = bool Function(int tabIndex);
