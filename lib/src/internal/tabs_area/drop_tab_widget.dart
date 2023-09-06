import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/draggable_data.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';

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

  @override
  void didUpdateWidget(covariant DropTabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.provider.draggingTabIndex == null) {
      _over = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<DraggableData>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        if (_over) {
          return CustomPaint(
              foregroundPainter: _CustomPainter(), child: widget.child);
        }
        return widget.child;
      },
      onMove: (details) {
        if (_over == false && _canDrop(details.data)) {
          setState(() {
            _over = true;
          });
        }
      },
      onLeave: (data) {
        if (_over) {
          setState(() {
            _over = false;
          });
        }
      },
      onWillAccept: (data) {
        if (data != null) {
          return _canDrop(data);
        }
        return false;
      },
      onAccept: (DraggableData data) {
        if (widget.provider.onBeforeDropAccept != null) {
          if (widget.provider.onBeforeDropAccept!(
                  data, widget.provider.controller, widget.newIndex) ==
              false) {
            setState(() {
              _over = false;
            });
            return;
          }
        }
        if (widget.provider.controller == data.controller) {
          widget.provider.controller
              .reorderTab(data.tabData.index, widget.newIndex);
        } else {
          data.controller.removeTab(data.tabData.index);
          widget.provider.controller.insertTab(widget.newIndex, data.tabData);
        }
      },
    );
  }

  bool _canDrop(DraggableData source) {
    if (widget.provider.canDrop == null) {
      return true;
    }
    return widget.provider.canDrop!(source, widget.provider.controller);
  }
}

class _CustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black.withOpacity(.7)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, DropTabWidget.dropWidth, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
