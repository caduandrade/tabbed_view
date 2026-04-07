import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../tab_data.dart';
import '../../tab_status.dart';
import '../../theme/tab_theme_data.dart';
import '../../theme/vertical_alignment.dart';
import '../../typedefs/tab_label_builder.dart';

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
      Widget? leading = tab.leading!(context, TabStatus.unselected);
      if (leading != null) {
        children.add(leading);
      }
    }
    Widget label;
    final TabLabelBuilder? labelBuilder = tab.labelBuilder;
    if (labelBuilder != null) {
      label = labelBuilder.call(TabLabelBuilderContext(
          tab: tab,
          status: null,
          tabTheme: tabTheme,
          textStyle: tabTheme.textStyle));
    } else {
      final TabTextProvider? textProvider = tab.textProvider;
      final String text = textProvider?.call() ?? tab.text ?? '';
      label = SizedBox(
          width: tab.textSize,
          child: Text(text,
              style: tabTheme.textStyle, overflow: TextOverflow.ellipsis));
    }
    children.add(label);

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
