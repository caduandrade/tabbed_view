import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/internal/tabs_area/drop_tab_widget.dart';
import 'package:tabbed_view/src/internal/tabs_area/hidden_tabs.dart';
import 'package:tabbed_view/src/internal/tabs_area/tabs_area_buttons_widget.dart';
import 'package:tabbed_view/src/tabbed_view.dart';
import 'package:tabbed_view/src/theme/tab_theme_data.dart';
import 'package:tabbed_view/src/theme/theme_widget.dart';

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
    final List<Widget> children = [
      TabsAreaButtonsWidget(provider: provider, hiddenTabs: hiddenTabs)
    ];

    if (provider.trailing != null) {
      Widget trailing = provider.trailing!;
      if (provider.tabBarPosition.isVertical) {
        final TabThemeData tabTheme = TabbedViewTheme.of(context).tab;
        if (tabTheme.rotateCaptionsInVerticalTabs) {
          final int quarterTurns =
              provider.tabBarPosition == TabBarPosition.left ? -1 : 1;
          trailing = RotatedBox(quarterTurns: quarterTurns, child: trailing);
        }
      }
      children.add(trailing);
    }

    Widget cornerContent;
    if (provider.tabBarPosition.isHorizontal) {
      cornerContent = Row(mainAxisSize: MainAxisSize.min, children: children);
    } else {
      cornerContent =
          Column(mainAxisSize: MainAxisSize.min, children: children);
    }

    Widget corner = Container(
        padding: provider.tabBarPosition.isHorizontal
            ? EdgeInsets.only(left: DropTabWidget.dropWidth)
            : EdgeInsets.only(top: DropTabWidget.dropWidth),
        child: cornerContent);

    if (provider.controller.reorderEnable) {
      return DropTabWidget(
          provider: provider,
          newIndex: provider.controller.length,
          child: corner,
          halfWidthDrop: false);
    }
    return corner;
  }
}
