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
        child: IntrinsicWidth(
          child: Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey.shade600)),
            ),
            child: Column(children: buildConfigurations(context)),
          ),
        ),
      ),
    );
  }

  List<Widget> buildConfigurations(BuildContext context);
}
