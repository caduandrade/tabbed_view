import 'package:dev_workbench/src/scenario_config.dart';
import 'package:dev_workbench/src/scenario_configurator.dart';
import 'package:dev_workbench/src/scenario_screen.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/src/internal/tab/tab_header_layout.dart';

class TabHeaderRowScenario {
  static (ScenarioConfigurator?, ScenarioScreen) builder({
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  }) {
    _Config config = _Config();
    return (
      _Configurator(config: config),
      ScenarioScreen(
        config: config,
        builder: (context) => _Screen(config: config),
      ),
    );
  }
}

class _Screen extends StatelessWidget {
  const _Screen({required this.config});
  final _Config config;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TabHeaderRow(
        text: Text(
          'This is just a longer text. This is just a longer text. This is just a longer text.',
          overflow: config.overflow ? TextOverflow.ellipsis : null,
          maxLines: config.maxLines ? 2 : null,
        ),
        leading: Container(color: Colors.green, width: 200, height: 6),
        trailing: [Container(color: Colors.blue, width: 200, height: 6)],
      ),
    );
  }
}

class _Config extends ScenarioConfig {
  bool _overflow = false;
  bool get overflow => _overflow;
  set overflow(bool value) {
    _overflow = value;
    notifyListeners();
  }

  bool _maxLines = false;
  bool get maxLines => _maxLines;
  set maxLines(bool value) {
    _maxLines = value;
    notifyListeners();
  }
}

class _Configurator extends ScenarioConfigurator<_Config> {
  const _Configurator({required super.config});

  @override
  List<Widget> buildConfigurations(BuildContext context) {
    return [
      CheckboxListTile(
        value: config.maxLines,
        onChanged: (v) {
          if (v != null) {
            config.maxLines = v;
          }
        },
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        title: Text('MaxLines'),
      ),
      CheckboxListTile(
        value: config.overflow,
        onChanged: (v) {
          if (v != null) {
            config.overflow = v;
          }
        },
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        title: Text('Overflow'),
      ),
    ];
  }
}
