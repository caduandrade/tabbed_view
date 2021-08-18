import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/flow_layout.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tab_button_widget.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tab_status.dart';
import 'package:tabbed_view/src/tabbed_view_data.dart';
import 'package:tabbed_view/src/theme_data.dart';
import 'package:tabbed_view/src/theme_widget.dart';

/// Listener for the tabs with the mouse over.
typedef UpdateHighlightedIndex = void Function(int? tabIndex);

/// The tab widget. Displays the tab text and its buttons.
class TabWidget extends StatelessWidget {
  const TabWidget(
      {required this.index,
      required this.status,
      required this.data,
      required this.updateHighlightedIndex});

  final int index;
  final TabStatus status;
  final TabbedViewData data;
  final UpdateHighlightedIndex updateHighlightedIndex;

  @override
  Widget build(BuildContext context) {
    TabData tab = data.controller.tabs[index];
    TabbedViewThemeData theme = TabbedViewTheme.of(context);
    TabsAreaThemeData tabsAreaTheme = theme.tabsArea;
    TabThemeData tabTheme = tabsAreaTheme.tab;
    TabStatusThemeData statusTheme = _getTabThemeFor(theme, status);

    List<Widget> textAndButtons = _textAndButtons(context, theme);

    Widget textAndButtonsContainer = ClipRect(
        child: FlowLayout(
            children: textAndButtons,
            firstChildFlex: true,
            verticalAlignment: tabTheme.verticalAlignment));

    BorderSide innerBottomBorder = statusTheme.innerBottomBorder ??
        tabTheme.innerBottomBorder ??
        BorderSide.none;
    BorderSide innerTopBorder = statusTheme.innerTopBorder ??
        tabTheme.innerTopBorder ??
        BorderSide.none;
    BoxDecoration? decoration = statusTheme.decoration ?? tabTheme.decoration;

    EdgeInsetsGeometry? padding = tabsAreaTheme.tab.padding;
    if (statusTheme.padding != null) {
      padding = statusTheme.padding;
    }

    EdgeInsetsGeometry? margin = tabsAreaTheme.tab.margin;
    if (statusTheme.margin != null) {
      margin = statusTheme.margin;
    }

    Container tabContainer = Container(
        child: Container(
            child: textAndButtonsContainer,
            padding: padding,
            decoration: BoxDecoration(
                border:
                    Border(top: innerTopBorder, bottom: innerBottomBorder))),
        decoration: decoration,
        margin: margin);

    GestureDetector gestureDetector = GestureDetector(
        onTap: () => data.controller.selectedIndex = index,
        child: tabContainer);

    MouseRegion mouseRegion = MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (details) => updateHighlightedIndex(index),
        onExit: (details) => updateHighlightedIndex(null),
        child: gestureDetector);

    if (data.draggableTabBuilder != null) {
      return data.draggableTabBuilder!(index, tab, mouseRegion);
    }
    return mouseRegion;
  }

  /// Builds a list with title text and buttons.
  List<Widget> _textAndButtons(
      BuildContext context, TabbedViewThemeData theme) {
    List<Widget> textAndButtons = [];

    TabData tab = data.controller.tabs[index];
    TabsAreaThemeData tabsAreaTheme = theme.tabsArea;
    TabThemeData tabTheme = tabsAreaTheme.tab;
    TabStatusThemeData statusTheme = _getTabThemeFor(theme, status);
    ButtonColors buttonColors = statusTheme.buttonColors != null
        ? statusTheme.buttonColors!
        : tabTheme.buttonColors;

    TextStyle? textStyle = tabTheme.textStyle;
    if (statusTheme.fontColor != null) {
      if (textStyle != null) {
        textStyle = textStyle.copyWith(color: statusTheme.fontColor);
      } else {
        textStyle = TextStyle(color: statusTheme.fontColor);
      }
    }

    bool buttonsEnabled = data.selectToEnableButtons == false ||
        (data.selectToEnableButtons && status == TabStatus.selected);
    EdgeInsets? padding;
    if (tab.closable ||
        (tab.buttons != null && tab.buttons!.length > 0) &&
            tabTheme.buttonsOffset > 0) {
      padding = EdgeInsets.only(right: tabTheme.buttonsOffset);
    }

    textAndButtons.add(Container(
        child:
            Text(tab.text, style: textStyle, overflow: TextOverflow.ellipsis),
        padding: padding));

    bool hasButtons = tab.buttons != null && tab.buttons!.length > 0;
    if (hasButtons) {
      for (int i = 0; i < tab.buttons!.length; i++) {
        EdgeInsets? padding;
        if (i > 0 && i < tab.buttons!.length && tabTheme.buttonsGap > 0) {
          padding = EdgeInsets.only(left: tabTheme.buttonsGap);
        }
        TabButton button = tab.buttons![i];
        textAndButtons.add(Container(
            child: TabButtonWidget(
                controller: data.controller,
                button: button,
                enabled: buttonsEnabled,
                colors: buttonColors,
                iconSize: tabTheme.buttonIconSize),
            padding: padding));
      }
    }
    if (tab.closable) {
      EdgeInsets? padding;
      if (hasButtons && tabTheme.buttonsGap > 0) {
        padding = EdgeInsets.only(left: tabTheme.buttonsGap);
      }
      TabButton closeButton = TabButton(
          icon: tabsAreaTheme.closeButtonIcon,
          onPressed: () => _onClose(context, index),
          toolTip: data.closeButtonTooltip);

      textAndButtons.add(Container(
          child: TabButtonWidget(
              controller: data.controller,
              button: closeButton,
              enabled: buttonsEnabled,
              colors: buttonColors,
              iconSize: tabTheme.buttonIconSize),
          padding: padding));
    }

    return textAndButtons;
  }

  _onClose(BuildContext context, int index) {
    if (data.onTabClosing == null || data.onTabClosing!(index)) {
      data.controller.removeTab(index);
    }
  }

  /// Gets the theme of a tab according to its status.
  TabStatusThemeData _getTabThemeFor(
      TabbedViewThemeData theme, TabStatus status) {
    TabsAreaThemeData tabsAreaTheme = theme.tabsArea;
    switch (status) {
      case TabStatus.normal:
        return TabStatusThemeData.empty;
      case TabStatus.selected:
        return tabsAreaTheme.tab.selectedStatus;
      case TabStatus.highlighted:
        return tabsAreaTheme.tab.highlightedStatus;
    }
  }
}
