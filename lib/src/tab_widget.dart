import 'package:flutter/material.dart';
import 'package:tabbed_view/src/flow_layout.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/internal/tabs_area/drop_tab_widget.dart';
import 'package:tabbed_view/src/internal/tabs_area/tab_drag_feedback_widget.dart';
import 'package:tabbed_view/src/tab_button_widget.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Listener for the tabs with the mouse over.
typedef UpdateHighlightedIndex = void Function(int? tabIndex);

/// The tab widget. Displays the tab text and its buttons.
class TabWidget extends StatelessWidget {
  const TabWidget(
      {required UniqueKey key,
      required this.index,
      required this.status,
      required this.provider,
      required this.updateHighlightedIndex,
      required this.onClose})
      : super(key: key);

  final int index;
  final TabStatus status;
  final TabbedViewProvider provider;
  final UpdateHighlightedIndex updateHighlightedIndex;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    final TabData tab = provider.controller.tabs[index];
    final TabbedViewThemeData theme = TabbedViewTheme.of(context);
    final TabThemeData tabTheme = theme.tab;
    final bool isStacked = provider.tabBarPosition.isVertical &&
        tabTheme.verticalLayoutStyle == VerticalTabLayoutStyle.stacked;

    Widget widget = _TabContentWidget(
        provider: provider,
        index: index,
        isStacked: isStacked,
        onClose: onClose,
        status: status,
        tabTheme: tabTheme);

    TabBorderBuilder? borderBuilder = tabTheme.borderBuilder;
    while (borderBuilder != null) {
      TabBorder tabBorder = borderBuilder(
          status: status, tabBarPosition: provider.tabBarPosition);
      if (tabBorder.border != null) {
        final BorderRadius? borderRadius = tabBorder.borderRadius;
        if (borderRadius != null) {
          widget = ClipRRect(
              borderRadius: borderRadius,
              child: Container(
                  decoration: BoxDecoration(
                      border: tabBorder.border, borderRadius: borderRadius),
                  child: widget));
        } else {
          widget = Container(
              decoration: BoxDecoration(border: tabBorder.border),
              child: widget);
        }
      }
      borderBuilder = tabBorder.wrapperBorderBuilder;
    }

    final maxWidth = tabTheme.maxWidth;
    if (maxWidth != null) {
      BoxConstraints constraints;
      if (provider.tabBarPosition.isHorizontal) {
        constraints = BoxConstraints(maxWidth: maxWidth);
      } else {
        // left or right
        constraints = BoxConstraints(maxHeight: maxWidth);
      }
      widget = ConstrainedBox(
        constraints: constraints,
        child: widget,
      );
    }

    MouseCursor cursor = MouseCursor.defer;
    if (provider.draggingTabIndex == null && status == TabStatus.selected) {
      cursor = SystemMouseCursors.click;
    }

    final Widget interactiveTab = widget;

    widget = MouseRegion(
        cursor: cursor,
        onEnter: (event) => updateHighlightedIndex(index),
        onExit: (event) => updateHighlightedIndex(null),
        child: provider.draggingTabIndex == null
            ? GestureDetector(
                onTap: () => _onSelect(context, index),
                onSecondaryTapDown: (details) {
                  if (provider.onTabSecondaryTap != null) {
                    TabData tab = provider.controller.tabs[index];
                    provider.onTabSecondaryTap!(index, tab, details);
                  }
                },
                child: interactiveTab)
            : interactiveTab);

    if (tab.draggable) {
      DraggableConfig draggableConfig = DraggableConfig.defaultConfig;
      if (provider.onDraggableBuild != null) {
        draggableConfig =
            provider.onDraggableBuild!(provider.controller, index, tab);
      }

      if (draggableConfig.canDrag) {
        Widget feedback = draggableConfig.feedback != null
            ? draggableConfig.feedback!
            : TabDragFeedbackWidget(tab: tab, tabTheme: tabTheme);

        widget = Draggable<DraggableData>(
            child: widget,
            feedback: Material(child: feedback),
            data: DraggableData(provider.controller, tab, provider.dragScope),
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
            });

        widget = Opacity(
            child: widget,
            opacity: provider.draggingTabIndex != index
                ? 1
                : tabTheme.draggingOpacity);
      }
    }

    if (provider.controller.reorderEnable &&
        provider.draggingTabIndex != tab.index) {
      return DropTabWidget(
          provider: provider,
          newIndex: tab.index,
          child: widget,
          halfWidthDrop: true);
    }
    return widget;
  }

  void _onSelect(BuildContext context, int newTabIndex) {
    if (provider.tabSelectInterceptor == null ||
        provider.tabSelectInterceptor!(newTabIndex)) {
      provider.controller.selectedIndex = newTabIndex;
    }
  }
}

class _TabContentWidget extends StatelessWidget {
  const _TabContentWidget(
      {required this.index,
      required this.status,
      required this.provider,
      required this.onClose,
      required this.tabTheme,
      required this.isStacked});

  final int index;
  final TabStatus status;
  final TabbedViewProvider provider;
  final Function onClose;
  final TabThemeData tabTheme;
  final bool isStacked;

