import 'package:demo/example_multi_view_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TabsAreaThemePage extends StatefulWidget {
  @override
  TabsAreaThemePageState createState() => TabsAreaThemePageState();
}

enum _View { gaps, color }

class TabsAreaThemePageState extends ExampleMultiViewPageState<_View> {
  @override
  _View defaultView() {
    return _View.gaps;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [buttonView('Gaps', _View.gaps), buttonView('Color', _View.color)];
  }

  @override
  Widget buildContentView(_View currentView) {
    switch (currentView) {
      case _View.gaps:
        return _gaps();
      case _View.color:
        return _color();
    }
  }

  Widget _gaps() {
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }

    TabbedViewTheme theme = TabbedViewTheme.classic();
    theme.tabsArea
      ..initialGap = 20
      ..middleGap = 5
      ..minimalFinalGap = 5;

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
    return tabbedView;
  }

  Widget _color() {
    var tabs = [TabData(text: 'Tab 1'), TabData(text: 'Tab 2')];

    TabbedViewTheme theme = TabbedViewTheme.minimalist();
    theme.tabsArea.color = Colors.green[100];

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
    return tabbedView;
  }
}
