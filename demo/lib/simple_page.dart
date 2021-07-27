import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class SimplePage extends StatefulWidget {
  @override
  SimplePageState createState() => SimplePageState();
}

class SimplePageState extends ExamplePageState {
  @override
  Widget buildContent() {
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      Widget tabContent = Center(child: Text('Content $i'));
      tabs.add(TabData(text: 'Tab $i', content: tabContent));
    }
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
    return tabbedView;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [ElevatedButton(child: Text('Rebuild'), onPressed: _onRebuild)];
  }

  _onRebuild() {
    setState(() {});
  }
}
