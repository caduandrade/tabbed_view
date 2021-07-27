import 'package:demo/example_page.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TabsAreaButtonsPage extends StatefulWidget {
  @override
  TabsAreaButtonsPageState createState() => TabsAreaButtonsPageState();
}

class TabsAreaButtonsPageState extends ExamplePageState {
  @override
  Widget buildContent() {
    TabbedViewController controller = TabbedViewController([]);

    TabbedView tabbedView = TabbedView(
        controller: controller,
        tabsAreaButtonsBuilder: (context, tabsCount) {
          List<TabButton> buttons = [];
          buttons.add(TabButton(
              icon: Icons.add,
              onPressed: () {
                int millisecond = DateTime.now().millisecondsSinceEpoch;
                controller.addTab(TabData(text: '$millisecond'));
              }));
          if (tabsCount > 0) {
            buttons.add(TabButton(
                icon: Icons.delete,
                onPressed: () {
                  if (controller.selectedIndex != null) {
                    controller.removeTab(controller.selectedIndex!);
                  }
                }));
          }
          return buttons;
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
