import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

/// Parent data for [_TabsAreaLayoutRenderBox] class.
@internal
class TabsAreaLayoutParentData extends ContainerBoxParentData<RenderBox> {
  bool visible = false;
  bool selected = false;

  /// Resets all values.
  void reset() {
    visible = false;
    selected = false;
  }
}

/// Utility extension to facilitate obtaining parent data.
@internal
extension TabsAreaLayoutParentDataGetter on RenderObject {
  TabsAreaLayoutParentData tabsAreaLayoutParentData() {
    return parentData as TabsAreaLayoutParentData;
  }
}
