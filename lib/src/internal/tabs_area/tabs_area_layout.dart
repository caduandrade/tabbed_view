import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

import '../../tab_bar_position.dart';
import '../../theme/last_visible_tab_behavior.dart';
import '../../theme/tab_header_extent_behavior.dart';
import '../../theme/tabbed_view_theme_data.dart';
import '../../theme/tabs_area_cross_axis_alignment.dart';
import '../../theme/tabs_area_cross_axis_fit.dart';
import '../../theme/tabs_area_theme_data.dart';
import 'hidden_tabs.dart';
import 'tabs_area_layout_parent_data.dart';

/// Inner widget for [TabsArea] layout.
/// Displays the popup menu button for tabs hidden due to lack of space.
/// The selected [TabWidget] will always be visible.
@internal
class TabsAreaLayout extends MultiChildRenderObjectWidget {
  TabsAreaLayout(
      {Key? key,
      required List<Widget> children,
      required this.theme,
      required this.hiddenTabs,
      required this.selectedTabIndex})
      : super(key: key, children: children);

  final TabbedViewThemeData theme;
  final HiddenTabs hiddenTabs;
  final int? selectedTabIndex;

  @override
  _TabsAreaLayoutElement createElement() {
    return _TabsAreaLayoutElement(this);
  }

  @override
  _TabsAreaLayoutRenderBox createRenderObject(BuildContext context) {
    return _TabsAreaLayoutRenderBox(theme, hiddenTabs, selectedTabIndex);
  }

  @override
  void updateRenderObject(
      BuildContext context, _TabsAreaLayoutRenderBox renderObject) {
    renderObject..theme = theme;
    renderObject..divider = theme.isDividerWithinTabArea ? theme.divider : null;
    renderObject..hiddenTabs = hiddenTabs;
    renderObject..selectedTabIndex = selectedTabIndex;

    renderObject.markNeedsLayoutForSizedByParentChange();
  }
}

/// The [TabsAreaLayout] element.
class _TabsAreaLayoutElement extends MultiChildRenderObjectElement {
  _TabsAreaLayoutElement(TabsAreaLayout widget) : super(widget);

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    children.forEach((child) {
      if (child.renderObject != null) {
        TabsAreaLayoutParentData parentData =
            child.renderObject!.parentData as TabsAreaLayoutParentData;
        if (parentData.visible) {
          visitor(child);
        }
      }
    });
  }
}

/// The [TabsAreaLayout] render box.
class _TabsAreaLayoutRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TabsAreaLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TabsAreaLayoutParentData> {
  _TabsAreaLayoutRenderBox(
      TabbedViewThemeData theme, HiddenTabs hiddenTabs, int? selectedTabIndex)
      : this._theme = theme,
        this._divider = theme.isDividerWithinTabArea ? theme.divider : null,
        this._hiddenTabs = hiddenTabs,
        this._selectedTabIndex = selectedTabIndex;

  int? _selectedTabIndex;

  int? get selectedTabIndex => _selectedTabIndex;

  set selectedTabIndex(int? value) {
    if (_selectedTabIndex != value) {
      _selectedTabIndex = value;
      markNeedsLayout();
    }
  }

  BorderSide? _divider;

  set divider(BorderSide? value) {
    if (_divider != value) {
      _divider = value;
      markNeedsLayout();
    }
  }

  TabbedViewThemeData _theme;

  TabbedViewThemeData get theme => _theme;

  set theme(TabbedViewThemeData value) {
    if (_theme != value) {
      _theme = value;
      markNeedsLayout();
    }
  }

  TabsAreaThemeData get tabsAreaTheme => theme.tabsArea;

  TabBarPosition get tabBarPosition => theme.tabsArea.position;

  HiddenTabs _hiddenTabs;

  HiddenTabs get hiddenTabs => _hiddenTabs;

  set hiddenTabs(HiddenTabs value) {
    if (_hiddenTabs != value) {
      _hiddenTabs = value;
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TabsAreaLayoutParentData) {
      child.parentData = TabsAreaLayoutParentData();
    }
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      // Safety fallback, but the layout will always
      // have at least the corner widget as the last child.
      size = constraints.constrain(Size.zero);
      return;
    }

