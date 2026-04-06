import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../widgets/theme_chooser.dart';
import '../scenario_config.dart';

class ThemeConfig extends ScenarioConfig {
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

  Brightness _brightness = Brightness.light;
  Brightness get brightness => _brightness;
  set brightness(Brightness value) {
    if (_brightness != value) {
      _brightness = value;
      notifyListeners();
    }
  }
}
