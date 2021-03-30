import 'dart:collection';

import 'package:flutter/material.dart';

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

  int? get selectedIndex => _selectedIndex;

  set selectedIndex(int? tabIndex) {
    if (tabIndex != null) {
      _validateIndex(tabIndex);
    }
    _selectedIndex = tabIndex;
  }

  add(TabData tab) {
    _tabs.add(tab);
    if (_tabs.length > 0) {
      _selectedIndex = 0;
    }
  }

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
