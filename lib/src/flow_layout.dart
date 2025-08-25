import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/theme/vertical_alignment.dart';

enum FlowDirection { horizontal, vertical }

/// Flow layout.
class FlowLayout extends MultiChildRenderObjectWidget {
  FlowLayout(
      {Key? key,
      required List<Widget> children,
      required this.firstChildFlex,
      this.verticalAlignment = VerticalAlignment.center,
      this.direction = FlowDirection.horizontal})
      : super(key: key, children: children);

  final bool firstChildFlex;
  final VerticalAlignment verticalAlignment;
  final FlowDirection direction;

  @override
  _FlowLayoutElement createElement() {
    return _FlowLayoutElement(this);
  }

  @override
  _FlowLayoutRenderBox createRenderObject(BuildContext context) {
    return _FlowLayoutRenderBox(firstChildFlex, verticalAlignment, direction);
  }

  @override
  void updateRenderObject(
      BuildContext context, _FlowLayoutRenderBox renderObject) {
    renderObject..firstChildFlex = firstChildFlex;
    renderObject..verticalAlignment = verticalAlignment;
    renderObject..direction = direction;
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
  _FlowLayoutRenderBox(
      this.firstChildFlex, this.verticalAlignment, this.direction);

  bool firstChildFlex;
  VerticalAlignment verticalAlignment;
  FlowDirection direction;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _FlowLayoutParentData) {
      child.parentData = _FlowLayoutParentData();
    }
  }

  // Calculates the offset along the secondary axis for a child.
  double _calculateSecondaryAxisOffset(
      double childSecondarySize, double secondaryAxisConstraint) {
    if (!secondaryAxisConstraint.isFinite || secondaryAxisConstraint < 0) {
      // If the constraint is infinite or negative, treat it as zero to prevent infinite offsets.
      secondaryAxisConstraint = 0;
    }
    // This is for secondary axis alignment (vertical for horizontal flow, horizontal for vertical flow)
    // verticalAlignment is actually secondary axis alignment (e.g., top/center/bottom for horizontal flow, left/center/right for vertical flow)
    switch (verticalAlignment) {
      // verticalAlignment is actually secondary axis alignment
      case VerticalAlignment.top:
        // Align to the start of the secondary axis (top for horizontal, left for vertical)
        return 0;
      case VerticalAlignment.center:
        // Center along the secondary axis
        return (secondaryAxisConstraint - childSecondarySize) / 2;
      case VerticalAlignment.bottom:
        // Align to the end of the secondary axis (bottom for horizontal, right for vertical)
        return secondaryAxisConstraint - childSecondarySize;
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
        direction == FlowDirection.horizontal
            ? BoxConstraints.loose(Size(double.infinity, constraints.maxHeight))
            : BoxConstraints.loose(Size(constraints.maxWidth, double.infinity));

    double firstPrimarySize = 0;
    double otherPrimarySizes = 0;
    double biggestSecondarySize = 0;

    for (int i = 0; i < children.length; i++) {
      children[i].layout(childConstraints, parentUsesSize: true);
      double childPrimarySize = direction == FlowDirection.horizontal
          ? children[i].size.width
          : children[i].size.height;
      double childSecondarySize = direction == FlowDirection.horizontal
          ? children[i].size.height
          : children[i].size.width;

      if (firstChildFlex && i == 0) {
        firstPrimarySize = childPrimarySize;
      } else {
        otherPrimarySizes += childPrimarySize;
      }
      biggestSecondarySize = math.max(biggestSecondarySize, childSecondarySize);
    }

    double totalPrimarySize = 0;
    double primaryAxisConstraint = direction == FlowDirection.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;

    if (otherPrimarySizes > primaryAxisConstraint) {
      totalPrimarySize = primaryAxisConstraint;
      if (firstChildFlex) {
        children[0].flowLayoutParentData().visible = false;
      }
      double availablePrimarySpace = primaryAxisConstraint;
      for (int i = children.length - 1; i >= 0; i--) {
        if (firstChildFlex && i > 0) {
          double childPrimarySize = direction == FlowDirection.horizontal
              ? children[i].size.width
              : children[i].size.height;
          double childSecondarySize = direction == FlowDirection.horizontal
              ? children[i].size.height
              : children[i].size.width;

          if (availablePrimarySpace <= 0) {
            children[i].flowLayoutParentData().visible = false;
          } else {
            if (direction == FlowDirection.horizontal) {
              children[i].flowLayoutParentData().offset = Offset(
                  availablePrimarySpace - childPrimarySize,
                  _calculateSecondaryAxisOffset(
                      childSecondarySize, biggestSecondarySize));
            } else {
              children[i].flowLayoutParentData().offset = Offset(
                  _calculateSecondaryAxisOffset(
                      childSecondarySize, biggestSecondarySize),
                  availablePrimarySpace - childPrimarySize);
            }
            availablePrimarySpace -= childPrimarySize;
          }
        }
      }
    } else {
      if (firstChildFlex &&
          firstPrimarySize + otherPrimarySizes > primaryAxisConstraint) {
        children[0].layout(
            BoxConstraints(
                minWidth: direction == FlowDirection.horizontal
                    ? 0
                    : biggestSecondarySize,
                maxWidth: direction == FlowDirection.horizontal
                    ? primaryAxisConstraint - otherPrimarySizes
                    : biggestSecondarySize,
                minHeight: direction == FlowDirection.horizontal
                    ? biggestSecondarySize
                    : 0,
                maxHeight: direction == FlowDirection.horizontal
                    ? biggestSecondarySize
                    : primaryAxisConstraint - otherPrimarySizes),
            parentUsesSize: true);
      }
      double currentPrimaryOffset = 0;
      for (RenderBox child in children) {
        double childPrimarySize = direction == FlowDirection.horizontal
            ? child.size.width
            : child.size.height;
        double childSecondarySize = direction == FlowDirection.horizontal
            ? child.size.height
            : child.size.width;
        if (direction == FlowDirection.horizontal) {
          child.flowLayoutParentData().offset = Offset(
              currentPrimaryOffset,
              _calculateSecondaryAxisOffset(
                  childSecondarySize, biggestSecondarySize));
        } else {
          child.flowLayoutParentData().offset = Offset(
              _calculateSecondaryAxisOffset(
                  childSecondarySize, biggestSecondarySize),
              currentPrimaryOffset);
        }

        currentPrimaryOffset += childPrimarySize;
      }
      totalPrimarySize = currentPrimaryOffset;
    }

    size = constraints.constrain(direction == FlowDirection.horizontal
        ? Size(totalPrimarySize, biggestSecondarySize)
        : Size(biggestSecondarySize, totalPrimarySize));
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
