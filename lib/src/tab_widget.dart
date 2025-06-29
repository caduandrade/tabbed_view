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
    if (isVertical) {
      // For vertical tabs, the layout is counter-intuitive due to RotatedBox.
      // The 'inline' style uses a vertical flow and 'stacked' uses a horizontal
      // flow to achieve the desired row/column effect after rotation.
      flowDirection =
          isStacked ? FlowDirection.horizontal : FlowDirection.vertical;
    } else {
      flowDirection = FlowDirection.horizontal;
    }
    Widget textAndButtonsContainer = ClipRect(
        child: FlowLayout(
            children: textAndButtons,
            firstChildFlex: true,
            direction: flowDirection,
            verticalAlignment: tabTheme.verticalAlignment));

    var themeInnerBottomBorder = statusTheme.innerBottomBorder ??
        tabTheme.innerBottomBorder ??
        BorderSide.none;
    var themeInnerTopBorder = statusTheme.innerTopBorder ??
        tabTheme.innerTopBorder ??
        BorderSide.none;

    BoxDecoration? decoration = statusTheme.decoration ?? tabTheme.decoration;

    // Adjust decoration for tab bar position.
    if (decoration != null) {
      // Start with the border from the current decoration. If null, use a default Border.
      Border currentBorder;
      if (decoration.border is Border) {
        currentBorder = decoration.border as Border;
      } else if (decoration.border is BorderDirectional) {
        final bd = decoration.border as BorderDirectional;
        currentBorder = Border(
            top: bd.top, bottom: bd.bottom, left: bd.start, right: bd.end);
      } else {
        currentBorder = Border(); // Default to no border if not specified
      }

      // Frame-filling. If any side is defined, fill the others.
      // This ensures that a theme defining e.g. only a bottom border gets a full frame.
      BorderSide frameSide = currentBorder.top;
      if (frameSide == BorderSide.none) frameSide = currentBorder.bottom;
      if (frameSide == BorderSide.none) frameSide = currentBorder.left;
      if (frameSide == BorderSide.none) frameSide = currentBorder.right;

      if (frameSide != BorderSide.none) {
        currentBorder = Border(
          top: currentBorder.top == BorderSide.none
              ? frameSide
              : currentBorder.top,
          bottom: currentBorder.bottom == BorderSide.none
              ? frameSide
              : currentBorder.bottom,
          left: currentBorder.left == BorderSide.none
              ? frameSide
              : currentBorder.left,
          right: currentBorder.right == BorderSide.none
              ? frameSide
              : currentBorder.right,
        );
      }

      // Collapse border with adjacent tab to prevent double borders.
      if (index > 0) {
        if (isHorizontal) {
          currentBorder = Border(
              top: currentBorder.top,
              bottom: currentBorder.bottom,
              left: BorderSide.none,
              right: currentBorder.right);
        } else {
          // For vertical tabs, collapse top border for subsequent tabs
          currentBorder = Border(
              top: BorderSide.none,
              bottom: currentBorder.bottom,
              left: currentBorder.left,
              right: currentBorder.right);
        }
      }

      // Remove border adjacent to content area for the selected tab to merge them.
      if (status == TabStatus.selected) {
        switch (provider.tabBarPosition) {
          case TabBarPosition.top:
            currentBorder = Border(
                top: currentBorder.top,
                bottom: BorderSide.none,
                left: currentBorder.left,
                right: currentBorder.right);
            break;
          case TabBarPosition.bottom:
            currentBorder = Border(
                top: BorderSide.none,
                bottom: currentBorder.bottom,
                left: currentBorder.left,
                right: currentBorder.right);
            break;
          case TabBarPosition.left:
            // For left tab bar, selected tab's right border should be removed
            currentBorder = Border(
                top: currentBorder.top,
                bottom: currentBorder.bottom,
                left: currentBorder.left,
                right: BorderSide.none);
            break;
          case TabBarPosition.right:
            // For right tab bar, selected tab's left border should be removed
            currentBorder = Border(
                top: currentBorder.top,
                bottom: currentBorder.bottom,
                left: BorderSide.none,
                right: currentBorder.right);
            break;
        }
      }
      // Apply the calculated border to the decoration.
      decoration = decoration.copyWith(border: currentBorder);

      // BorderRadius
      if (decoration.borderRadius is BorderRadius) {
        final r = decoration.borderRadius as BorderRadius;
        BorderRadius? effectiveBorderRadius;
        switch (provider.tabBarPosition) {
          case TabBarPosition.top:
            effectiveBorderRadius = r; // Use original radius
            break;
          case TabBarPosition.bottom:
            // Round the top corners (flip top to bottom)
            effectiveBorderRadius = BorderRadius.only(
              topLeft: r.bottomLeft,
              topRight: r.bottomRight,
              bottomLeft: r.topLeft,
              bottomRight: r.topRight,
            );
            break;
          case TabBarPosition.left:
            // Rotate 90 deg clockwise
            effectiveBorderRadius = BorderRadius.only(
              topLeft: r.bottomLeft,
              topRight: r.topLeft,
              bottomLeft: r.bottomRight,
              bottomRight: r.topRight,
            );
            break;
          case TabBarPosition.right:
            // Rotate 90 deg counter-clockwise
            effectiveBorderRadius = BorderRadius.only(
              topLeft: r.topRight,
              topRight: r.bottomRight,
              bottomLeft: r.topLeft,
              bottomRight: r.bottomLeft,
            );
            break;
        }
        decoration = decoration.copyWith(borderRadius: effectiveBorderRadius);
      }
    }

    BorderSide effectiveInnerTopBorder = BorderSide.none;
    BorderSide effectiveInnerBottomBorder = BorderSide.none;
    BorderSide effectiveInnerLeftBorder = BorderSide.none;
    BorderSide effectiveInnerRightBorder = BorderSide.none;
    switch (provider.tabBarPosition) {
      case TabBarPosition.top:
        effectiveInnerBottomBorder = themeInnerBottomBorder;
        effectiveInnerTopBorder = themeInnerTopBorder;
        break;
      case TabBarPosition.bottom:
        effectiveInnerTopBorder = themeInnerBottomBorder;
        effectiveInnerBottomBorder = themeInnerTopBorder;
        break;
      case TabBarPosition.left:
      case TabBarPosition.right:
        // For vertical tab bars, the inner borders are applied to the top/bottom
        // of the widget before it's rotated. The 'bottom' border is the one
        // adjacent to the content area after rotation for both left and right.
        effectiveInnerBottomBorder = themeInnerBottomBorder;
        effectiveInnerTopBorder = themeInnerTopBorder;
        break;
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
                  top: effectiveInnerTopBorder,
                  bottom: effectiveInnerBottomBorder,
                  left: effectiveInnerLeftBorder,
                  right: effectiveInnerRightBorder))),
    );

    // Rotate the tab content if tab bar is vertical
    if (provider.tabBarPosition == TabBarPosition.left) {
      tabContent = RotatedBox(quarterTurns: -1, child: tabContent);
    } else if (provider.tabBarPosition == TabBarPosition.right) {
      tabContent = RotatedBox(quarterTurns: 1, child: tabContent);
    }

    Widget tabWidget =
        Container(child: tabContent, decoration: decoration, margin: margin);

    MouseCursor cursor = MouseCursor.defer;
    if (provider.draggingTabIndex == null && status == TabStatus.selected) {
      cursor = SystemMouseCursors.click;
    }

    tabWidget = MouseRegion(
        cursor: cursor,
        onEnter: (event) => updateHighlightedIndex(index),
        onExit: (event) => updateHighlightedIndex(null),
        child: provider.draggingTabIndex == null
            ? GestureDetector(
                onTap: () => _onSelect(context, index), child: tabWidget)
            : tabWidget);

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
          provider: provider, newIndex: tab.index, child: tabWidget);
    }
    return tabWidget;
  }

  /// Builds a list with title text and buttons.
  List<Widget> _textAndButtons(
      BuildContext context, TabThemeData tabTheme, bool isStacked) {
    List<Widget> textAndButtons = [];

    TabData tab = provider.controller.tabs[index];
    TabStatusThemeData statusTheme = tabTheme.getTabThemeFor(status);

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
        String verticalText = tab.text.split('').join('\n');
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

      textAndButtons.add(Container(
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
