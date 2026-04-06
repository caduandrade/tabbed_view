import 'package:dev_workbench/src/scenarios/scenario_config.dart';
import 'package:flutter/material.dart';

abstract class ScenarioConfigurator<CONFIG extends ScenarioConfig>
    extends StatelessWidget {
  const ScenarioConfigurator({super.key, required this.config});

  final CONFIG config;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: config,
      builder: (context, child) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildConfigurations(context),
        ),
      ),
    );
  }

  List<Widget> buildConfigurations(BuildContext context);
}
