import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class ChangeTabPage extends StatefulWidget {
  @override
  ChangeTabPageState createState() => ChangeTabPageState();
}

class ChangeTabPageState extends ExamplePageState {
  late TabbedWiewModel _model;

  @override
  void initState() {
    super.initState();

    List<TabData> tabs = [];
    for (var i = 0; i < 5; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }
    _model = TabbedWiewModel(tabs);
  }

  @override
  Widget buildContent() {
    TabbedWiew tabbedView = TabbedWiew(model: _model);
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
    if (_model.tabs.length > 0) {
      setState(() {
        _model.tabs[0].text = 'New text';
      });
    }
  }

  _onDisableClose() {
    if (_model.tabs.length > 0) {
      setState(() {
        _model.tabs[0].closable = false;
      });
    }
  }
}
