import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/internal/tabs_area/drop_tab_widget.dart';
import 'package:tabbed_view/src/internal/tabs_area/hidden_tabs.dart';
import 'package:tabbed_view/src/internal/tabs_area/tabs_area_buttons_widget.dart';
import 'package:tabbed_view/tabbed_view.dart';

@internal
class TabsAreaCorner extends StatelessWidget {
  final TabbedViewProvider provider;
  final HiddenTabs hiddenTabs;

  const TabsAreaCorner({super.key, required this.provider, required this.hiddenTabs});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: hiddenTabs, builder: _builder);
  }

  Widget _builder(BuildContext context, Widget? child) {
    TabbedViewThemeData theme = TabbedViewTheme.of(context);
    TabsAreaThemeData tabsAreaTheme = theme.tabsArea;
    TabThemeData tabTheme = theme.tab;
    Widget areaButtons = Container(
      margin: tabTheme.margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [TabsAreaButtonsWidget(provider: provider, hiddenTabs: hiddenTabs)],
      ),
    );
    if (tabsAreaTheme.addButton != null) {
      return areaButtons;
    }
    if(provider.controller.reorderEnable) {
      return DropTabWidget(
        provider: provider,
        newIndex: provider.controller.length,
        child: Container(
          padding: const EdgeInsets.only(left: DropTabWidget.dropWidth),
          child: areaButtons,
        ),
      );
    }
    return areaButtons;
  }
}
