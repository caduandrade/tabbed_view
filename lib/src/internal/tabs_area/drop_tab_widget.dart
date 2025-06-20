import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/draggable_data.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/theme/tabbed_view_theme_data.dart';
import 'package:tabbed_view/src/theme/theme_widget.dart';

@internal
class DropTabWidget extends StatefulWidget {
  const DropTabWidget(
      {super.key,
      required this.provider,
      required this.newIndex,
      required this.child});

  final TabbedViewProvider provider;
  final Widget child;
  final int newIndex;

  static const double dropWidth = 8;

  @override
  State<StatefulWidget> createState() => DropTabWidgetState();
}

class DropTabWidgetState extends State<DropTabWidget> {
  bool _over = false;
  bool _canDrop = false;

  @override
  void didUpdateWidget(covariant DropTabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.provider.draggingTabIndex == null) {
      _over = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onExit: (e) {
          if (_over) {
            setState(() {
              _over = false;
              _canDrop = false;
            });
          }
        },
        child: DragTarget<DraggableData>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            if (_over) {
              TabbedViewThemeData theme = TabbedViewTheme.of(context);
              return CustomPaint(
                  foregroundPainter:
                      _CustomPainter(dropColor: theme.tabsArea.dropColor),
                  child: widget.child);
            }
            return widget.child;
          },
          onMove: (details) {
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
              _canDrop = widget.provider.canDrop!(
                  details.data, widget.provider.controller);
            }
            return _canDrop;
          },
          onAcceptWithDetails: (details) {
            final DraggableData data = details.data;
            if (widget.provider.onBeforeDropAccept != null) {
              if (widget.provider.onBeforeDropAccept!(
                      data, widget.provider.controller, widget.newIndex) ==
                  false) {
                setState(() {
                  _over = false;
                  _canDrop = false;
                });
                return;
              }
            }
            if (widget.provider.controller == data.controller) {
              widget.provider.controller
                  .reorderTab(data.tabData.index, widget.newIndex);
            } else {
              data.controller.removeTab(data.tabData.index);
              widget.provider.controller
                  .insertTab(widget.newIndex, data.tabData);
            }
          },
        ));
  }
}

class _CustomPainter extends CustomPainter {
  _CustomPainter({required this.dropColor});

  final Color dropColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = dropColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, DropTabWidget.dropWidth, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
