import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

    List<RenderBox> tabs = [];
    visitChildren((child) {
      tabs.add(child as RenderBox);
    });

    if (tabs.isEmpty) {
      size = constraints.constrain(Size.zero);
      return;
    }

    _corner = tabs.removeLast();

    double maxChildSecondaryAxis = 0;

    for (int i = 0; i < tabs.length; i++) {
      final RenderBox child = tabs[i];
      final TabsAreaLayoutParentData parentData =
          child.tabsAreaLayoutParentData();
      parentData.reset();
      parentData.selected = (selectedTabIndex != null && selectedTabIndex == i);
      child.layout(childConstraints, parentUsesSize: true);
      if (isHorizontal) {
        maxChildSecondaryAxis =
            math.max(maxChildSecondaryAxis, child.size.height);
      } else {
        maxChildSecondaryAxis =
            math.max(maxChildSecondaryAxis, child.size.width);
      }
    }

    _corner.layout(childConstraints, parentUsesSize: true);
    if (isHorizontal) {
      maxChildSecondaryAxis =
          math.max(maxChildSecondaryAxis, _corner.size.height);
    } else {
      maxChildSecondaryAxis =
          math.max(maxChildSecondaryAxis, _corner.size.width);
    }

    final double tabsAreaSecondaryDimension = maxChildSecondaryAxis;

    if (tabsAreaTheme.equalHeights != EqualHeights.none) {
      for (RenderBox child in tabs) {
        child.layout(
            BoxConstraints.tightFor(
                width: isHorizontal
                    ? child.size.width
                    : tabsAreaSecondaryDimension,
                height: isHorizontal
                    ? tabsAreaSecondaryDimension
                    : child.size.height),
            parentUsesSize: true);
      }
      // Re-layout the corner, constraining its secondary axis to match the tabs,
      // but allowing its primary axis to be determined by its content. This
      // avoids a crash when the corner's content changes (e.g., overflow
      // menu appears) and it needs more space on its primary axis.
      _corner.layout(
          BoxConstraints(
              minWidth: !isHorizontal ? tabsAreaSecondaryDimension : 0,
              maxWidth:
                  !isHorizontal ? tabsAreaSecondaryDimension : double.infinity,
              minHeight: isHorizontal ? tabsAreaSecondaryDimension : 0,
              maxHeight:
                  isHorizontal ? tabsAreaSecondaryDimension : double.infinity),
          parentUsesSize: true);
    }

    VisibleTabs visibleTabs = VisibleTabs(tabsAreaTheme, tabBarPosition);
    for (int i = 0; i < tabs.length; i++) {
      visibleTabs.add(tabs[i]);
    }

    final TabsAreaLayoutParentData cornerParentData =
        _corner.tabsAreaLayoutParentData();
    // The corner is always visible to show buttons like 'new tab'.
    cornerParentData.visible = true;

    final double reservedForCorner =
        isHorizontal ? _corner.size.width : _corner.size.height;

    final double availablePrimarySpace =
        isHorizontal ? constraints.maxWidth : constraints.maxHeight;

    double availableSpaceForTabs = math.max(0,
        availablePrimarySpace - tabsAreaTheme.initialGap - reservedForCorner);

    visibleTabs.layoutSingleTab(
        availableSpaceForTabs, tabsAreaSecondaryDimension, isHorizontal);

    List<int> hiddenIndexes = [];

    while (visibleTabs.length > 0 &&
        visibleTabs.requiredTotalSize() > availableSpaceForTabs) {
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
          availableSpaceForTabs, tabsAreaSecondaryDimension, isHorizontal);
    }

    hiddenTabs.update(hiddenIndexes);

    visibleTabs.updateOffsets();

    for (int i = 0; i < visibleTabs.length; i++) {
      final RenderBox tab = visibleTabs.get(i);
      tab.tabsAreaLayoutParentData().visible = true;
    }

    // Position the corner.
    if (isHorizontal) {
      cornerParentData.offset = Offset(
          constraints.maxWidth - _corner.size.width,
          (tabsAreaSecondaryDimension - _corner.size.height) / 2);
    } else {
      double cornerX = 0;
      if (tabsAreaTheme.equalHeights == EqualHeights.all) {
        cornerX = (tabsAreaSecondaryDimension - _corner.size.width) / 2;
      }
      cornerParentData.offset =
          Offset(cornerX, constraints.maxHeight - _corner.size.height);
    }

    if (isHorizontal) {
      size = constraints
          .constrain(Size(constraints.maxWidth, tabsAreaSecondaryDimension));
    } else {
      size = constraints
          .constrain(Size(tabsAreaSecondaryDimension, constraints.maxHeight));
    }
    if (tabsAreaTheme.equalHeights == EqualHeights.none) {
      for (RenderBox tab in tabs) {
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
      // Center the corner vertically/horizontally if equalHeights is none.
      if (isHorizontal) {
        cornerParentData.offset = Offset(cornerParentData.offset.dx,
            (tabsAreaSecondaryDimension - _corner.size.height) / 2);
      } else {
        cornerParentData.offset = Offset(
            (tabsAreaSecondaryDimension - _corner.size.width) / 2,
            cornerParentData.offset.dy);
      }
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

    for (RenderBox child in children.reversed) {
      // Painting in reverse order to ensure the drop area is visible
      // when the middle gap is negative
      final TabsAreaLayoutParentData childParentData =
          child.tabsAreaLayoutParentData();
      context.paintChild(child, childParentData.offset + offset);
      //TODO Evaluate whether it is necessary to paint the selected tab last,
      // otherwise remove the bool selected from the parentData
    }

    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = _tabsAreaTheme.contentBorderColor ?? Colors.transparent;

    //TODO Experimental: drawing the border between the tab area
    // and content (top position only).

    //TODO need all tab positions
    double x = 0;
    double y = size.height - _tabsAreaTheme.contentBorderThickness;
    for (RenderBox child in children) {
      final TabsAreaLayoutParentData parentData =
          child.tabsAreaLayoutParentData();
      final bool isCorner = child == _corner;
      Rect rect = Rect.fromLTRB(
          offset.dx + x,
          offset.dy + y,
          offset.dx + (isCorner ? size.width : parentData.offset.dx),
          offset.dy + size.height);
      if (rect.width > 0 && rect.height > 0) {
        context.canvas.drawRect(rect, paint);
      }
      x = parentData.offset.dx + child.size.width;
    }
    ;
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

//TODO remove?
class TabsAreaLayoutChild extends ParentDataWidget<TabsAreaLayoutParentData> {
  const TabsAreaLayoutChild({
    super.key,
    required Widget child,
  }) : super(child: child);

  @override
  void applyParentData(RenderObject renderObject) {
    final TabsAreaLayoutParentData parentData =
        renderObject.parentData as TabsAreaLayoutParentData;
  }

  @override
  Type get debugTypicalAncestorWidgetClass => TabsAreaLayout;
}
