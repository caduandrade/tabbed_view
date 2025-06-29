import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/internal/tabs_area/drop_tab_widget.dart';
import 'package:tabbed_view/src/internal/tabs_area/hidden_tabs.dart';
import 'package:tabbed_view/src/internal/tabs_area/tabs_area_buttons_widget.dart';
import 'package:tabbed_view/src/tabbed_view.dart' show TabBarPosition;

@internal
class TabsAreaCorner extends StatelessWidget {
  final TabbedViewProvider provider;
  final HiddenTabs hiddenTabs;

  const TabsAreaCorner(
      {super.key, required this.provider, required this.hiddenTabs});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: hiddenTabs, builder: _builder);
  }

  Widget _builder(BuildContext context, Widget? child) {
    Widget cornerContent =
        TabsAreaButtonsWidget(provider: provider, hiddenTabs: hiddenTabs);

    Widget corner = Container(
        padding: provider.tabBarPosition.isHorizontal
            ? EdgeInsets.only(left: DropTabWidget.dropWidth)
            : EdgeInsets.only(top: DropTabWidget.dropWidth),
        child: cornerContent);

    if (provider.controller.reorderEnable) {
      return DropTabWidget(
          provider: provider,
          newIndex: provider.controller.length,
          child: corner);
    }
    return corner;
  }
}