    final List<RenderBox> children = [];
    int index = 0;
    visitChildren((renderObject) {
      RenderBox child = renderObject as RenderBox;
      final TabsAreaLayoutParentData parentData =
          child.tabsAreaLayoutParentData();
      parentData.reset();
      children.add(child);
      if (child != lastChild) {
        // Corner will always be the last
        parentData.selected =
            (selectedTabIndex != null && selectedTabIndex == index);
      }
      index++;
    });

    final BorderSide? divider = theme.divider;
    final double minimalCrossAxisSize = theme.isDividerWithinTabArea
        ? (divider != null ? divider.width : 0)
        : 0;
    double maxCrossAxisSize =
        math.max(_layoutChildren(children: children), minimalCrossAxisSize);
    final RenderBox corner = children.removeLast();

    final double reservedForCorner =
        tabBarPosition.isHorizontal ? corner.size.width : corner.size.height;

    final double availableMainAxisSpace = tabBarPosition.isHorizontal
        ? constraints.maxWidth
        : constraints.maxHeight;

    final double availableSpaceForTabs = math.max(
        0,
        availableMainAxisSpace -
            tabsAreaTheme.initialGap -
            reservedForCorner -
            tabsAreaTheme.minimalFinalGap);

    switch (theme.tabsArea.lastVisibleTabBehavior) {
      case LastVisibleTabBehavior.hide:
        _hideTabsUntilThereIsNoMoreSpace(
            children: children, availableSpaceForTabs: availableSpaceForTabs);
        break;
      case LastVisibleTabBehavior.shrink:
        maxCrossAxisSize = _shrinkLast(
            children: children,
            availableSpaceForTabs: availableSpaceForTabs,
            maxCrossAxisSize: maxCrossAxisSize,
            minimalCrossAxisSize: minimalCrossAxisSize,
            corner: corner);
        break;
    }

    // The corner has already been removed from the children.
    _positionChildren(
        tabs: children, corner: corner, maxCrossAxisSize: maxCrossAxisSize);

