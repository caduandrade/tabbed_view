import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/internal/tabs_area/tabs_area_layout_parent_data.dart';
import 'package:tabbed_view/src/theme/tabs_area_theme_data.dart';

/// Utility class to find out which tabs may be visible.
/// Calculates the required width and sets the offset value.
@internal
class VisibleTabs {
  VisibleTabs(this.tabsAreaTheme);

  final TabsAreaThemeData tabsAreaTheme;

  List<RenderBox> _tabs = [];

  void add(RenderBox tab) {
    _tabs.add(tab);
  }

  int get length => _tabs.length;

  RenderBox get(int index) {
    return _tabs[index];
  }

  /// Layouts the single selected tab.
  void layoutSingleTab(
      double maxWidth, double maxHeight, double reservedWidth) {
    if (_tabs.length == 1) {
      double availableWidth = maxWidth -
          reservedWidth -
          tabsAreaTheme.initialGap -
          tabsAreaTheme.minimalFinalGap;

      if (availableWidth > 0) {
        RenderBox tab = _tabs.first;
        if (tab.size.width > availableWidth) {
          final BoxConstraints childConstraints =
              BoxConstraints.loose(Size(availableWidth, maxHeight));
          tab.layout(childConstraints, parentUsesSize: true);
        }
      }
    }
  }

  /// Updates the offset given the tab width, initial offset and gap values.
  void updateOffsets() {
    double offset = tabsAreaTheme.initialGap;
    for (int i = 0; i < _tabs.length; i++) {
      RenderBox tab = _tabs[i];
      final TabsAreaLayoutParentData tabParentData =
          tab.parentData as TabsAreaLayoutParentData;

      tabParentData.offset = Offset(offset, tabParentData.offset.dy);

      if (i < _tabs.length - 1) {
        offset += tab.size.width + tabsAreaTheme.middleGap;
      } else {
        offset += tab.size.width + tabsAreaTheme.minimalFinalGap;
      }
    }
  }

  /// Calculates the required width for the tab. Includes the gap values
  /// on the right.
  double requiredTabWidth(int index) {
    RenderBox tab = _tabs[index];
    if (index < _tabs.length - 1) {
      return tab.size.width + tabsAreaTheme.middleGap;
    }
    return tab.size.width + tabsAreaTheme.minimalFinalGap;
  }

  /// Calculates the required width for all tabs.
  double requiredTotalWidth() {
    double width = 0;
    for (int i = 0; i < _tabs.length; i++) {
      width += requiredTabWidth(i);
    }
    return width;
  }

  /// Removes the last non-selected tab. Returns the removed tab index.
  int? removeLastNonSelected() {
    int index = _tabs.length - 1;
    while (index >= 0) {
      RenderBox tab = _tabs[index];
      TabsAreaLayoutParentData parentData =
          tab.parentData as TabsAreaLayoutParentData;
      if (parentData.selected == false) {
        _tabs.removeAt(index);
        return index;
      }
      index--;
    }
    return null;
  }

  /// Removes the first tab.
  void removeFirst() {
    if (_tabs.length > 0) {
      _tabs.removeAt(0);
    }
  }

  double maxX() {
    if (_tabs.isEmpty) {
      return 0;
    }
    RenderBox tab = _tabs.last;
    TabsAreaLayoutParentData parentData =
        tab.parentData as TabsAreaLayoutParentData;
    return parentData.offset.dx + tab.size.width;
  }
}
