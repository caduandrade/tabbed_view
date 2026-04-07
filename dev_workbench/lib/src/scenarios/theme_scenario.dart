import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../scenario_config.dart';
import '../scenario_configurator.dart';
import '../scenario_screen.dart';

class ThemeScenario {
  static (ScenarioConfigurator?, ScenarioScreen) builder({
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  }) {
    _Config config = _Config();
    return (
      _Configurator(config: config),
      ScenarioScreen(
        config: config,
        builder: (BuildContext context) =>
            _Screen(scaffoldMessengerKey: scaffoldMessengerKey, config: config),
      ),
    );
  }
}

class _Screen extends StatefulWidget {
  const _Screen({required this.scaffoldMessengerKey, required this.config});

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final _Config config;

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
        id: 'tab1',
        text: 'Tab 1',
        value: 'myTab',
        leading: (context, status) => Icon(Icons.star, size: 16),
        view: Padding(padding: EdgeInsets.all(8), child: Text('Hello')),
        buttonsBuilder: (context) => [
          TabButton.icon(
            IconProvider.data(Icons.info),
            onPressed: () {
              widget.scaffoldMessengerKey.currentState?.showSnackBar(
                const SnackBar(content: Text('Info button clicked!')),
              );
            },
          ),
        ],
      ),
    );
    tabs.add(
      TabData(
        id: 'tab2',
        text: 'Tab 2',
        buttonsBuilder: (context) => [
          TabButton.menu((context) {
            return [
              TabbedViewMenuItem(
                text: 'Menu item 1',
                onSelection: () =>
                    widget.scaffoldMessengerKey.currentState?.showSnackBar(
                      const SnackBar(content: Text('Menu item 1')),
                    ),
              ),
              TabbedViewMenuItem(
                text: 'Menu item 2',
                onSelection: () =>
                    widget.scaffoldMessengerKey.currentState?.showSnackBar(
                      const SnackBar(content: Text('Menu item 2')),
                    ),
              ),
            ];
          }),
        ],
        view: Padding(padding: EdgeInsets.all(8), child: Text('Hello again')),
      ),
    );
    tabs.add(
      TabData(
        id: 'textField',
        text: 'TextField',
        view: Padding(
          padding: EdgeInsets.all(8),
          child: TextField(
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ),
        keepAlive: true,
      ),
    );
    tabs.add(
      TabData(
        id: 'longTitle',
        text: 'This is a very long tab title that should be truncated',
        view: Padding(
          padding: EdgeInsets.all(8),
          child: Text('Content for the long tab'),
        ),
      ),
    );
    tabs.add(
      TabData(
        id: 'unclosable',
        text: 'Unclosable',
        closable: false,
        view: Padding(
          padding: EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.topLeft,
            child: TextButton(
              child: Text('Force close'),
              onPressed: () {
                int index = _controller.tabs.indexWhere(
                  (tab) => tab.id == 'unclosable',
                );
                if (index != -1) {
                  _controller.removeTab(index);
                }
              },
            ),
          ),
        ),
      ),
    );
    _controller.setTabs(tabs);
    _controller.selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return TabbedViewTheme(
      data: widget.config.buildTabbedViewThemeData(),
      child: _buildTabbedView(),
    );
  }

  TabbedView _buildTabbedView() {
    return TabbedView(
      trailing: widget.config.trailingWidgetEnabled
          ? Text('Trailing text')
          : null,
      controller: _controller,
      viewBuilder: null,
      tabsAreaButtonsBuilder: widget.config.addButtonEnabled
          ? (context, tabsCount) {
              return [
                TabButton.icon(
                  IconProvider.data(Icons.add),
                  onPressed: () {
                    _controller.addTab(
                      TabData(
                        id: Object(),
                        text: 'New Tab',
                        view: Center(child: Text('Content of New Tab')),
                      ),
                    );
                  },
                ),
              ];
            }
          : null,
    );
  }
}

class _Config extends AbstractScenarioConfig {}

class _Configurator extends AbstractScenarioConfigurator<_Config> {
  const _Configurator({required super.config});
}
