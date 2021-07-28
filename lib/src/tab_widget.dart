import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tab_button_widget.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tab_status.dart';
import 'package:tabbed_view/src/tabbed_view_data.dart';
import 'package:tabbed_view/src/theme.dart';

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
    TabsAreaTheme tabsAreaTheme = data.theme.tabsArea;
    TabTheme tabTheme = tabsAreaTheme.tab;
    TabStatusTheme statusTheme = _getTabThemeFor(status);
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
    List<Widget> textAndButtons = [Text(tab.text, style: textStyle)];

    bool buttonsEnabled = data.selectToEnableButtons == false ||
        (data.selectToEnableButtons && status == TabStatus.selected);
    if (tab.closable ||
        (tab.buttons != null && tab.buttons!.length > 0) &&
            tabTheme.buttonsOffset > 0) {
      textAndButtons.add(SizedBox(width: tabTheme.buttonsOffset));
    }
    bool hasButtons = tab.buttons != null && tab.buttons!.length > 0;

    if (hasButtons) {
      for (int i = 0; i < tab.buttons!.length; i++) {
        TabButton button = tab.buttons![i];
        textAndButtons.add(TabButtonWidget(
            controller: data.controller,
            button: button,
            enabled: buttonsEnabled,
            colors: buttonColors,
            iconSize: tabTheme.buttonIconSize));
        if (i < tab.buttons!.length - 1 && tabTheme.buttonsGap > 0) {
          textAndButtons.add(SizedBox(width: tabTheme.buttonsGap));
        }
      }
    }
    if (tab.closable) {
      if (hasButtons && tabTheme.buttonsGap > 0) {
        textAndButtons.add(SizedBox(width: tabTheme.buttonsGap));
      }
      TabButton closeButton = TabButton(
          icon: tabsAreaTheme.closeButtonIcon,
          onPressed: () => _onClose(context, index),
          toolTip: data.closeButtonTooltip);

      textAndButtons.add(TabButtonWidget(
          controller: data.controller,
          button: closeButton,
          enabled: buttonsEnabled,
          colors: buttonColors,
          iconSize: tabTheme.buttonIconSize));
    }

    CrossAxisAlignment? alignment;
    switch (tabTheme.verticalAlignment) {
      case VerticalAlignment.top:
        alignment = CrossAxisAlignment.start;
        break;
      case VerticalAlignment.center:
        alignment = CrossAxisAlignment.center;
        break;
      case VerticalAlignment.bottom:
        alignment = CrossAxisAlignment.end;
    }
    Widget textAndButtonsContainer =
        Row(children: textAndButtons, crossAxisAlignment: alignment);

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

  _onClose(BuildContext context, int index) {
    if (data.onTabClosing == null || data.onTabClosing!(index)) {
      data.controller.removeTab(index);
    }
  }

  /// Gets the theme of a tab according to its status.
  TabStatusTheme _getTabThemeFor(TabStatus status) {
    TabsAreaTheme tabsAreaTheme = data.theme.tabsArea;
    switch (status) {
      case TabStatus.normal:
        return TabStatusTheme.empty;
      case TabStatus.selected:
        return tabsAreaTheme.tab.selectedStatus;
      case TabStatus.highlighted:
        return tabsAreaTheme.tab.highlightedStatus;
    }
  }
}
