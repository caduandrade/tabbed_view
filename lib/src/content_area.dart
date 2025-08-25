import 'package:flutter/material.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/tabbed_view.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/theme/content_area_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/theme_widget.dart';

/// Container widget for the tab content and menu.
class ContentArea extends StatelessWidget {
  ContentArea({required this.tabsAreaVisible, required this.provider});

  final bool tabsAreaVisible;
  final TabbedViewProvider provider;

  @override
  Widget build(BuildContext context) {
    TabbedViewController controller = provider.controller;
    TabbedViewThemeData theme = TabbedViewTheme.of(context);
    ContentAreaThemeData contentAreaTheme = theme.contentArea;

    LayoutBuilder layoutBuilder = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      List<Widget> children = [];

      for (int i = 0; i < controller.tabs.length; i++) {
        TabData tab = controller.tabs[i];
        bool selectedTab =
            controller.selectedIndex != null && i == controller.selectedIndex;
        if (tab.keepAlive || selectedTab) {
          Widget? child;
          if (provider.contentBuilder != null) {
            child = provider.contentBuilder!(context, i);
          } else {
            child = tab.content;
          }
          if (child != null) {
            child = ExcludeFocus(excluding: !selectedTab, child: child);
          }
          if (tab.keepAlive) {
            child = Offstage(offstage: !selectedTab, child: child);
          }
          // Padding will be applied once on the parent container.
          children.add(
              Positioned.fill(key: tab.key, child: Container(child: child)));
        }
      }

      Widget listener = NotificationListener<SizeChangedLayoutNotification>(
          child: SizeChangedLayoutNotifier(child: Stack(children: children)));

      final Border border = _buildBorder(theme: theme);
      final BorderRadius borderRadius =
          _buildBorderRadius(theme: contentAreaTheme);

      BoxDecoration decoration = BoxDecoration(
          color: contentAreaTheme.color,
          borderRadius: borderRadius,
          border: border);
      return Container(
          child: listener,
          decoration: decoration,
          padding: contentAreaTheme.padding);
    });
    if (provider.contentClip) {
      return ClipRect(child: layoutBuilder);
    }

    return layoutBuilder;
  }

  BorderRadius _buildBorderRadius({required ContentAreaThemeData theme}) {
    final Radius radius = Radius.circular(theme.borderRadius);
    final TabBarPosition position = provider.tabBarPosition;

    bool top = position != TabBarPosition.top;
    bool bottom = position != TabBarPosition.bottom;
    bool left = position != TabBarPosition.left;
    bool right = position != TabBarPosition.right;

    return BorderRadius.only(
      topLeft: (left && top) ? radius : Radius.zero,
      topRight: (right && top) ? radius : Radius.zero,
      bottomLeft: (left && bottom) ? radius : Radius.zero,
      bottomRight: (right && bottom) ? radius : Radius.zero,
    );
  }

  Border _buildBorder({required TabbedViewThemeData theme}) {
    final BorderSide divider = theme.isDividerWithinTabArea
        ? BorderSide.none
        : theme.divider ?? BorderSide.none;
    final BorderSide borderSide = theme.contentArea.border ?? BorderSide.none;
    final TabBarPosition position = provider.tabBarPosition;

    bool top = position != TabBarPosition.top;
    bool bottom = position != TabBarPosition.bottom;
    bool left = position != TabBarPosition.left;
    bool right = position != TabBarPosition.right;

    return Border(
      top: top ? borderSide : divider,
      bottom: bottom ? borderSide : divider,
      left: left ? borderSide : divider,
      right: right ? borderSide : divider,
    );
  }
}
