import 'package:demo/example_multi_view_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class CustomTabPage extends StatefulWidget {
  @override
  CustomTabPageState createState() => CustomTabPageState();
}

enum _View { extra_button, nonclosable }

class CustomTabPageState extends ExampleMultiViewPageState<_View> {
  @override
  _View defaultView() {
    return _View.extra_button;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [
      buttonView('Extra button', _View.extra_button),
      buttonView('Non-closable', _View.nonclosable)
    ];
  }

  @override
  Widget buildContentView(_View currentView) {
    switch (currentView) {
      case _View.extra_button:
        return _extra_button();
      case _View.nonclosable:
        return _nonclosable();
    }
  }

  Widget _extra_button() {
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
