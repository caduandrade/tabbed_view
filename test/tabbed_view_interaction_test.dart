import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/src/internal/tab/tab_button_widget.dart';
import 'package:tabbed_view/src/internal/tab/tab_widget.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  group('TabbedView User Interaction', () {
    late TabbedViewController controller;
    TabData? onSelectionTabData;
    TabData? onSecondaryTapTabData;
    TabData? onTabCloseTabData;
    bool removeInterceptorCalled = false;

    setUp(() {
      controller = TabbedViewController(
        [
          TabData(id: 1, text: 'Tab 1'),
          TabData(id: 2, text: 'Tab 2'),
        ],
        onTabRemove: (tabData) => onTabCloseTabData = tabData,
        onTabSelected: (selection) => onSelectionTabData = selection?.tab,
      );
      onSelectionTabData = null;
      onSecondaryTapTabData = null;
      onTabCloseTabData = null;
      removeInterceptorCalled = false;
    });

    Widget _buildTestApp() {
      return MaterialApp(
        home: Scaffold(
          body: TabbedView(
            controller: controller,
            tabRemoveInterceptor: (context, index, tabData) {
              removeInterceptorCalled = true;
              // Prevent closing the first tab
              return index != 0;
            },
            onTabSecondaryTap: (index, tabData, details) =>
                onSecondaryTapTabData = tabData,
          ),
        ),
      );
    }

    testWidgets('onTabSelection is called when a tab is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestApp());

      // Tap the second tab
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(controller.selectedIndex, 1);
      expect(onSelectionTabData, isNotNull);
      expect(onSelectionTabData?.text, 'Tab 2');
    });

    testWidgets('onTabSecondaryTap is called on right-click',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestApp());

      // Right-click the first tab
      await tester.tap(find.text('Tab 1'), buttons: kSecondaryButton);
      await tester.pumpAndSettle();

      expect(onSecondaryTapTabData, isNotNull);
      expect(onSecondaryTapTabData?.text, 'Tab 1');
    });

    testWidgets('tabRemoveInterceptor prevents tab from closing',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestApp());

      // Find the close button for the first tab and tap it
      final closeButton = find.descendant(
          of: find.byWidgetPredicate((w) => w is TabWidget && w.index == 0),
          matching: find.byType(TabButtonWidget));

      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      // Verify the interceptor was called and the tab was not closed
      expect(removeInterceptorCalled, isTrue);
      expect(controller.length, 2);
      expect(onTabCloseTabData, isNull);
    });
  });
}
