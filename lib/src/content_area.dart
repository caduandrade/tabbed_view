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
          children.add(Positioned.fill(key: tab.key, child: Container(child: child)));
        }
      }

      Widget listener = NotificationListener<SizeChangedLayoutNotification>(
          child: SizeChangedLayoutNotifier(child: Stack(children: children)));

      BoxDecoration? decoration;
      if (tabsAreaVisible) {
        decoration = contentAreaTheme.decoration;
        final borderSide = contentAreaTheme.border;
        if (borderSide != null) {
          final position = provider.tabBarPosition;
          Border border;
          if (position == TabBarPosition.top) {
            border =
                Border(bottom: borderSide, left: borderSide, right: borderSide);
          } else if (position == TabBarPosition.bottom) {
            border = Border(top: borderSide, left: borderSide, right: borderSide);
          } else if (position == TabBarPosition.left) {
            border =
                Border(bottom: borderSide, top: borderSide, right: borderSide);
          } else {
            // right
            border =
                Border(bottom: borderSide, top: borderSide, left: borderSide);
          }
          decoration = decoration?.copyWith(border: border) ??
              BoxDecoration(border: border);
        }
      } else {
        decoration = contentAreaTheme.decorationNoTabsArea;
      }
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
}
