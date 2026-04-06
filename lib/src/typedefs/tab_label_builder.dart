import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

typedef TabLabelBuilder = Widget Function(TabLabelBuilderContext context);

class TabLabelBuilderContext {
  TabLabelBuilderContext(
      {required this.tab,
      required this.tabTheme,
      required this.hasButtons,
      required this.textStyle,
      required this.padding,
      required this.textOverflow});

  final TabData tab;
  final TabThemeData tabTheme;
  final bool hasButtons;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final TextOverflow? textOverflow;
}
