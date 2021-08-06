import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/theme.dart';

/// Inner widget for [TabsArea] layout.
/// Displays the popup menu button for tabs hidden due to lack of space.
/// The selected [TabWidget] will always be visible.
class TabsAreaLayout extends MultiChildRenderObjectWidget {
  TabsAreaLayout(
      {Key? key,
      required WidgetBuilder buttonsAreaBuilder,
      required List<Widget> children,
      required this.theme,
      required this.hiddenTabs,
      required this.selectedTabIndex})
      : super(
          key: key,
          children: [
            ...children,
            LayoutBuilder(
              builder: (context, constraints) {
                return buttonsAreaBuilder(context);
              },
            ),
          ],
        );

  final TabbedViewTheme theme;
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
  }
}

/// The [TabsAreaLayout] element.
class _TabsAreaLayoutElement extends MultiChildRenderObjectElement {
  _TabsAreaLayoutElement(TabsAreaLayout widget) : super(widget);

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    children.forEach((child) {
      if (child.renderObject != null) {
        _TabsAreaLayoutParentData parentData =
            child.renderObject!.parentData as _TabsAreaLayoutParentData;
        if (parentData.visible) {
          visitor(child);
        }
      }
    });
  }
}

/// Holds the hidden tab indexes.
class HiddenTabs {
  List<int> indexes = [];

  bool get hasHiddenTabs => indexes.isNotEmpty;
}

/// Constraints with value for [TabsAreaLayout].
class _TabsAreaButtonsBoxConstraints extends BoxConstraints {
  _TabsAreaButtonsBoxConstraints({
    required HiddenTabs hiddenTabs,
    required BoxConstraints constraints,
  })  : this.hasHiddenTabs = hiddenTabs.hasHiddenTabs,
        super(
            minWidth: constraints.minWidth,
            maxWidth: constraints.maxWidth,
            minHeight: constraints.minHeight,
            maxHeight: constraints.maxHeight);

  final bool hasHiddenTabs;

  @override
  bool operator ==(dynamic other) {
    assert(debugAssertIsValid());
    if (identical(this, other)) return true;
    if (other is! _TabsAreaButtonsBoxConstraints) return false;
    final _TabsAreaButtonsBoxConstraints typedOther = other;
    assert(typedOther.debugAssertIsValid());
    return hasHiddenTabs == typedOther.hasHiddenTabs &&
        minWidth == typedOther.minWidth &&
        maxWidth == typedOther.maxWidth &&
        minHeight == typedOther.minHeight &&
        maxHeight == typedOther.maxHeight;
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return hashValues(minWidth, maxWidth, minHeight, maxHeight, hasHiddenTabs);
  }
}

/// Parent data for [_TabsAreaLayoutRenderBox] class.
class _TabsAreaLayoutParentData extends ContainerBoxParentData<RenderBox> {
  bool visible = false;
  bool selected = false;

  double leftBorderHeight = 0;
  double rightBorderHeight = 0;

  /// Resets all values.
  reset() {
    visible = false;
    selected = false;

    leftBorderHeight = 0;
    rightBorderHeight = 0;
  }
}

/// Utility class to find out which tabs may be visible.
/// Calculates the required width and sets the offset value.
class _VisibleTabs {
  _VisibleTabs(this.tabsAreaTheme);

  final TabsAreaTheme tabsAreaTheme;

  List<RenderBox> _tabs = [];

  add(RenderBox tab) {
    _tabs.add(tab);
  }

  int get length => _tabs.length;

  RenderBox get(int index) {
    return _tabs[index];
  }

  /// Layouts the single selected tab.
  layoutSingleTab(BoxConstraints constraints, Size tabsAreaButtonsSize) {
    if (_tabs.length == 1) {
      double availableWidth = constraints.maxWidth -
          tabsAreaButtonsSize.width -
          tabsAreaTheme.initialGap -
          tabsAreaTheme.minimalFinalGap;

      if (availableWidth > 0) {
        RenderBox tab = _tabs.first;
        if (tab.size.width > availableWidth) {
          final BoxConstraints childConstraints =
              BoxConstraints.loose(Size(availableWidth, constraints.maxHeight));
          tab.layout(childConstraints, parentUsesSize: true);
        }
      }
    }
  }

