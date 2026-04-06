import 'package:flutter/material.dart';

class BrightnessChooser extends StatelessWidget {
  const BrightnessChooser({
    super.key,
    required this.currentBrightness,
    required this.onSelected,
  });

  final Brightness currentBrightness;
  final Function(Brightness brightness) onSelected;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = Brightness.values.map<Widget>((value) {
      return ChoiceChip(
        label: Text(value.name),
        selected: currentBrightness == value,
        onSelected: (selected) => onSelected(value),
      );
    }).toList();

    return Wrap(spacing: 8, runSpacing: 4, children: children);
  }
}
