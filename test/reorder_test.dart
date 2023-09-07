import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/src/tab_data.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';

class Helper {
  Helper() {
    controller = TabbedViewController([
      TabData(text: 'a'),
      TabData(text: 'b'),
      TabData(text: 'c'),
      TabData(text: 'd')
    ], onReorder: _onReorder);
    test(p0: 'a', p1: 'b', p2: 'c', p3: 'd', selected: 'a', reordered: false);
  }

  late final TabbedViewController controller;

  bool _reordered = false;

  void _onReorder(int oldIndex, int newIndex) {
    _reordered = true;
  }

  void test(
      {required String p0,
      required String p1,
      required String p2,
      required String p3,
      required String selected,
      bool reordered = true}) {
    expect(controller.tabs.isEmpty, false);
    expect(controller.tabs.length, 4);
    expect(controller.tabs[0].text, p0);
    expect(controller.tabs[1].text, p1);
    expect(controller.tabs[2].text, p2);
    expect(controller.tabs[3].text, p3);
    expect(controller.selectedTab?.text, selected);
    expect(_reordered, reordered);
  }

  void selectAndTest(
      {required int newSelectedIndex, required String selectedText}) {
    controller.selectedIndex = newSelectedIndex;
    expect(controller.selectedTab?.text, selectedText);
  }
}

void main() {
  group('controller', () {
    test('reorder', () {
      // ignores
      Helper helper = Helper();
      helper.controller.reorderTab(0, 0);
      helper.test(
          p0: 'a', p1: 'b', p2: 'c', p3: 'd', selected: 'a', reordered: false);

      // ignores
      helper = Helper();
      helper.controller.reorderTab(0, 1);
      helper.test(
          p0: 'a', p1: 'b', p2: 'c', p3: 'd', selected: 'a', reordered: false);

      // a,b,c,d => b,a,c,d
      helper = Helper();
      helper.controller.reorderTab(0, 2);
      helper.test(p0: 'b', p1: 'a', p2: 'c', p3: 'd', selected: 'a');
      helper.selectAndTest(newSelectedIndex: 1, selectedText: 'a');

      // a,b,c,d => b,c,a,d
      helper = Helper();
      helper.controller.reorderTab(0, 3);
      helper.test(p0: 'b', p1: 'c', p2: 'a', p3: 'd', selected: 'a');
      helper.selectAndTest(newSelectedIndex: 1, selectedText: 'c');

      // a,b,c,d => b,a,c,d
      helper = Helper();
      helper.controller.reorderTab(1, 0);
      helper.test(p0: 'b', p1: 'a', p2: 'c', p3: 'd', selected: 'a');
      helper.selectAndTest(newSelectedIndex: 1, selectedText: 'a');

      // ignores
      helper = Helper();
      helper.controller.reorderTab(1, 1);
      helper.test(
          p0: 'a', p1: 'b', p2: 'c', p3: 'd', selected: 'a', reordered: false);

      // ignores
      helper = Helper();
      helper.controller.reorderTab(1, 2);
      helper.test(
          p0: 'a', p1: 'b', p2: 'c', p3: 'd', selected: 'a', reordered: false);

      // a,b,c,d => a,c,b,d
      helper = Helper();
      helper.controller.reorderTab(1, 3);
      helper.test(p0: 'a', p1: 'c', p2: 'b', p3: 'd', selected: 'a');
      helper.selectAndTest(newSelectedIndex: 1, selectedText: 'c');

      // a,b,c,d => c,a,b,d
      helper = Helper();
      helper.controller.reorderTab(2, 0);
      helper.test(p0: 'c', p1: 'a', p2: 'b', p3: 'd', selected: 'a');
      helper.selectAndTest(newSelectedIndex: 1, selectedText: 'a');

      // a,b,c,d => a,c,b,d
      helper = Helper();
      helper.controller.reorderTab(2, 1);
      helper.test(p0: 'a', p1: 'c', p2: 'b', p3: 'd', selected: 'a');
      helper.selectAndTest(newSelectedIndex: 1, selectedText: 'c');

      // ignores
      helper = Helper();
      helper.controller.reorderTab(2, 2);
      helper.test(
          p0: 'a', p1: 'b', p2: 'c', p3: 'd', selected: 'a', reordered: false);

      // ignores
      helper = Helper();
      helper.controller.reorderTab(2, 3);
      helper.test(
          p0: 'a', p1: 'b', p2: 'c', p3: 'd', selected: 'a', reordered: false);

      // a,b,c,d => d,a,b,c
      helper = Helper();
      helper.controller.reorderTab(3, 0);
      helper.test(p0: 'd', p1: 'a', p2: 'b', p3: 'c', selected: 'a');
      helper.selectAndTest(newSelectedIndex: 1, selectedText: 'a');

      // a,b,c,d => a,d,b,c
      helper = Helper();
      helper.controller.reorderTab(3, 1);
      helper.test(p0: 'a', p1: 'd', p2: 'b', p3: 'c', selected: 'a');
      helper.selectAndTest(newSelectedIndex: 1, selectedText: 'd');

      // a,b,c,d => a,b,d,c
      helper = Helper();
      helper.controller.reorderTab(3, 2);
      helper.test(p0: 'a', p1: 'b', p2: 'd', p3: 'c', selected: 'a');
      helper.selectAndTest(newSelectedIndex: 1, selectedText: 'b');

      // ignores
      helper = Helper();
      helper.controller.reorderTab(3, 3);
      helper.test(
          p0: 'a', p1: 'b', p2: 'c', p3: 'd', selected: 'a', reordered: false);

      // a,b,c,d => b,c,d,a
      helper = Helper();
      helper.controller.reorderTab(0, 3); //b,c,a,d
      helper.controller.reorderTab(3, 2);
      helper.test(p0: 'b', p1: 'c', p2: 'd', p3: 'a', selected: 'a');
      helper.selectAndTest(newSelectedIndex: 1, selectedText: 'c');

      helper = Helper();
      expect(() => helper.controller.reorderTab(-1, 1), indexOutOfRangeError());
      expect(
          () => helper.controller.reorderTab(-1, 100), indexOutOfRangeError());

      helper = Helper();
      helper.controller.reorderTab(0, 100);
      helper.test(p0: 'b', p1: 'c', p2: 'd', p3: 'a', selected: 'a');

      TabbedViewController controller = TabbedViewController([]);
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
