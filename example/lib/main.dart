import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  runApp(TabbedViewExample());
}

class TabbedViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: TabbedViewExamplePage());
  }
}

class TabbedViewExamplePage extends StatefulWidget {
  @override
  _TabbedViewExamplePageState createState() => _TabbedViewExamplePageState();
}

class _TabbedViewExamplePageState extends State<TabbedViewExamplePage> {
  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    List<TabData> tabs = [];

    tabs.add(TabData(
        text: 'Tab 1',
        leading: (context, status, value) => Icon(Icons.person),
        content: Padding(child: Text('Hello'), padding: EdgeInsets.all(8))));
    tabs.add(TabData(
        text: 'Tab 2',
        content:
            Padding(child: Text('Hello again'), padding: EdgeInsets.all(8))));
    tabs.add(TabData(
        closable: false,
        text: 'TextField',
        content: Padding(
            child: TextField(
                decoration: InputDecoration(
                    isDense: true, border: OutlineInputBorder())),
            padding: EdgeInsets.all(8)),
        keepAlive: true));

    _controller = TabbedViewController(tabs);
  }

  @override
  Widget build(BuildContext context) {
    TabbedView tabbedView = TabbedView(controller: _controller);
    Widget w =
        TabbedViewTheme(child: tabbedView, data: TabbedViewThemeData.mobile());
    return Scaffold(body: Container(child: w, padding: EdgeInsets.all(32)));
  }
}
