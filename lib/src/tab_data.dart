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
/// See also:
///
/// * [TabbedView.contentBuilder]
class TabData {
  TabData(
      {this.value,
      required this.text,
      this.buttons,
      this.content,
      this.closable = true});

  final dynamic value;
  String text;
  List<TabButton>? buttons;
  Widget? content;
  bool closable;
}
