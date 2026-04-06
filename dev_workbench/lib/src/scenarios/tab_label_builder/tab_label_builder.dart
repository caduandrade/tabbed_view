import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../scenario_config.dart';
import '../scenario_configurator.dart';
import '../scenario_screen.dart';

class TabLabelBuilder {
  static (ScenarioConfigurator?, ScenarioScreen) builder() {
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
  final TabbedViewController _controller = TabbedViewController([
    TabData(id: 1, text: 'Test'),
  ]);

  @override
  Widget build(BuildContext context) {
    return TabbedView(controller: _controller);
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
