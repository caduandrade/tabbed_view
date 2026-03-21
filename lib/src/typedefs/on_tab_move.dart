/// Called when the user requests to move a tab.
///
/// This callback represents a move intent triggered by user interaction,
/// such as dragging a tab within the same [TabbedView] or across different
/// TabbedViews.
///
/// The [tabId] identifies the tab being moved.
///
/// The [type] defines the move operation relative to this [TabbedView]:
///
/// - [TabMoveType.reorder]: the tab should be repositioned within this [TabbedView].
/// - [TabMoveType.attach]: a tab from another [TabbedView] should be inserted here.
/// - [TabMoveType.detach]: the tab is being moved out of this [TabbedView].
///
/// The tab must be placed before the tab identified by [targetTabId].
/// If [targetTabId] is `null`, the tab must be moved to the end of the list.
/// It is only relevant for [TabMoveType.reorder] and [TabMoveType.attach].
///
/// In declarative usage, it is the responsibility of the caller to update
/// the tab list accordingly.
///
/// This callback does not guarantee that the move will be applied.
typedef OnTabMove = void Function(
  Object tabId,
  TabMoveType type,
  Object? targetTabId,
);

enum TabMoveType {
  /// Moving within the same [TabbedView].
  reorder,

  /// Tab is entering this [TabbedView] from another.
  attach,

  /// Tab is leaving this [TabbedView] to another.
  detach,
}
