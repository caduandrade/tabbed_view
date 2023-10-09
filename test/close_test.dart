import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';

void main() {
  group('controller', () {
    test('close - selectedIndex', () {
      TabbedViewController controller =
          TabbedViewController([TabData(text: 'a'), TabData(text: 'b')]);

      expect(controller.selectedIndex, 0);

      controller.selectedIndex = 1;
      expect(controller.selectedIndex, 1);

      controller.removeTab(1);
      expect(controller.selectedIndex, 0);

      controller.removeTab(0);
      expect(controller.selectedIndex, null);
    });
  });
}
