import 'package:dev_workbench/src/scenarios/scenario_config.dart';
import 'package:dev_workbench/src/scenarios/scenario_configurator.dart';
import 'package:dev_workbench/src/scenarios/scenario_screen.dart';
import 'package:dev_workbench/src/scenarios/tab_header_row/tab_header_row_scenario.dart';
import 'package:dev_workbench/src/scenarios/tab_label_builder/tab_label_builder.dart';
import 'package:dev_workbench/src/scenarios/theme/theme_config.dart';
import 'package:dev_workbench/src/scenarios/theme/theme_configurator.dart';
import 'package:dev_workbench/src/scenarios/theme/theme_scenario.dart';

enum Scenario {
  theme('Theme', ThemeScenario.builder),
  tabLabelBuilder('TabLabelBuilder', TabLabelBuilder.builder),
  tabHeaderRow('TabHeaderRow', TabHeaderRowScenario.builder);

  const Scenario(this.text, this.builder);

  final String text;
  final ScenarioBuilder builder;
}

typedef ScenarioBuilder = (ScenarioConfigurator?, ScenarioScreen) Function();
