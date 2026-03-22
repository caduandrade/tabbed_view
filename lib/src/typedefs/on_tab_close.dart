import '../tab_data.dart';

/// Called when the user requests to close a tab.
///
/// This callback represents an intent triggered by user interaction,
/// such as clicking the close button on a tab.
///
/// In declarative usage, it is the responsibility of the caller to
/// update the tab list accordingly.
///
/// This callback does not guarantee that the tab will be removed.
typedef OnTabClose = void Function(TabData tab);