  @override
  Widget build(BuildContext context) {
    List<Widget> textAndButtons = _textAndButtons(context, tabTheme, isStacked);

    FlowDirection flowDirection;
    if (provider.tabBarPosition.isHorizontal) {
      flowDirection = FlowDirection.horizontal;
    } else {
      // For vertical tabs, the layout is counter-intuitive due to RotatedBox.
      // 'stacked' uses a horizontal flow and 'inline' uses a vertical
      // flow to achieve the desired column/row effect after rotation.
      flowDirection =
          isStacked ? FlowDirection.horizontal : FlowDirection.vertical;
    }

    Widget textAndButtonsContainer = ClipRect(
        child: FlowLayout(
            children: textAndButtons,
            firstChildFlex: true,
            direction: flowDirection,
            verticalAlignment: tabTheme.verticalAlignment));

    final TabStatusThemeData statusTheme = tabTheme.getTabThemeFor(status);

    EdgeInsetsGeometry? padding;
    if (textAndButtons.length == 1) {
      padding =
          statusTheme.paddingWithoutButton ?? tabTheme.paddingWithoutButton;
    }
    if (padding == null) {
      padding = statusTheme.padding ?? tabTheme.padding;
    }

    Widget widget = Container(
      child: Container(child: textAndButtonsContainer, padding: padding),
    );

    // Rotate the tab content if tab bar is vertical
    if (provider.tabBarPosition == TabBarPosition.left) {
      widget = RotatedBox(quarterTurns: -1, child: widget);
    } else if (provider.tabBarPosition == TabBarPosition.right) {
      widget = RotatedBox(quarterTurns: 1, child: widget);
    }

    return widget;
  }

  /// Builds a list with title text and buttons.
  List<Widget> _textAndButtons(
      BuildContext context, TabThemeData tabTheme, bool isStacked) {
    List<Widget> textAndButtons = [];

    TabData tab = provider.controller.tabs[index];
    TabStatusThemeData statusTheme = tabTheme.getTabThemeFor(status);

    Color normalColor =
        statusTheme.normalButtonColor ?? tabTheme.normalButtonColor;
    Color hoverColor =
        statusTheme.hoverButtonColor ?? tabTheme.hoverButtonColor;
    Color disabledColor =
        statusTheme.disabledButtonColor ?? tabTheme.disabledButtonColor;

    BoxDecoration? normalBackground =
        statusTheme.normalButtonBackground ?? tabTheme.normalButtonBackground;
    BoxDecoration? hoverBackground =
        statusTheme.hoverButtonBackground ?? tabTheme.hoverButtonBackground;
    BoxDecoration? disabledBackground = statusTheme.disabledButtonBackground ??
        tabTheme.disabledButtonBackground;

    TextStyle? textStyle = tabTheme.textStyle;
    if (statusTheme.fontColor != null) {
      if (textStyle != null) {
        textStyle = textStyle.copyWith(color: statusTheme.fontColor);
      } else {
        textStyle = TextStyle(color: statusTheme.fontColor);
      }
    }

    final bool buttonsEnabled = provider.draggingTabIndex == null &&
        (provider.selectToEnableButtons == false ||
            (provider.selectToEnableButtons && status == TabStatus.selected));
    bool hasButtons = tab.buttons != null && tab.buttons!.isNotEmpty;
    EdgeInsets? padding;
    if (tab.closable || hasButtons && tabTheme.buttonsOffset > 0) {
      padding = EdgeInsets.only(
          right: tabTheme.buttonsOffset); // Use final buttonsOffset
    }

    if (tab.leading != null) {
      Widget? leading = tab.leading!(context, status);
      if (leading != null) {
        textAndButtons.add(leading);
      }
    }

    final bool isVertical = provider.tabBarPosition == TabBarPosition.left ||
        provider.tabBarPosition == TabBarPosition.right;

    Widget textWidget;
    if (isVertical && !isStacked) {
      if (tabTheme.rotateCaptionsInVerticalTabs) {
        textWidget =
            Text(tab.text, style: textStyle, overflow: TextOverflow.ellipsis);
      } else {
        String verticalText = tab.text.split('').join('');
        textWidget =
            Text(verticalText, style: textStyle, textAlign: TextAlign.center);
        // Counter-rotate the text to keep it upright within the rotated tab.
        int quarterTurns =
            provider.tabBarPosition == TabBarPosition.left ? 1 : -1;
        textWidget = RotatedBox(quarterTurns: quarterTurns, child: textWidget);
      }
    } else {
      // For horizontal tabs or stacked vertical tabs, display text normally.
      textWidget =
          Text(tab.text, style: textStyle, overflow: TextOverflow.ellipsis);
    }

    textAndButtons.add(Container(
        child: SizedBox(width: tab.textSize, child: textWidget),
        padding: padding));

    if (hasButtons) {
      for (int i = 0; i < tab.buttons!.length; i++) {
        EdgeInsets? padding;
        if (i > 0 && i < tab.buttons!.length && tabTheme.buttonsGap > 0) {
          // Use final buttonsGap
          padding = EdgeInsets.only(left: tabTheme.buttonsGap);
        }
        TabButton button = tab.buttons![i];
        textAndButtons.add(Container(
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
          onPressed: () async => await _onClose(context, index),
          toolTip: provider.closeButtonTooltip);

      bool enabled = buttonsEnabled;
      if (tabTheme.showCloseIconWhenNotFocused) {
        enabled = provider.draggingTabIndex == null;
      }

      textAndButtons.add(Container(
          child: TabButtonWidget(
              provider: provider,
              button: closeButton,
              enabled: enabled,
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

  Future<void> _onClose(BuildContext context, int index) async {
    TabData tabData = provider.controller.getTabByIndex(index);
    if (provider.tabCloseInterceptor == null ||
        (await provider.tabCloseInterceptor!(index, tabData))) {
      onClose();
      index = provider.controller.tabs.indexOf(tabData);
      index != -1 ? provider.controller.removeTab(index) : null;
      if (provider.onTabClose != null && index != -1) {
        provider.onTabClose!(index, tabData);
      }
    }
  }
}
