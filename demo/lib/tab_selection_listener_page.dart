import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TabSelectionListenerPage extends StatefulWidget {
  @override
  TabSelectionListenerPageState createState() =>
      TabSelectionListenerPageState();
}

class TabSelectionListenerPageState extends ExamplePageState {
  @override
  Widget buildContent() {
    _onTabSelection(int? newTabIndex) {
      print('The new selected tab is $newTabIndex.');
    }

    List<TabData> tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];
    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs),
        onTabSelection: _onTabSelection);
    return tabbedView;
  }
}
