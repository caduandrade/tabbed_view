import '../tab_data.dart';

/// Called after a tab has been removed from the tab list.
///
/// This callback is triggered when a tab is effectively removed,
/// regardless of the cause. This includes:
///
/// - User-initiated close actions
/// - Programmatic removal
/// - External state updates
typedef OnTabRemoved = void Function(TabData tab);
