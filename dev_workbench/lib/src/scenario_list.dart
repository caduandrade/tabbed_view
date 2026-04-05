import 'package:dev_workbench/src/scenario.dart';
import 'package:flutter/material.dart';

class ScenarioList extends StatelessWidget {
  const ScenarioList({
    super.key,
    required this.selectedScenario,
    required this.onScenarioSelected,
  });

  final Scenario selectedScenario;
  final ValueChanged<Scenario> onScenarioSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Scenario.values.length,
      itemBuilder: (context, index) {
        final scenario = Scenario.values[index];
        final selected = scenario == selectedScenario;
        return ListTile(
          dense: true,
          selected: selected,
          title: Text(scenario.text),
          onTap: () => onScenarioSelected(scenario),
        );
      },
    );
  }
}
