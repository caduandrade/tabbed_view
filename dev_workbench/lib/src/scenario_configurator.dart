import 'package:dev_workbench/src/scenario_config.dart';
import 'package:flutter/material.dart';

import 'widgets/brightness_chooser.dart';
import 'widgets/position_chooser.dart';
import 'widgets/selector.dart';
import 'widgets/side_tabs_layout_chooser.dart';
import 'widgets/theme_chooser.dart';

abstract class ScenarioConfigurator<CONFIG extends ScenarioConfig>
    extends StatelessWidget {
  const ScenarioConfigurator({super.key, required this.config});

  final CONFIG config;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: config,
      builder: (context, child) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildConfigurations(context),
        ),
      ),
    );
  }

  List<Widget> buildConfigurations(BuildContext context);
}

class AbstractScenarioConfigurator<CONFIG extends AbstractScenarioConfig>
    extends ScenarioConfigurator<CONFIG> {
  const AbstractScenarioConfigurator({super.key, required super.config});

  @override
  List<Widget> buildConfigurations(BuildContext context) {
    List<Widget> list = [];
    list.add(Text('Flutter Brightness'));
    list.add(
      BrightnessChooser(
        currentBrightness: config.brightness,
        onSelected: (value) => config.brightness = value,
      ),
    );
    list.add(SizedBox(height: 16));
    list.add(Text('TabBarPosition'));
    list.add(
      PositionChooser(
        currentPosition: config.position,
        onSelected: (value) => config.position = value,
      ),
    );
    list.add(SizedBox(height: 16));
    list.add(Text('SideTabsLayout'));
    list.add(
      SideTabsLayoutChooser(
        currentLayout: config.sideTabsLayout,
        currentPosition: config.position,
        onSelected: (value) => config.sideTabsLayout = value,
      ),
    );
    list.add(SizedBox(height: 16));
    list.add(Text('Theme'));
    list.add(
      ThemeChooser(
        currentTheme: config.themeName,
        onSelected: (value) => config.themeName = value,
      ),
    );
    list.add(SizedBox(height: 16));

    list.add(
      Selector(
        text: 'Trailing widget',
        value: config.trailingWidgetEnabled,
        onChanged: (value) => config.trailingWidgetEnabled = value ?? false,
      ),
    );
    list.add(
      Selector(
        text: 'Modify theme colors',
        value: config.modifyThemeColors,
        onChanged: (value) => config.modifyThemeColors = value ?? false,
      ),
    );
    list.add(
      Selector(
        text: 'Max tab main size',
        value: config.maxMainSizeEnabled,
        onChanged: (value) => config.maxMainSizeEnabled = value ?? false,
      ),
    );
    list.add(
      Selector(
        text: 'Max tab lines',
        value: config.maxLinesEnabled,
        onChanged: (value) => config.maxLinesEnabled = value ?? false,
      ),
    );
    list.add(
      Selector(
        text: 'Add button',
        value: config.addButtonEnabled,
        onChanged: (value) => config.addButtonEnabled = value ?? false,
      ),
    );

    return list;
  }
}
