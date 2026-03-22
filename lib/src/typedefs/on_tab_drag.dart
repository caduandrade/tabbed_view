import '../tab_data.dart';

/// Called when the user requests to reorder a tab within this [TabbedView].
///
/// This callback is triggered for drag-and-drop operations that keep the tab
/// inside the same [TabbedView].
///
/// The [tab] identifies the tab being moved.
///
/// The tab must be placed before the tab identified by [target].
/// If [target] is `null`, the tab must be moved to the end of the list.
///
/// In declarative usage, it is the responsibility of the caller to reorder
/// the tab list accordingly and rebuild the widget.
///
/// This callback does not guarantee that the reorder will be applied.
typedef OnTabReorder = void Function(
  TabData tab,
  TabData? target,
);

/// Called when a tab is detached from this [TabbedView].
///
/// This callback is triggered when the user drags a tab out of this
/// [TabbedView] with the intent of moving it to another [TabbedView].
///
/// The [tab] identifies the tab being detached.
///
/// In declarative usage, it is the responsibility of the caller to remove
/// the tab from this [TabbedView] and rebuild the widget.
///
/// This callback does not guarantee that the detach will be applied.
typedef OnTabDetach = void Function(
  TabData tab,
);

/// Called when a tab is attached to this [TabbedView].
///
/// This callback is triggered when the user drops a tab into this
/// [TabbedView] from another instance.
///
/// The [tab] identifies the tab being attached.
///
/// The tab must be inserted before the tab identified by [target].
/// If [target] is `null`, the tab must be inserted at the end.
///
/// In declarative usage, it is the responsibility of the caller to insert
/// the tab into this [TabbedView] and rebuild the widget.
///
/// This callback does not guarantee that the attach will be applied.
typedef OnTabAttach = void Function(
  TabData tab,
  TabData? target,
);
