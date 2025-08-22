import 'package:flutter/material.dart';
import 'package:tabbed_view/src/draggable_config.dart';
import 'package:tabbed_view/src/draggable_data.dart';
import 'package:tabbed_view/src/flow_layout.dart';
import 'package:tabbed_view/src/tabbed_view.dart' show TabBarPosition;
import 'package:tabbed_view/src/theme/vertical_tab_layout_style.dart';
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
    TabData tab = provider.controller.tabs[index];
    final TabbedViewThemeData theme = TabbedViewTheme.of(context);
    TabThemeData tabTheme = theme.tab;
    TabStatusThemeData statusTheme = tabTheme.getTabThemeFor(status);
    final bool isHorizontal = provider.tabBarPosition == TabBarPosition.top ||
        provider.tabBarPosition == TabBarPosition.bottom;
    final bool isVertical = !isHorizontal;
    final bool isStacked = isVertical &&
        tabTheme.verticalLayoutStyle == VerticalTabLayoutStyle.stacked;

    List<Widget> textAndButtons = _textAndButtons(context, tabTheme, isStacked);

    FlowDirection flowDirection;
    if (isHorizontal) {
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

    BoxDecoration? decoration = statusTheme.decoration ?? tabTheme.decoration;

    BorderSide? indicatorBorder;
    BorderSide? frameBorderSide;

    // Decide if statusTheme.border is for an indicator or a frame.
    if (statusTheme.border != null) {
      // A border is defined for the current status.
      // If the base tab theme's decoration has a border, we assume this is a
      // "frame" theme like 'classic'. Otherwise, it's an "indicator" theme
      // like 'dark' or 'mobile'.
      if (tabTheme.decoration?.border != null) {
        frameBorderSide = statusTheme.border;
      } else {
        indicatorBorder = statusTheme.border;
      }
    }

    // Builds inner borders for indicators.
    BorderSide innerTop = statusTheme.innerTopBorder ??
        tabTheme.innerTopBorder ??
        BorderSide.none;
    BorderSide innerBottom = statusTheme.innerBottomBorder ??
        tabTheme.innerBottomBorder ??
        BorderSide.none;
    BorderSide innerLeft = tabTheme.innerLeftBorder ?? BorderSide.none;
    BorderSide innerRight = tabTheme.innerRightBorder ?? BorderSide.none;

    if (indicatorBorder != null) {
      // Theme with an indicator border like 'dark' or 'mobile'.
      switch (provider.tabBarPosition) {
        case TabBarPosition.top:
          innerBottom = indicatorBorder;
          break;
        case TabBarPosition.bottom:
          innerTop = indicatorBorder;
          break;
        case TabBarPosition.left:
          // For a left tab bar, the content area is on the right. After a -1
          // quarter turn rotation, the original 'bottom' of the tab becomes
          // the right side.
          innerBottom = indicatorBorder;
          break;
        case TabBarPosition.right:
          // For a right tab bar, the content area is on the left. After a +1
          // quarter turn rotation, the original 'bottom' of the tab becomes
          // the left side.
          innerBottom = indicatorBorder;
          break;
      }
    }

    // Builds outer frame border.
    if (decoration != null) {
      Border? border;
      if (status == TabStatus.selected && frameBorderSide != null) {
        // Selected tab for a theme that merges with content area (e.g. 'classic')
        if (provider.tabBarPosition == TabBarPosition.bottom) {
          border = Border(
              bottom: frameBorderSide,
              left: frameBorderSide,
              right: frameBorderSide);
        } else {
          // For top, left, and right positions, the border should be open
          // on the bottom of the un-rotated widget.
          border = Border(
              top: frameBorderSide,
              left: frameBorderSide,
              right: frameBorderSide);
        }
      } else if (decoration.border != null && decoration.border is Border) {
        // Unselected tab with a full border (e.g. 'classic')
        Border currentBorder = decoration.border as Border;
        if (index > 0) {
          // Collapse border with previous tab to avoid double thickness.
          if (isHorizontal) {
            currentBorder = Border(
                top: currentBorder.top,
                right: currentBorder.right,
                bottom: currentBorder.bottom,
                left: BorderSide.none);
          } else {
            currentBorder = Border(
                top: BorderSide.none,
                right: currentBorder.right,
                bottom: currentBorder.bottom,
                left: currentBorder.left);
          }
        }
        border = currentBorder;
      }
      decoration = decoration.copyWith(border: border);
    }

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

    // Apply rotation for vertical tabs
    Widget tabContent = Container(
      child: Container(
          child: textAndButtonsContainer,
          padding: padding,
          decoration: BoxDecoration(
              border: Border(
                  top: innerTop,
                  bottom: innerBottom,
                  left: innerLeft,
                  right: innerRight))),
    );

    // Rotate the tab content if tab bar is vertical
    if (provider.tabBarPosition == TabBarPosition.left) {
      tabContent = RotatedBox(quarterTurns: -1, child: tabContent);
    } else if (provider.tabBarPosition == TabBarPosition.right) {
      tabContent = RotatedBox(quarterTurns: 1, child: tabContent);
    }

    Widget tabWidget =
        Container(child: tabContent, decoration: decoration, margin: margin);

    final maxWidth = tabTheme.maxWidth;
    if (maxWidth != null) {
      BoxConstraints constraints;
      if (isHorizontal) {
        constraints = BoxConstraints(maxWidth: maxWidth);
      } else {
        // left or right
        constraints = BoxConstraints(maxHeight: maxWidth);
      }
      tabWidget = ConstrainedBox(
        constraints: constraints,
        child: tabWidget,
      );
    }

    MouseCursor cursor = MouseCursor.defer;
    if (provider.draggingTabIndex == null && status == TabStatus.selected) {
      cursor = SystemMouseCursors.click;
    }

    Widget interactiveTab = tabWidget;

    tabWidget = MouseRegion(
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

        tabWidget = Draggable<DraggableData>(
            child: tabWidget,
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

        tabWidget = Opacity(
            child: tabWidget,
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
          child: tabWidget,
          halfWidthDrop: true);
    }
    return tabWidget;
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
      if (tabTheme.rotateCharactersInVerticalTabs) {
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

  void _onSelect(BuildContext context, int newTabIndex) {
    if (provider.tabSelectInterceptor == null ||
        provider.tabSelectInterceptor!(newTabIndex)) {
      provider.controller.selectedIndex = newTabIndex;
    }
  }
}
