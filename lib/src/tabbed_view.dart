import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tabbed_view/src/content_area.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tab_button_widget.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tab_status.dart';
import 'package:tabbed_view/src/tab_widget.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/src/tabbed_view_data.dart';
import 'package:tabbed_view/src/tabbed_view_menu_item.dart';
import 'package:tabbed_view/src/tabs_area_layout.dart';
import 'package:tabbed_view/src/theme.dart';

/// Defines a draggable builder for each tab.
typedef DraggableTabBuilder = Draggable Function(
    int tabIndex, TabData tab, Widget tabWidget);

/// Tabs area buttons builder
typedef TabsAreaButtonsBuilder = List<TabButton> Function(
    BuildContext context, int tabsCount);

/// Event that will be triggered when starting the tab closing.
/// The return indicates whether the tab can be closed.
typedef OnTabClosing = bool Function(int tabIndex);

/// Event that will be triggered when the tab selection is changed.
typedef OnTabSelection = Function(int? newTabIndex);

/// Widget inspired by the classic Desktop-style tab component.
///
/// Supports customizable themes.
///
/// Parameters:
/// * [selectToEnableButtons]: allows buttons to be clicked only if the tab is
///   selected. The default value is [TRUE].
/// * [closeButtonTooltip]: optional tooltip for the close button.
class TabbedView extends StatefulWidget {
  TabbedView(
      {required TabbedViewController controller,
      TabbedViewTheme? theme,
      IndexedWidgetBuilder? contentBuilder,
      OnTabClosing? onTabClosing,
      OnTabSelection? onTabSelection,
      bool selectToEnableButtons = true,
      String? closeButtonTooltip,
      TabsAreaButtonsBuilder? tabsAreaButtonsBuilder,
      DraggableTabBuilder? draggableTabBuilder})
      : this._data = TabbedViewData(
            controller: controller,
            theme: theme == null ? TabbedViewTheme.classic() : theme,
            contentBuilder: contentBuilder,
            onTabClosing: onTabClosing,
            onTabSelection: onTabSelection,
            selectToEnableButtons: selectToEnableButtons,
            closeButtonTooltip: closeButtonTooltip,
            tabsAreaButtonsBuilder: tabsAreaButtonsBuilder,
            draggableTabBuilder: draggableTabBuilder);

  final TabbedViewData _data;

  @override
  State<StatefulWidget> createState() => _TabbedViewState();
}

/// The [TabbedView] state.
class _TabbedViewState extends State<TabbedView> {
  int? _lastSelectedIndex;

  @override
  void initState() {
    super.initState();
    widget._data.controller.addListener(_rebuild);
    _lastSelectedIndex = widget._data.controller.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant TabbedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._data.controller != oldWidget._data.controller) {
      oldWidget._data.controller.removeListener(_rebuild);
      widget._data.controller.addListener(_rebuild);
      _lastSelectedIndex = widget._data.controller.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget tabArea = _TabsArea(data: widget._data);
    ContentArea contentArea = ContentArea(data: widget._data);
    return CustomMultiChildLayout(children: [
      LayoutId(id: 1, child: tabArea),
      LayoutId(id: 2, child: contentArea)
    ], delegate: _TabbedViewLayout());
  }

  _rebuild() {
    int? newTabIndex = widget._data.controller.selectedIndex;
    if (_lastSelectedIndex != newTabIndex) {
      _lastSelectedIndex = newTabIndex;
      if (widget._data.onTabSelection != null) {
        widget._data.onTabSelection!(newTabIndex);
      }
    }

    setState(() {
      // rebuild
    });
  }

  @override
  void dispose() {
    widget._data.controller.removeListener(_rebuild);
    super.dispose();
  }
}

// Layout delegate for [TabbedView]
class _TabbedViewLayout extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    Size childSize = layoutChild(1, BoxConstraints.tightFor(width: size.width));
    positionChild(1, Offset.zero);
    double height = math.max(0, size.height - childSize.height);
    layoutChild(2, BoxConstraints.tightFor(width: size.width, height: height));
    positionChild(2, Offset(0, childSize.height));
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

/// Widget for the tabs and buttons.
class _TabsArea extends StatefulWidget {
  const _TabsArea({required this.data});

