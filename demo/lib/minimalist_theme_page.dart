import 'package:demo/example_multi_view_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class MinimalistThemePage extends StatefulWidget {
  @override
  MinimalistThemePageState createState() => MinimalistThemePageState();
}

enum _View { normal, change_color }

class MinimalistThemePageState extends ExampleMultiViewPageState<_View> {
  @override
  _View defaultView() {
    return _View.normal;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [
      buttonView('Normal', _View.normal),
      buttonView('Change color', _View.change_color)
    ];
  }

  @override
  Widget buildContentView(_View currentView) {
    switch (currentView) {
      case _View.normal:
        return _normal();
      case _View.change_color:
        return _changeColor();
    }
  }

  Widget _normal() {
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }
    TabbedViewController controller = TabbedViewController(tabs);
    TabbedView tabbedView =
        TabbedView(controller: controller, theme: TabbedViewTheme.minimalist());
    return tabbedView;
  }

  Widget _changeColor() {
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }
    TabbedViewController controller = TabbedViewController(tabs);
    TabbedView tabbedView = TabbedView(
        controller: controller,
        theme: TabbedViewTheme.minimalist(colorSet: Colors.blue));
    return tabbedView;
  }
}
