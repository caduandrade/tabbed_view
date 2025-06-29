import 'package:flutter/material.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
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
          children.add(Positioned.fill(
              key: tab.key,
              child:
                  Container(child: child, padding: contentAreaTheme.padding)));
        }
      }

      Widget listener = NotificationListener<SizeChangedLayoutNotification>(
          child: SizeChangedLayoutNotifier(child: Stack(children: children)));

      Decoration? decoration = tabsAreaVisible
          ? contentAreaTheme.decoration
          : contentAreaTheme.decorationNoTabsArea;

      if (decoration is BoxDecoration) {
        Border currentBorder;
        if (decoration.border is Border) {
          currentBorder = decoration.border as Border;
        } else if (decoration.border is BorderDirectional) {
          final bd = decoration.border as BorderDirectional;
          currentBorder = Border(
              top: bd.top, bottom: bd.bottom, left: bd.start, right: bd.end);
        } else {
          currentBorder = Border();
        }

        BorderSide top = currentBorder.top;
        BorderSide bottom = currentBorder.bottom;
        BorderSide left = currentBorder.left;
        BorderSide right = currentBorder.right;

        BorderSide frameBorderSide = currentBorder.top;
        if (frameBorderSide == BorderSide.none)
          frameBorderSide = currentBorder.bottom;
        if (frameBorderSide == BorderSide.none)
          frameBorderSide = currentBorder.left;
        if (frameBorderSide == BorderSide.none)
          frameBorderSide = currentBorder.right;

        if (top == BorderSide.none && frameBorderSide != BorderSide.none)
          top = frameBorderSide;
        if (bottom == BorderSide.none && frameBorderSide != BorderSide.none)
          bottom = frameBorderSide;
        if (left == BorderSide.none && frameBorderSide != BorderSide.none)
          left = frameBorderSide;
        if (right == BorderSide.none && frameBorderSide != BorderSide.none)
          right = frameBorderSide;
        decoration = decoration.copyWith(
            border: Border(top: top, bottom: bottom, left: left, right: right));
      }
      return Container(child: listener, decoration: decoration);
    });
    if (provider.contentClip) {
      return ClipRect(child: layoutBuilder);
    }
    return layoutBuilder;
  }
}
