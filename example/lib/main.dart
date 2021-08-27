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
        buttons: [TabButton(iconPath: TabbedViewIcons.close,onPressed: (){})],
        content: Padding(child: Text('Hello'), padding: EdgeInsets.all(8))));
    for(int i = 2; i< 8;i++) {
      tabs.add(TabData(
          text: 'Tab $i',
          content:
          Padding(child: Text('Hello again'), padding: EdgeInsets.all(8))));
    }
    tabs.add(TabData(
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
    TabbedView tabbedView = TabbedView(controller: _controller,tabsAreaButtonsBuilder: _tabsAreaButtonsBuilder);
    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: TabbedViewThemeData.mobile());
    return Scaffold(
        body: Container(child: theme, padding: EdgeInsets.all(32)));
  }

  List<TabButton> _tabsAreaButtonsBuilder(
      BuildContext context, int tabsCount){
    return [TabButton(iconPath: TabbedViewIcons.close,onPressed: (){})];
  }
}
