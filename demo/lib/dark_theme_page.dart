import 'package:demo/example_multi_view_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class DarkThemePage extends StatefulWidget {
  @override
  DarkThemePageState createState() => DarkThemePageState();
}

enum _View { normal, change_color }

class DarkThemePageState extends ExampleMultiViewPageState<_View> {
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
      tabs.add(TabData(text: 'Tab $i'));
    }
    TabbedViewController controller = TabbedViewController(tabs);

    var contentBuilder = (BuildContext context, int index) {
      int i = index + 1;
      Text text = Text('Content $i', style: TextStyle(color: Colors.white));
      return Center(child: text);
    };

    TabbedView tabbedView = TabbedView(
        controller: controller,
        contentBuilder: contentBuilder,
        theme: TabbedViewTheme.dark());

    Container container = Container(child: tabbedView, color: Colors.black);

    return container;
  }

  Widget _changeColor() {
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }
    TabbedViewController controller = TabbedViewController(tabs);

    var contentBuilder = (BuildContext context, int index) {
      int i = index + 1;
      Text text = Text('Content $i', style: TextStyle(color: Colors.white));
      return Center(child: text);
    };

    TabbedViewTheme theme = TabbedViewTheme.dark(colorSet: Colors.indigo);

    TabbedView tabbedView = TabbedView(
        controller: controller, contentBuilder: contentBuilder, theme: theme);

    Container container = Container(child: tabbedView, color: Colors.black12);

    return container;
  }
}
