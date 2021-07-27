import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TabCloseListenerPage extends StatefulWidget {
  @override
  TabCloseListenerPageState createState() => TabCloseListenerPageState();
}

class TabCloseListenerPageState extends ExamplePageState {
  @override
  Widget buildContent() {
    bool _onTabClosing(int tabIndex) {
      if (tabIndex == 0) {
        print('The tab $tabIndex is busy and cannot be closed.');
        return false;
      }
      print('Closing tab $tabIndex...');
      return true;
    }

    List<TabData> tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];
    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs), onTabClosing: _onTabClosing);
    return tabbedView;
  }
}
