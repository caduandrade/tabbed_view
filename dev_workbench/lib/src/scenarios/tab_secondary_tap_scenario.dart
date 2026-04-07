import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../scenario_config.dart';
import '../scenario_configurator.dart';
import '../scenario_screen.dart';

class TabSecondaryTapScenario {
  static (ScenarioConfigurator?, ScenarioScreen) builder({
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  }) {
    ScenarioConfig config = ScenarioConfig();
    return (
      null,
      ScenarioScreen(
        config: config,
        builder: (BuildContext context) =>
            _Screen(scaffoldMessengerKey: scaffoldMessengerKey),
      ),
    );
  }
}

class _Screen extends StatefulWidget {
  const _Screen({required this.scaffoldMessengerKey});

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  @override
  State<StatefulWidget> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  final TabbedViewController _controller = TabbedViewController([]);

  @override
  void initState() {
    super.initState();

    List<TabData> tabs = List.generate(
      3,
      (index) => TabData(id: index, text: 'Tab $index'),
    );
    _controller.setTabs(tabs);
    _controller.selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return _buildTabbedView();
  }

  TabbedView _buildTabbedView() {
    return TabbedView(
      controller: _controller,
      viewBuilder: (context, tab) =>
          Padding(padding: EdgeInsets.all(8), child: Text('Tab ${tab.id}')),
      onTabSecondaryTap: (index, tabData, details) {
        widget.scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              'Secondary tap on tab. Index: $index Id: ${tabData.id} Text: ${tabData.text}',
            ),
          ),
        );
      },
    );
  }
}
