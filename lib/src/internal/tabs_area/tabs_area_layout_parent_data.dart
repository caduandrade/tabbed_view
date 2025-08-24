import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

/// Parent data for [_TabsAreaLayoutRenderBox] class.
@internal
class TabsAreaLayoutParentData extends ContainerBoxParentData<RenderBox> {

  Color? contentBorderColor;

  bool visible = false;
  bool selected = false;

  double leftBorderHeight = 0;
  double rightBorderHeight = 0;

  /// Resets all values.
  void reset() {
    visible = false;
    selected = false;

    leftBorderHeight = 0;
    rightBorderHeight = 0;
  }
}

/// Utility extension to facilitate obtaining parent data.
@internal
extension TabsAreaLayoutParentDataGetter on RenderObject {
  TabsAreaLayoutParentData tabsAreaLayoutParentData() {
    return parentData as TabsAreaLayoutParentData;
  }
}
