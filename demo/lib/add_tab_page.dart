import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class AddTabPage extends StatefulWidget {
  @override
  AddTabPageState createState() => AddTabPageState();
}

class AddTabPageState extends ExamplePageState {
  late TabbedViewController _controller;
  int _lastTabIndex = 1;

  @override
  void initState() {
    super.initState();
    _controller = TabbedViewController([]);
  }

  @override
  Widget buildContent() {
    TabbedView tabbedView = TabbedView(controller: _controller);
    return tabbedView;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [
      ElevatedButton(child: Text('Add tab'), onPressed: _onAdd),
      ElevatedButton(child: Text('Rebuild'), onPressed: _onRebuild)
    ];
  }

  _onAdd() {
    _controller.addTab(TabData(
        text: 'Tab $_lastTabIndex', content: Text('Content $_lastTabIndex')));
    _lastTabIndex++;
  }

  _onRebuild() {
    setState(() {});
  }
}
