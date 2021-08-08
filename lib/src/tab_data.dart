import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tab_button.dart';

/// The tab data.
///
/// The text displayed on the tab is defined by [text] parameter.
///
/// The optional [value] parameter allows associate the tab to any value.
///
/// The optional [content] parameter defines the content of the tab.
///
/// The [closable] parameter defines whether the Close button is visible.
///
/// The [buttons] parameter allows you to define extra buttons in addition
/// to the Close button.
///
/// The [keepAlive] parameter indicates whether to keep the tab content widget
/// in memory even if it is not visible. Indicated to prevent loss of state
/// due to tree change by tab selection. If enabled, the Widget will
/// continue to be instantiated in the tree but will remain invisible.
/// The default value is `FALSE`.
/// A more efficient alternative is to keep the data in [TabData]'s [value]
/// parameter as long as the [TabbedViewController] is being kept in the
/// state of its class.
///
/// See also:
///
/// * [TabbedView.contentBuilder]
class TabData {
  TabData(
      {this.value,
      required this.text,
      this.buttons,
      this.content,
      this.closable = true,
      this.keepAlive = false});

  /// Identifies the content of the tab in the tree
  final UniqueKey uniqueKey = UniqueKey();
  final bool keepAlive;
  final dynamic value;
  String text;
  List<TabButton>? buttons;
  Widget? content;
  bool closable;
}
