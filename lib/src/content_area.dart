import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/tabbed_view_data.dart';
import 'package:tabbed_view/src/tabbed_view_menu_widget.dart';
import 'package:tabbed_view/src/theme/content_area_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/theme_widget.dart';

/// Container widget for the tab content and menu.
class ContentArea extends StatelessWidget {
  ContentArea({required this.data});

  final TabbedViewData data;

  @override
  Widget build(BuildContext context) {
    TabbedViewController controller = data.controller;
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
          if (data.contentBuilder != null) {
            child = data.contentBuilder!(context, i);
          } else {
            child = tab.content;
          }

          if (tab.keepAlive) {
            child = Offstage(offstage: !selectedTab, child: child);
          }
          children.add(Positioned.fill(
              key: tab.uniqueKey,
              child:
                  Container(child: child, padding: contentAreaTheme.padding)));
        }
      }

      NotificationListenerCallback<SizeChangedLayoutNotification>?
          onSizeNotification;
      if (data.menuItems.isNotEmpty) {
        children.add(Positioned.fill(child: _Glass(theme.menu.blur, data)));
        children.add(Positioned(
            child: LimitedBox(
                maxWidth: math.min(theme.menu.maxWidth, constraints.maxWidth),
                child: TabbedViewMenuWidget(data: data)),
            right: 0,
            top: 0,
            bottom: 0));
        onSizeNotification = (n) {
          scheduleMicrotask(() {
            data.menuItemsUpdater([]);
          });
          return true;
        };
      }
      Widget listener = NotificationListener<SizeChangedLayoutNotification>(
          child: SizeChangedLayoutNotifier(child: Stack(children: children)),
          onNotification: onSizeNotification);
      return Container(
          child: listener, decoration: contentAreaTheme.decoration);
    });
    if (data.contentClip) {
      return ClipRect(child: layoutBuilder);
    }
    return layoutBuilder;
  }
}

class _Glass extends StatelessWidget {
  _Glass(this.blur, this.data);

  final bool blur;
  final TabbedViewData data;

  @override
  Widget build(BuildContext context) {
    Widget? child;
    if (blur) {
      child = BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(color: Colors.transparent));
    }
    return ClipRect(
        child: GestureDetector(
            child: child, onTap: () => data.menuItemsUpdater([])));
  }
}
