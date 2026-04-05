import 'package:dev_workbench/src/scenario.dart';
import 'package:dev_workbench/src/scenarios/scenario_configurator.dart';
import 'package:dev_workbench/src/scenarios/scenario_screen.dart';
import 'package:dev_workbench/src/scenarios/tab_header_row/tab_header_row_scenario.dart';

class ScenarioWidgetBuilder {
  static (ScenarioConfigurator?, ScenarioScreen) build(Scenario scenario) {
    switch (scenario) {
      case Scenario.tabHeaderRow:
        return TabHeaderRowScenario.build();
    }
  }
}
