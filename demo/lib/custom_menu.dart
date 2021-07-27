import 'package:demo/example_multi_view_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class CustomMenuPage extends StatefulWidget {
  @override
  CustomMenuPageState createState() => CustomMenuPageState();
}

enum _View { normal, width, ellipsis }

class CustomMenuPageState extends ExampleMultiViewPageState<_View> {
  @override
  _View defaultView() {
    return _View.normal;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [
      buttonView('Normal', _View.normal),
      buttonView('Width', _View.width),
      buttonView('Ellipsis', _View.ellipsis)
    ];
  }

  @override
  Widget buildContentView(_View currentView) {
    switch (currentView) {
      case _View.normal:
        return _normal();
      case _View.width:
        return _width();
      case _View.ellipsis:
        return _ellipsis();
    }
  }

  Widget _normal() {
    List<TabData> tabs = [];
    for (int i = 1; i < 11; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }

    TabbedViewTheme theme = TabbedViewTheme.classic();

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
    return tabbedView;
  }

  Widget _width() {
    List<TabData> tabs = [];
    for (int i = 1; i < 11; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }

    TabbedViewTheme theme = TabbedViewTheme.classic()..menu.maxWidth = 100;

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
    return tabbedView;
  }

  Widget _ellipsis() {
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3'),
      TabData(
          text: 'The name of the tab is so long that it doesn'
              't fit on the menu')
    ];

    TabbedViewTheme theme = TabbedViewTheme.classic()
      ..menu.ellipsisOverflowText = true;

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
    return tabbedView;
  }
}
