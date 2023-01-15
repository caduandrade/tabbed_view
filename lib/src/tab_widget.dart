import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/flow_layout.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tab_button_widget.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tab_status.dart';
import 'package:tabbed_view/src/tabbed_view_data.dart';
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

    EdgeInsetsGeometry? padding;
    if (textAndButtons.length == 1) {
      padding =
          statusTheme.paddingWithoutButton ?? tabTheme.paddingWithoutButton;
    }
    if (padding == null) {
      padding = statusTheme.padding ?? tabTheme.padding;
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
        onTap: () => _onSelect(context, index), child: tabContainer);

    MouseCursor cursor = MouseCursor.defer;
    if (status != TabStatus.selected) {
      cursor = SystemMouseCursors.click;
    }
    MouseRegion mouseRegion = MouseRegion(
        cursor: cursor,
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

    Color normalColor = statusTheme.normalButtonColor != null
        ? statusTheme.normalButtonColor!
        : tabTheme.normalButtonColor;
    Color hoverColor = statusTheme.hoverButtonColor != null
        ? statusTheme.hoverButtonColor!
        : tabTheme.hoverButtonColor;
    Color disabledColor = statusTheme.disabledButtonColor != null
        ? statusTheme.disabledButtonColor!
        : tabTheme.disabledButtonColor;

    BoxDecoration? normalBackground = statusTheme.normalButtonBackground != null
        ? statusTheme.normalButtonBackground
        : tabTheme.normalButtonBackground;
    BoxDecoration? hoverBackground = statusTheme.hoverButtonBackground != null
        ? statusTheme.hoverButtonBackground
        : tabTheme.hoverButtonBackground;
    BoxDecoration? disabledBackground =
        statusTheme.disabledButtonBackground != null
            ? statusTheme.disabledButtonBackground
            : tabTheme.disabledButtonBackground;

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
    bool hasButtons = tab.buttons != null && tab.buttons!.length > 0;
    EdgeInsets? padding;
    if (tab.closable || hasButtons && tabTheme.buttonsOffset > 0) {
      padding = EdgeInsets.only(right: tabTheme.buttonsOffset);
    }

    if (tab.leading != null) {
      textAndButtons.add(tab.leading!);
    }

    textAndButtons.add(Container(
        child:
            Text(tab.text, style: textStyle, overflow: TextOverflow.ellipsis),
        padding: padding));

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
                normalColor: normalColor,
                hoverColor: hoverColor,
                disabledColor: disabledColor,
                normalBackground: normalBackground,
                hoverBackground: hoverBackground,
                disabledBackground: disabledBackground,
                iconSize: button.iconSize != null
                    ? button.iconSize!
                    : tabTheme.buttonIconSize,
                themePadding: tabTheme.buttonPadding),
            padding: padding));
      }
    }
    if (tab.closable) {
      EdgeInsets? padding;
      if (hasButtons && tabTheme.buttonsGap > 0) {
        padding = EdgeInsets.only(left: tabTheme.buttonsGap);
      }
      TabButton closeButton = TabButton(
          icon: tabTheme.closeIcon,
          onPressed: () => _onClose(context, index),
          toolTip: data.closeButtonTooltip);

      textAndButtons.add(Container(
          child: TabButtonWidget(
              data: data,
              button: closeButton,
              enabled: buttonsEnabled,
              normalColor: normalColor,
              hoverColor: hoverColor,
              disabledColor: disabledColor,
              normalBackground: normalBackground,
              hoverBackground: hoverBackground,
              disabledBackground: disabledBackground,
              iconSize: tabTheme.buttonIconSize,
              themePadding: tabTheme.buttonPadding),
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

  void _onSelect(BuildContext context, int newTabIndex) {
    if (data.tabSelectInterceptor == null ||
        data.tabSelectInterceptor!(newTabIndex)) {
      data.controller.selectedIndex = newTabIndex;
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
