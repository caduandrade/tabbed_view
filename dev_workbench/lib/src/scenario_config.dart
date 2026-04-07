import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import 'widgets/theme_chooser.dart';

class ScenarioConfig extends ChangeNotifier {
  Brightness _brightness = Brightness.light;
  Brightness get brightness => _brightness;
  set brightness(Brightness value) {
    if (_brightness != value) {
      _brightness = value;
      notifyListeners();
    }
  }
}

abstract class AbstractScenarioConfig extends ScenarioConfig {
  TabBarPosition _position = TabBarPosition.top;
  TabBarPosition get position => _position;
  set position(TabBarPosition value) {
    if (_position != value) {
      _position = value;
      notifyListeners();
    }
  }

  ThemeName _themeName = ThemeName.underline;
  ThemeName get themeName => _themeName;
  set themeName(ThemeName value) {
    if (_themeName != value) {
      _themeName = value;
      notifyListeners();
    }
  }

  SideTabsLayout _sideTabsLayout = SideTabsLayout.rotated;
  SideTabsLayout get sideTabsLayout => _sideTabsLayout;
  set sideTabsLayout(SideTabsLayout value) {
    if (_sideTabsLayout != value) {
      _sideTabsLayout = value;
      notifyListeners();
    }
  }

  bool _modifyThemeColors = false;
  bool get modifyThemeColors => _modifyThemeColors;
  set modifyThemeColors(bool value) {
    if (_modifyThemeColors != value) {
      _modifyThemeColors = value;
      notifyListeners();
    }
  }

  bool _maxMainSizeEnabled = false;
  bool get maxMainSizeEnabled => _maxMainSizeEnabled;
  set maxMainSizeEnabled(bool value) {
    if (_maxMainSizeEnabled != value) {
      _maxMainSizeEnabled = value;
      notifyListeners();
    }
  }

  bool _maxLinesEnabled = false;
  bool get maxLinesEnabled => _maxLinesEnabled;
  set maxLinesEnabled(bool value) {
    if (_maxLinesEnabled != value) {
      _maxLinesEnabled = value;
      notifyListeners();
    }
  }

  bool _trailingWidgetEnabled = false;
  bool get trailingWidgetEnabled => _trailingWidgetEnabled;
  set trailingWidgetEnabled(bool value) {
    if (_trailingWidgetEnabled != value) {
      _trailingWidgetEnabled = value;
      notifyListeners();
    }
  }

  bool _addButtonEnabled = true;
  bool get addButtonEnabled => _addButtonEnabled;
  set addButtonEnabled(bool value) {
    if (_addButtonEnabled != value) {
      _addButtonEnabled = value;
      notifyListeners();
    }
  }

  TabbedViewThemeData buildTabbedViewThemeData() {
    TabbedViewThemeData theme;
    switch (themeName) {
      case ThemeName.classic:
        theme = modifyThemeColors
            ? TabbedViewThemeData.classic(
                brightness: brightness,
                colorSet: Colors.blueGrey,
                borderColor: Colors.black,
              )
            : TabbedViewThemeData.classic(brightness: brightness);
        break;
      case ThemeName.minimalist:
        theme = modifyThemeColors
            ? TabbedViewThemeData.minimalist(
                brightness: brightness,
                colorSet: Colors.blueGrey,
              )
            : TabbedViewThemeData.minimalist(brightness: brightness);
        break;
      case ThemeName.underline:
        theme = modifyThemeColors
            ? TabbedViewThemeData.underline(
                brightness: brightness,
                colorSet: Colors.brown,
                underlineColorSet: Colors.brown,
              )
            : TabbedViewThemeData.underline(brightness: brightness);
        break;
      case ThemeName.folder:
        theme = modifyThemeColors
            ? TabbedViewThemeData.folder(
                brightness: brightness,
                colorSet: Colors.brown,
              )
            : TabbedViewThemeData.folder(brightness: brightness);
        break;
    }
    theme.tabsArea.position = position;
    theme.tabsArea.sideTabsLayout = sideTabsLayout;
    if (maxMainSizeEnabled) {
      theme.tab.maxMainSize = 200;
    }
    if (maxLinesEnabled) {
      theme.tab.maxLines = 2;
    }
    return theme;
  }
}
