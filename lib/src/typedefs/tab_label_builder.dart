import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

typedef TabLabelBuilder = Widget Function(TabLabelBuilderContext context);

class TabLabelBuilderContext {
  TabLabelBuilderContext(
      {required this.tab,
      required this.status,
      required this.tabTheme,
      required this.hasButtons,
      required this.textStyle});

  final TabData tab;
  final TabStatus status;
  final TabThemeData tabTheme;
  final bool hasButtons;
  final TextStyle? textStyle;
}
