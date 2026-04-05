import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum _TabSlot { leading, text, trailing }

class _TabHeaderParentData extends ContainerBoxParentData<RenderBox> {
  _TabSlot? slot;
}

class TabHeaderRow extends MultiChildRenderObjectWidget {
  TabHeaderRow({
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    Widget? leading,
    required Widget text,
    List<Widget>? trailing,
  }) : super(children: [
          if (leading != null)
            _TabSlotWrapper(slot: _TabSlot.leading, child: leading),
          _TabSlotWrapper(slot: _TabSlot.text, child: text),
          if (trailing != null)
            ...trailing
                .map((w) => _TabSlotWrapper(slot: _TabSlot.trailing, child: w)),
        ]);

  final CrossAxisAlignment crossAxisAlignment;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderTabHeaderRow(crossAxisAlignment: crossAxisAlignment);

  @override
  void updateRenderObject(
      BuildContext context, _RenderTabHeaderRow renderObject) {
    renderObject.crossAxisAlignment = crossAxisAlignment;
  }
}

class _TabSlotWrapper extends ParentDataWidget<_TabHeaderParentData> {
  const _TabSlotWrapper({required this.slot, required super.child});
  final _TabSlot slot;

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as _TabHeaderParentData;
    if (parentData.slot != slot) {
      parentData.slot = slot;
      renderObject.parent?.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => TabHeaderRow;
}

class _RenderTabHeaderRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TabHeaderParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TabHeaderParentData> {
  _RenderTabHeaderRow({required CrossAxisAlignment crossAxisAlignment})
      : _crossAxisAlignment = crossAxisAlignment;

  CrossAxisAlignment _crossAxisAlignment;
  set crossAxisAlignment(CrossAxisAlignment value) {
    if (_crossAxisAlignment != value) {
      _crossAxisAlignment = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TabHeaderParentData)
      child.parentData = _TabHeaderParentData();
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;

    RenderBox? leading;
    RenderBox? text;
    final List<RenderBox> trailingList = [];

    RenderBox? child = firstChild;
    while (child != null) {
      final parentData = child.parentData as _TabHeaderParentData;
      if (parentData.slot == _TabSlot.leading)
        leading = child;
      else if (parentData.slot == _TabSlot.text)
        text = child;
      else if (parentData.slot == _TabSlot.trailing) trailingList.add(child);
      child = parentData.nextSibling;
    }

    double consumedWidth = 0;
    double maxHeight = 0;

    double getAvail(double consumed) {
      if (constraints.maxWidth == double.infinity) return double.infinity;
      return (constraints.maxWidth - consumed).clamp(0.0, double.infinity);
    }

    // If height is infinite, then infinity passes to the children
    // allowing them to grow as much as they intrinsically want.
    final BoxConstraints childConstraints = constraints.loosen();

    if (leading != null) {
      leading.layout(childConstraints, parentUsesSize: true);
      consumedWidth += leading.size.width;
      if (leading.size.height > maxHeight) maxHeight = leading.size.height;
    }

    for (final t in trailingList) {
      double avail = getAvail(consumedWidth);
      t.layout(
          BoxConstraints(
              minWidth: 0,
              maxWidth: avail,
              minHeight: 0,
              maxHeight: constraints.maxHeight),
          parentUsesSize: true);
      consumedWidth += t.size.width;
      if (t.size.height > maxHeight) maxHeight = t.size.height;
    }

    if (text != null) {
      double avail = getAvail(consumedWidth);
      double textIdealWidth = text.getMaxIntrinsicWidth(constraints.maxHeight);
      double textFinalWidth = avail == double.infinity
          ? textIdealWidth
          : textIdealWidth.clamp(0.0, avail);

      text.layout(
        BoxConstraints(
            minWidth: 0,
            maxWidth: textFinalWidth,
            minHeight: 0,
            maxHeight: constraints.maxHeight),
        parentUsesSize: true,
      );

      consumedWidth += text.size.width;
      if (text.size.height > maxHeight) maxHeight = text.size.height;
    }

    double finalHeight =
        maxHeight.clamp(constraints.minHeight, constraints.maxHeight);
    double finalWidth =
        consumedWidth.clamp(constraints.minWidth, constraints.maxWidth);

    size = Size(finalWidth, finalHeight);

    double xCursor = 0;
    void positionChild(RenderBox? child) {
      if (child == null) return;
      final pData = child.parentData as _TabHeaderParentData;
      double yOffset = 0;
      switch (_crossAxisAlignment) {
        case CrossAxisAlignment.start:
          yOffset = 0;
          break;
        case CrossAxisAlignment.end:
          yOffset = size.height - child.size.height;
          break;
        case CrossAxisAlignment.center:
        default:
          yOffset = (size.height - child.size.height) / 2;
          break;
      }
      pData.offset = Offset(xCursor, yOffset);
      xCursor += child.size.width;
    }

    positionChild(leading);
    positionChild(text);
    for (var t in trailingList) positionChild(t);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    double width = 0;
    visitChildren(
        (child) => width += (child as RenderBox).getMaxIntrinsicWidth(height));
    return width;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    double maxHeight = 0;
    visitChildren((child) => maxHeight =
        ((child as RenderBox).getMaxIntrinsicHeight(width) > maxHeight)
            ? child.getMaxIntrinsicHeight(width)
            : maxHeight);
    return maxHeight;
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      computeMaxIntrinsicHeight(width);

  @override
  void paint(PaintingContext context, Offset offset) {
    context.pushClipRect(needsCompositing, offset, Offset.zero & size,
        (context, offset) => defaultPaint(context, offset));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
