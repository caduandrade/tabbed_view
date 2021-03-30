import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class CustomLightThemePage extends StatefulWidget {
  @override
  CustomLightThemePageState createState() => CustomLightThemePageState();
}

class CustomLightThemePageState extends ExamplePageState {
  @override
  Widget buildContent() {
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }
    TabbedWiewModel model = TabbedWiewModel(tabs);

    TabbedViewTheme theme = TabbedViewTheme.light().copyWith(TabbedViewTheme());

    TabbedWiew tabbedView = TabbedWiew(model: model, theme: theme);
    return tabbedView;
  }
}
