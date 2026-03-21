import '../tab_selection.dart';

/// Called when the effective tab selection has changed.
///
/// This callback is triggered after the selection state is updated, regardless
/// of the cause. This includes:
///
/// - User-initiated selection
/// - Tab removal
/// - Tab reordering
/// - Clearing all tabs
/// - External state updates
///
/// The [selection] will be `null` if no tab is currently selected.
typedef OnTabSelected = void Function(TabSelection? selection);
