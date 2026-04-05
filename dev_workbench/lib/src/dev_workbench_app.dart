import 'package:dev_workbench/src/scenario.dart';
import 'package:dev_workbench/src/scenario_list.dart';
import 'package:dev_workbench/src/scenario_widget_builder.dart';
import 'package:dev_workbench/src/scenarios/scenario_configurator.dart';
import 'package:dev_workbench/src/scenarios/scenario_screen.dart';
import 'package:flutter/material.dart';

import 'controlled_layout.dart';

class DevWorkbenchApp extends StatelessWidget {
  const DevWorkbenchApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  Scenario _selectedScenario = Scenario.tabHeaderRow;

  @override
  Widget build(BuildContext context) {
    (ScenarioConfigurator? c, ScenarioScreen) scenario =
        ScenarioWidgetBuilder.build(_selectedScenario);

    List<Widget> rows = [
      SizedBox(
        width: 200,
        child: ScenarioList(
          selectedScenario: _selectedScenario,
          onScenarioSelected: (scenario) {
            setState(() {
              _selectedScenario = scenario;
            });
          },
        ),
      ),
    ];

    final ScenarioConfigurator? configurator = scenario.$1;
    if (configurator != null) {
      rows.add(configurator);
    }

    rows.add(
      Expanded(
        child: ControlledLayout(
          key: ValueKey(_selectedScenario),
          child: scenario.$2,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows),
    );
  }
}
