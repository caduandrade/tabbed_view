import 'package:demo/add_tab_page.dart';
import 'package:demo/content_builder_page.dart';
import 'package:demo/custom_light_theme_page.dart';
import 'package:demo/new_model_page.dart';
import 'package:demo/simple_page.dart';
import 'package:flutter/material.dart';
import 'change_tab_page.dart';
import 'dark_page.dart';

void main() {
  runApp(TabbedViewDemoApp());
}

class Example {
  const Example(this.name);

  static const Example simple = const Example('Simple');
  static const Example content_builder = const Example('Content builder');
  static const Example dark_theme = const Example('Dark');
  static const Example new_model = const Example('New model');
  static const Example change_tab = const Example('Change tab');
  static const Example add_tab = const Example('Add tab');
  static const Example custom_light_theme = const Example('Custom light theme');

  static const List<Example> values = [
    Example.simple,
    Example.content_builder,
    Example.dark_theme,
    Example.new_model,
    Example.change_tab,
    Example.add_tab,
    Example.custom_light_theme
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
    } else if (_currentExample == Example.dark_theme) {
      example = DarkPage();
    } else if (_currentExample == Example.new_model) {
      example = NewModelPage();
    } else if (_currentExample == Example.change_tab) {
      example = ChangeTabPage();
    } else if (_currentExample == Example.add_tab) {
      example = AddTabPage();
    } else if (_currentExample == Example.custom_light_theme) {
      example = CustomLightThemePage();
    } else {
      example = Center(child: Text(_currentExample.name + ' ?'));
    }
    return example;
  }
}