    if (tabBarPosition.isHorizontal) {
      size =
          constraints.constrain(Size(constraints.maxWidth, maxCrossAxisSize));
    } else {
      size =
          constraints.constrain(Size(maxCrossAxisSize, constraints.maxHeight));
    }
  }

  void _hideTabsUntilThereIsNoMoreSpace({
    required List<RenderBox> children,
    required double availableSpaceForTabs,
  }) {
    final List<int> hiddenIndexes = [];
    while (children.length >= 1 &&
        _requiredTabsMainAxisSize(tabs: children) > availableSpaceForTabs) {
      int? removedIndex;
      if (children.length == 1) {
        children.removeAt(0).tabsAreaLayoutParentData().visible = false;
        removedIndex = 0;
      } else {
        removedIndex = _removeLastNonSelected(tabs: children);
      }
      if (removedIndex != null) {
        hiddenIndexes.add(removedIndex);
      }
    }
    hiddenTabs.update(hiddenIndexes);
  }

  double _shrinkLast({
    required List<RenderBox> children,
    required double availableSpaceForTabs,
    required double maxCrossAxisSize,
    required double minimalCrossAxisSize,
    required RenderBox corner,
  }) {
    final List<int> hiddenIndexes = [];

    while (children.length > 1 &&
        _requiredTabsMainAxisSize(tabs: children) > availableSpaceForTabs) {
      int? removedIndex;
      if (children.length == 1) {
        children.removeAt(0).tabsAreaLayoutParentData().visible = false;
        removedIndex = 0;
      } else {
        removedIndex = _removeLastNonSelected(tabs: children);
      }
      if (removedIndex != null) {
        hiddenIndexes.add(removedIndex);
      }
    }

    if (children.length == 1) {
      RenderBox child = children.first;

      if (tabBarPosition.isHorizontal) {
        child.layout(
            BoxConstraints(
              minWidth: 0,
              maxWidth: availableSpaceForTabs,
              minHeight: 0,
              maxHeight: double.infinity,
            ),
            parentUsesSize: true);
        maxCrossAxisSize = math.max(child.size.height, corner.size.height);
        if (tabsAreaTheme.crossAxisFit == TabsAreaCrossAxisFit.all &&
            child.size.height < maxCrossAxisSize) {
          child.layout(
              BoxConstraints.tightFor(
                  width: child.size.width, height: maxCrossAxisSize),
              parentUsesSize: true);
        }
      } else {
        child.layout(
            BoxConstraints(
              minWidth: 0,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: availableSpaceForTabs,
            ),
            parentUsesSize: true);
        maxCrossAxisSize = math.max(child.size.width, corner.size.width);
        if (tabsAreaTheme.crossAxisFit == TabsAreaCrossAxisFit.all &&
            child.size.width < maxCrossAxisSize) {
          child.layout(
              BoxConstraints.tightFor(
                  width: maxCrossAxisSize, height: child.size.height),
              parentUsesSize: true);
        }
      }
      maxCrossAxisSize = math.max(maxCrossAxisSize, minimalCrossAxisSize);
    }

    hiddenTabs.update(hiddenIndexes);
    return maxCrossAxisSize;
  }

  /// Removes the last non-selected tab. Returns the removed tab index.
  int? _removeLastNonSelected({required List<RenderBox> tabs}) {
    int index = tabs.length - 1;
    while (index >= 0) {
      RenderBox tab = tabs[index];
      TabsAreaLayoutParentData parentData = tab.tabsAreaLayoutParentData();
      if (parentData.selected == false) {
        tabs.removeAt(index);
        parentData.visible = false;
        return index;
      }
      index--;
    }
    return null;
  }

  /// Calculates the required main axis size.
  double _requiredTabsMainAxisSize({required List<RenderBox> tabs}) {
    double totalSize = 0;
    for (int i = 0; i < tabs.length; i++) {
      final RenderBox tab = tabs[i];
      totalSize +=
          tabBarPosition.isHorizontal ? tab.size.width : tab.size.height;
      if (i < tabs.length - 1) {
        // Not the last tab
        totalSize += tabsAreaTheme.middleGap;
      }
    }
    return totalSize;
  }

  double _layoutChildren({required List<RenderBox> children}) {
    final BoxConstraints childLooseConstraints =
        BoxConstraints.loose(Size(double.infinity, double.infinity));
    double maxCrossAxisSize = 0;
    double maxTabHeaderExtentSize = 0;
    for (RenderBox child in children) {
      child.layout(childLooseConstraints, parentUsesSize: true);

      final isTab = child != lastChild;
      final needTabHeaderCrossAxisSize = isTab &&
          tabsAreaTheme.tabHeaderExtentBehavior ==
              TabHeaderExtentBehavior.uniform;

      final Size? tabHeaderCrossAxisSize = needTabHeaderCrossAxisSize
          ? child.tabsAreaLayoutParentData().sizeHolder?.size
          : null;

      double minimalCrossAxisSize = 0;
      if (child == lastChild) {
        final BorderSide? divider = theme.divider;
        minimalCrossAxisSize = theme.isDividerWithinTabArea
            ? (divider != null ? divider.width : 0)
            : 0;
      }

      if (tabBarPosition.isHorizontal) {
        maxCrossAxisSize = math.max(
            maxCrossAxisSize, child.size.height + minimalCrossAxisSize);
        if (tabHeaderCrossAxisSize != null) {
          maxTabHeaderExtentSize =
              math.max(maxTabHeaderExtentSize, tabHeaderCrossAxisSize.height);
        }
      } else {
        maxCrossAxisSize =
            math.max(maxCrossAxisSize, child.size.width + minimalCrossAxisSize);
        if (tabHeaderCrossAxisSize != null) {
          maxTabHeaderExtentSize =
              math.max(maxTabHeaderExtentSize, tabHeaderCrossAxisSize.width);
        }
      }
    }

    if (tabsAreaTheme.crossAxisFit != TabsAreaCrossAxisFit.none) {
      // Cross axis fit
      for (RenderBox child in children) {
        final isTab = child != lastChild;
        if (tabsAreaTheme.crossAxisFit == TabsAreaCrossAxisFit.all ||
            (isTab &&
                tabsAreaTheme.crossAxisFit == TabsAreaCrossAxisFit.tabs)) {
          child.layout(
              BoxConstraints.tightFor(
                  width: tabBarPosition.isHorizontal
                      ? child.size.width
                      : maxCrossAxisSize,
                  height: tabBarPosition.isHorizontal
                      ? maxCrossAxisSize
                      : child.size.height),
              parentUsesSize: true);
        }
      }
    } else if (tabsAreaTheme.tabHeaderExtentBehavior ==
        TabHeaderExtentBehavior.uniform) {
      // Tab header resize
      for (RenderBox child in children) {
        final isTab = child != lastChild;
        if (isTab) {
          final Size? tabHeaderExtentSize =
              child.tabsAreaLayoutParentData().sizeHolder?.size;

          if (tabHeaderExtentSize != null) {
            if (tabBarPosition.isHorizontal) {
              final double delta =
                  maxTabHeaderExtentSize - tabHeaderExtentSize.height;
              if (delta > 0) {
                child.layout(
                    BoxConstraints.tightFor(
                        width: child.size.width,
                        height: child.size.height + delta),
                    parentUsesSize: true);
                maxCrossAxisSize =
                    math.max(maxCrossAxisSize, child.size.height);
              }
            } else {
              final double delta =
                  maxTabHeaderExtentSize - tabHeaderExtentSize.width;
              if (delta > 0) {
                child.layout(
                    BoxConstraints.tightFor(
                        width: child.size.width + delta,
                        height: child.size.height),
                    parentUsesSize: true);
                maxCrossAxisSize = math.max(maxCrossAxisSize, child.size.width);
              }
            }
          }
        }
      }
    }
    return maxCrossAxisSize;
  }

  void _positionChildren(
      {required List<RenderBox> tabs,
      required RenderBox corner,
      required double maxCrossAxisSize}) {
    double mainAxisOffset = tabsAreaTheme.initialGap;
    for (int i = 0; i < tabs.length; i++) {
      RenderBox tab = tabs[i];
      _position(
          child: tab,
          startCrossAxisSize: 0,
          maxCrossAxisSize: maxCrossAxisSize,
          mainAxisOffset: mainAxisOffset,
          alignment: tabsAreaTheme.crossAxisFit == TabsAreaCrossAxisFit.none
              ? tabsAreaTheme.crossAxisAlignment
              : TabsAreaCrossAxisAlignment.outer);
      final double tabMainAxisSize =
          tabBarPosition.isHorizontal ? tab.size.width : tab.size.height;
      if (i < tabs.length - 1) {
        // Not the last tab
        mainAxisOffset += tabMainAxisSize + tabsAreaTheme.middleGap;
      } else {
        mainAxisOffset += tabMainAxisSize + tabsAreaTheme.minimalFinalGap;
      }
    }

    // Position the corner
    final BorderSide? divider = theme.divider;
    final double startCrossAxisSize = theme.isDividerWithinTabArea
        ? (divider != null ? divider.width : 0)
        : 0;
    _position(
        child: corner,
        startCrossAxisSize: startCrossAxisSize,
        maxCrossAxisSize: maxCrossAxisSize,
        mainAxisOffset: tabBarPosition.isHorizontal
            ? constraints.maxWidth - corner.size.width
            : constraints.maxHeight - corner.size.height,
        alignment: tabsAreaTheme.crossAxisFit == TabsAreaCrossAxisFit.all
            ? TabsAreaCrossAxisAlignment.outer
            : tabsAreaTheme.crossAxisAlignment);
  }

  void _position(
      {required RenderBox child,
      required double startCrossAxisSize,
      required double maxCrossAxisSize,
      required double mainAxisOffset,
      required TabsAreaCrossAxisAlignment alignment}) {
    final TabsAreaLayoutParentData parentData =
        child.tabsAreaLayoutParentData();
    switch (alignment) {
      case TabsAreaCrossAxisAlignment.outer:
        switch (tabBarPosition) {
          case TabBarPosition.top:
            parentData.offset = Offset(mainAxisOffset, startCrossAxisSize);
            break;
          case TabBarPosition.bottom:
            parentData.offset = Offset(mainAxisOffset,
                maxCrossAxisSize - child.size.height - startCrossAxisSize);
            break;
          case TabBarPosition.left:
            parentData.offset = Offset(startCrossAxisSize, mainAxisOffset);
            break;
          case TabBarPosition.right:
            parentData.offset = Offset(
                maxCrossAxisSize - child.size.width - startCrossAxisSize,
                mainAxisOffset);
            break;
        }
        break;
      case TabsAreaCrossAxisAlignment.center:
        if (tabBarPosition.isHorizontal) {
          parentData.offset = Offset(mainAxisOffset,
              (maxCrossAxisSize - child.size.height - startCrossAxisSize) / 2);
        } else {
          parentData.offset =
              Offset((maxCrossAxisSize - child.size.width) / 2, mainAxisOffset);
        }
        break;
      case TabsAreaCrossAxisAlignment.inner:
        switch (tabBarPosition) {
          case TabBarPosition.top:
            parentData.offset = Offset(mainAxisOffset,
                maxCrossAxisSize - child.size.height - startCrossAxisSize);
            break;
          case TabBarPosition.bottom:
            parentData.offset = Offset(mainAxisOffset, startCrossAxisSize);
            break;
          case TabBarPosition.left:
            parentData.offset = Offset(
                maxCrossAxisSize - child.size.width - startCrossAxisSize,
                mainAxisOffset);
            break;
          case TabBarPosition.right:
            parentData.offset = Offset(startCrossAxisSize, mainAxisOffset);
            break;
        }
        break;
    }
  }

  void _visitVisibleChildren(RenderObjectVisitor visitor) {
    visitChildren((child) {
      if (child.tabsAreaLayoutParentData().visible) {
        visitor(child);
      }
    });
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    _visitVisibleChildren(visitor);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    List<RenderBox> children = [];
    _visitVisibleChildren((RenderObject child) {
      children.add(child as RenderBox);
    });

    RenderBox? selectedTab;
    for (RenderBox child in children.reversed) {
      // Painting in reverse order to ensure the drop area is visible
      // when the middle gap is negative
      final TabsAreaLayoutParentData parentData =
          child.tabsAreaLayoutParentData();
      if (parentData.selected) {
        // Paint the selected tab last.
        // Ensure it is completely visible at the top.
        // Although there is a very negative middle gap, otherwise,
        // despite being selected, it could be behind another tab.
        selectedTab = child;
      } else {
        context.paintChild(child, parentData.offset + offset);
      }
    }
    if (selectedTab != null) {
      final TabsAreaLayoutParentData parentData =
          selectedTab.tabsAreaLayoutParentData();
      context.paintChild(selectedTab, parentData.offset + offset);
    }

    final BorderSide? divider = _divider;
    if (divider != null && divider.width > 0) {
      Paint paint = Paint();
      paint.style = PaintingStyle.fill;
      paint.color = divider.color;

      if (tabBarPosition.isHorizontal) {
        double x = 0;
        double y1 = tabBarPosition == TabBarPosition.top
            ? size.height - divider.width
            : 0;
        double y2 =
            tabBarPosition == TabBarPosition.top ? size.height : divider.width;
        for (RenderBox child in children) {
          final TabsAreaLayoutParentData parentData =
              child.tabsAreaLayoutParentData();
          final bool isCorner = child == lastChild;
          Rect rect = Rect.fromLTRB(
              offset.dx + x,
              offset.dy + y1,
              offset.dx + (isCorner ? size.width : parentData.offset.dx),
              offset.dy + y2);
          if (rect.width > 0 && rect.height > 0) {
            context.canvas.drawRect(rect, paint);
          }
          x = parentData.offset.dx + child.size.width;
        }
      } else {
        // vertical
        double y = 0;
        double x1 = tabBarPosition == TabBarPosition.left
            ? size.width - divider.width
            : 0;
        double x2 =
            tabBarPosition == TabBarPosition.left ? size.width : divider.width;
        for (RenderBox child in children) {
          final TabsAreaLayoutParentData parentData =
              child.tabsAreaLayoutParentData();
          final bool isCorner = child == lastChild;
          Rect rect = Rect.fromLTRB(
              offset.dx + x1,
              offset.dy + y,
              offset.dx + x2,
              offset.dy + (isCorner ? size.height : parentData.offset.dy));
          if (rect.width > 0 && rect.height > 0) {
            context.canvas.drawRect(rect, paint);
          }
          y = parentData.offset.dy + child.size.height;
        }
      }
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    List<RenderBox> hitTestOrder = [];
    RenderBox? selectedTab;

    // Collect all visible children, putting the selected tab first for hit testing.
    _visitVisibleChildren((RenderObject child) {
      final TabsAreaLayoutParentData childParentData =
          child.tabsAreaLayoutParentData();
      if (childParentData.selected) {
        selectedTab = child as RenderBox;
      } else {
        hitTestOrder.add(child as RenderBox);
      }
    });
    if (selectedTab != null) {
      hitTestOrder.insert(0, selectedTab!);
    }
    for (RenderBox child in hitTestOrder) {
      final TabsAreaLayoutParentData childParentData =
          child.tabsAreaLayoutParentData();
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}
