import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/src/theme/tabs_area_theme_data.dart';

void main() {
  group('menu icon', () {
    test('default', () {
      TabsAreaThemeData data = TabsAreaThemeData();
      expect(data.menuIcon.iconData, isNull);
      expect(data.menuIcon.iconPath, isNotNull);
    });
  });
}
