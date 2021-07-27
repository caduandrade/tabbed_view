import 'package:demo/example_multi_view_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class MobileThemePage extends StatefulWidget {
  @override
  MobileThemePageState createState() => MobileThemePageState();
}

enum _View { normal, change_color_set, change_highlighted_tab_color }

class MobileThemePageState extends ExampleMultiViewPageState<_View> {
  @override
  _View defaultView() {
    return _View.normal;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [
      buttonView('Normal', _View.normal),
      buttonView('Change color set', _View.change_color_set),
      buttonView(
          'Change highlightedTabColor', _View.change_highlighted_tab_color)
    ];
  }

  @override
  Widget buildContentView(_View currentView) {
    switch (currentView) {
      case _View.normal:
        return _normal();
      case _View.change_color_set:
        return _changeColorSet();
      case _View.change_highlighted_tab_color:
        return _changeHighlightedTabColor();
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
        TabbedView(controller: controller, theme: TabbedViewTheme.mobile());
    return tabbedView;
  }

  Widget _changeColorSet() {
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }
    TabbedViewController controller = TabbedViewController(tabs);
    TabbedViewTheme theme = TabbedViewTheme.mobile(colorSet: Colors.blueGrey);
    TabbedView tabbedView = TabbedView(controller: controller, theme: theme);
    return tabbedView;
  }

  Widget _changeHighlightedTabColor() {
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }
    TabbedViewController controller = TabbedViewController(tabs);
    TabbedViewTheme theme =
        TabbedViewTheme.mobile(highlightedTabColor: Colors.green[700]!);
    TabbedView tabbedView = TabbedView(controller: controller, theme: theme);
    return tabbedView;
  }
}
