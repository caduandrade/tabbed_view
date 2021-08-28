import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/src/tabbed_view_icons.dart';
import 'package:tabbed_view/src/theme/tab_theme_data.dart';
import 'package:tabbed_view/src/theme/tabs_area_theme_data.dart';

void main() {
  group('close icon', () {
    test('default', () {
      TabThemeData data = TabThemeData();
      expect(data.closeIconData, isNull);
      expect(data.closeIconPath, isNotNull);
    });

    test('null', () {
      TabThemeData data =
          TabThemeData(closeIconData: null, closeIconPath: null);
      expect(data.closeIconData, isNull);
      expect(data.closeIconPath, isNotNull);
    });

    test('path', () {
      TabThemeData data = TabThemeData(closeIconPath: TabbedViewIcons.close);
      expect(data.closeIconData, isNull);
      expect(data.closeIconPath, isNotNull);
    });

    test('data', () {
      TabThemeData data = TabThemeData(closeIconData: Icons.close);
      expect(data.closeIconData, isNotNull);
      expect(data.closeIconPath, isNull);
    });

    test('both', () {
      TabThemeData data = TabThemeData(
          closeIconData: Icons.close, closeIconPath: TabbedViewIcons.close);
      expect(data.closeIconData, isNotNull);
      expect(data.closeIconPath, isNotNull);
    });
  });
}
