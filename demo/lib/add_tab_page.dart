import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class AddTabPage extends StatefulWidget {
  @override
  AddTabPageState createState() => AddTabPageState();
}

class AddTabPageState extends ExamplePageState {
  late TabbedWiewModel _model;
  int _lastTabIndex = 1;

  @override
  void initState() {
    super.initState();
    _model = TabbedWiewModel([]);
  }

  @override
  Widget buildContent() {
    TabbedWiew tabbedView = TabbedWiew(model: _model);
    return tabbedView;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [ElevatedButton(child: Text('Add tab'), onPressed: _onPressed)];
  }

  _onPressed() {
    setState(() {
      _model.add(TabData(
          text: 'Tab $_lastTabIndex', content: Text('Content $_lastTabIndex')));
      _lastTabIndex++;
    });
  }
}
