import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tab_status.dart';
import 'package:tabbed_view/src/theme/tab_theme_data.dart';
import 'package:tabbed_view/src/theme/vertical_alignment.dart';

/// The tab drag feedback widget.
@internal
class TabDragFeedbackWidget extends StatelessWidget {
  const TabDragFeedbackWidget({required this.tab, required this.tabTheme});

  final TabData tab;
  final TabThemeData tabTheme;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (tab.leading != null) {
      Widget? leading = tab.leading!(context, TabStatus.normal);
      if (leading != null) {
        children.add(leading);
      }
    }
    children.add(SizedBox(
        width: tab.textSize,
        child: Text(tab.text,
            style: tabTheme.textStyle, overflow: TextOverflow.ellipsis)));

    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;
    if (tabTheme.verticalAlignment == VerticalAlignment.top) {
      crossAxisAlignment = CrossAxisAlignment.start;
    } else if (tabTheme.verticalAlignment == VerticalAlignment.bottom) {
      crossAxisAlignment = CrossAxisAlignment.end;
    }

    return Container(
        child: Row(children: children, crossAxisAlignment: crossAxisAlignment),
        padding: EdgeInsets.all(4),
        decoration: tabTheme.draggingDecoration);
  }
}
