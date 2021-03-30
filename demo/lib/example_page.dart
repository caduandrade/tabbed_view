import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

abstract class ExamplePageState extends State<StatefulWidget> {
  late MultiSplitViewController _horizontalController;
  late MultiSplitViewController _verticalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = MultiSplitViewController(weights: [.1, .8, .1]);
    _verticalController = MultiSplitViewController(weights: [.1, .8, .1]);
  }

  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = Scaffold(body: Center(child: buildContent()));

    MaterialApp materialApp = MaterialApp(
        theme: buildThemeData(),
        debugShowCheckedModeBanner: false,
        home: scaffold);

    MultiSplitView horizontal = MultiSplitView(
        dividerThickness: 20,
        children: [_buildEmptyArea(), materialApp, _buildEmptyArea()],
        minimalWeight: .1,
        controller: _horizontalController);

    MultiSplitView vertical = MultiSplitView(
        axis: Axis.vertical,
        dividerThickness: 20,
        children: [_buildEmptyArea(), horizontal, _buildEmptyArea()],
        minimalWeight: .1,
        controller: _verticalController);

    SizedBox sizedBox = SizedBox(child: vertical, width: 800, height: 600);
    Center center = Center(child: sizedBox);

    Row row = Row(
        children: [Expanded(child: center), _buildExampleWidgetsContainer()]);
    return Container(child: row, color: Colors.white);
  }

  Widget _buildExampleWidgetsContainer() {
    List<Widget> children = buildExampleWidgets();
    if (children.isEmpty) {
      return Container();
    }
    Widget column = Wrap(
        direction: Axis.vertical, // make sure to set this
        spacing: 8,
        children: buildExampleWidgets());
    Container container = Container(
        child: column,
        color: Colors.grey[100],
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16));
    return SingleChildScrollView(child: container);
  }

  List<Widget> buildExampleWidgets() {
    return [];
  }

  Widget _buildEmptyArea() {
    return Container(color: Colors.white);
  }

  ThemeData? buildThemeData() {
    return null;
  }

  Widget buildContent();
}
