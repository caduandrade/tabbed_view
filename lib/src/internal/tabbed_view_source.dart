import 'package:meta/meta.dart';

/// Internal identity object used to uniquely identify a [TabbedView] instance
/// during drag-and-drop operations.
///
/// Each [TabbedViewState] owns a unique instance of this class. Identity is
/// determined by reference (object identity), allowing reliable comparison
/// between drag source and drop target.
///
/// This enables distinguishing between:
/// - reordering tabs within the same [TabbedView]
/// - moving tabs across different [TabbedView] instances
///
/// This class intentionally has no fields. Do not make it `const`, as each
/// instance must be unique.
///
/// This object is not intended for public API usage.
@internal
class TabbedViewSource {
  TabbedViewSource();
}
