import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';

void main() {
  group('controller', () {
    test('reorder', () {
      int reorderCount = 0;
      OnReorder onReorder = (int oldIndex, int newIndex) {
        reorderCount++;
      };

      // initial order a,b,c,d
      TabbedViewController controller = TabbedViewController([
        TabData(text: 'a'),
        TabData(text: 'b'),
        TabData(text: 'c'),
        TabData(text: 'd')
      ], onReorder: onReorder);

      expect(false, controller.tabs.isEmpty);
      expect(4, controller.tabs.length);

      expect('a', controller.tabs[0].text);
      expect('b', controller.tabs[1].text);
      expect('c', controller.tabs[2].text);
      expect('d', controller.tabs[3].text);
      expect('a', controller.selectedTab?.text);

      // ignores
      controller.reorderTab(0, 0);
      expect(0, reorderCount);
      expect('a', controller.tabs[0].text);
      expect('b', controller.tabs[1].text);
      expect('c', controller.tabs[2].text);
      expect('d', controller.tabs[3].text);
      expect('a', controller.selectedTab?.text);

      // a,b,c,d => b,a,c,d
      controller.reorderTab(0, 1);
      expect(1, reorderCount);
      expect('b', controller.tabs[0].text);
      expect('a', controller.tabs[1].text);
      expect('c', controller.tabs[2].text);
      expect('d', controller.tabs[3].text);
      expect('a', controller.selectedTab?.text);

      // b,a,c,d => a,b,c,d
      controller.reorderTab(1, 0);
      expect(2, reorderCount);
      expect('a', controller.tabs[0].text);
      expect('b', controller.tabs[1].text);
      expect('c', controller.tabs[2].text);
      expect('d', controller.tabs[3].text);
      expect('a', controller.selectedTab?.text);

      // a,b,c,d => a,c,d,b
      controller.reorderTab(1, 3);
      expect(3, reorderCount);
      expect('a', controller.tabs[0].text);
      expect('c', controller.tabs[1].text);
      expect('d', controller.tabs[2].text);
      expect('b', controller.tabs[3].text);
      expect('a', controller.selectedTab?.text);

      controller.selectedIndex = 1;
      expect('c', controller.selectedTab?.text);

      // a,c,d,b => c,d,b,a
      controller.reorderTab(0, 3);
      expect(4, reorderCount);
      expect('c', controller.tabs[0].text);
      expect('d', controller.tabs[1].text);
      expect('b', controller.tabs[2].text);
      expect('a', controller.tabs[3].text);
      expect('c', controller.selectedTab?.text);

      expect(() => controller.reorderTab(-1, 1), indexOutOfRangeError());
      expect(() => controller.reorderTab(1, 100), indexOutOfRangeError());
      expect(() => controller.reorderTab(-1, 100), indexOutOfRangeError());

      controller = TabbedViewController([]);
      expect(() => controller.reorderTab(1, 2), emptyError());
    });
  });
}

Matcher indexOutOfRangeError() {
  return throwsA(predicate(
      (x) => x is ArgumentError && x.message == 'Index out of range.'));
}

Matcher emptyError() {
  return throwsA(predicate(
      (x) => x is ArgumentError && x.message == 'There are no tabs.'));
}
