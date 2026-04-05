import 'package:flutter/material.dart';

class ControlledLayout extends StatefulWidget {
  final Widget child;

  const ControlledLayout({super.key, required this.child});

  @override
  State<ControlledLayout> createState() => _ControlledLayoutState();
}

class _ControlledLayoutState extends State<ControlledLayout> {
  double _horizontalScale = 0.8;
  double _verticalScale = 0.8;

  @override
  Widget build(BuildContext context) {
    final BorderSide borderSide = BorderSide(color: Colors.grey.shade600);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(left: borderSide),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _horizontalScale,
                  onChanged: (v) => setState(() => _horizontalScale = v),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: _horizontalScale,
                      heightFactor: _verticalScale,
                      child: Container(
                        color: Colors.white,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Slider(
                      value: _verticalScale,
                      onChanged: (v) => setState(() => _verticalScale = v),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
