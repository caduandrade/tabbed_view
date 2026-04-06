import 'package:dev_workbench/src/scenario.dart';
import 'package:dev_workbench/src/scenarios/scenario_configurator.dart';
import 'package:dev_workbench/src/scenarios/scenario_screen.dart';
import 'package:flutter/material.dart';

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
  Scenario _selectedScenario = Scenario.theme;

  @override
  Widget build(BuildContext context) {
    (ScenarioConfigurator? c, ScenarioScreen) scenario = _selectedScenario
        .builder
        .call();

    List<Widget> rows = [];

    final ScenarioConfigurator? configurator = scenario.$1;

    rows.add(
      _SideBar(
        selectedScenario: _selectedScenario,
        onScenarioSelected: (scenario) {
          setState(() {
            _selectedScenario = scenario;
          });
        },
        configurator: configurator ?? Container(),
      ),
    );

    rows.add(
      Expanded(
        child: _ResizableLayout(
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

class _ResizableLayout extends StatefulWidget {
  final Widget child;

  const _ResizableLayout({super.key, required this.child});

  @override
  State<_ResizableLayout> createState() => _ResizableLayoutState();
}

class _ResizableLayoutState extends State<_ResizableLayout> {
  double _horizontalScale = 0.8;
  double _verticalScale = 0.8;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _horizontalScale,
                  onChanged: (v) => setState(() => _horizontalScale = v),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: _horizontalScale,
                      heightFactor: _verticalScale,
                      child: Container(
                        color: Colors.white,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Slider(
                      value: _verticalScale,
                      onChanged: (v) => setState(() => _verticalScale = v),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SideBar extends StatelessWidget {
  const _SideBar({
    required this.selectedScenario,
    required this.onScenarioSelected,
    required this.configurator,
  });

  final Scenario selectedScenario;
  final ValueChanged<Scenario> onScenarioSelected;
  final Widget configurator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade600)),
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ScenarioChooser(
              selectedScenario: selectedScenario,
              onScenarioSelected: onScenarioSelected,
            ),
            Divider(),
            configurator,
          ],
        ),
      ),
    );
  }
}

class _ScenarioChooser extends StatelessWidget {
  const _ScenarioChooser({
    required this.selectedScenario,
    required this.onScenarioSelected,
  });

  final Scenario selectedScenario;
  final ValueChanged<Scenario> onScenarioSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: DropdownMenu<Scenario>(
        initialSelection: selectedScenario,
        requestFocusOnTap: false,
        label: const Text('Scenario'),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          isDense: true,
        ),
        onSelected: (Scenario? newValue) {
          if (newValue != null) {
            onScenarioSelected(newValue);
          }
        },
        dropdownMenuEntries: Scenario.values.map<DropdownMenuEntry<Scenario>>((
          Scenario scenario,
        ) {
          return DropdownMenuEntry<Scenario>(
            value: scenario,
            label: scenario.text,
            style: MenuItemButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
          );
        }).toList(),
      ),
    );
  }
}
