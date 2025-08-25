import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/src/content_area.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:tabbed_view/src/tab_widget.dart';

void main() {
  group('TabbedView Theming for different TabBarPosition', () {
    late TabbedViewController controller;

    setUp(() {
      controller = TabbedViewController([
        TabData(text: 'Tab 1'),
        TabData(text: 'Tab 2'),
      ]);
    });

    Widget _buildTestApp(
        {required TabbedViewThemeData theme,
        required TabBarPosition position}) {
      return MaterialApp(
        home: Scaffold(
          body: TabbedViewTheme(
            data: theme,
            child: TabbedView(
              controller: controller,
              tabBarPosition: position,
            ),
          ),
        ),
      );
    }

    group('Classic Theme', () {
      final theme = TabbedViewThemeData.classic(
          colorSet: Colors.blueGrey, borderColor: Colors.black);

      testWidgets('ContentArea has correct border for TabBarPosition.top',
          (WidgetTester tester) async {
        await tester.pumpWidget(
            _buildTestApp(theme: theme, position: TabBarPosition.top));

        final contentArea = find.byType(ContentArea);
        expect(contentArea, findsOneWidget);

        final container = find
            .descendant(of: contentArea, matching: find.byType(Container))
            .first;

        final widget = tester.widget<Container>(container);
        final decoration = widget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.top, equals(BorderSide.none));
        expect(border.bottom, isNot(equals(BorderSide.none)));
        expect(border.left, isNot(equals(BorderSide.none)));
        expect(border.right, isNot(equals(BorderSide.none)));
      });

      testWidgets('ContentArea has correct border for TabBarPosition.bottom',
          (WidgetTester tester) async {
        await tester.pumpWidget(
            _buildTestApp(theme: theme, position: TabBarPosition.bottom));

        final contentArea = find.byType(ContentArea);
        expect(contentArea, findsOneWidget);

        final container = find
            .descendant(of: contentArea, matching: find.byType(Container))
            .first;

        final widget = tester.widget<Container>(container);
        final decoration = widget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.top, isNot(equals(BorderSide.none)));
        expect(border.bottom, equals(BorderSide.none));
        expect(border.left, isNot(equals(BorderSide.none)));
        expect(border.right, isNot(equals(BorderSide.none)));
      });

      testWidgets(
          'Selected TabWidget has correct border for TabBarPosition.top',
          (WidgetTester tester) async {
        controller.selectedIndex = 0;
        await tester.pumpWidget(
            _buildTestApp(theme: theme, position: TabBarPosition.top));

        final selectedTab = find.byWidgetPredicate((widget) =>
            widget is TabWidget && widget.status == TabStatus.selected);
        expect(selectedTab, findsOneWidget);

        // Find the outer container of the TabWidget which has the frame border
        final container = find
            .descendant(
                of: selectedTab,
                matching: find.byWidgetPredicate(
                    (w) => w is Container && w.margin != null))
            .first;

        final widget = tester.widget<Container>(container);
        final decoration = widget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        // For top position, the selected tab should be open on the bottom
        expect(border.bottom, equals(BorderSide.none));
        expect(border.top, isNot(equals(BorderSide.none)));
        expect(border.left, isNot(equals(BorderSide.none)));
        expect(border.right, isNot(equals(BorderSide.none)));
      });

      testWidgets(
          'Selected TabWidget has correct border for TabBarPosition.left',
          (WidgetTester tester) async {
        controller.selectedIndex = 0;
        await tester.pumpWidget(
            _buildTestApp(theme: theme, position: TabBarPosition.left));

        final selectedTab = find.byWidgetPredicate((widget) =>
            widget is TabWidget && widget.status == TabStatus.selected);
        expect(selectedTab, findsOneWidget);

        final container = find
            .descendant(
                of: selectedTab,
                matching: find.byWidgetPredicate(
                    (w) => w is Container && w.margin != null))
            .first;

        final widget = tester.widget<Container>(container);
        final decoration = widget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        // For left position, the tab is rotated. The "open" side should be
        // the bottom of the un-rotated widget, which becomes the right side.
        expect(border.bottom, equals(BorderSide.none));
        expect(border.top, isNot(equals(BorderSide.none)));
        expect(border.left, isNot(equals(BorderSide.none)));
        expect(border.right, isNot(equals(BorderSide.none)));
      });

      testWidgets(
          'Selected TabWidget has correct border for TabBarPosition.right',
          (WidgetTester tester) async {
        controller.selectedIndex = 0;
        await tester.pumpWidget(
            _buildTestApp(theme: theme, position: TabBarPosition.right));

        final selectedTab = find.byWidgetPredicate((widget) =>
            widget is TabWidget && widget.status == TabStatus.selected);
        expect(selectedTab, findsOneWidget);

        final container = find
            .descendant(
                of: selectedTab,
                matching: find.byWidgetPredicate(
                    (w) => w is Container && w.margin != null))
            .first;

        final widget = tester.widget<Container>(container);
        final decoration = widget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.bottom, equals(BorderSide.none));
        expect(border.top, isNot(equals(BorderSide.none)));
        expect(border.left, isNot(equals(BorderSide.none)));
        expect(border.right, isNot(equals(BorderSide.none)));
      });
    });

    group('Mobile Theme', () {
      final theme = TabbedViewThemeData.mobile(
          colorSet: Colors.blueGrey, accentColor: Colors.blue);

      testWidgets(
          'Selected TabWidget has correct indicator for TabBarPosition.left',
          (WidgetTester tester) async {
        controller.selectedIndex = 0;
        await tester.pumpWidget(
            _buildTestApp(theme: theme, position: TabBarPosition.left));

        final selectedTab = find.byWidgetPredicate((widget) =>
            widget is TabWidget && widget.status == TabStatus.selected);
        expect(selectedTab, findsOneWidget);

        // Find the inner container that holds the indicator border
        final indicatorContainer = find.descendant(
            of: selectedTab,
            matching: find.byWidgetPredicate((w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).border != null &&
                w.padding != null));

        final widget = tester.widget<Container>(indicatorContainer.first);
        final decoration = widget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        // For left position, indicator is on the bottom of the un-rotated widget.
        expect(border.bottom, isNot(equals(BorderSide.none)));
        expect(border.top, equals(BorderSide.none));
        expect(border.left, equals(BorderSide.none));
        expect(border.right, equals(BorderSide.none));
      });

      testWidgets(
          'Selected TabWidget has correct indicator for TabBarPosition.right',
          (WidgetTester tester) async {
        controller.selectedIndex = 0;
        await tester.pumpWidget(
            _buildTestApp(theme: theme, position: TabBarPosition.right));

        final selectedTab = find.byWidgetPredicate((widget) =>
            widget is TabWidget && widget.status == TabStatus.selected);
        expect(selectedTab, findsOneWidget);

        // Find the inner container that holds the indicator border
        final indicatorContainer = find.descendant(
            of: selectedTab,
            matching: find.byWidgetPredicate((w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).border != null &&
                w.padding != null));

        final widget = tester.widget<Container>(indicatorContainer.first);
        final decoration = widget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        // For right position, indicator is on the bottom of the un-rotated widget.
        expect(border.bottom, isNot(equals(BorderSide.none)));
        expect(border.top, equals(BorderSide.none));
        expect(border.left, equals(BorderSide.none));
        expect(border.right, equals(BorderSide.none));
      });
    });

    group('Trailing Widget', () {
      testWidgets(
          'is present and not rotated when TabBarPosition is left by default',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: TabbedView(
              controller: controller,
              tabBarPosition: TabBarPosition.left,
              trailing: Text('Trailing'),
            ),
          ),
        ));

        final trailingFinder = find.text('Trailing');
        expect(trailingFinder, findsOneWidget);

        final rotatedBoxFinder = find.ancestor(
            of: trailingFinder, matching: find.byType(RotatedBox));
        expect(rotatedBoxFinder, findsNothing);
      });

      testWidgets(
          'is present and rotated when TabBarPosition is left and theme enables it',
          (WidgetTester tester) async {
        final theme = TabbedViewThemeData.classic();
        theme.tab.rotateCaptionsInVerticalTabs = true;

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: TabbedViewTheme(
              data: theme,
              child: TabbedView(
                controller: controller,
                tabBarPosition: TabBarPosition.left,
                trailing: Text('Trailing'),
              ),
            ),
          ),
        ));

        final trailingFinder = find.text('Trailing');
        expect(trailingFinder, findsOneWidget);

        final rotatedBoxFinder = find.ancestor(
            of: trailingFinder, matching: find.byType(RotatedBox));
        expect(rotatedBoxFinder, findsOneWidget);
      });
    });
  });
}
