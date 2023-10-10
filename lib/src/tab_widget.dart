import 'package:flutter/material.dart';
import 'package:tabbed_view/src/draggable_config.dart';
import 'package:tabbed_view/src/draggable_data.dart';
import 'package:tabbed_view/src/flow_layout.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/internal/tabs_area/drop_tab_widget.dart';
import 'package:tabbed_view/src/internal/tabs_area/tab_drag_feedback_widget.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tab_button_widget.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tab_status.dart';
import 'package:tabbed_view/src/theme/tab_status_theme_data.dart';
import 'package:tabbed_view/src/theme/tab_theme_data.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/theme_widget.dart';

/// Listener for the tabs with the mouse over.
typedef UpdateHighlightedIndex = void Function(int? tabIndex);

/// The tab widget. Displays the tab text and its buttons.
class TabWidget extends StatelessWidget {
  const TabWidget({required UniqueKey key, required this.index, required this.status, required this.provider, required this.updateHighlightedIndex, required this.onClose}) : super(key: key);

  final int index;
  final TabStatus status;
  final TabbedViewProvider provider;
  final UpdateHighlightedIndex updateHighlightedIndex;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    TabData tab = provider.controller.tabs[index];
    TabbedViewThemeData theme = TabbedViewTheme.of(context);
    TabThemeData tabTheme = theme.tab;
    TabStatusThemeData statusTheme = tabTheme.getTabThemeFor(status);

    bool isMinWidthOrMaxWidth = tabTheme.minWidth != null || tabTheme.maxWidth != null;

    List<Widget> textAndButtons = _textAndButtons(context, tabTheme, isMinWidthOrMaxWidth);

    Widget textAndButtonsContainer = ClipRect(
        child: isMinWidthOrMaxWidth
            ? Row(
                children: textAndButtons,
              )
            : FlowLayout(
                firstChildFlex: true,
                verticalAlignment: tabTheme.verticalAlignment,
                children: textAndButtons,
              ));

    BorderSide innerBottomBorder = statusTheme.innerBottomBorder ?? tabTheme.innerBottomBorder ?? BorderSide.none;
    BorderSide innerTopBorder = statusTheme.innerTopBorder ?? tabTheme.innerTopBorder ?? BorderSide.none;
    BoxDecoration? decoration = statusTheme.decoration ?? tabTheme.decoration;

    EdgeInsetsGeometry? padding;
    if (textAndButtons.length == 1) {
      padding = statusTheme.paddingWithoutButton ?? tabTheme.paddingWithoutButton;
    }
    padding ??= statusTheme.padding ?? tabTheme.padding;

    EdgeInsetsGeometry? margin = tabTheme.margin;
    if (statusTheme.margin != null) {
      margin = statusTheme.margin;
    }

    Widget tabWidget = Container(
      constraints: tabTheme.minWidth != null || tabTheme.maxWidth != null
          ? BoxConstraints(
              maxWidth: tabTheme.maxWidth ?? tabTheme.minWidth ?? double.infinity,
              minWidth: tabTheme.minWidth ?? 0,
            )
          : null,
      decoration: decoration,
      margin: margin,
      child: Container(padding: padding, decoration: BoxDecoration(border: Border(top: innerTopBorder, bottom: innerBottomBorder)), child: textAndButtonsContainer),
    );

    MouseCursor cursor = MouseCursor.defer;
    if (provider.draggingTabIndex == null && status == TabStatus.selected) {
      cursor = SystemMouseCursors.click;
    }

    tabWidget = MouseRegion(
        cursor: cursor,
        onHover: (details) => updateHighlightedIndex(index),
        onExit: (details) => updateHighlightedIndex(null),
        child: provider.draggingTabIndex == null ? GestureDetector(onTap: () => _onSelect(context, index), child: tabWidget) : tabWidget);

    if (tab.draggable) {
      DraggableConfig draggableConfig = DraggableConfig.defaultConfig;
      if (provider.onDraggableBuild != null) {
        draggableConfig = provider.onDraggableBuild!(provider.controller, index, tab);
      }

      if (draggableConfig.canDrag) {
        Widget feedback = draggableConfig.feedback != null ? draggableConfig.feedback! : TabDragFeedbackWidget(tab: tab, tabTheme: tabTheme);

        tabWidget = Draggable<DraggableData>(
            feedback: Material(child: feedback),
            data: DraggableData(provider.controller, tab),
            feedbackOffset: draggableConfig.feedbackOffset,
            dragAnchorStrategy: draggableConfig.dragAnchorStrategy,
            onDragStarted: () {
              provider.onTabDrag(index);
              if (draggableConfig.onDragStarted != null) {
                draggableConfig.onDragStarted!();
              }
            },
            onDragUpdate: (details) {
              if (draggableConfig.onDragUpdate != null) {
                draggableConfig.onDragUpdate!(details);
              }
            },
            onDraggableCanceled: (velocity, offset) {
              provider.onTabDrag(null);
              if (draggableConfig.onDraggableCanceled != null) {
                draggableConfig.onDraggableCanceled!(velocity, offset);
              }
            },
            onDragEnd: (details) {
              if (draggableConfig.onDragEnd != null) {
                draggableConfig.onDragEnd!(details);
              }
            },
            onDragCompleted: () {
              provider.onTabDrag(null);
              if (draggableConfig.onDragCompleted != null) {
                draggableConfig.onDragCompleted!();
              }
            },
            child: tabWidget);

        tabWidget = Opacity(opacity: provider.draggingTabIndex != index ? 1 : tabTheme.draggingOpacity, child: tabWidget);
      }
    }

