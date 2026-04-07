import 'package:tabbed_view/tabbed_view.dart';
import 'package:flutter/material.dart';

class PositionChooser extends StatelessWidget {
  const PositionChooser({
    super.key,
    required this.currentPosition,
    required this.onSelected,
  });

  final TabBarPosition currentPosition;
  final Function(TabBarPosition newPosition) onSelected;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = TabBarPosition.values.map<Widget>((value) {
      return ChoiceChip(
        label: Text(value.name),
        selected: currentPosition == value,
        onSelected: (selected) => onSelected(value),
      );
    }).toList();

    return Wrap(spacing: 8, runSpacing: 4, children: children);
  }
}
