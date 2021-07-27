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
  late TabbedViewController _model;

  @override
  void initState() {
    super.initState();
    List<TabData> tabs = [];
    for (int i = 1; i < 5; i++) {
      tabs.add(TabData(text: 'Tab $i', content: Text('Content $i')));
    }
    _model = TabbedViewController(tabs);
  }

  @override
  Widget build(BuildContext context) {
    TabbedView tabbedView = TabbedView(controller: _model);
    return Scaffold(
        body: Container(child: tabbedView, padding: EdgeInsets.all(32)));
  }
}
