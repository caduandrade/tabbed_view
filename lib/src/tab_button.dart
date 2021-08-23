import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tabbed_view_menu_builder.dart';

/// Configures a tab button.
class TabButton {
  TabButton(
      {required this.icon,
      this.color,
      this.hoverColor,
      this.disabledColor,
      this.onPressed,
      this.menuBuilder,
      this.toolTip,
      this.padding});

  final IconData icon;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Color? hoverColor;
  final Color? disabledColor;
  final VoidCallback? onPressed;
  final TabbedViewMenuBuilder? menuBuilder;
  final String? toolTip;
}
