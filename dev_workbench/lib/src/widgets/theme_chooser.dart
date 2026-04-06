import 'package:flutter/material.dart';

enum ThemeName { classic, underline, minimalist, folder }

class ThemeChooser extends StatelessWidget {
  const ThemeChooser({
    super.key,
    required this.currentTheme,
    required this.onSelected,
  });

  final ThemeName currentTheme;
  final Function(ThemeName themeName) onSelected;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = ThemeName.values.map<Widget>((value) {
      return ChoiceChip(
        label: Text(value.name),
        selected: currentTheme == value,
        onSelected: (selected) => onSelected(value),
      );
    }).toList();

    return Wrap(spacing: 8, runSpacing: 4, children: children);
  }
}
