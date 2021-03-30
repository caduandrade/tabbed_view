import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class ContentBuilderPage extends StatefulWidget {
  @override
  ContentBuilderPageState createState() => ContentBuilderPageState();
}

class ContentBuilderPageState extends ExamplePageState {
  @override
  Widget buildContent() {
    List<TabData> tabs = [];
    for (var i = 1; i < 5; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }

    TabbedWiew tabbedView = TabbedWiew(
        model: TabbedWiewModel(tabs),
        contentBuilder: (BuildContext context, int tabIndex) {
          int i = tabIndex + 1;
          return Center(child: Text('Content $i'));
        });
    return tabbedView;
  }
}
