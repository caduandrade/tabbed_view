import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../tab_bar_position.dart';
import '../../tab_button.dart';
import '../../tabbed_view.dart';
import '../../tabbed_view_menu_item.dart';
import '../../theme/tabbed_view_theme_data.dart';
import '../../theme/tabs_area_theme_data.dart';
import '../../theme/theme_widget.dart';
import '../tab/tab_button_widget.dart';
import '../tabbed_view_provider.dart';
import 'hidden_tabs.dart';

/// Area for buttons like the hidden tabs menu button.
@internal
class TabsAreaButtonsWidget extends StatelessWidget {
  final TabbedViewProvider provider;
  final HiddenTabs hiddenTabs;

  const TabsAreaButtonsWidget(
      {super.key, required this.provider, required this.hiddenTabs});

  @override
  Widget build(BuildContext context) {
    final TabbedViewThemeData theme = TabbedViewTheme.of(context);
    final TabsAreaThemeData tabsAreaTheme = theme.tabsArea;
    final TabbedViewDelegate delegate = provider.delegate;

    List<TabButton> buttons = [];
    if (provider.tabsAreaButtonsBuilder != null) {
      buttons = provider.tabsAreaButtonsBuilder!(context, delegate.tabs.length);
    }
    if (hiddenTabs.hasHiddenTabs) {
      final menuButton = TabButton.menu((context) {
        List<TabbedViewMenuItem> menus = [];
        for (int tabIndex in hiddenTabs.indexes) {
          final String text = delegate.tabs[tabIndex].text;
          menus.add(TabbedViewMenuItem(
              text: text,
              onSelection: () => delegate.selectedIndex = tabIndex));
        }
        return menus;
      });
      if (theme.tabsArea.position == TabBarPosition.left) {
        // For a left tab bar, the overflow button should be last.
        buttons.add(menuButton);
      } else {
        buttons.insert(0, menuButton);
      }
    }

    List<Widget> children = [];

    for (int i = 0; i < buttons.length; i++) {
      EdgeInsets? padding;
      if (i > 0 && tabsAreaTheme.buttonsGap > 0) {
        padding = EdgeInsets.only(left: tabsAreaTheme.buttonsGap);
      }
      final TabButton tabButton = buttons[i];
      children.add(Container(
          child: TabButtonWidget(
              button: tabButton,
              enabled: provider.draggingTabIndex == null,
              normalColor: tabButton.color ?? tabsAreaTheme.buttonColor,
              hoverColor: tabButton.hoverColor ??
                  tabsAreaTheme.hoveredButtonColor ??
                  tabsAreaTheme.buttonColor,
              disabledColor:
                  tabButton.disabledColor ?? tabsAreaTheme.disabledButtonColor,
              background:
                  tabButton.background ?? tabsAreaTheme.buttonBackground,
              hoverBackground: tabButton.hoverBackground ??
                  tabsAreaTheme.hoveredButtonBackground,
              disabledBackground: tabButton.disabledBackground ??
                  tabsAreaTheme.disabledButtonBackground,
              iconSize: tabButton.iconSize ?? tabsAreaTheme.buttonIconSize,
              themePadding: tabButton.padding ?? tabsAreaTheme.buttonPadding),
          padding: padding));
    }

    Widget buttonsArea =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: children);

    EdgeInsetsGeometry? margin;
    if (tabsAreaTheme.buttonsOffset > 0) {
      margin = EdgeInsets.only(left: tabsAreaTheme.buttonsOffset);
    }

    if (children.isNotEmpty &&
        (tabsAreaTheme.buttonsAreaDecoration != null ||
            tabsAreaTheme.buttonsAreaPadding != null ||
            margin != null)) {
      buttonsArea = Container(
          child: buttonsArea,
          decoration: tabsAreaTheme.buttonsAreaDecoration,
          padding: tabsAreaTheme.buttonsAreaPadding,
          margin: margin);
    }

    return buttonsArea;
  }
}
