import 'package:dev_workbench/src/scenarios/scenario_config.dart';
import 'package:flutter/material.dart';

abstract class ScenarioScreen<CONFIG extends ScenarioConfig>
    extends StatelessWidget {
  const ScenarioScreen({super.key, required this.config});

  final CONFIG config;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: config,
      builder: (context, child) => buildScenario(context),
    );
  }

  Widget buildScenario(BuildContext context);
}
