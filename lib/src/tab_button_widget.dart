import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/theme_data.dart';

/// Widget for tab buttons. Used for any tab button such as the close button.
class TabButtonWidget extends StatefulWidget {
  TabButtonWidget(
      {required this.controller,
      required this.button,
      required this.enabled,
      required this.iconSize,
      required this.colors});

  final TabbedViewController controller;
  final TabButton button;
  final double iconSize;
  final ButtonColors colors;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => TabButtonWidgetState();
}

/// The [TabButtonWidget] state.
class TabButtonWidgetState extends State<TabButtonWidget> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    Color color = widget.button.color != null
        ? widget.button.color!
        : widget.colors.normal;

    Color hoverColor = widget.button.hoverColor != null
        ? widget.button.hoverColor!
        : widget.colors.hover;

    bool hasEvent =
        widget.button.onPressed != null || widget.button.menuBuilder != null;

    if (hasEvent == false || widget.enabled == false) {
      Color disabledColor = widget.button.disabledColor != null
          ? widget.button.disabledColor!
          : widget.colors.disabled;
      return Icon(widget.button.icon,
          color: disabledColor, size: widget.iconSize);
    }

    Color finalColor = _hover ? hoverColor : color;
    Widget icon =
        Icon(widget.button.icon, color: finalColor, size: widget.iconSize);

    VoidCallback? onPressed = widget.button.onPressed;
    if (widget.button.menuBuilder != null) {
      onPressed = () {
        if (widget.controller.hasMenu() == false &&
            widget.button.menuBuilder != null) {
          widget.controller.updateMenu(widget.button.menuBuilder!);
        } else {
          widget.controller.removeMenu();
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

  _onEnter(PointerEnterEvent event) {
    setState(() {
      _hover = true;
    });
  }

  _onExit(PointerExitEvent event) {
    setState(() {
      _hover = false;
    });
  }
}
