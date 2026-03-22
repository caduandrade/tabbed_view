import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/src/internal/view_area.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:tabbed_view/src/internal/tab/tab_widget.dart';

void main() {
  group('TabbedView Theming for different TabBarPosition', () {
    late TabbedViewController controller;

    setUp(() {
      controller = TabbedViewController([
        TabData(id: 1, text: 'Tab 1'),
        TabData(id: 2, text: 'Tab 2'),
      ]);
    });

    Widget _buildTestApp(
        {required TabbedViewThemeData theme,
        required TabBarPosition position}) {
      theme.tabsArea.position = position;
      return MaterialApp(
        home: Scaffold(
          body: TabbedViewTheme(
            data: theme,
            child: TabbedView(
              controller: controller,
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

        final contentArea = find.byType(ViewArea);
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

        final contentArea = find.byType(ViewArea);
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

        final decoratedBoxes = find.descendant(
          of: selectedTab,
          matching: find.byType(DecoratedBox),
        );
        expect(decoratedBoxes, findsWidgets);
        final widget = tester.widget<DecoratedBox>(decoratedBoxes.first);
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

        final decoratedBoxes = find.descendant(
          of: selectedTab,
          matching: find.byType(DecoratedBox),
        );
        expect(decoratedBoxes, findsWidgets);
        final widget = tester.widget<DecoratedBox>(decoratedBoxes.first);
        final decoration = widget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        // For left position, the selected tab should be open on the right
        expect(border.right, equals(BorderSide.none));
        expect(border.top, isNot(equals(BorderSide.none)));
        expect(border.left, isNot(equals(BorderSide.none)));
        expect(border.bottom, isNot(equals(BorderSide.none)));
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

        final decoratedBoxes = find.descendant(
          of: selectedTab,
          matching: find.byType(DecoratedBox),
        );
        expect(decoratedBoxes, findsWidgets);
        final widget = tester.widget<DecoratedBox>(decoratedBoxes.first);
        final decoration = widget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        // For right position, the selected tab should be open on the left
        expect(border.left, equals(BorderSide.none));
        expect(border.top, isNot(equals(BorderSide.none)));
        expect(border.right, isNot(equals(BorderSide.none)));
        expect(border.bottom, isNot(equals(BorderSide.none)));
      });
    });

    group('Underline Theme', () {
      final theme = TabbedViewThemeData.underline(
          colorSet: Colors.blueGrey, underlineColorSet: Colors.blue);

      testWidgets(
          'Selected TabWidget has correct indicator for TabBarPosition.left',
          (WidgetTester tester) async {
        controller.selectedIndex = 0;
        await tester.pumpWidget(
            _buildTestApp(theme: theme, position: TabBarPosition.left));

        final selectedTab = find.byWidgetPredicate((widget) =>
            widget is TabWidget && widget.status == TabStatus.selected);
        expect(selectedTab, findsOneWidget);

        final decoratedBoxes = find.descendant(
          of: selectedTab,
          matching: find.byType(DecoratedBox),
        );
        expect(decoratedBoxes, findsWidgets);
        final widget = tester.widget<DecoratedBox>(decoratedBoxes.last);
        final decoration = widget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        // For left position, indicator is on the right of the un-rotated widget.
        expect(border.right, isNot(equals(BorderSide.none)));
        expect(border.top, equals(BorderSide.none));
        expect(border.left, equals(BorderSide.none));
        expect(border.bottom, equals(BorderSide.none));
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

        final decoratedBoxes = find.descendant(
          of: selectedTab,
          matching: find.byType(DecoratedBox),
        );
        expect(decoratedBoxes, findsWidgets);
        final widget = tester.widget<DecoratedBox>(decoratedBoxes.last);
        final decoration = widget.decoration as BoxDecoration;
        final border = decoration.border as Border;

        // For right position, indicator is on the left of the un-rotated widget.
        expect(border.left, isNot(equals(BorderSide.none)));
        expect(border.top, equals(BorderSide.none));
        expect(border.right, equals(BorderSide.none));
        expect(border.bottom, equals(BorderSide.none));
      });
    });

    group('Trailing Widget', () {
      testWidgets(
          'is present and rotated when TabBarPosition is left by default',
          (WidgetTester tester) async {
        TabbedViewThemeData theme = TabbedViewThemeData.classic();
        theme.tabsArea.position = TabBarPosition.left;
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: TabbedViewTheme(
            data: theme,
            child: TabbedView(
              controller: controller,
              trailing: Text('Trailing'),
            ),
          )),
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
