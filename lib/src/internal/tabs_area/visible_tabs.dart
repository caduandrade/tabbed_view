import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/internal/tabs_area/tabs_area_layout_parent_data.dart';
import 'package:tabbed_view/src/tabbed_view.dart'; // Import TabBarPosition
import 'package:tabbed_view/src/theme/tabs_area_theme_data.dart';

/// Utility class to find out which tabs may be visible.
/// Calculates the required width and sets the offset value.
@internal
class VisibleTabs {
  VisibleTabs(this.tabsAreaTheme, this.tabBarPosition);

  final TabsAreaThemeData tabsAreaTheme;
  final TabBarPosition tabBarPosition;

  List<RenderBox> _tabs = [];

  void add(RenderBox tab) {
    _tabs.add(tab);
  }

  int get length => _tabs.length;

  RenderBox get(int index) {
    return _tabs[index];
  }

  /// Layouts the single selected tab.
  void layoutSingleTab(double maxPrimarySize, double maxSecondarySize) {
    if (_tabs.length == 1) {
      double availablePrimarySize = maxPrimarySize -
          tabsAreaTheme.initialGap -
          tabsAreaTheme.minimalFinalGap;

      if (availablePrimarySize > 0) {
        RenderBox tab = _tabs.first;
        if ((tabBarPosition.isHorizontal ? tab.size.width : tab.size.height) >
            availablePrimarySize) {
          final BoxConstraints childConstraints = tabBarPosition.isHorizontal
              ? BoxConstraints.loose(
                  Size(availablePrimarySize, maxSecondarySize))
              : BoxConstraints.loose(
                  Size(maxSecondarySize, availablePrimarySize));
          tab.layout(childConstraints, parentUsesSize: true);
        }
      }
    }
  }

  /// Updates the offset given the tab size, initial offset and gap values.
  void updateOffsets() {
    double offset =
        tabsAreaTheme.initialGap; // This is initial gap in primary axis
    for (int i = 0; i < _tabs.length; i++) {
      RenderBox tab = _tabs[i];
      final TabsAreaLayoutParentData tabParentData =
          tab.tabsAreaLayoutParentData();

      if (tabBarPosition.isHorizontal) {
        // For horizontal, primary axis is X, secondary is Y.
        tabParentData.offset = Offset(offset, tabParentData.offset.dy);
      } else {
        // For vertical, primary axis is Y, secondary is X.
        tabParentData.offset = Offset(tabParentData.offset.dx, offset);
      }

      double tabPrimarySize =
          tabBarPosition.isHorizontal ? tab.size.width : tab.size.height;

      if (i < _tabs.length - 1) {
        // Not the last tab
        offset += tabPrimarySize + tabsAreaTheme.middleGap;
      } else {
        offset += tabPrimarySize + tabsAreaTheme.minimalFinalGap;
      }
    }
  }

  /// Calculates the required size for the tab in the primary axis. Includes the gap values.
  double requiredTabPrimarySize(int index) {
    RenderBox tab = _tabs[index];
    double tabSize =
        tabBarPosition.isHorizontal ? tab.size.width : tab.size.height;
    if (index < _tabs.length - 1) {
      // Not the last tab
      return tabSize + tabsAreaTheme.middleGap;
    }
    return tabSize + tabsAreaTheme.minimalFinalGap;
  }

  /// Calculates the required total size for all tabs in the primary axis.
  double requiredTotalSize() {
    double totalSize = 0;
    for (int i = 0; i < _tabs.length; i++) {
      totalSize += requiredTabPrimarySize(i);
    }
    return totalSize;
  }

  /// Removes the last non-selected tab. Returns the removed tab index.
  int? removeLastNonSelected() {
    int index = _tabs.length - 1;
    while (index >= 0) {
      RenderBox tab = _tabs[index];
      TabsAreaLayoutParentData parentData = tab.tabsAreaLayoutParentData();
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
    if (_tabs.isNotEmpty) {
      _tabs.removeAt(0);
    }
  }
}
