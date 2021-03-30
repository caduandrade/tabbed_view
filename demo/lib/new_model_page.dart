import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class NewModelPage extends StatefulWidget {
  @override
  NewModelPageState createState() => NewModelPageState();
}

class NewModelPageState extends ExamplePageState {
  int _start = 1;

  @override
  Widget buildContent() {
    List<TabData> tabs = [];
    for (var i = _start; i < _start + 5; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }
    TabbedWiewModel model = TabbedWiewModel(tabs);

    TabbedWiew tabbedView = TabbedWiew(model: model);
    return tabbedView;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [ElevatedButton(child: Text('New model'), onPressed: _onPressed)];
  }

  _onPressed() {
    setState(() {
      _start += 10;
    });
  }
}
