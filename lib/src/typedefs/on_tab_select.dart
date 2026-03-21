/// Called when the user requests to select a tab.
///
/// This callback represents a selection intent triggered by user interaction,
/// such as tapping or clicking a tab.
///
/// It may be invoked even if the requested tab is already selected.
///
/// In declarative usage, it is the responsibility of the caller to update
/// the selection state accordingly (e.g., via `setState`).
///
/// This callback does not guarantee that the selection has changed.
typedef OnTabSelect = void Function(Object tabId);
