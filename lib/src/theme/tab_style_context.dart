import '../tab_data.dart';
import '../tab_status.dart';

/// Context information used by [TabStyleResolver] to compute per-tab styles.
///
/// This object encapsulates all relevant state needed to resolve styling for a
/// specific tab at a given moment, avoiding the need to pass multiple parameters
/// across resolver methods.
///
/// It is designed to be extensible: new properties can be added over time
/// without breaking existing resolver implementations.
///
/// Notes:
/// - [tab] identifies the target tab.
/// - [status] represents the current visual state of the tab (e.g., selected, hovered).
/// - [index] is the tab position within the tab list.
/// - [tabsCount] is the total number of tabs.
/// - [hasButtons] indicates whether the tab includes action buttons (e.g., close).
/// - [hasLeading] indicates whether the tab includes leading widget.
///
/// Additional fields may be introduced as needed by themes.
class TabStyleContext {
  const TabStyleContext({
    required this.tab,
    required this.status,
    required this.index,
    required this.tabsCount,
  });

  /// The tab for which the style is being resolved.
  final TabData tab;

  /// The current visual status of the tab.
  final TabStatus status;

  /// The index of the tab in the tab list.
  final int index;

  /// Total number of tabs.
  final int tabsCount;

  /// Whether this is the first tab.
  bool get isFirst => index == 0;

  /// Whether this is the last tab.
  bool get isLast => index == tabsCount - 1;
}
