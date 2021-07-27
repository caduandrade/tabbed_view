import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class ChangeTabPage extends StatefulWidget {
  @override
  ChangeTabPageState createState() => ChangeTabPageState();
}

class ChangeTabPageState extends ExamplePageState {
  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();

    List<TabData> tabs = [];
    for (var i = 0; i < 5; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }
    _controller = TabbedViewController(tabs);
  }

  @override
  Widget buildContent() {
    TabbedView tabbedView = TabbedView(controller: _controller);
    return tabbedView;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [
      ElevatedButton(child: Text('Disable close'), onPressed: _onDisableClose),
      ElevatedButton(
          child: Text('Change tab text'), onPressed: _onChangeTabText)
    ];
  }

  _onChangeTabText() {
    if (_controller.tabs.length > 0) {
      setState(() {
        _controller.tabs[0].text = 'New text';
      });
    }
  }

  _onDisableClose() {
    if (_controller.tabs.length > 0) {
      setState(() {
        _controller.tabs[0].closable = false;
      });
    }
  }
}
