import 'package:dev_workbench/src/scenarios/theme/theme_config.dart';
import 'package:dev_workbench/src/scenarios/theme/theme_configurator.dart';
import 'package:flutter/material.dart';

import '../scenario_configurator.dart';
import '../scenario_screen.dart';

class ThemeScenario {
  static (ScenarioConfigurator?, ScenarioScreen) builder() {
    ThemeConfig config = ThemeConfig();
    return (
      ThemeConfigurator(config: config),
      ScenarioScreen(
        config: config,
        builder: (BuildContext context) => Container(),
      ),
    );
  }
}
