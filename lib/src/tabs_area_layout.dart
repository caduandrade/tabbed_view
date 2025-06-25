import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/internal/tabs_area/hidden_tabs.dart';
import 'package:tabbed_view/src/internal/tabs_area/tabs_area_layout_parent_data.dart';
import 'package:tabbed_view/src/internal/tabs_area/visible_tabs.dart';
import 'package:tabbed_view/src/tabbed_view.dart';
import 'package:tabbed_view/src/theme/equal_heights.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/tabs_area_theme_data.dart';

/// Inner widget for [TabsArea] layout.
/// Displays the popup menu button for tabs hidden due to lack of space.
/// The selected [TabWidget] will always be visible.
class TabsAreaLayout extends MultiChildRenderObjectWidget {
  TabsAreaLayout(
      {Key? key,
      required List<Widget> children,
      required this.theme,
      required this.hiddenTabs,
      required this.selectedTabIndex,
      required this.tabBarPosition})
      : super(key: key, children: children);

  final TabbedViewThemeData theme;
  final HiddenTabs hiddenTabs;
  final int? selectedTabIndex;
  final TabBarPosition tabBarPosition;

  @override
  _TabsAreaLayoutElement createElement() {
    return _TabsAreaLayoutElement(this);
  }

  @override
  _TabsAreaLayoutRenderBox createRenderObject(BuildContext context) {
    return _TabsAreaLayoutRenderBox(
        theme, hiddenTabs, selectedTabIndex, tabBarPosition);
  }

