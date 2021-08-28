import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/icon_path.dart';
import 'package:tabbed_view/src/tabbed_view_menu_builder.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_constants.dart';

/// Configures a tab button.
class TabButton {
  TabButton(
      {this.iconData,
      this.iconPath,
      this.color,
      this.hoverColor,
      this.disabledColor,
      this.onPressed,
      this.menuBuilder,
      this.toolTip,
      this.padding,
      double? iconSize})
      : this.iconSize = iconSize == null
            ? iconSize
            : TabbedViewThemeConstants.normalize(iconSize) {
    if ((this.iconData != null && this.iconPath != null) ||
        (this.iconData == null && this.iconPath == null)) {
      throw ArgumentError('iconData or iconPath must be set');
    }
  }

  final IconData? iconData;
  final IconPath? iconPath;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Color? hoverColor;
  final Color? disabledColor;
  final VoidCallback? onPressed;
  final TabbedViewMenuBuilder? menuBuilder;
  final String? toolTip;
  final double? iconSize;
}
