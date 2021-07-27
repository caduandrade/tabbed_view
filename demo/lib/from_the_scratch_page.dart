import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class FromTheScratchPage extends StatefulWidget {
  @override
  FromTheScratchPageState createState() => FromTheScratchPageState();
}

class FromTheScratchPageState extends ExamplePageState {
  @override
  Widget buildContent() {
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];

    TabbedViewTheme theme = TabbedViewTheme();
    theme.tabsArea
      ..border = Border(bottom: BorderSide(color: Colors.green[700]!, width: 3))
      ..middleGap = 6;

    Radius radius = Radius.circular(10.0);
    BorderRadiusGeometry? borderRadius =
        BorderRadius.only(topLeft: radius, topRight: radius);

    theme.tabsArea.tab
      ..padding = EdgeInsets.fromLTRB(10, 4, 10, 4)
      ..buttonsOffset = 8
      ..decoration = BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green[100],
          borderRadius: borderRadius)
      ..selectedStatus.decoration =
          BoxDecoration(color: Colors.green[200], borderRadius: borderRadius)
      ..highlightedStatus.decoration =
          BoxDecoration(color: Colors.green[50], borderRadius: borderRadius);

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
    return tabbedView;
  }
}
