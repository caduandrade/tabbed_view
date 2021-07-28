import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/tabbed_view_data.dart';
import 'package:tabbed_view/src/tabbed_view_menu_item.dart';
import 'package:tabbed_view/src/theme.dart';

/// Widget for menu.
class TabbedViewMenuWidget extends StatefulWidget {
  const TabbedViewMenuWidget({required this.controller, required this.data});

  final TabbedViewController controller;
  final TabbedViewData data;

  @override
  State<StatefulWidget> createState() => _TabbedViewMenuWidgetState();
}

/// State for [TabbedViewMenuWidget].
class _TabbedViewMenuWidgetState extends State<TabbedViewMenuWidget> {
  @override
  Widget build(BuildContext context) {
    MenuTheme menuTheme = widget.data.theme.menu;
    List<TabbedViewMenuItem> items = widget.controller.menuBuilder!(context);
    bool hasDivider =
        menuTheme.dividerThickness > 0 && menuTheme.dividerColor != null;
    int itemCount = items.length;
    if (hasDivider) {
      itemCount += items.length - 1;
    }
    ListView list = ListView.builder(
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          int itemIndex = index;
          if (hasDivider) {
            itemIndex = index ~/ 2;
            if (index.isOdd) {
              return Divider(
                  height: menuTheme.dividerThickness,
                  color: menuTheme.dividerColor,
                  thickness: menuTheme.dividerThickness);
            }
          }
          return InkWell(
              child: Container(
                  padding: menuTheme.menuItemPadding,
                  child: Text(items[itemIndex].text,
                      overflow: menuTheme.ellipsisOverflowText
                          ? TextOverflow.ellipsis
                          : null)),
              hoverColor: menuTheme.hoverColor,
              onTap: () {
                widget.controller.removeMenu();
                Function? onSelection = items[itemIndex].onSelection;
                if (onSelection != null) {
                  onSelection();
                }
              });
        });

    return Container(
        margin: menuTheme.margin,
        padding: menuTheme.padding,
        child: Material(
            child: list,
            textStyle: menuTheme.textStyle,
            color: Colors.transparent),
        decoration:
            BoxDecoration(color: menuTheme.color, border: menuTheme.border));
  }
}
