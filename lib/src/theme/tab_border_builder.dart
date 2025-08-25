import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

typedef TabBorderBuilder = TabBorder Function(
    {required TabBarPosition tabBarPosition, required TabStatus status});

class TabBorder {
  TabBorder({this.borderRadius, this.border, this.wrapperBorderBuilder});

  final BorderRadius? borderRadius;
  final Border? border;
  final TabBorderBuilder? wrapperBorderBuilder;
}
