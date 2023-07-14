import 'package:tabbed_view/src/draggable_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';

typedef OnBeforeDropAccept = bool Function(
    DraggableData source, TabbedViewController target);
