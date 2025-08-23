import 'package:flutter/material.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/internal/tabs_area/hidden_tabs.dart';
import 'package:tabbed_view/src/internal/tabs_area/tabs_area_corner.dart';
import 'package:tabbed_view/src/tab_widget.dart';
import 'package:tabbed_view/src/tabs_area_layout.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Widget for the tabs and buttons.
class TabsArea extends StatefulWidget {
  const TabsArea({required this.provider});

  final TabbedViewProvider provider;

  @override
  State<StatefulWidget> createState() => _TabsAreaState();
}

/// The [TabsArea] state.
class _TabsAreaState extends State<TabsArea> {
  int? _highlightedIndex;
  Key? _tabsAreaLayoutKey;
  late bool _lastIsHorizontal;

  final HiddenTabs _hiddenTabs = HiddenTabs();

  @override
  void initState() {
    super.initState();
    _lastIsHorizontal = widget.provider.tabBarPosition.isHorizontal;
    _tabsAreaLayoutKey = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    TabbedViewController controller = widget.provider.controller;
    TabbedViewThemeData theme = TabbedViewTheme.of(context);
    TabsAreaThemeData tabsAreaTheme = theme.tabsArea;
    List<Widget> children = [];
    for (int index = 0; index < controller.tabs.length; index++) {
      TabStatus status = _getStatusFor(index);
      children.add(TabWidget(
          key: controller.tabs[index].uniqueKey,
          index: index,
          status: status,
          provider: widget.provider,
          updateHighlightedIndex: _updateHighlightedIndex,
          onClose: _onTabClose));
    }

    children.add(
        TabsAreaCorner(provider: widget.provider, hiddenTabs: _hiddenTabs));

    bool isHorizontal = widget.provider.tabBarPosition.isHorizontal;
    if (isHorizontal != _lastIsHorizontal) {
      _lastIsHorizontal = isHorizontal;
      // Changing the key to force the layout to be rebuilt.
      _tabsAreaLayoutKey = UniqueKey();
    }

    Widget tabsAreaLayout = TabsAreaLayout(
        key: _tabsAreaLayoutKey,
        children: children,
        theme: theme,
        hiddenTabs: _hiddenTabs,
        selectedTabIndex: controller.selectedIndex,
        tabBarPosition: widget.provider.tabBarPosition);
    tabsAreaLayout = ClipRect(child: tabsAreaLayout);

    Widget content = tabsAreaLayout;

    // Apply the theme's color and border directly.
    return Container(
        child: content,
        decoration: BoxDecoration(
            color: tabsAreaTheme.color,
            borderRadius: _buildBorderRadius(theme: tabsAreaTheme),
            border: _buildBorder(theme: tabsAreaTheme)));
  }

  BorderRadius _buildBorderRadius({required TabsAreaThemeData theme}) {
    final Radius radius = Radius.circular(theme.borderRadius);
    final TabBarPosition position = widget.provider.tabBarPosition;

    bool top = position != TabBarPosition.bottom;
    bool bottom = position != TabBarPosition.top;
    bool left = position != TabBarPosition.right;
    bool right = position != TabBarPosition.left;

    return BorderRadius.only(
      topLeft: (left && top) ? radius : Radius.zero,
      topRight: (right && top) ? radius : Radius.zero,
      bottomLeft: (left && bottom) ? radius : Radius.zero,
      bottomRight: (right && bottom) ? radius : Radius.zero,
    );
  }

  Border _buildBorder({required TabsAreaThemeData theme}) {
    final BorderSide borderSide = theme.border ?? BorderSide.none;
    final TabBarPosition position = widget.provider.tabBarPosition;

    bool top = position != TabBarPosition.bottom;
    bool bottom = position != TabBarPosition.top;
    bool left = position != TabBarPosition.right;
    bool right = position != TabBarPosition.left;

    return Border(
      top: top ? borderSide : BorderSide.none,
      bottom: bottom ? borderSide : BorderSide.none,
      left: left ? borderSide : BorderSide.none,
      right: right ? borderSide : BorderSide.none,
    );
  }

  /// Gets the status of the tab for a given index.
  TabStatus _getStatusFor(int tabIndex) {
    TabbedViewController controller = widget.provider.controller;
    if (controller.tabs.isEmpty || tabIndex >= controller.tabs.length) {
      throw Exception('Invalid tab index: $tabIndex');
    }

    if (controller.selectedIndex != null &&
        controller.selectedIndex == tabIndex) {
      return TabStatus.selected;
    } else if (_highlightedIndex != null && _highlightedIndex == tabIndex) {
      return TabStatus.highlighted;
    }
    return TabStatus.normal;
  }

  void _updateHighlightedIndex(int? tabIndex) {
    if (_highlightedIndex != tabIndex) {
      setState(() {
        _highlightedIndex = tabIndex;
      });
    }
  }

  void _onTabClose() {
    setState(() {
      _highlightedIndex = null;
    });
  }
}
