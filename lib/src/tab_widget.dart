import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/flow_layout.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tab_button_widget.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tab_status.dart';
import 'package:tabbed_view/src/tabbed_view_data.dart';
import 'package:tabbed_view/src/theme/button_colors.dart';
import 'package:tabbed_view/src/theme/tab_status_theme_data.dart';
import 'package:tabbed_view/src/theme/tab_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/theme_widget.dart';

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
    TabThemeData tabTheme = theme.tab;
    TabStatusThemeData statusTheme = _getTabThemeFor(tabTheme, status);

    List<Widget> textAndButtons = _textAndButtons(context, tabTheme);

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

    EdgeInsetsGeometry? padding = tabTheme.padding;
    if (statusTheme.padding != null) {
      padding = statusTheme.padding;
    }

    EdgeInsetsGeometry? margin = tabTheme.margin;
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
  List<Widget> _textAndButtons(BuildContext context, TabThemeData tabTheme) {
    List<Widget> textAndButtons = [];

    TabData tab = data.controller.tabs[index];
    TabStatusThemeData statusTheme = _getTabThemeFor(tabTheme, status);
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
                data: data,
                button: button,
                enabled: buttonsEnabled,
                colors: buttonColors,
                iconSize: button.iconSize != null
                    ? button.iconSize!
                    : tabTheme.buttonIconSize),
            padding: padding));
      }
    }
    if (tab.closable) {
      EdgeInsets? padding;
      if (hasButtons && tabTheme.buttonsGap > 0) {
        padding = EdgeInsets.only(left: tabTheme.buttonsGap);
      }
      TabButton closeButton = TabButton(
          iconData: tabTheme.closeIconData,
          iconPath: tabTheme.closeIconPath,
          onPressed: () => _onClose(context, index),
          toolTip: data.closeButtonTooltip);

      textAndButtons.add(Container(
          child: TabButtonWidget(
              data: data,
              button: closeButton,
              enabled: buttonsEnabled,
              colors: buttonColors,
              iconSize: tabTheme.buttonIconSize),
          padding: padding));
    }

    return textAndButtons;
  }

  void _onClose(BuildContext context, int index) {
    if (data.tabCloseInterceptor == null || data.tabCloseInterceptor!(index)) {
      TabData tabData = data.controller.removeTab(index);
      if (data.onTabClose != null) {
        data.onTabClose!(index, tabData);
      }
    }
  }

  /// Gets the theme of a tab according to its status.
  TabStatusThemeData _getTabThemeFor(TabThemeData tabTheme, TabStatus status) {
    switch (status) {
      case TabStatus.normal:
        return TabStatusThemeData.empty;
      case TabStatus.selected:
        return tabTheme.selectedStatus;
      case TabStatus.highlighted:
        return tabTheme.highlightedStatus;
    }
  }
}
