import 'package:demo/example_multi_view_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class CustomTabPage extends StatefulWidget {
  @override
  CustomTabPageState createState() => CustomTabPageState();
}

enum _View {
  extra_button,
  nonclosable,
  top_alignment,
  text_style,
  extra_button_override_color
}

class CustomTabPageState extends ExampleMultiViewPageState<_View> {
  @override
  _View defaultView() {
    return _View.extra_button;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [
      buttonView('Extra button', _View.extra_button),
      buttonView('Non-closable', _View.nonclosable),
      buttonView('Top alignment', _View.top_alignment),
      buttonView('Text style', _View.text_style),
      buttonView(
          'Extra button - override color', _View.extra_button_override_color)
    ];
  }

  @override
  Widget buildContentView(_View currentView) {
    switch (currentView) {
      case _View.extra_button:
        return _extraButton();
      case _View.nonclosable:
        return _nonclosable();
      case _View.top_alignment:
        return _topAlignment();
      case _View.text_style:
        return _textStyle();
      case _View.extra_button_override_color:
        return _extraButtonOverrideColor();
    }
  }

  Widget _extraButton() {
    TabData tab = TabData(text: 'Tab', buttons: [
      TabButton(icon: Icons.star, onPressed: () => print('Hello!'))
    ]);
    TabbedView tabbedView = TabbedView(controller: TabbedViewController([tab]));
    return tabbedView;
  }

  Widget _nonclosable() {
    var tabs = [
      TabData(text: 'Tab'),
      TabData(text: 'Non-closable tab', closable: false)
    ];
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
    return tabbedView;
  }

  Widget _textStyle() {
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
    ];

    TabbedViewTheme theme = TabbedViewTheme.classic();
    theme.tabsArea.tab.textStyle = TextStyle(fontSize: 20, color: Colors.blue);

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
    return tabbedView;
  }

  Widget _topAlignment() {
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
    ];

    TabbedViewTheme theme = TabbedViewTheme.classic();
    theme.tabsArea.tab
      ..textStyle = TextStyle(fontSize: 20)
      ..verticalAlignment = VerticalAlignment.top;

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
    return tabbedView;
  }

  Widget _extraButtonOverrideColor() {
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2', buttons: [
        TabButton(
            icon: Icons.star,
            color: Colors.green,
            onPressed: () => print('Hello!'))
      ])
    ];
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
    return tabbedView;
  }
}
