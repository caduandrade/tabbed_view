import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/theme_data.dart';

/// Flow layout.
class FlowLayout extends MultiChildRenderObjectWidget {
  FlowLayout(
      {Key? key,
      required List<Widget> children,
      required this.firstChildFlex,
      this.verticalAlignment = VerticalAlignment.center})
      : super(key: key, children: children);

  final bool firstChildFlex;
  final VerticalAlignment verticalAlignment;

  @override
  _FlowLayoutElement createElement() {
    return _FlowLayoutElement(this);
  }

  @override
  _FlowLayoutRenderBox createRenderObject(BuildContext context) {
    return _FlowLayoutRenderBox(firstChildFlex, verticalAlignment);
  }

  @override
  void updateRenderObject(
      BuildContext context, _FlowLayoutRenderBox renderObject) {
    renderObject..firstChildFlex = firstChildFlex;
    renderObject..verticalAlignment = verticalAlignment;
  }
}

/// The [FlowLayout] element.
class _FlowLayoutElement extends MultiChildRenderObjectElement {
  _FlowLayoutElement(FlowLayout widget) : super(widget);

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    children.forEach((child) {
      if (child.renderObject != null) {
        visitor(child);
      }
    });
  }
}

/// Parent data for [_FlowLayoutRenderBox] class.
class _FlowLayoutParentData extends ContainerBoxParentData<RenderBox> {
  bool visible = true;
}

/// The [FlowLayout] render box.
class _FlowLayoutRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _FlowLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _FlowLayoutParentData> {
  _FlowLayoutRenderBox(this.firstChildFlex, this.verticalAlignment);

  bool firstChildFlex;
  VerticalAlignment verticalAlignment;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _FlowLayoutParentData) {
      child.parentData = _FlowLayoutParentData();
    }
  }

  double _y(double childHeight) {
    switch (verticalAlignment) {
      case VerticalAlignment.top:
        return 0;
      case VerticalAlignment.center:
        return (constraints.maxHeight - childHeight) / 2;
      case VerticalAlignment.bottom:
        return constraints.maxHeight - childHeight;
    }
  }

  @override
  void performLayout() {
    List<RenderBox> children = [];
    visitChildren((child) {
      children.add(child as RenderBox);
      child.flowLayoutParentData().visible = true;
    });

    final BoxConstraints childConstraints =
        BoxConstraints.loose(Size(double.infinity, constraints.maxHeight));

    double firstWidth = 0;
    double otherWidths = 0;
    double biggestChildHeight = 0;
    for (int i = 0; i < children.length; i++) {
      children[i].layout(childConstraints, parentUsesSize: true);
      if (firstChildFlex && i == 0) {
        firstWidth = children[i].size.width;
      } else {
        otherWidths += children[i].size.width;
      }
      biggestChildHeight =
          math.max(biggestChildHeight, children[i].size.height);
    }

    double width = 0;
    if (otherWidths > constraints.maxWidth) {
      width = constraints.maxWidth;
      if (firstChildFlex) {
        children[0].flowLayoutParentData().visible = false;
      }
      double availableWidth = constraints.maxWidth;
      for (int i = children.length - 1; i >= 0; i--) {
        if (firstChildFlex && i > 0) {
          if (availableWidth <= 0) {
            children[i].flowLayoutParentData().visible = false;
          } else {
            children[i].flowLayoutParentData().offset = Offset(
                availableWidth - children[i].size.width,
                _y(children[i].size.height));
            availableWidth -= children[i].size.width;
          }
        }
      }
    } else {
      if (firstChildFlex && firstWidth + otherWidths > constraints.maxWidth) {
        children[0].layout(
            BoxConstraints(
                minWidth: 0,
                maxWidth: constraints.maxWidth - otherWidths,
                minHeight: biggestChildHeight,
                maxHeight: biggestChildHeight),
            parentUsesSize: true);
      }
      double x = 0;
      children.forEach((child) {
        child.flowLayoutParentData().offset = Offset(x, _y(child.size.height));
        x += child.size.width;
      });
      width = x;
    }

    size = constraints.constrain(Size(width, biggestChildHeight));
  }

  void _visitVisibleChildren(RenderObjectVisitor visitor) {
    visitChildren((child) {
      if (child.flowLayoutParentData().visible) {
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
    _visitVisibleChildren((RenderObject child) {
      final _FlowLayoutParentData childParentData =
          child.flowLayoutParentData();
      context.paintChild(child, childParentData.offset + offset);
    });
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    _visitVisibleChildren((renderObject) {
      final RenderBox child = renderObject as RenderBox;
      final _FlowLayoutParentData childParentData =
          child.flowLayoutParentData();
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
extension _FlowLayoutParentDataDataGetter on RenderObject {
  _FlowLayoutParentData flowLayoutParentData() {
    return this.parentData as _FlowLayoutParentData;
  }
}
