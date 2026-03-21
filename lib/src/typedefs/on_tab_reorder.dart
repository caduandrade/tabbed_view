/// Called when the user requests to reorder a tab.
///
/// This callback represents a reorder intent triggered by user interaction,
/// such as dragging a tab to a new position.
///
/// The [sourceTabId] identifies the tab being moved.
///
/// The [afterTabId] identifies the tab after which the source tab should be
/// placed. If `afterTabId` is `null`, the tab should be moved to the beginning
/// of the list (index 0).
///
/// In declarative usage, it is the responsibility of the caller to update
/// the tab order accordingly.
///
/// This callback does not guarantee that the reorder will be applied.
typedef OnTabReorder = void Function(Object sourceTabId, Object? afterTabId);
