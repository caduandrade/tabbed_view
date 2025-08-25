import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/theme_widget.dart';

/// The menu widget for hidden tabs, displayed in an overlay.
@internal
class HiddenTabsMenuWidget extends StatelessWidget {
  const HiddenTabsMenuWidget({
    super.key,
    required this.provider,
    required this.hiddenTabs,
    required this.onSelection,
    this.reverse = false,
  });

  final TabbedViewProvider provider;
  final List<int> hiddenTabs;
  final void Function(int tabIndex) onSelection;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final TabbedViewThemeData theme = TabbedViewTheme.of(context);
    final menuTheme = theme.menu;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color? color = isDark ? menuTheme.colorDark : menuTheme.color;
    final Color? hoverColor =
        isDark ? menuTheme.hoverColorDark : menuTheme.hoverColor;
    final Color? highlightColor =
        isDark ? menuTheme.highlightColorDark : menuTheme.highlightColor;
    final TextStyle? textStyle =
        isDark ? menuTheme.textStyleDark : menuTheme.textStyle;

    final List<TabData> tabs = provider.controller.tabs;
    final HiddenTabsMenuItemBuilder? menuItemBuilder =
        provider.hiddenTabsMenuItemBuilder;

    return Container(
      constraints: BoxConstraints(maxWidth: menuTheme.maxWidth),
      decoration: BoxDecoration(
        color: color ?? theme.tabsArea.color,
        borderRadius: menuTheme.borderRadius,
        boxShadow: menuTheme.boxShadow,
      ),
      // The clipBehavior is necessary to avoid having the InkWell effects
      // spill outside the rounded corners.
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: ListView.builder(
          shrinkWrap: true,
          reverse: reverse,
          itemCount: hiddenTabs.length,
          itemBuilder: (context, i) {
            final int tabIndex = hiddenTabs[i];
            final TabData tab = tabs[tabIndex];
            final Widget child;
            if (menuItemBuilder != null) {
              child = menuItemBuilder(context, tabIndex, tab);
            } else {
              child = Padding(
                padding: menuTheme.menuItemPadding,
                child: Text(
                  tab.text,
                  style: textStyle,
                  overflow: menuTheme.ellipsisOverflowText
                      ? TextOverflow.ellipsis
                      : null,
                ),
              );
            }
            return InkWell(
              onTap: () => onSelection(tabIndex),
              hoverColor: hoverColor,
              highlightColor: highlightColor,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
