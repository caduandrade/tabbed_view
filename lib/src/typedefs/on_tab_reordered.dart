/// Called after a tab has been reordered.
///
/// This callback is triggered when a tab is effectively moved to a new
/// position in the tab list, regardless of the cause. This includes:
///
/// - User-initiated drag-and-drop
/// - Programmatic reordering
/// - External state updates
///
/// The [oldIndex] is the previous position of the tab, and [newIndex]
/// is its new position after the reorder.
typedef OnTabReordered = void Function(int oldIndex, int newIndex);
