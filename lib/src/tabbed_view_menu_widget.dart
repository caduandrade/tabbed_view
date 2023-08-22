import 'package:flutter/material.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/theme/menu_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/theme_widget.dart';

/// Widget for menu.
class TabbedViewMenuWidget extends StatefulWidget {
  const TabbedViewMenuWidget({super.key, required this.provider});

  final TabbedViewProvider provider;

  @override
  State<StatefulWidget> createState() => _TabbedViewMenuWidgetState();
}

/// State for [TabbedViewMenuWidget].
class _TabbedViewMenuWidgetState extends State<TabbedViewMenuWidget> {
  @override
  Widget build(BuildContext context) {
    TabbedViewThemeData theme = TabbedViewTheme.of(context);
    TabbedViewMenuThemeData menuTheme = theme.menu;
    bool hasDivider = menuTheme.dividerThickness > 0 && menuTheme.dividerColor != null;
    int itemCount = widget.provider.menuItems.length;
    if (hasDivider) {
      itemCount += widget.provider.menuItems.length - 1;
    }
    ListView list = ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        int itemIndex = index;
        if (hasDivider) {
          itemIndex = index ~/ 2;
          if (index.isOdd) {
            return Divider(height: menuTheme.dividerThickness, color: menuTheme.dividerColor, thickness: menuTheme.dividerThickness);
          }
        }
        return InkWell(
          hoverColor: menuTheme.hoverColor,
          onTap: () {
            widget.provider.menuItemsUpdater([]);
            Function? onSelection = widget.provider.menuItems[itemIndex].onSelection;
            if (onSelection != null) {
              onSelection();
            }
          },
          child: Container(
            padding: menuTheme.menuItemPadding,
            child: Text(
              widget.provider.menuItems[itemIndex].text,
              overflow: menuTheme.ellipsisOverflowText ? TextOverflow.ellipsis : null,
            ),
          ),
        );
      },
    );

    return Container(
      margin: menuTheme.margin,
      padding: menuTheme.padding,
      decoration: menuTheme.decoration,
      child: Material(
        type: MaterialType.transparency,
        textStyle: menuTheme.textStyle,
        child: list,
      ),
    );
  }
}
