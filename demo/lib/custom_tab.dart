import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class CustomTabPage extends StatefulWidget {
  @override
  CustomTabPageState createState() => CustomTabPageState();
}

enum _Custom { button, nonclosable }

class CustomTabPageState extends ExamplePageState {
  _Custom _custom = _Custom.button;

  @override
  List<Widget> buildExampleWidgets() {
    return [
      ElevatedButton(
          onPressed: () {
            setState(() {
              _custom = _Custom.button;
            });
          },
          child: Text('Button')),
      ElevatedButton(
          onPressed: () {
            setState(() {
              _custom = _Custom.nonclosable;
            });
          },
          child: Text('Non-closable'))
    ];
  }

  @override
  Widget buildContent() {
    switch (_custom) {
      case _Custom.button:
        return _button();
      case _Custom.nonclosable:
        return _nonclosable();
    }
  }

  Widget _button() {
    TabData tab = TabData(text: 'Tab', buttons: [
      TabButton(icon: Icons.star, onPressed: () => print('Hello!'))
    ]);
    TabbedWiew tabbedView = TabbedWiew(model: TabbedWiewModel([tab]));
    return tabbedView;
  }

  Widget _nonclosable() {
    var tabs = [
      TabData(text: 'Tab'),
      TabData(text: 'Non-closable tab', closable: false)
    ];
    TabbedWiew tabbedView = TabbedWiew(model: TabbedWiewModel(tabs));
    return tabbedView;
  }
}