    if (provider.controller.reorderEnable && provider.draggingTabIndex != tab.index) {
      return DropTabWidget(provider: provider, newIndex: tab.index, child: tabWidget);
    }
    return tabWidget;
  }

  /// Builds a list with title text and buttons.
  List<Widget> _textAndButtons(BuildContext context, TabThemeData tabTheme, bool isMinWidthOrMaxWidth) {
    List<Widget> textAndButtons = [];

    TabData tab = provider.controller.tabs[index];
    TabStatusThemeData statusTheme = tabTheme.getTabThemeFor(status);

    Color normalColor = statusTheme.normalButtonColor != null ? statusTheme.normalButtonColor! : tabTheme.normalButtonColor;
    Color hoverColor = statusTheme.hoverButtonColor != null ? statusTheme.hoverButtonColor! : tabTheme.hoverButtonColor;
    Color disabledColor = statusTheme.disabledButtonColor != null ? statusTheme.disabledButtonColor! : tabTheme.disabledButtonColor;

    BoxDecoration? normalBackground = statusTheme.normalButtonBackground ?? tabTheme.normalButtonBackground;
    BoxDecoration? hoverBackground = statusTheme.hoverButtonBackground ?? tabTheme.hoverButtonBackground;
    BoxDecoration? disabledBackground = statusTheme.disabledButtonBackground ?? tabTheme.disabledButtonBackground;

    TextStyle? textStyle = tabTheme.textStyle;
    if (statusTheme.fontColor != null) {
      if (textStyle != null) {
        textStyle = textStyle.copyWith(color: statusTheme.fontColor);
      } else {
        textStyle = TextStyle(color: statusTheme.fontColor);
      }
    }

    final bool buttonsEnabled = provider.draggingTabIndex == null && (provider.selectToEnableButtons == false || (provider.selectToEnableButtons && status == TabStatus.selected));
    bool hasButtons = tab.buttons != null && tab.buttons!.isNotEmpty;
    EdgeInsets? padding;
    if (tab.closable || hasButtons && tabTheme.buttonsOffset > 0) {
      padding = EdgeInsets.only(right: tabTheme.buttonsOffset);
    }

    if (tab.leading != null) {
      Widget? leading = tab.leading!(context, status);
      if (leading != null) {
        textAndButtons.add(leading);
      }
    }

    Widget text = Container(padding: padding, child: Text(tab.text, style: textStyle, overflow: TextOverflow.ellipsis));
    textAndButtons.add(isMinWidthOrMaxWidth ? Expanded(child: text) : text);

    if (hasButtons) {
      for (int i = 0; i < tab.buttons!.length; i++) {
        EdgeInsets? padding;
        if (i > 0 && i < tab.buttons!.length && tabTheme.buttonsGap > 0) {
          padding = EdgeInsets.only(left: tabTheme.buttonsGap);
        }
        TabButton button = tab.buttons![i];
        textAndButtons.add(Container(
            padding: padding,
            child: TabButtonWidget(
                provider: provider,
                button: button,
                enabled: buttonsEnabled,
                normalColor: normalColor,
                hoverColor: hoverColor,
                disabledColor: disabledColor,
                normalBackground: normalBackground,
                hoverBackground: hoverBackground,
                disabledBackground: disabledBackground,
                iconSize: button.iconSize != null ? button.iconSize! : tabTheme.buttonIconSize,
                themePadding: tabTheme.buttonPadding)));
      }
    }
    if (tab.closable) {
      EdgeInsets? padding;
      if (hasButtons && tabTheme.buttonsGap > 0) {
        padding = EdgeInsets.only(left: tabTheme.buttonsGap);
      }
      TabButton closeButton = TabButton(icon: tabTheme.closeIcon, onPressed: () => _onClose(context, index), toolTip: provider.closeButtonTooltip);

      textAndButtons.add(
        Container(
          padding: padding,
          child: TabButtonWidget(
            provider: provider,
            button: closeButton,
            enabled: buttonsEnabled,
            normalColor: normalColor,
            hoverColor: hoverColor,
            disabledColor: disabledColor,
            normalBackground: normalBackground,
            hoverBackground: hoverBackground,
            disabledBackground: disabledBackground,
            iconSize: tabTheme.buttonIconSize,
            themePadding: tabTheme.buttonPadding,
          ),
        ),
      );
    }

    return textAndButtons;
  }

  void _onClose(BuildContext context, int index) {
    if (provider.tabCloseInterceptor == null || provider.tabCloseInterceptor!(index)) {
      onClose();
      TabData tabData = provider.controller.removeTab(index);
      if (provider.onTabClose != null) {
        provider.onTabClose!(index, tabData);
      }
    }
  }

  void _onSelect(BuildContext context, int newTabIndex) {
    if (provider.tabSelectInterceptor == null || provider.tabSelectInterceptor!(newTabIndex)) {
      provider.controller.selectedIndex = newTabIndex;
    }
  }
}
