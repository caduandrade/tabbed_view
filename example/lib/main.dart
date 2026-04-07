import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  runApp(TabbedViewExample());
}

class TabbedViewExample extends StatefulWidget {
  const TabbedViewExample({super.key});

  @override
  TabbedViewExampleState createState() => TabbedViewExampleState();
}

class TabbedViewExampleState extends State<TabbedViewExample> {
  late final TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabbedViewController(List.generate(
      6,
      (i) => TabData(
        id: i,
        text: 'Tab ${i + 1}',
        view: Center(
            child: Text(
          'Content ${i + 1}',
        )),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return TabbedView(controller: _controller);
  }
}
