import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/tab_data.dart';
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
    final List<TabData> tabs = provider.controller.tabs;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        constraints: BoxConstraints(maxWidth: theme.menu.maxWidth),
        decoration: BoxDecoration(
          color: theme.menu.color ?? theme.tabsArea.color,
          borderRadius: theme.menu.borderRadius,
          boxShadow: theme.menu.boxShadow,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          reverse: reverse,
          itemCount: hiddenTabs.length,
          itemBuilder: (context, i) {
            final int tabIndex = hiddenTabs[i];
            final TabData tab = tabs[tabIndex];
            return InkWell(
              onTap: () => onSelection(tabIndex),
              child: Padding(
                padding: theme.menu.menuItemPadding,
                child: Text(
                  tab.text,
                  style: theme.menu.textStyle,
                  overflow: theme.menu.ellipsisOverflowText
                      ? TextOverflow.ellipsis
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
