import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/src/tabbed_view_icons.dart';
import 'package:tabbed_view/src/theme/tabs_area_theme_data.dart';

void main() {
  group('close icon', () {
    test('default', () {
      TabsAreaThemeData data = TabsAreaThemeData();
      expect(data.closeIconData, isNull);
      expect(data.closeIconPath, isNotNull);
    });

    test('null', () {
      TabsAreaThemeData data =
          TabsAreaThemeData(closeIconData: null, closeIconPath: null);
      expect(data.closeIconData, isNull);
      expect(data.closeIconPath, isNotNull);
    });

    test('path', () {
      TabsAreaThemeData data =
          TabsAreaThemeData(closeIconPath: TabbedViewIcons.close);
      expect(data.closeIconData, isNull);
      expect(data.closeIconPath, isNotNull);
    });

    test('data', () {
      TabsAreaThemeData data = TabsAreaThemeData(closeIconData: Icons.close);
      expect(data.closeIconData, isNotNull);
      expect(data.closeIconPath, isNull);
    });

    test('both', () {
      TabsAreaThemeData data = TabsAreaThemeData(
          closeIconData: Icons.close, closeIconPath: TabbedViewIcons.close);
      expect(data.closeIconData, isNotNull);
      expect(data.closeIconPath, isNotNull);
    });
  });

  group('menu icon', () {
    test('default', () {
      TabsAreaThemeData data = TabsAreaThemeData();
      expect(data.menuIconData, isNull);
      expect(data.menuIconPath, isNotNull);
    });

    test('null', () {
      TabsAreaThemeData data =
          TabsAreaThemeData(menuIconData: null, menuIconPath: null);
      expect(data.menuIconData, isNull);
      expect(data.menuIconPath, isNotNull);
    });

    test('path', () {
      TabsAreaThemeData data =
          TabsAreaThemeData(menuIconPath: TabbedViewIcons.menu);
      expect(data.menuIconData, isNull);
      expect(data.menuIconPath, isNotNull);
    });

    test('data', () {
      TabsAreaThemeData data = TabsAreaThemeData(menuIconData: Icons.menu);
      expect(data.menuIconData, isNotNull);
      expect(data.menuIconPath, isNull);
    });

    test('both', () {
      TabsAreaThemeData data = TabsAreaThemeData(
          menuIconData: Icons.menu, menuIconPath: TabbedViewIcons.menu);
      expect(data.menuIconData, isNotNull);
      expect(data.menuIconPath, isNotNull);
    });
  });
}
