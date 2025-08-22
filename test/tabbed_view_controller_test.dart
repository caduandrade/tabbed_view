import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  group('TabbedViewController', () {
    late TabbedViewController controller;
    final tabs = [
      TabData(text: 'Tab 1', value: 'value1'),
      TabData(text: 'Tab 2', value: 'value2'),
      TabData(text: 'Tab 3', value: 'value3', closable: false),
      TabData(text: 'Tab 4', value: 'value4'),
    ];

    setUp(() {
      // Using List.from to create a new list for each test,
      // as the controller modifies the list in place.
      controller = TabbedViewController(List.from(tabs));
    });

    test('selectTabByValue selects the correct tab', () {
      // The controller selects the first tab by default.
      expect(controller.selectedIndex, 0);
      controller.selectTabByValue('value2');
      expect(controller.selectedIndex, 1);
      expect(controller.selectedTab?.value, 'value2');
    });

    test('selectTab selects the correct tab', () {
      // The controller selects the first tab by default.
      expect(controller.selectedIndex, 0);
      final tabToSelect = controller.tabs[1];
      controller.selectTab(tabToSelect);
      expect(controller.selectedIndex, 1);
      expect(controller.selectedTab, same(tabToSelect));
    });

    test('getTabByValue returns correct tab or null', () {
      final tab = controller.getTabByValue('value3');
      expect(tab, isNotNull);
      expect(tab?.text, 'Tab 3');

      final nullTab = controller.getTabByValue('nonexistent');
      expect(nullTab, isNull);
    });

    test('removeTab updates selectedIndex correctly when closing selected tab',
        () {
      controller.selectedIndex = 1; // Select 'Tab 2'
      controller.removeTab(1);
      expect(controller.length, 3);
      expect(controller.selectedIndex, 1); // Should select the next tab ('Tab 3')
    });

    test('removeTab updates selectedIndex correctly when closing tab before selected', () {
      controller.selectedIndex = 1; // Select 'Tab 2'
      controller.removeTab(0); // Close 'Tab 1'
      expect(controller.selectedIndex, 0); // Selection should shift left
    });

    test('closeOtherTabs closes all but the specified tab', () async {
      expect(controller.length, 4);
      await controller.closeOtherTabs(1); // Close all tabs except 'Tab 2'
      // Tab 2 and the non-closable Tab 3 should remain.
      expect(controller.length, 2);
      expect(controller.tabs[0].text, 'Tab 2');
      expect(controller.tabs[1].text, 'Tab 3');
    });

    test('closeTabsToTheRight closes correct tabs', () async {
      expect(controller.length, 4);
      await controller.closeTabsToTheRight(0); // Close all tabs to the right of 'Tab 1'
      // Tab 1 and the non-closable Tab 3 should remain.
      expect(controller.length, 2);
      expect(controller.tabs[0].text, 'Tab 1');
      expect(controller.tabs[1].text, 'Tab 3');
    });
  });
}