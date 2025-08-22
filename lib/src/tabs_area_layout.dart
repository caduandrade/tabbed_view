import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/internal/tabs_area/hidden_tabs.dart';
import 'package:tabbed_view/src/internal/tabs_area/tabs_area_layout_parent_data.dart';
import 'package:tabbed_view/src/internal/tabs_area/visible_tabs.dart';
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
    renderObject..tabsAreaTheme = theme.tabsArea;
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
      : this._tabsAreaTheme = theme.tabsArea,
        this._hiddenTabs = hiddenTabs,
        this._selectedTabIndex = selectedTabIndex;

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
    final BoxConstraints childConstraints =
        BoxConstraints.loose(Size(double.infinity, constraints.maxHeight));

    List<RenderBox> children = [];
    visitChildren((child) {
      children.add(child as RenderBox);
    });

    // There will always be at least 1 child (corner area).
    _corner = children.removeLast();

    // Defines the biggest height to avoid displacement of tabs when
    // changing visibility.
    double height = 0;

    _corner.layout(childConstraints, parentUsesSize: true);
    final double minCornerAreaWidth = _corner.size.width;
    height = math.max(height, _corner.size.height);

    // layout all (tabs + tabs area buttons)
    VisibleTabs visibleTabs = VisibleTabs(tabsAreaTheme);

    for (int i = 0; i < children.length; i++) {
      final RenderBox child = children[i];
      final TabsAreaLayoutParentData parentData =
          child.tabsAreaLayoutParentData();
      parentData.reset();
      parentData.selected =
          selectedTabIndex != null && selectedTabIndex == i ? true : false;
      child.layout(childConstraints, parentUsesSize: true);
      height = math.max(height, child.size.height);
      visibleTabs.add(child);
    }

    if (tabsAreaTheme.gapBottomBorder.style == BorderStyle.solid &&
        tabsAreaTheme.gapBottomBorder.width > 0) {
      height = math.max(height, tabsAreaTheme.gapBottomBorder.width);
    }

    double availableWidth = math.max(
        constraints.maxWidth - tabsAreaTheme.initialGap - _corner.size.width,
        0);

    visibleTabs.layoutSingleTab(
        constraints.maxWidth, height, _corner.size.width);

    List<int> hiddenIndexes = [];

    while (visibleTabs.length > 0 &&
        visibleTabs.requiredTotalWidth() > availableWidth) {
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
          constraints.maxWidth, height, _corner.size.width);
    }

    hiddenTabs.update(hiddenIndexes);

    visibleTabs.updateOffsets();

    _corner.layout(
        BoxConstraints.tightFor(
            width: math.max(
                constraints.maxWidth - visibleTabs.maxX(), minCornerAreaWidth),
            height: height),
        parentUsesSize: true);

    List<RenderBox> visibleChildren = [];
    for (int i = 0; i < visibleTabs.length; i++) {
      RenderBox tab = visibleTabs.get(i);
      final TabsAreaLayoutParentData tabParentData =
          tab.tabsAreaLayoutParentData();
      tabParentData.visible = true;
      visibleChildren.add(tab);
    }

    final TabsAreaLayoutParentData cornerParentData =
        _corner.tabsAreaLayoutParentData();
    // anchoring corner to the right
    cornerParentData.offset = Offset(constraints.maxWidth - _corner.size.width,
        constraints.maxHeight - _corner.size.height);

    cornerParentData.visible = true;
    visibleChildren.add(_corner);

    if (tabsAreaTheme.equalHeights == EqualHeights.none) {
      // Aligning and fix max height on visible children.
      for (RenderBox tab in visibleChildren) {
        final TabsAreaLayoutParentData parentData =
            tab.tabsAreaLayoutParentData();
        tab.layout(
            BoxConstraints(
                minWidth: tab.size.width,
                maxWidth: tab.size.width,
                minHeight: tab.size.height,
                maxHeight: tab.size.height),
            parentUsesSize: true);
        parentData.offset =
            Offset(parentData.offset.dx, height - tab.size.height);
      }
    } else {
      if (tabsAreaTheme.equalHeights == EqualHeights.tabs) {
        int visibleCount = visibleChildren.length;
        if (hiddenTabs.hasHiddenTabs) {
          // ignoring corner
          visibleCount--;
        }
        for (int i = 0; i < visibleCount; i++) {
          RenderBox tab = visibleChildren[i];
          tab.layout(
              BoxConstraints.tightFor(width: tab.size.width, height: height),
              parentUsesSize: true);
          final TabsAreaLayoutParentData parentData =
              tab.tabsAreaLayoutParentData();
          parentData.offset = Offset(parentData.offset.dx, 0);
        }
        if (hiddenTabs.hasHiddenTabs) {
          RenderBox corner = visibleChildren.last;
          final TabsAreaLayoutParentData parentData =
              corner.tabsAreaLayoutParentData();
          parentData.offset =
              Offset(parentData.offset.dx, height - corner.size.height);
        }
      } else if (tabsAreaTheme.equalHeights == EqualHeights.all) {
        for (RenderBox child in visibleChildren) {
          child.layout(
              BoxConstraints.tightFor(width: child.size.width, height: height),
              parentUsesSize: true);

          final TabsAreaLayoutParentData parentData =
              child.tabsAreaLayoutParentData();
          parentData.offset = Offset(parentData.offset.dx, 0);
        }
      }
    }

    size = constraints.constrain(Size(constraints.maxWidth, height));
  }

  void visitVisibleChildren(RenderObjectVisitor visitor) {
    visitChildren((child) {
      if (child.tabsAreaLayoutParentData().visible) {
        visitor(child);
      }
    });
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    visitVisibleChildren(visitor);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    List<RenderBox> visibleTabs = [];
    RenderBox? selectedTab;
    TabsAreaLayoutParentData? selectedTabParentData;
    visitVisibleChildren((RenderObject child) {
      final TabsAreaLayoutParentData childParentData =
          child.tabsAreaLayoutParentData();
      if (child != _corner) {
        if (childParentData.selected) {
          selectedTab = child as RenderBox;
          selectedTabParentData = childParentData;
        } else {
          context.paintChild(child, childParentData.offset + offset);
        }
        visibleTabs.add(child as RenderBox);
      } else {
        context.paintChild(child, childParentData.offset + offset);
      }
    });
    if (selectedTab != null) {
      context.paintChild(selectedTab!, selectedTabParentData!.offset + offset);
    }

    Canvas canvas = context.canvas;

    Paint? gapBorderPaint;
    if (tabsAreaTheme.gapBottomBorder.style == BorderStyle.solid &&
        tabsAreaTheme.gapBottomBorder.width > 0) {
      gapBorderPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = tabsAreaTheme.gapBottomBorder.color;
    }
    double top = offset.dy;
    double left = offset.dx;
    double topGap = top + size.height - tabsAreaTheme.gapBottomBorder.width;

    // initial gap
    if (tabsAreaTheme.initialGap > 0 && gapBorderPaint != null) {
      canvas.drawRect(
          Rect.fromLTWH(left, topGap, tabsAreaTheme.initialGap,
              tabsAreaTheme.gapBottomBorder.width),
          gapBorderPaint);
    }
    left += tabsAreaTheme.initialGap;

    for (int i = 0; i < visibleTabs.length; i++) {
      RenderBox tab = visibleTabs[i];
      TabsAreaLayoutParentData tabParentData = tab.tabsAreaLayoutParentData();
      if (tabParentData.visible) {
        left += tab.size.width;

        // right gap
        if (tabsAreaTheme.middleGap > 0 && gapBorderPaint != null) {
          canvas.drawRect(
              Rect.fromLTWH(left, topGap, tabsAreaTheme.middleGap,
                  tabsAreaTheme.gapBottomBorder.width),
              gapBorderPaint);
        }
        left += tabsAreaTheme.middleGap;
      }
    }

    // fill last gap
    if (gapBorderPaint != null) {
      double lastX;
      if (visibleTabs.isNotEmpty) {
        RenderBox lastTab = visibleTabs.last;
        TabsAreaLayoutParentData tabParentData =
            lastTab.tabsAreaLayoutParentData();
        lastX = offset.dx + tabParentData.offset.dx + lastTab.size.width;
      } else {
        lastX = offset.dx + tabsAreaTheme.initialGap;
      }

      double lastGapWidth = offset.dx + size.width - lastX;
      if (_corner.tabsAreaLayoutParentData().visible) {
        // lastGapWidth -= _corner.size.width;
      }
      if (lastGapWidth > 0) {
        canvas.drawRect(
            Rect.fromLTWH(lastX, topGap, lastGapWidth,
                tabsAreaTheme.gapBottomBorder.width),
            gapBorderPaint);
      }
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    List<RenderBox> visibleTabs = [];
    visitVisibleChildren((renderObject) {
      final RenderBox child = renderObject as RenderBox;
      final TabsAreaLayoutParentData childParentData =
          child.tabsAreaLayoutParentData();
      if (childParentData.selected) {
        visibleTabs.insert(0, child);
      } else {
        visibleTabs.add(child);
      }
    });

    bool hitTest = false;
    visibleTabs.forEach((child) {
      if (!hitTest) {
        final TabsAreaLayoutParentData childParentData =
            child.tabsAreaLayoutParentData();
        hitTest = result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - childParentData.offset);
            return child.hitTest(result, position: transformed);
          },
        );
      }
    });

    return hitTest;
  }
}

/// Utility extension to facilitate obtaining parent data.
extension _TabsAreaLayoutParentDataGetter on RenderObject {
  TabsAreaLayoutParentData tabsAreaLayoutParentData() {
    return this.parentData as TabsAreaLayoutParentData;
  }
}