  final TabbedViewData data;

  @override
  State<StatefulWidget> createState() => _TabsAreaState();
}

/// The [_TabsArea] state.
class _TabsAreaState extends State<_TabsArea> {
  int? _highlightedIndex;

  final HiddenTabs hiddenTabs = HiddenTabs();

  @override
  Widget build(BuildContext context) {
    TabbedViewController controller = widget.data.controller;
    TabsAreaTheme tabsAreaTheme = widget.data.theme.tabsArea;
    List<Widget> children = [];
    for (int index = 0; index < controller.tabs.length; index++) {
      TabStatus status = _getStatusFor(index);
      children.add(TabWidget(
          index: index,
          status: status,
          data: widget.data,
          updateHighlightedIndex: _updateHighlightedIndex));
    }
    Widget tabsAreaLayout = TabsAreaLayout(
        children: children,
        buttonsAreaBuilder: _buttonsAreaBuilder,
        theme: widget.data.theme,
        hiddenTabs: hiddenTabs,
        selectedTabIndex: controller.selectedIndex);
    tabsAreaLayout = ClipRect(child: tabsAreaLayout);

    Decoration? decoration;
    if (tabsAreaTheme.color != null || tabsAreaTheme.border != null) {
      decoration = BoxDecoration(
          color: tabsAreaTheme.color, border: tabsAreaTheme.border);
    }
    return Container(
        child: MouseRegion(child: tabsAreaLayout), decoration: decoration);
  }

  /// Area for buttons like the hidden tabs menu button.
  ///
  /// Even if there are no visible buttons, an empty container must be created.
  Widget _buttonsAreaBuilder(BuildContext context) {
    ButtonsAreaTheme buttonsAreaTheme = widget.data.theme.tabsArea.buttonsArea;
    Widget buttonsArea;

    List<TabButton> buttons = [];
    if (widget.data.tabsAreaButtonsBuilder != null) {
      buttons = widget.data.tabsAreaButtonsBuilder!(
          context, widget.data.controller.tabs.length);
    }

    if (hiddenTabs.hasHiddenTabs) {
      TabButton hiddenTabsMenuButton = TabButton(
          icon: buttonsAreaTheme.hiddenTabsMenuButtonIcon,
          menuBuilder: _hiddenTabsMenuBuilder);
      buttons.insert(0, hiddenTabsMenuButton);
    }

    if (buttons.isNotEmpty) {
      List<Widget> children = [];
      for (int i = 0; i < buttons.length; i++) {
        TabButton tabButton = buttons[i];
        children.add(TabButtonWidget(
            controller: widget.data.controller,
            button: tabButton,
            enabled: true,
            colors: buttonsAreaTheme.buttonColors,
            iconSize: buttonsAreaTheme.buttonIconSize));
      }

      buttonsArea = Row(children: children);

      EdgeInsetsGeometry? margin;
      if (buttonsAreaTheme.offset > 0) {
        margin = EdgeInsets.only(left: buttonsAreaTheme.offset);
      }
      if (buttonsAreaTheme.decoration != null ||
          buttonsAreaTheme.padding != null ||
          margin != null) {
        buttonsArea = Container(
            child: buttonsArea,
            decoration: buttonsAreaTheme.decoration,
            padding: buttonsAreaTheme.padding,
            margin: margin);
      }
    } else {
      buttonsArea = Container();
    }
    return buttonsArea;
  }

  /// Builder for hidden tabs menu.
  List<TabbedViewMenuItem> _hiddenTabsMenuBuilder(BuildContext context) {
    List<TabbedViewMenuItem> list = [];
    hiddenTabs.indexes.sort();
    for (int index in hiddenTabs.indexes) {
      TabData tab = widget.data.controller.tabs[index];
      list.add(TabbedViewMenuItem(
          text: tab.text,
          onSelection: () => widget.data.controller.selectedIndex = index));
    }
    return list;
  }

  /// Gets the status of the tab for a given index.
  TabStatus _getStatusFor(int tabIndex) {
    TabbedViewController controller = widget.data.controller;
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

  _updateHighlightedIndex(int? tabIndex) {
    if (_highlightedIndex != tabIndex) {
      setState(() {
        _highlightedIndex = tabIndex;
      });
    }
  }
}
