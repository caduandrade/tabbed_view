import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/internal/tabs_area/hidden_tabs.dart';
import 'package:tabbed_view/src/internal/tabs_area/hidden_tabs_menu_widget.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:tabbed_view/src/tab_button_widget.dart';

/// Area for buttons like the hidden tabs menu button.
@internal
class TabsAreaButtonsWidget extends StatefulWidget {
  final TabbedViewProvider provider;
  final HiddenTabs hiddenTabs;

  const TabsAreaButtonsWidget(
      {super.key, required this.provider, required this.hiddenTabs});

  @override
  State<StatefulWidget> createState() => _TabsAreaButtonsWidgetState();
}

class _TabsAreaButtonsWidgetState extends State<TabsAreaButtonsWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _showMenu(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenSize = MediaQuery.of(context).size;

    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      Alignment followerAnchor;
      Alignment targetAnchor;
      bool reverseMenu = false;
      double availableHeight;

      switch (widget.provider.tabBarPosition) {
        case TabBarPosition.top:
          // Menu opens below the button, aligned to the right.
          followerAnchor = Alignment.topRight;
          targetAnchor = Alignment.bottomRight;
          availableHeight = screenSize.height - position.dy - size.height;
          break;
        case TabBarPosition.bottom:
          // Menu opens above the button, aligned to the right.
          followerAnchor = Alignment.bottomRight;
          targetAnchor = Alignment.topRight;
          reverseMenu = true;
          availableHeight = position.dy;
          break;
        case TabBarPosition.left:
          // Menu opens to the right of the button, aligned to the bottom.
          followerAnchor = Alignment.bottomLeft;
          targetAnchor = Alignment.bottomRight;
          reverseMenu = true;
          availableHeight = position.dy + size.height;
          break;
        case TabBarPosition.right:
          // Menu opens to the left of the button, aligned to the bottom.
          followerAnchor = Alignment.bottomRight;
          targetAnchor = Alignment.bottomLeft;
          reverseMenu = true;
          availableHeight = position.dy + size.height;
          break;
      }

      final theme = TabbedViewTheme.of(context);
      final effectiveMaxHeight =
          math.min(theme.menu.maxHeight, math.max(0.0, availableHeight - 8));

      return Stack(children: [
        // Invisible gesture detector to dismiss the menu on outside tap
        GestureDetector(
            onTap: _hideMenu, child: Container(color: Colors.transparent)),
        CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            followerAnchor: followerAnchor,
            targetAnchor: targetAnchor,
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: effectiveMaxHeight),
                child: HiddenTabsMenuWidget(
                    provider: widget.provider,
                    reverse: reverseMenu,
                    hiddenTabs: widget.hiddenTabs.indexes.toList(),
                    onSelection: (tabIndex) {
                      widget.provider.controller.selectedIndex = tabIndex;
                      _hideMenu();
                    })))
      ]);
    });
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      if (mounted) setState(() {});
    }
  }

  bool isHorizontal() =>
      widget.provider.tabBarPosition == TabBarPosition.top ||
      widget.provider.tabBarPosition == TabBarPosition.bottom;

  @override
  Widget build(BuildContext context) {
    final TabbedViewThemeData theme = TabbedViewTheme.of(context);
    final TabsAreaThemeData tabsAreaTheme = theme.tabsArea;

    List<TabButton> buttons = [];
    if (widget.provider.tabsAreaButtonsBuilder != null) {
      buttons = widget.provider.tabsAreaButtonsBuilder!(
          context, widget.provider.controller.tabs.length);
    }
    if (widget.hiddenTabs.hasHiddenTabs) {
      IconProvider icon;
      final bool isOpen = _overlayEntry != null;
      switch (widget.provider.tabBarPosition) {
        case TabBarPosition.top:
          icon = isOpen ? tabsAreaTheme.menuIconOpen : tabsAreaTheme.menuIcon;
          break;
        case TabBarPosition.bottom:
          icon = isOpen ? tabsAreaTheme.menuIcon : tabsAreaTheme.menuIconOpen;
          break;
        case TabBarPosition.left:
          icon =
              isOpen ? tabsAreaTheme.menuIconLeft : tabsAreaTheme.menuIconRight;
          break;
        case TabBarPosition.right:
          icon =
              isOpen ? tabsAreaTheme.menuIconRight : tabsAreaTheme.menuIconLeft;
          break;
      }

      final menuButton = TabButton(
          icon: icon,
          onPressed: () {
            if (_overlayEntry == null) {
              _showMenu(context);
            } else {
              _hideMenu();
            }
          });
      if (widget.provider.tabBarPosition == TabBarPosition.left) {
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
              provider: widget.provider,
              button: tabButton,
              enabled: widget.provider.draggingTabIndex == null,
              normalColor: tabsAreaTheme.normalButtonColor,
              hoverColor: tabsAreaTheme.hoverButtonColor,
              disabledColor: tabsAreaTheme.disabledButtonColor,
              normalBackground: tabsAreaTheme.normalButtonBackground,
              hoverBackground: tabsAreaTheme.hoverButtonBackground,
              disabledBackground: tabsAreaTheme.disabledButtonBackground,
              iconSize: tabButton.iconSize != null
                  ? tabButton.iconSize!
                  : tabsAreaTheme.buttonIconSize,
              themePadding: tabsAreaTheme.buttonPadding),
          padding: padding));
    }

    Widget buttonsArea = Row(children: children);

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

    return CompositedTransformTarget(
      link: _layerLink,
      child: buttonsArea,
    );
  }
}
