import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../draggable_tab_data.dart';
import '../../tab_bar_position.dart';
import '../../tab_data.dart';
import '../../theme/tabbed_view_theme_data.dart';
import '../../theme/theme_widget.dart';
import '../tabbed_view_provider.dart';

@internal
class DropTabWidget extends StatefulWidget {
  const DropTabWidget(
      {super.key,
      required this.provider,
      required this.tabIndex,
      required this.child,
      this.halfWidthDrop = true});

  final TabbedViewProvider provider;
  final Widget child;
  final int tabIndex;
  final bool halfWidthDrop;

  static const double dropWidth = 8;

  @override
  State<StatefulWidget> createState() => DropTabWidgetState();
}

enum _DropPosition { before, after }

class DropTabWidgetState extends State<DropTabWidget> {
  bool _over = false;
  bool _canDrop = false;
  _DropPosition _dropPosition = _DropPosition.before;

  @override
  void didUpdateWidget(covariant DropTabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.provider.draggingTabIndex == null) {
      _over = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    TabbedViewThemeData theme = TabbedViewTheme.of(context);
    return MouseRegion(
        onExit: (e) {
          if (!mounted) return;
          if (_over) {
            setState(() {
              _over = false;
              _canDrop = false;
            });
          }
        },
        child: DragTarget<DraggableTabData>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            if (_over) {
              TabbedViewThemeData theme = TabbedViewTheme.of(context);
              return CustomPaint(
                  foregroundPainter: _CustomPainter(
                      dropPosition: _dropPosition,
                      tabBarPosition: theme.tabsArea.position,
                      dropColor: theme.tabsArea.dropColor),
                  child: widget.child);
            }
            return widget.child;
          },
          onMove: (details) {
            if (!mounted) return;
            if (widget.halfWidthDrop) {
              final renderBox = context.findRenderObject() as RenderBox;

              // Dynamically adjust the drop zone based on drag direction.
              double ratio = 0.5;

              final int? sourceIndex = widget.provider.draggingTabIndex;
              // Checking if the drag is happening inside the same tabbed_view.
              if (sourceIndex != null) {
                final int targetIndex = widget.tabIndex;
                if (sourceIndex > targetIndex) {
                  // Dragging from right to left, make "before" zone larger.
                  ratio = 0.75;
                } else if (sourceIndex < targetIndex) {
                  // Dragging from left to right, make "after" zone larger.
                  ratio = 0.25;
                }
              }

              final localPosition = renderBox.globalToLocal(details.offset);

              final newDropPosition = theme.tabsArea.position.isHorizontal
                  ? (localPosition.dx < renderBox.size.width * ratio
                      ? _DropPosition.before
                      : _DropPosition.after)
                  : (details.offset.dy < renderBox.size.height * ratio
                      ? _DropPosition.before
                      : _DropPosition.after);
              if (_dropPosition != newDropPosition) {
                setState(() {
                  _dropPosition = newDropPosition;
                });
              }
            }
            if (_canDrop && _over == false) {
              setState(() {
                _over = true;
              });
            }
          },
          onWillAcceptWithDetails: (details) {
            if (widget.provider.dragScope != null &&
                details.data.dragScope != null &&
                widget.provider.dragScope != details.data.dragScope) {
              _canDrop = false; // Reject if drag scopes don't match
            } else if (widget.provider.canDrop == null) {
              _canDrop = true;
            } else {
              _canDrop = widget.provider.canDrop!(details.data);
            }
            return _canDrop;
          },
          onAcceptWithDetails: (details) {
            final DraggableTabData data = details.data;
            TabData? targetTab;
            if (widget.tabIndex < widget.provider.delegate.tabs.length) {
              targetTab = widget.provider.delegate.tabs[widget.tabIndex];
            }
            int finalNewIndex = widget.tabIndex;
            if (widget.halfWidthDrop && _dropPosition == _DropPosition.after) {
              finalNewIndex++;
              if (widget.tabIndex == widget.provider.delegate.tabs.length - 1) {
                // Current drop is the last. Send to the end.
                targetTab = null;
              } else if (widget.tabIndex + 1 <
                  widget.provider.delegate.tabs.length) {
                targetTab = widget.provider.delegate.tabs[widget.tabIndex + 1];
              }
            }
            if (widget.provider.onBeforeDropAccept != null) {
              if (widget.provider.onBeforeDropAccept!(data, finalNewIndex) ==
                  false) {
                setState(() {
                  _over = false;
                  _canDrop = false;
                });
                return;
              }
            }
            if (widget.provider.source ==
                DraggableTabDataHelper.source(draggable: data)) {
              widget.provider.delegate.reorderTab(data.tab, targetTab);
            } else {
              DraggableTabDataHelper.delegate(draggable: data)
                  .detachTab(data.tab);
              widget.provider.delegate.attachTab(data.tab, targetTab);
            }
          },
        ));
  }
}

class _CustomPainter extends CustomPainter {
  _CustomPainter(
      {required this.dropPosition,
      required this.tabBarPosition,
      required this.dropColor});

  final _DropPosition dropPosition;
  final TabBarPosition tabBarPosition;
  final Color dropColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = dropColor
      ..style = PaintingStyle.fill;
    if (tabBarPosition.isHorizontal) {
      double x = 0;
      if (dropPosition == _DropPosition.after) {
        x = size.width - DropTabWidget.dropWidth;
      }
      canvas.drawRect(
          Rect.fromLTWH(x, 0, DropTabWidget.dropWidth, size.height), paint);
    } else {
      double y = 0;
      if (dropPosition == _DropPosition.after) {
        y = size.height - DropTabWidget.dropWidth;
      }
      canvas.drawRect(
          Rect.fromLTWH(0, y, size.width, DropTabWidget.dropWidth), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
