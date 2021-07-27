import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class DraggableTabPage extends StatefulWidget {
  @override
  DraggableTabPageState createState() => DraggableTabPageState();
}

class DraggableTabPageState extends ExamplePageState {
  @override
  Widget buildContent() {
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      Widget tabContent = Center(child: Text('Content $i'));
      tabs.add(TabData(text: 'Tab $i', content: tabContent));
    }
    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs),
        draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) {
          return Draggable<String>(
              child: tabWidget,
              feedback: Material(
                  child: Container(
                      child: Text(tab.text),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(border: Border.all()))),
              data: tab.text,
              dragAnchorStrategy: (Draggable<Object> draggable,
                  BuildContext context, Offset position) {
                return Offset.zero;
              });
        });
    return tabbedView;
  }

  @override
  List<Widget> buildExampleWidgets() {
    return [ElevatedButton(child: Text('Rebuild'), onPressed: _onRebuild)];
  }

  _onRebuild() {
    setState(() {});
  }
}
