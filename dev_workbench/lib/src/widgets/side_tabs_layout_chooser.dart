import 'package:tabbed_view/tabbed_view.dart';
import 'package:flutter/material.dart';

class SideTabsLayoutChooser extends StatelessWidget {
  const SideTabsLayoutChooser({
    super.key,
    required this.currentLayout,
    required this.onSelected,
    required this.currentPosition,
  });

  final SideTabsLayout currentLayout;
  final TabBarPosition currentPosition;
  final Function(SideTabsLayout newLayout) onSelected;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = SideTabsLayout.values.map<Widget>((value) {
      return ChoiceChip(
        label: Text(value.name),
        selected: currentLayout == value,
        onSelected: currentPosition.isVertical
            ? (selected) => onSelected(value)
            : null,
      );
    }).toList();

    return Wrap(spacing: 8, runSpacing: 4, children: children);
  }
}
