import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tabbed_view_data.dart';
import 'package:tabbed_view/src/tabbed_view_menu_item.dart';

/// Widget for tab buttons. Used for any tab button such as the close button.
class TabButtonWidget extends StatefulWidget {
  TabButtonWidget(
      {required this.data,
      required this.button,
      required this.enabled,
      required this.iconSize,
      required this.normalColor,
      required this.hoverColor,
      required this.disabledColor,
      this.themePadding,
      this.normalBackground,
      this.hoverBackground,
      this.disabledBackground});

  final TabbedViewData data;
  final TabButton button;
  final double iconSize;
  final Color normalColor;
  final Color hoverColor;
  final Color disabledColor;
  final EdgeInsetsGeometry? themePadding;
  final bool enabled;
  final BoxDecoration? normalBackground;
  final BoxDecoration? hoverBackground;
  final BoxDecoration? disabledBackground;

  @override
  State<StatefulWidget> createState() => TabButtonWidgetState();
}

/// The [TabButtonWidget] state.
class TabButtonWidgetState extends State<TabButtonWidget> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    Color color;
    BoxDecoration? background;

    bool hasEvent =
        widget.button.onPressed != null || widget.button.menuBuilder != null;
    bool isDisabled = hasEvent == false || widget.enabled == false;
    if (isDisabled) {
      color = widget.button.disabledColor != null
          ? widget.button.disabledColor!
          : widget.disabledColor;
      background = widget.button.disabledBackground != null
          ? widget.button.disabledBackground
          : widget.disabledBackground;
    } else if (_hover) {
      color = widget.button.hoverColor != null
          ? widget.button.hoverColor!
          : widget.hoverColor;
      background = widget.button.hoverBackground != null
          ? widget.button.hoverBackground
          : widget.hoverBackground;
    } else {
      color = widget.button.color != null
          ? widget.button.color!
          : widget.normalColor;
      background = widget.button.background != null
          ? widget.button.background
          : widget.normalBackground;
    }

    Widget icon = widget.button.icon.buildIcon(color, widget.iconSize);

    EdgeInsetsGeometry? padding = widget.button.padding != null
        ? widget.button.padding
        : widget.themePadding;
    if (padding != null || background != null) {
      icon = Container(child: icon, padding: padding, decoration: background);
    }

    if (isDisabled) {
      return icon;
    }

    VoidCallback? onPressed = widget.button.onPressed;
    if (widget.button.menuBuilder != null) {
      onPressed = () {
        if (widget.data.menuItems.isEmpty) {
          List<TabbedViewMenuItem> menuItems =
              widget.button.menuBuilder!(context);
          if (menuItems.isNotEmpty) {
            widget.data.menuItemsUpdater(menuItems);
          }
        } else {
          widget.data.menuItemsUpdater([]);
        }
      };
    }

    if (widget.button.toolTip != null) {
      icon = Tooltip(
          message: widget.button.toolTip!,
          child: icon,
          waitDuration: Duration(milliseconds: 500));
    }

    return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: _onEnter,
        onExit: _onExit,
        child: GestureDetector(child: icon, onTap: onPressed));
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() {
      _hover = true;
    });
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _hover = false;
    });
  }
}