  /// Updates the offset given the tab width, initial offset and gap values.
  updateOffsets(BoxConstraints constraints, Size tabsAreaButtonsSize) {
    double offset = tabsAreaTheme.initialGap;
    for (int i = 0; i < _tabs.length; i++) {
      RenderBox tab = _tabs[i];
      _TabsAreaLayoutParentData tabParentData = tab.tabsAreaLayoutParentData();

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
      _TabsAreaLayoutParentData parentData =
          tab.parentData as _TabsAreaLayoutParentData;
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
}

/// The [TabsAreaLayout] render box.
class _TabsAreaLayoutRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TabsAreaLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TabsAreaLayoutParentData> {
  _TabsAreaLayoutRenderBox(
      TabbedViewTheme theme, this.hiddenTabs, this.selectedTabIndex)
      : this.tabsAreaTheme = theme.tabsArea;

  int? selectedTabIndex;
  TabsAreaTheme tabsAreaTheme;
  HiddenTabs hiddenTabs;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TabsAreaLayoutParentData) {
      child.parentData = _TabsAreaLayoutParentData();
    }
  }

  @override
  void performLayout() {
    List<RenderBox> children = [];
    // There will always be at least 1 child (tabs area buttons).
    visitChildren((child) {
      final _TabsAreaLayoutParentData parentData =
          child.tabsAreaLayoutParentData();
      parentData.reset();
      parentData.selected =
          selectedTabIndex != null && selectedTabIndex == children.length
              ? true
              : false;
      children.add(child as RenderBox);
    });

    hiddenTabs.indexes.clear();

    // layout all (tabs + tabs area buttons)
    _VisibleTabs visibleTabs = _VisibleTabs(tabsAreaTheme);

    final BoxConstraints childConstraints =
        BoxConstraints.loose(Size(constraints.maxWidth, constraints.maxHeight));

    for (int i = 0; i < children.length; i++) {
      RenderBox child = children[i];
      child.layout(childConstraints, parentUsesSize: true);
      if (i < children.length - 1) {
        // ignoring tabs area buttons
        visibleTabs.add(child);
      }
    }

    // lastChild is the tabs area buttons and will always exist and be visible.
    // It can be an empty SizedBox, a single button or a Container with buttons.
    RenderBox tabsAreaButtons = lastChild!;

    double availableWidth = math.max(
        constraints.maxWidth -
            tabsAreaTheme.initialGap -
            tabsAreaButtons.size.width,
        0);

    visibleTabs.layoutSingleTab(constraints, tabsAreaButtons.size);
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
        hiddenTabs.indexes.add(removedIndex);

        // It performs another layout because the component can be changed
        // with hidden tabs.
        tabsAreaButtons.layout(
          _TabsAreaButtonsBoxConstraints(
              hiddenTabs: hiddenTabs, constraints: childConstraints),
          parentUsesSize: true,
        );
        availableWidth = math.max(
            constraints.maxWidth -
                tabsAreaTheme.initialGap -
                tabsAreaButtons.size.width,
            0);
      }
      visibleTabs.layoutSingleTab(constraints, tabsAreaButtons.size);
    }
    visibleTabs.updateOffsets(constraints, tabsAreaButtons.size);

    List<RenderBox> visibleChildren = [];
    for (int i = 0; i < visibleTabs.length; i++) {
      RenderBox tab = visibleTabs.get(i);
      final _TabsAreaLayoutParentData tabParentData =
          tab.tabsAreaLayoutParentData();
      tabParentData.visible = true;
      visibleChildren.add(tab);
    }

    if (tabsAreaButtons.size.width > 0 &&
        tabsAreaButtons.size.width <=
            constraints.maxWidth - tabsAreaTheme.initialGap) {
      final _TabsAreaLayoutParentData tabsAreaButtonsParentData =
          tabsAreaButtons.tabsAreaLayoutParentData();
      tabsAreaButtonsParentData.visible = true;
      // anchoring tabsAreaButtons to the right
      tabsAreaButtonsParentData.offset =
          Offset(constraints.maxWidth - tabsAreaButtons.size.width, 0);
      visibleChildren.add(tabsAreaButtons);
    }

    // Defines the biggest height to avoid displacement of tabs when
    // changing visibility.
    final double biggestChildHeight = children.fold(
      0,
      (previousValue, child) => math.max(
        previousValue,
        child.size.height,
      ),
    );

    if (tabsAreaTheme.equalHeights == EqualHeights.none) {
      // Aligning visible children.
      for (RenderBox tab in visibleChildren) {
        final _TabsAreaLayoutParentData parentData =
            tab.tabsAreaLayoutParentData();
        parentData.offset =
            Offset(parentData.offset.dx, biggestChildHeight - tab.size.height);
      }
    } else {
      if (tabsAreaTheme.equalHeights == EqualHeights.tabs) {
        int visibleCount = visibleChildren.length;
        if (hiddenTabs.hasHiddenTabs) {
          visibleCount--;
        }
        for (int i = 0; i < visibleCount; i++) {
          RenderBox tab = visibleChildren[i];
          tab.layout(
              BoxConstraints.tightFor(
                  width: tab.size.width, height: biggestChildHeight),
              parentUsesSize: true);
          final _TabsAreaLayoutParentData parentData =
              tab.tabsAreaLayoutParentData();
          parentData.offset = Offset(parentData.offset.dx, 0);
        }
        if (hiddenTabs.hasHiddenTabs) {
          RenderBox tabsAreaButtons = visibleChildren.last;
          final _TabsAreaLayoutParentData parentData =
              tabsAreaButtons.tabsAreaLayoutParentData();
          parentData.offset = Offset(parentData.offset.dx,
              biggestChildHeight - tabsAreaButtons.size.height);
        }
      } else if (tabsAreaTheme.equalHeights == EqualHeights.all) {
        for (RenderBox child in visibleChildren) {
          child.layout(
              BoxConstraints.tightFor(
                  width: child.size.width, height: biggestChildHeight),
              parentUsesSize: true);

          final _TabsAreaLayoutParentData parentData =
              child.tabsAreaLayoutParentData();
          parentData.offset = Offset(parentData.offset.dx, 0);
        }
      }
    }

    double height = biggestChildHeight;
    if (tabsAreaTheme.gapBottomBorder.style == BorderStyle.solid &&
        tabsAreaTheme.gapBottomBorder.width > 0) {
      height = math.max(height, tabsAreaTheme.gapBottomBorder.width);
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
    visitVisibleChildren((RenderObject child) {
      final _TabsAreaLayoutParentData childParentData =
          child.tabsAreaLayoutParentData();
      context.paintChild(child, childParentData.offset + offset);
      if (child != lastChild) {
        visibleTabs.add(child as RenderBox);
      }
    });

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
      _TabsAreaLayoutParentData tabParentData = tab.tabsAreaLayoutParentData();
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
      if (visibleTabs.length > 0) {
        RenderBox lastTab = visibleTabs.last;
        _TabsAreaLayoutParentData tabParentData =
            lastTab.tabsAreaLayoutParentData();
        lastX = offset.dx + tabParentData.offset.dx + lastTab.size.width;
      } else {
        lastX = offset.dx + tabsAreaTheme.initialGap;
      }

      RenderBox? tabsAreaButtons = lastChild!;
      double lastGapWidth = offset.dx + size.width - lastX;
      if (tabsAreaButtons.tabsAreaLayoutParentData().visible) {
        lastGapWidth -= tabsAreaButtons.size.width;
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
    visitVisibleChildren((renderObject) {
      final RenderBox child = renderObject as RenderBox;
      final _TabsAreaLayoutParentData childParentData =
          child.tabsAreaLayoutParentData();
      result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
    });

    return false;
  }
}

/// Utility extension to facilitate obtaining parent data.
extension _TabsAreaLayoutParentDataGetter on RenderObject {
  _TabsAreaLayoutParentData tabsAreaLayoutParentData() {
    return this.parentData as _TabsAreaLayoutParentData;
  }
}
