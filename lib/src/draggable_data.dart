import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';

class DraggableData {
  DraggableData(this.controller, this.tabData, this.group);

  final TabbedViewController controller;
  final TabData tabData;
  final String? group;
}
