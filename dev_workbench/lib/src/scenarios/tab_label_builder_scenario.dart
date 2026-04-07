import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../scenario_config.dart';
import '../scenario_configurator.dart';
import '../scenario_screen.dart';

class TabLabelBuilderScenario {
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
  final TabbedViewController _controller = TabbedViewController([]);

  @override
  void initState() {
    super.initState();
    _controller.setTabs([
      TabData(id: 1, labelBuilder: _labelBuilder),
      TabData(id: 2, labelBuilder: _labelBuilder),
      TabData(id: 3, labelBuilder: _labelBuilder),
    ]);
    _controller.selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return TabbedView(controller: _controller);
  }

  Widget _labelBuilder(TabLabelBuilderContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      color: context.status == TabStatus.hovered
          ? Colors.yellow
          : context.status == TabStatus.selected
          ? Colors.green
          : Colors.blue,
      child: Text(context.tab.id.toString()),
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
