import 'package:flutter/material.dart';

class Selector extends StatelessWidget {
  const Selector({super.key, required this.text, this.value, this.onChanged});
  final String text;
  final bool? value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(text),
      ],
    );
  }
}
