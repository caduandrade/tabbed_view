import 'package:tabbed_view/src/draggable_config.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';

/// Defines the configuration of a [Draggable] in its construction.
typedef OnDraggableBuild = DraggableConfig Function(
    TabbedViewController controller, int tabIndex, TabData tab);
