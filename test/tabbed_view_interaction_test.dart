import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/src/tab_button_widget.dart';
import 'package:tabbed_view/src/tab_widget.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  group('TabbedView User Interaction', () {
    late TabbedViewController controller;
    TabData? onSelectionTabData;
    TabData? onSecondaryTapTabData;
    TabData? onTabCloseTabData;
    bool closeInterceptorCalled = false;

    setUp(() {
      controller = TabbedViewController([
        TabData(text: 'Tab 1'),
        TabData(text: 'Tab 2'),
      ]);
      onSelectionTabData = null;
      onSecondaryTapTabData = null;
      onTabCloseTabData = null;
      closeInterceptorCalled = false;
    });

    Widget _buildTestApp() {
      return MaterialApp(
        home: Scaffold(
          body: TabbedView(
            controller: controller,
            onTabSelection: (tabData) => onSelectionTabData = tabData,
            onTabSecondaryTap: (index, tabData, details) =>
                onSecondaryTapTabData = tabData,
            onTabClose: (index, tabData) => onTabCloseTabData = tabData,
            tabCloseInterceptor: (index, tabData) {
              closeInterceptorCalled = true;
              // Prevent closing the first tab
              return index != 0;
            },
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

    testWidgets('tabCloseInterceptor prevents tab from closing',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestApp());

      // Find the close button for the first tab and tap it
      final closeButton = find.descendant(
          of: find.byWidgetPredicate((w) => w is TabWidget && w.index == 0),
          matching: find.byType(TabButtonWidget));

      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      // Verify the interceptor was called and the tab was not closed
      expect(closeInterceptorCalled, isTrue);
      expect(controller.length, 2);
      expect(onTabCloseTabData, isNull);
    });
  });
}
