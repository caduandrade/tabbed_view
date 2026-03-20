import 'package:flutter/foundation.dart';

/// Signature for a callback that is invoked when a tab is selected
/// in the declarative [TabbedView].
///
/// The [selectedKey] identifies the selected tab using its [Key].
/// If `null`, it means that no tab is currently selected.
///
/// This callback represents a user intention. The parent widget is
/// responsible for updating the external state (e.g., `selectedIndex`
/// or selected key) and triggering a rebuild.
///
/// Unlike the controller-based API, this callback does not provide
/// direct access to tab instances. The [Key] must be used to identify
/// the corresponding tab in the current list.
typedef OnTabSelected = void Function(Key? selectedKey);
