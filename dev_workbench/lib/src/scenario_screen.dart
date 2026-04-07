import 'package:dev_workbench/src/scenario_config.dart';
import 'package:flutter/material.dart';

final class ScenarioScreen extends StatelessWidget {
  const ScenarioScreen({
    super.key,
    required this.config,
    required this.builder,
  });

  final ScenarioConfig config;
  final Builder builder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: config,
      builder: (context, child) {
        return Theme(
          data: ThemeData(brightness: config.brightness),
          child: Material(child: builder.call(context)),
        );
      },
    );
  }
}

typedef Builder = Widget Function(BuildContext context);
