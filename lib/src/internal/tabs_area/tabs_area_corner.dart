import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../tab_bar_position.dart';
import '../../theme/side_tabs_layout.dart';
import '../../theme/tabbed_view_theme_data.dart';
import '../../theme/tabs_area_cross_axis_fit.dart';
import '../../theme/tabs_area_theme_data.dart';
import '../../theme/theme_widget.dart';
import '../tabbed_view_provider.dart';
import 'drop_tab_widget.dart';
import 'hidden_tabs.dart';
import 'tabs_area_buttons_widget.dart';

@internal
class TabsAreaCorner extends StatelessWidget {
  final TabbedViewProvider provider;
  final HiddenTabs hiddenTabs;

  const TabsAreaCorner(
      {super.key, required this.provider, required this.hiddenTabs});

  @override
  Widget build(BuildContext context) {
    TabbedViewThemeData theme = TabbedViewTheme.of(context);
    TabsAreaThemeData tabsAreaTheme = theme.tabsArea;

    final List<Widget> children = [
      TabsAreaButtonsWidget(provider: provider, hiddenTabs: hiddenTabs)
    ];

    if (provider.trailing != null) {
      Widget trailing = provider.trailing!;
      if (theme.tabsArea.position.isVertical) {
        final TabsAreaThemeData tabsAreaTheme =
            TabbedViewTheme.of(context).tabsArea;
        if (tabsAreaTheme.sideTabsLayout == SideTabsLayout.rotated) {
          final int quarterTurns =
              theme.tabsArea.position == TabBarPosition.left ? -1 : 1;
          trailing = RotatedBox(quarterTurns: quarterTurns, child: trailing);
        }
      }
      children.add(trailing);
    }

    Widget cornerContent;
    if (theme.tabsArea.position.isHorizontal) {
      if (tabsAreaTheme.crossAxisFit == TabsAreaCrossAxisFit.all) {
        cornerContent = IntrinsicHeight(
            child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children));
      } else {
        cornerContent = Row(mainAxisSize: MainAxisSize.min, children: children);
      }
    } else {
      cornerContent =
          Column(mainAxisSize: MainAxisSize.min, children: children);
    }

    Widget corner = Container(
        padding: theme.tabsArea.position.isHorizontal
            ? EdgeInsets.only(left: DropTabWidget.dropWidth)
            : EdgeInsets.only(top: DropTabWidget.dropWidth),
        child: cornerContent);

    if (provider.tabReorderEnabled) {
      return DropTabWidget(
          provider: provider,
          tabIndex: provider.delegate.tabs.length,
          child: corner,
          halfWidthDrop: false);
    }
    return corner;
  }
}
