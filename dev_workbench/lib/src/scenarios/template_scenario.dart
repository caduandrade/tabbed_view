import 'package:flutter/material.dart';

import '../scenario_config.dart';
import '../scenario_configurator.dart';
import '../scenario_screen.dart';

class TemplateScenario {
  static (ScenarioConfigurator?, ScenarioScreen) builder({
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  }) {
    _Config config = _Config();
    return (
      _Configurator(config: config),
      ScenarioScreen(
        config: config,
        builder: (BuildContext context) => _Screen(config: config),
      ),
    );
  }
}

class _Screen extends StatefulWidget {
  const _Screen({required this.config});

  final _Config config;

  @override
  State<StatefulWidget> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _Config extends AbstractScenarioConfig {}

class _Configurator extends AbstractScenarioConfigurator<_Config> {
  const _Configurator({required super.config});
}
