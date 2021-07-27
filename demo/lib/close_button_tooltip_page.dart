import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class CloseButtonTooltipPage extends StatefulWidget {
  @override
  ListeningTabClosePageState createState() => ListeningTabClosePageState();
}

class ListeningTabClosePageState extends ExamplePageState {
  @override
  Widget buildContent() {
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];
    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs),
        closeButtonTooltip: 'Click here to close the tab');
    return tabbedView;
  }
}
