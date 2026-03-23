import '../draggable_config.dart';
import '../tab_data.dart';

/// Defines the configuration of a [Draggable] in its construction.
typedef OnDraggableBuild = DraggableConfig Function(
  int tabIndex,
  TabData tab,
);
