import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class CustomTabPage extends StatefulWidget {
  @override
  CustomTabPageState createState() => CustomTabPageState();
}

enum _Custom { button }

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
          child: Text('Button'))
    ];
  }

  @override
  Widget buildContent() {
    switch (_custom) {
      case _Custom.button:
        return _button();
    }
  }

  Widget _button() {
    TabData tab = TabData(text: 'Tab', buttons: [
      TabButton(icon: Icons.star, onPressed: () => print('Hello!'))
    ]);
    TabbedWiew tabbedView = TabbedWiew(model: TabbedWiewModel([tab]));
    return tabbedView;
  }
}
