import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

import '../../draggable_config.dart';
import '../../draggable_data.dart';
import '../../tab_data.dart';
import '../../tab_status.dart';
import '../../theme/side_tabs_layout.dart';
import '../../theme/tab_decoration_builder.dart';
import '../../theme/tab_theme_data.dart';
import '../../theme/tabbed_view_theme_data.dart';
import '../../theme/theme_widget.dart';
import '../size_holder.dart';
import '../tabbed_view_provider.dart';
import '../tabs_area/drop_tab_widget.dart';
import '../tabs_area/tab_drag_feedback_widget.dart';
import 'tab_header_widget.dart';

/// Listener for the tabs with the mouse over.
@internal
typedef UpdateHoveredIndex = void Function(int? tabIndex);

/// The tab widget. Displays the tab text and its buttons.
@internal
class TabWidget extends StatelessWidget {
  const TabWidget(
      {required UniqueKey key,
      required this.index,
      required this.status,
      required this.provider,
      required this.updateHoveredIndex,
      required this.onClose,
      required this.sizeHolder})
      : super(key: key);

  final int index;
  final TabStatus status;
  final TabbedViewProvider provider;
  final UpdateHoveredIndex updateHoveredIndex;
  final Function onClose;
  final SizeHolder sizeHolder;

  @override
  Widget build(BuildContext context) {
    final TabData tab = provider.controller.tabs[index];
    final TabbedViewThemeData theme = TabbedViewTheme.of(context);
    final TabThemeData tabTheme = theme.tab;

    Widget widget = TabHeaderWidget(
        provider: provider,
        index: index,
        onClose: onClose,
        status: status,
        sideTabsLayout: theme.tabsArea.sideTabsLayout);
    widget = _TabHeaderProxy(sizeHolder: sizeHolder, child: widget);

    TabDecorationBuilder? decorationBuilder = tabTheme.decorationBuilder;
    while (decorationBuilder != null) {
      TabDecoration tabDecoration = decorationBuilder(
          status: status, tabBarPosition: theme.tabsArea.position);
      if (tabDecoration.border != null ||
          tabDecoration.color != null ||
          tabDecoration.shape != null) {
        if (tabDecoration.shape != null) {
          widget = DecoratedBox(
            decoration: ShapeDecoration(
              shape: tabDecoration.shape!,
              color: tabDecoration.color,
            ),
            child: ClipPath(
              clipper: ShapeBorderClipper(shape: tabDecoration.shape!),
              child: widget,
            ),
          );
        } else {
          final BorderRadius? borderRadius = tabDecoration.borderRadius;
          if (borderRadius != null) {
            widget = Container(
                decoration: BoxDecoration(
                    color: tabDecoration.color,
                    border: tabDecoration.border,
                    borderRadius: borderRadius),
                child: ClipRRect(borderRadius: borderRadius, child: widget));
          } else {
            widget = Container(
                decoration: BoxDecoration(
                    color: tabDecoration.color, border: tabDecoration.border),
                child: widget);
          }
        }
      }
      decorationBuilder = tabDecoration.wrapperBorderBuilder;
    }

    final maxWidth = tabTheme.maxMainSize;
    if (maxWidth != null) {
      BoxConstraints constraints;
      if (theme.tabsArea.position.isHorizontal) {
        constraints = BoxConstraints(maxWidth: maxWidth);
      } else {
        // For vertical tab bars, the constraint depends on the layout.
        if (theme.tabsArea.sideTabsLayout == SideTabsLayout.stacked) {
          // Stacked tabs are not rotated, so their main axis is width.
          constraints = BoxConstraints(maxWidth: maxWidth);
        } else {
          // Rotated tabs have their logical width as physical height.
          constraints = BoxConstraints(maxHeight: maxWidth);
        }
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
        onEnter: (event) => updateHoveredIndex(index),
        onExit: (event) => updateHoveredIndex(null),
        child: provider.draggingTabIndex == null
            ? GestureDetector(
                onTap: () => provider.controller.selectedIndex = index,
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

    if (provider.tabReorderEnabled &&
        provider.draggingTabIndex != TabDataHelper.indexFrom(tab)) {
      return DropTabWidget(
          provider: provider,
          newIndex: TabDataHelper.indexFrom(tab),
          child: widget,
          halfWidthDrop: true);
    }
    return widget;
  }
}

class _TabHeaderProxy extends SingleChildRenderObjectWidget {
  const _TabHeaderProxy({
    required Widget super.child,
    required this.sizeHolder,
  });

  final SizeHolder sizeHolder;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderTabContentProxy(sizeHolder: sizeHolder);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderTabContentProxy renderObject) {
    renderObject.sizeHolder = sizeHolder;
  }
}

class _RenderTabContentProxy extends RenderProxyBox {
  _RenderTabContentProxy({
    required SizeHolder sizeHolder,
  }) : _sizeHolder = sizeHolder;

  SizeHolder _sizeHolder;

  SizeHolder get sizeHolder => _sizeHolder;
  set sizeHolder(SizeHolder value) {
    if (_sizeHolder != value) {
      _sizeHolder = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;
    } else {
      size = constraints.biggest;
    }
    sizeHolder.size = size;
  }
}
