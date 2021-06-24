import 'package:demo/add_tab_page.dart';
import 'package:demo/change_tab_page.dart';
import 'package:demo/classic_theme_page.dart';
import 'package:demo/close_button_tooltip_page.dart';
import 'package:demo/content_builder_page.dart';
import 'package:demo/custom_menu.dart';
import 'package:demo/dark_theme_page.dart';
import 'package:demo/draggable_tab_page.dart';
import 'package:demo/from_the_scratch_page.dart';
import 'package:demo/hidden_tabs_menu_button_icon_page.dart';
import 'package:demo/tab_close_listener_page.dart';
import 'package:demo/tab_selection_listener_page.dart';
import 'package:demo/tabs_area_buttons_page.dart';
import 'package:demo/tabs_area_theme_page.dart';
import 'package:demo/custom_tab.dart';
import 'package:demo/minimalist_theme_page.dart';
import 'package:demo/mobile_theme_page.dart';
import 'package:demo/new_model_page.dart';
import 'package:demo/simple_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TabbedViewDemoApp());
}

class Example {
  const Example(this.name);

  static const Example simple = const Example('Simple');
  static const Example content_builder = const Example('Content builder');
  static const Example dark_theme = const Example('Dark theme');
  static const Example classic_theme = const Example('Classic theme');
  static const Example mobile_theme = const Example('Mobile theme');
  static const Example minimalist_theme = const Example('Minimalist theme');
  static const Example new_model = const Example('New model');
  static const Example change_tab = const Example('Change tab');
  static const Example add_tab = const Example('Add tab');
  static const Example draggable_tab = const Example('Draggable tab');
  static const Example tabs_area_theme = const Example('Tabs area theme');
  static const Example custom_tab = const Example('Custom tab');
  static const Example custom_menu = const Example('Custom menu');
  static const Example from_the_scratch = const Example('From the scratch');
  static const Example tab_close_listener = const Example('Tab close listener');
  static const Example tabs_area_buttons = const Example('Tabs area buttons');
  static const Example tab_selection_listener =
      const Example('Tab selection listener');
  static const Example close_button_tooltip =
      const Example('Close button tooltip');
  static const Example hidden_tabs_menu_button_icon =
      const Example('Hidden tabs menu button icon');

  static const List<Example> values = [
    Example.simple,
    Example.content_builder,
    Example.tabs_area_buttons,
    Example.dark_theme,
    Example.classic_theme,
    Example.new_model,
    Example.change_tab,
    Example.add_tab,
    Example.draggable_tab,
    Example.tabs_area_theme,
    Example.mobile_theme,
    Example.minimalist_theme,
    Example.custom_tab,
    Example.custom_menu,
    Example.from_the_scratch,
    Example.tab_close_listener,
    Example.tab_selection_listener,
    Example.close_button_tooltip,
    Example.hidden_tabs_menu_button_icon
  ];

  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Example &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class TabbedViewDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TabbedView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabbedViewDemoPage(),
    );
  }
}

class TabbedViewDemoPage extends StatefulWidget {
  @override
  _TabbedViewDemoPageState createState() => _TabbedViewDemoPageState();
}

class _TabbedViewDemoPageState extends State<TabbedViewDemoPage> {
  Example _currentExample = Example.simple;

  @override
  Widget build(BuildContext context) {
    Widget exampleMenus = _buildExamplesMenu(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('TabbedView Demo'),
        ),
        body: Row(
            children: [exampleMenus, Expanded(child: _buildExample())],
            crossAxisAlignment: CrossAxisAlignment.stretch));
  }

  Widget _buildExamplesMenu(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Widget> children = [];
    for (Example example in Example.values) {
      children.add(Container(
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentExample = example;
                });
              },
              child: Text(example.name)),
          padding: EdgeInsets.only(bottom: 8)));
    }
    Column column = Column(
        children: children, crossAxisAlignment: CrossAxisAlignment.start);
    SingleChildScrollView scrollView = SingleChildScrollView(child: column);
    return Container(
        child: scrollView,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(width: 5, color: theme.primaryColor))));
  }

  Widget _buildExample() {
    Widget example;
    if (_currentExample == Example.simple) {
      example = SimplePage();
    } else if (_currentExample == Example.content_builder) {
      example = ContentBuilderPage();
    } else if (_currentExample == Example.tabs_area_buttons) {
      example = TabsAreaButtonsPage();
    } else if (_currentExample == Example.dark_theme) {
      example = DarkThemePage();
    } else if (_currentExample == Example.classic_theme) {
      example = ClassicThemePage();
    } else if (_currentExample == Example.new_model) {
      example = NewModelPage();
    } else if (_currentExample == Example.change_tab) {
      example = ChangeTabPage();
    } else if (_currentExample == Example.add_tab) {
      example = AddTabPage();
    } else if (_currentExample == Example.draggable_tab) {
      example = DraggableTabPage();
    } else if (_currentExample == Example.tabs_area_theme) {
      example = TabsAreaThemePage();
    } else if (_currentExample == Example.mobile_theme) {
      example = MobileThemePage();
    } else if (_currentExample == Example.minimalist_theme) {
      example = MinimalistThemePage();
    } else if (_currentExample == Example.custom_tab) {
      example = CustomTabPage();
    } else if (_currentExample == Example.custom_menu) {
      example = CustomMenuPage();
    } else if (_currentExample == Example.from_the_scratch) {
      example = FromTheScratchPage();
    } else if (_currentExample == Example.tab_close_listener) {
      example = TabCloseListenerPage();
    } else if (_currentExample == Example.tab_selection_listener) {
      example = TabSelectionListenerPage();
    } else if (_currentExample == Example.close_button_tooltip) {
      example = CloseButtonTooltipPage();
    } else if (_currentExample == Example.hidden_tabs_menu_button_icon) {
      example = HiddenTabsMenuButtonIconPage();
    } else {
      example = Center(child: Text(_currentExample.name + ' ?'));
    }
    return example;
  }
}
