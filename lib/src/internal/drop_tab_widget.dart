import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tabbed_view/src/internal/tabbed_view_provider.dart';
import 'package:tabbed_view/src/tab_data.dart';

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
    return DragTarget<TabData>(
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
        if (_over == false) {
          setState(() {
            _over = true;
          });
        }
      },
      onLeave: (data) {
        setState(() {
          _over = false;
        });
      },
      onAccept: (TabData tabData) {
        widget.provider.controller.reorderTab(tabData.index, widget.newIndex);
      },
    );
  }
}

class _CustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, 3, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
