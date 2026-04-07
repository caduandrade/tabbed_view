import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../scenario_config.dart';
import '../scenario_configurator.dart';
import '../scenario_screen.dart';

class TabRemoveInterceptorScenario {
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
    List<TabData> tabs = [];
    tabs.add(
      TabData(
        id: 1,
        text: 'Tab 1',
        view: Center(child: Text('Closable')),
      ),
    );
    tabs.add(
      TabData(
        id: 2,
        text: 'Tab 2',
        view: Center(child: Text('Removal will be intercepted')),
      ),
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
      tabRemoveInterceptor: (context, index, tabData) {
        if (tabData.id == 2) {
          return false;
        }
        return true;
      },
    );
  }
}
