import 'package:flutter/material.dart';

import '../tab_data.dart';

/// Builds the view associated with a tab in a [TabbedView].
///
/// This builder is used to render the main content area for the
/// currently selected tab.
///
/// The [tab] provides access to the tab's metadata and optional
/// domain data (e.g., via [TabData.value]).
typedef TabViewBuilder = Widget Function(
  BuildContext context,
  TabData tab,
);
