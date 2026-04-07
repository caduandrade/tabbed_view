import 'package:dev_workbench/src/scenario_configurator.dart';
import 'package:dev_workbench/src/scenario_screen.dart';
import 'package:dev_workbench/src/scenarios/tab_header_row_scenario.dart';
import 'package:dev_workbench/src/scenarios/tab_label_builder_scenario.dart';
import 'package:dev_workbench/src/scenarios/theme_scenario.dart';
import 'package:flutter/material.dart';

import 'scenarios/tab_remove_interceptor_scenario.dart';
import 'scenarios/tab_secondary_tap_scenario.dart';

enum Scenario {
  theme('Theme', ThemeScenario.builder),
  tabLabelBuilder('TabLabelBuilder', TabLabelBuilderScenario.builder),
  tabSecondaryTap('Tab secondary tap', TabSecondaryTapScenario.builder),
  tab('Tab remove interceptor', TabRemoveInterceptorScenario.builder),
  tabHeaderRow('TabHeaderRow', TabHeaderRowScenario.builder);

  const Scenario(this.text, this.builder);

  final String text;
  final ScenarioBuilder builder;
}

typedef ScenarioBuilder =
    (ScenarioConfigurator?, ScenarioScreen) Function({
      required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    });