  @override
  void updateRenderObject(
      BuildContext context, _TabsAreaLayoutRenderBox renderObject) {
    renderObject..tabsAreaTheme = theme.tabsArea;
    renderObject..hiddenTabs = hiddenTabs;
    renderObject..selectedTabIndex = selectedTabIndex;
    renderObject..tabBarPosition = tabBarPosition;

    //renderObject.markNeedsLayoutForSizedByParentChange()
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
  _TabsAreaLayoutRenderBox(TabbedViewThemeData theme, HiddenTabs hiddenTabs,
      int? selectedTabIndex, TabBarPosition tabBarPosition)
      : this._tabsAreaTheme = theme.tabsArea,
        this._hiddenTabs = hiddenTabs,
        this._selectedTabIndex = selectedTabIndex,
        this._tabBarPosition = tabBarPosition;

  int? _selectedTabIndex;

  int? get selectedTabIndex => _selectedTabIndex;

  late RenderBox _corner;

  set selectedTabIndex(int? value) {
    if (_selectedTabIndex != value) {
      _selectedTabIndex = value;
      markNeedsLayout();
    }
  }

  TabsAreaThemeData _tabsAreaTheme;

  TabsAreaThemeData get tabsAreaTheme => _tabsAreaTheme;

  set tabsAreaTheme(TabsAreaThemeData value) {
    if (_tabsAreaTheme != value) {
      _tabsAreaTheme = value;
      markNeedsLayout();
    }
  }

  TabBarPosition _tabBarPosition;
  TabBarPosition get tabBarPosition => _tabBarPosition;
  set tabBarPosition(TabBarPosition value) {
    if (_tabBarPosition != value) {
      _tabBarPosition = value;
      markNeedsLayout();
    }
  }

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
    final bool isHorizontal = tabBarPosition == TabBarPosition.top ||
        tabBarPosition == TabBarPosition.bottom;

    final BoxConstraints childConstraints =
        BoxConstraints.loose(Size(double.infinity, double.infinity));

    List<RenderBox> children = [];
    visitChildren((child) {
      // This collects all children, including the corner
      children.add(child as RenderBox);
    });

    _corner = children.removeLast();

    // First pass: Layout all children (tabs and corner) with loose constraints
    // to determine their natural sizes and find the maximum secondary dimension.
    double maxSecondaryAxisChildDimension =
        0; // Max height of a tab (horizontal), max width of a tab (vertical)

    for (int i = 0; i < children.length; i++) {
      // Iterate over tabs
      final RenderBox child = children[i];
      final TabsAreaLayoutParentData parentData =
          child.tabsAreaLayoutParentData();
      parentData.reset(); // Reset visibility and selection status
      parentData.selected = (selectedTabIndex != null && selectedTabIndex == i);
      child.layout(childConstraints, parentUsesSize: true);

      if (isHorizontal) {
        maxSecondaryAxisChildDimension = math.max(
            maxSecondaryAxisChildDimension,
            child.size.height); // For horizontal, height is secondary
      } else {
        maxSecondaryAxisChildDimension = math.max(
            maxSecondaryAxisChildDimension,
            child.size.width); // For vertical, width is secondary
      }
    }

    // Layout the corner to determine its size and include in max secondary dimension calculation.
    _corner.layout(childConstraints, parentUsesSize: true);
    if (isHorizontal) {
      maxSecondaryAxisChildDimension =
          math.max(maxSecondaryAxisChildDimension, _corner.size.height);
    } else {
      // For vertical, corner's width is secondary
      maxSecondaryAxisChildDimension =
          math.max(maxSecondaryAxisChildDimension, _corner.size.width);
    }

    // Determine the actual secondary dimension for the tabs area.
    // This will be the height for horizontal tabs, and the width for vertical tabs.
    double tabsAreaSecondaryDimension = maxSecondaryAxisChildDimension;

    // Second pass: Re-layout children if equalHeights is applied to force consistent secondary dimension.
    if (tabsAreaTheme.equalHeights != EqualHeights.none) {
      for (RenderBox child in children) {
        // Iterate over all children (tabs + corner)
        child.layout(
            BoxConstraints.tightFor(
                width: isHorizontal
                    ? child.size.width
                    : tabsAreaSecondaryDimension, // For vertical, force width
                height: isHorizontal
                    ? tabsAreaSecondaryDimension
                    : child.size.height),
            parentUsesSize: true); // For horizontal, force height
      }
      _corner.layout(
          BoxConstraints.tightFor(
              width: isHorizontal
                  ? _corner.size.width
                  : tabsAreaSecondaryDimension, // For vertical, force width
              height: isHorizontal
                  ? tabsAreaSecondaryDimension
                  : _corner.size.height),
          parentUsesSize: true); // For horizontal, force height
    }

    VisibleTabs visibleTabs = VisibleTabs(tabsAreaTheme, tabBarPosition);

    for (int i = 0; i < children.length; i++) {
      // Add only tabs, not corner, to VisibleTabs
      visibleTabs.add(children[i]);
    }

    double reservedSpaceForCornerPrimaryAxis =
        isHorizontal ? _corner.size.width : _corner.size.height;
    double availablePrimarySpace = isHorizontal
        ? math.max(
            constraints.maxWidth -
                tabsAreaTheme.initialGap -
                reservedSpaceForCornerPrimaryAxis,
            0)
        : math.max(
            constraints.maxHeight -
                tabsAreaTheme.initialGap -
                reservedSpaceForCornerPrimaryAxis,
            0);

    visibleTabs.layoutSingleTab(
        availablePrimarySpace, tabsAreaSecondaryDimension, isHorizontal);

    List<int> hiddenIndexes = [];

    while (visibleTabs.length > 0 &&
        visibleTabs.requiredTotalSize() > availablePrimarySpace) {
      int? removedIndex;
      if (visibleTabs.length == 1) {
        visibleTabs.removeFirst();
        removedIndex = 0;
      } else {
        removedIndex = visibleTabs.removeLastNonSelected();
      }
      if (removedIndex != null) {
        hiddenIndexes.add(removedIndex);
      }
      visibleTabs.layoutSingleTab(
          availablePrimarySpace, tabsAreaSecondaryDimension, isHorizontal);
    }

    hiddenTabs.update(hiddenIndexes);

    visibleTabs
        .updateOffsets(); // This sets the primary axis offset for visible tabs.

    for (int i = 0; i < visibleTabs.length; i++) {
      final RenderBox tab = visibleTabs.get(i);
      tab.tabsAreaLayoutParentData().visible = true;
    }

    // Position the corner.
    final TabsAreaLayoutParentData cornerParentData =
        _corner.tabsAreaLayoutParentData();

    if (isHorizontal) {
      // Horizontal layout, corner is on the right. Corner is top-right aligned.
      cornerParentData.offset = Offset(
          constraints.maxWidth - _corner.size.width,
          (tabsAreaSecondaryDimension - _corner.size.height) /
              2); // Center vertically
    } else {
      // Vertical layout, corner is at the bottom
      // For vertical, corner is at the bottom.
      // Its X position should be centered if equalHeights.all is applied, otherwise 0.
      double cornerX = 0;
      if (tabsAreaTheme.equalHeights == EqualHeights.all) {
        cornerX = (tabsAreaSecondaryDimension - _corner.size.width) / 2;
      }
      cornerParentData.offset =
          Offset(cornerX, constraints.maxHeight - _corner.size.height);
    }

    cornerParentData.visible = true;

    // Final size calculation
    if (isHorizontal) {
      size = constraints
          .constrain(Size(constraints.maxWidth, tabsAreaSecondaryDimension));
    } else {
      // Vertical layout
      // For vertical, width is tabsAreaSecondaryDimension, height is constrained by parent.
      size = constraints
          .constrain(Size(tabsAreaSecondaryDimension, constraints.maxHeight));
    }
    if (tabsAreaTheme.equalHeights == EqualHeights.none) {
      for (RenderBox tab in children) {
        // Iterate over tabs

        final TabsAreaLayoutParentData parentData =
            tab.tabsAreaLayoutParentData();
        if (isHorizontal) {
          parentData.offset = Offset(parentData.offset.dx,
              (tabsAreaSecondaryDimension - tab.size.height) / 2);
        } else {
          parentData.offset = Offset(
              (tabsAreaSecondaryDimension - tab.size.width) / 2,
              parentData.offset.dy);
        }
      }
      // Corner alignment if equalHeights is none
      final TabsAreaLayoutParentData cornerParentData =
          _corner.tabsAreaLayoutParentData();
      if (isHorizontal) {
        cornerParentData.offset = Offset(cornerParentData.offset.dx,
            (tabsAreaSecondaryDimension - _corner.size.height) / 2);
      } else {
        // Corner X position already calculated above for vertical layout.
        cornerParentData.offset = Offset(
            (tabsAreaSecondaryDimension - _corner.size.width) / 2,
            cornerParentData.offset.dy);
      }
    }
    for (RenderBox tab in children) {
      tab.tabsAreaLayoutParentData();
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
    RenderBox? selectedTab;
    TabsAreaLayoutParentData? selectedTabParentData;
    _visitVisibleChildren((RenderObject child) {
      final TabsAreaLayoutParentData childParentData =
          child.tabsAreaLayoutParentData();
      if (childParentData.selected) {
        // If it's the selected tab, save it to paint last
        selectedTab = child as RenderBox;
        selectedTabParentData = childParentData;
      } else {
        // Otherwise, paint it now
        context.paintChild(child, childParentData.offset + offset);
      }
    });
    if (selectedTab != null) {
      context.paintChild(selectedTab!, selectedTabParentData!.offset + offset);
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
