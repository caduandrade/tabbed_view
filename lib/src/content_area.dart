import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/tabbed_view_data.dart';
import 'package:tabbed_view/src/tabbed_view_menu_widget.dart';
import 'package:tabbed_view/src/theme.dart';

/// Container widget for the tab content and menu.
class ContentArea extends StatelessWidget {
  ContentArea({required this.data});

  final TabbedViewData data;

  @override
  Widget build(BuildContext context) {
    TabbedViewController controller = data.controller;
    ContentAreaTheme contentAreaTheme = data.theme.contentArea;
    Widget? child;
    if (controller.selectedIndex != null) {
      TabData tab = controller.tabs[controller.selectedIndex!];
      if (data.contentBuilder != null) {
        child = data.contentBuilder!(context, controller.selectedIndex!);
      } else {
        child = tab.content;
      }
    }

    if (controller.hasMenu()) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        List<Widget> children = [];
        children.add(Positioned.fill(
            child: Container(child: child, padding: contentAreaTheme.padding)));
        children.add(Positioned.fill(child: _Glass(data)));
        children.add(Positioned(
            child: LimitedBox(
                maxWidth:
                    math.min(data.theme.menu.maxWidth, constraints.maxWidth),
                child:
                    TabbedViewMenuWidget(controller: controller, data: data)),
            right: 0,
            top: 0,
            bottom: 0));
        Widget listener = NotificationListener<SizeChangedLayoutNotification>(
            child: SizeChangedLayoutNotifier(child: Stack(children: children)),
            onNotification: (n) {
              scheduleMicrotask(() {
                controller.removeMenu();
              });
              return true;
            });
        return Container(
            child: listener, decoration: contentAreaTheme.decoration);
      });
    }

    return Container(
        child: child,
        decoration: contentAreaTheme.decoration,
        padding: contentAreaTheme.padding);
  }
}

class _Glass extends StatelessWidget {
  _Glass(this.data);

  final TabbedViewData data;

  @override
  Widget build(BuildContext context) {
    Widget? child;
    if (data.theme.menu.blur) {
      child = BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(color: Colors.transparent));
    }
    return ClipRect(
        child: GestureDetector(
            child: child, onTap: () => data.controller.removeMenu()));
  }
}
