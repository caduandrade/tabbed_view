import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../tab_bar_position.dart';
import '../../tab_data.dart';
import '../../tab_status.dart';
import '../../theme/tabbed_view_theme_data.dart';
import '../../theme/tabs_area_theme_data.dart';
import '../../theme/theme_widget.dart';
import '../size_holder.dart';
import '../tab/tab_widget.dart';
import '../tabbed_view_delegate.dart';
import '../tabbed_view_provider.dart';
import 'hidden_tabs.dart';
import 'tabs_area_corner.dart';
import 'tabs_area_layout.dart';
import 'tabs_area_layout_child.dart';

/// Widget for the tabs and buttons.
@internal
class TabsArea extends StatefulWidget {
  const TabsArea({required this.provider});

  final TabbedViewProvider provider;

  @override
  State<StatefulWidget> createState() => _TabsAreaState();
}

/// The [TabsArea] state.
class _TabsAreaState extends State<TabsArea> {
  int? _hoveredIndex;

  final HiddenTabs _hiddenTabs = HiddenTabs();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: _hiddenTabs, builder: _builder);
  }

  Widget _builder(BuildContext context, Widget? child) {
    final TabbedViewDelegate delegate = widget.provider.delegate;
    TabbedViewThemeData theme = TabbedViewTheme.of(context);
    TabsAreaThemeData tabsAreaTheme = theme.tabsArea;
    List<Widget> children = [];
    for (int index = 0; index < delegate.tabs.length; index++) {
      TabStatus status = _getStatusFor(index);
      final TabData tab = delegate.tabs[index];
      SizeHolder sizeHolder = SizeHolder();
      children.add(TabsAreaLayoutChild(
          sizeHolder: sizeHolder,
          child: TabWidget(
              key: TabDataHelper.tabKey(tab),
              index: index,
              status: status,
              provider: widget.provider,
              sizeHolder: sizeHolder,
              updateHoveredIndex: _updateHoveredIndex,
              onClose: _onTabClose)));
    }

    children.add(
        TabsAreaCorner(provider: widget.provider, hiddenTabs: _hiddenTabs));

    Widget tabsAreaLayout = TabsAreaLayout(
        children: children,
        theme: theme,
        hiddenTabs: _hiddenTabs,
        selectedTabIndex: delegate.selectedIndex);
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
    final TabBarPosition position = theme.position;

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
    final TabBarPosition position = theme.position;

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
    final TabbedViewDelegate delegate = widget.provider.delegate;
    if (delegate.tabs.length == 0 || tabIndex >= delegate.tabs.length) {
      throw Exception('Invalid tab index: $tabIndex');
    }

    if (delegate.selectedIndex != null && delegate.selectedIndex == tabIndex) {
      return TabStatus.selected;
    } else if (_hoveredIndex != null && _hoveredIndex == tabIndex) {
      return TabStatus.hovered;
    }
    return TabStatus.normal;
  }

  void _updateHoveredIndex(int? tabIndex) {
    if (_hoveredIndex != tabIndex) {
      setState(() {
        _hoveredIndex = tabIndex;
      });
    }
  }

  void _onTabClose() {
    setState(() {
      _hoveredIndex = null;
    });
  }
}
