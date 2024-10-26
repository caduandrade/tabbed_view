import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  runApp(TabbedViewExample());
}

class TabbedViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TabbedViewExamplePage());
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

    tabs.add(TabData(text: 'Tab 1', leading: (context, status) => Icon(Icons.star, size: 16), content: Padding(child: Text('Hello'), padding: EdgeInsets.all(8))));
    tabs.add(TabData(text: 'Tab 2', content: Padding(child: Text('Hello again'), padding: EdgeInsets.all(8))));
    tabs.add(TabData(
        closable: false, text: 'TextField', content: Padding(child: TextField(decoration: InputDecoration(isDense: true, border: OutlineInputBorder())), padding: EdgeInsets.all(8)), keepAlive: true));

    _controller = TabbedViewController(tabs);
  }

  @override
  Widget build(BuildContext context) {
    TabbedView tabbedView = TabbedView(controller: _controller);
    TabbedViewThemeData themeData = TabbedViewThemeData.classic();
    themeData.tabsArea
      ..addButton = TabButton(
          icon: IconProvider.data(Icons.add),
          onPressed: () {
            _controller.addTab(TabData(
                text: DateTime.now().toString(),
                content: const Center(
                  child: Text('New Tab'),
                )));
          })
      ..dropColor = Colors.red
      ..dropOverPainter = _CustomDropOverPainter();
    themeData.menu.maxWidth = 100;
    themeData.tab
      ..maxWidth = 100
      ..minWidth = 50
      ..decoration = BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.orange, width: 5),
      );
    Widget w = TabbedViewTheme(child: tabbedView, data: themeData);
    return Scaffold(body: Container(child: w, padding: EdgeInsets.all(32)));
  }
}

class _CustomDropOverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(0,size.height/2), 4, paint);
    canvas.drawRRect(RRect.fromLTRBXY(0, 4, 4, size.height, 2, 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
