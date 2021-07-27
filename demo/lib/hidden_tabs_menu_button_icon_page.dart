import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class HiddenTabsMenuButtonIconPage extends StatefulWidget {
  @override
  HiddenTabsMenuButtonIconPageState createState() =>
      HiddenTabsMenuButtonIconPageState();
}

class HiddenTabsMenuButtonIconPageState extends ExamplePageState {
  @override
  Widget buildContent() {
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }

    TabbedViewTheme theme = TabbedViewTheme.classic();
    theme.tabsArea.buttonsArea.hiddenTabsMenuButtonIcon =
        Icons.arrow_drop_down_circle_outlined;

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
    return tabbedView;
  }
}
