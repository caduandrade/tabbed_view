import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  runApp(TabbedViewExample());
}

class TabbedViewExample extends StatefulWidget {
  const TabbedViewExample({super.key});

  @override
  TabbedViewExampleState createState() => TabbedViewExampleState();
}

class TabbedViewExampleState extends State<TabbedViewExample> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late TabbedViewController _controller;
  TabBarPosition _position = TabBarPosition.top;
  ThemeName _themeName = ThemeName.underline;
  SideTabsLayout _sideTabsLayout = SideTabsLayout.rotated;
  bool _modifyThemeColors = false;
  bool _maxMainSizeEnabled = false;
  bool _maxLinesEnabled = false;
  bool _trailingWidgetEnabled = false;
  bool _addButtonEnabled = true;
  Brightness _brightness = Brightness.light;

  @override
  void initState() {
    super.initState();
    List<TabData> tabs = [];

    tabs.add(TabData(
        text: 'Tab 1',
        value: 'myTab',
        leading: (context, status) => Icon(Icons.star, size: 16),
        content: Padding(padding: EdgeInsets.all(8), child: Text('Hello')),
        buttonsBuilder: (context) => [
              TabButton.icon(IconProvider.data(Icons.info), onPressed: () {
                _scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Info button clicked!')));
              })
            ]));
    tabs.add(TabData(
        text: 'Tab 2',
        buttonsBuilder: (context) => [
              TabButton.menu((context) {
                return [
                  TabbedViewMenuItem(
                      text: 'Menu item 1',
                      onSelection: () => _scaffoldMessengerKey.currentState
                          ?.showSnackBar(
                              const SnackBar(content: Text('Menu item 1')))),
                  TabbedViewMenuItem(
                      text: 'Menu item 2',
                      onSelection: () => _scaffoldMessengerKey.currentState
                          ?.showSnackBar(
                              const SnackBar(content: Text('Menu item 2'))))
                ];
              })
            ],
        content:
            Padding(padding: EdgeInsets.all(8), child: Text('Hello again'))));
    tabs.add(TabData(
        closable: false,
        text: 'TextField',
        content: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
                decoration: InputDecoration(
                    isDense: true, border: OutlineInputBorder()))),
        keepAlive: true));
    tabs.add(TabData(
        text: 'This is a very long tab title that should be truncated',
        leading: (context, status) => Icon(Icons.star, size: 16),
        content: Padding(
            padding: EdgeInsets.all(8),
            child: Text('Content for the long tab'))));

    _controller = TabbedViewController(
      tabs,
      onTabReorder: (int oldIndex, int newIndex) {},
      onTabSelection: (selection) {},
      onTabRemove: (tabData) {},
    );
  }

  TabbedViewThemeData _getTheme() {
    TabbedViewThemeData theme;
    switch (_themeName) {
      case ThemeName.classic:
        theme = _modifyThemeColors
            ? TabbedViewThemeData.classic(
                brightness: _brightness,
                colorSet: Colors.blueGrey,
                borderColor: Colors.black,
       )
            : TabbedViewThemeData.classic(brightness: _brightness);
        break;
      case ThemeName.minimalist:
        theme = _modifyThemeColors
            ? TabbedViewThemeData.minimalist(
                brightness: _brightness, colorSet: Colors.blueGrey)
            : TabbedViewThemeData.minimalist(brightness: _brightness, tabStyleResolver: MyTabStyleResolver());
        break;
      case ThemeName.underline:
        theme = _modifyThemeColors
            ? TabbedViewThemeData.underline(
                brightness: _brightness,
                colorSet: Colors.brown,
                underlineColorSet: Colors.brown)
            : TabbedViewThemeData.underline(brightness: _brightness);
        break;
      case ThemeName.folder:
        theme = _modifyThemeColors
            ? TabbedViewThemeData.folder(
                brightness: _brightness, colorSet: Colors.brown)
            : TabbedViewThemeData.folder(brightness: _brightness);
        break;
    }
    theme.tabsArea.position = _position;
    theme.tabsArea.sideTabsLayout = _sideTabsLayout;
    if (_maxMainSizeEnabled) {
      theme.tab.maxMainSize = 200;
    }
    if (_maxLinesEnabled) {
      theme.tab.maxLines = 2;
    }
    return theme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: _scaffoldMessengerKey,
        theme: ThemeData(brightness: _brightness),
        home: Scaffold(
            appBar: AppBar(title: Text('TabbedView Example (All properties)')),
            body:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              _buildSettings(),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: TabbedViewTheme(
                          data: _getTheme(), child: _buildTabbedView())))
            ])));
  }

  TabbedView _buildTabbedView() {
    // Configuring the [TabbedView] with all available properties.
    return TabbedView(
        trailing: _trailingWidgetEnabled
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Text('Trailing text'),
              )
            : null,
        controller: _controller,
        onTabSecondaryTap: (index, tabData, details) {
          _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
              content:
                  Text('Right-clicked on tab #$index: "${tabData.text}"')));
        },
        contentBuilder: null,
        tabsAreaButtonsBuilder: _addButtonEnabled
            ? (context, tabsCount) {
                return [
                  TabButton.icon(IconProvider.data(Icons.add), onPressed: () {
                    _controller.addTab(TabData(
                        text: 'New Tab',
                        content: Center(child: Text('Content of New Tab'))));
                  })
                ];
              }
            : null,
        onDraggableBuild: (controller, tabIndex, tab) {
          return DraggableConfig(
            canDrag: true,
            feedback: null,
            feedbackOffset: Offset.zero,
            dragAnchorStrategy: childDragAnchorStrategy,
            onDragStarted: null,
            onDragUpdate: null,
            onDraggableCanceled: null,
            onDragEnd: null,
            onDragCompleted: null,
          );
        },
        tabRemoveInterceptor: (context, index, tabData) {
          if (tabData.text == 'Tab 1') {
            return false;
          }
          return true;
        },
        closeButtonTooltip: 'Close this tab',
        tabsAreaVisible: true,
        contentClip: true,
        dragScope: null,
        unselectedTabButtonsBehavior: UnselectedTabButtonsBehavior.allDisabled);
  }

  void _onBrightnessSelected(Brightness brightness) {
    setState(() {
      _brightness = brightness;
    });
  }

  void _onPositionSelected(TabBarPosition newPosition) {
    setState(() {
      _position = newPosition;
    });
  }

  void _onSideTabsLayoutSelected(SideTabsLayout newLayout) {
    setState(() {
      _sideTabsLayout = newLayout;
    });
  }

  void _onThemeSelected(ThemeName? themeName) {
    if (themeName != null) {
      setState(() {
        _themeName = themeName;
      });
    }
  }

  Widget _buildSettings() {
    return Container(
        decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.grey))),
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Flutter Brightness'),
                      BrightnessChooser(
                          currentBrightness: _brightness,
                          onSelected: _onBrightnessSelected),
                      SizedBox(height: 16),
                      Text('TabBarPosition'),
                      PositionChooser(
                          currentPosition: _position,
                          onSelected: _onPositionSelected),
                      SizedBox(height: 16),
                      Text('SideTabsLayout'),
                      SideTabsLayoutChooser(
                        currentLayout: _sideTabsLayout,
                        onSelected: _onSideTabsLayoutSelected,
                        currentPosition: _position,
                      ),
                      SizedBox(height: 16),
                      Text('Theme'),
                      ThemeChooser(
                          currentTheme: _themeName,
                          onSelected: _onThemeSelected),
                      SizedBox(height: 16),
                      _buildTrailingWidgetSelector(),
                      _buildModifyThemeColorsSelector(),
                      _buildMaxMainSizeSelector(),
                      _buildMaxLinesSelector(),
                      _buildAddButtonSelector(),
                      ElevatedButton(
                          onPressed: () => _controller.removeTabs(),
                          child: Text('Remove tabs'))
                    ]))));
  }

  Widget _buildModifyThemeColorsSelector() {
    return _buildSelector(
        value: _modifyThemeColors,
        text: 'Modify theme colors',
        setter: (v) => _modifyThemeColors = v);
  }

  Widget _buildTrailingWidgetSelector() {
    return _buildSelector(
        value: _trailingWidgetEnabled,
        text: 'Trailing widget',
        setter: (v) => _trailingWidgetEnabled = v);
  }

  Widget _buildMaxMainSizeSelector() {
    return _buildSelector(
        value: _maxMainSizeEnabled,
        text: 'Max tab main size',
        setter: (v) => _maxMainSizeEnabled = v);
  }

  Widget _buildMaxLinesSelector() {
    return _buildSelector(
        value: _maxLinesEnabled,
        text: 'Max tab lines',
        setter: (v) => _maxLinesEnabled = v);
  }

  Widget _buildAddButtonSelector() {
    return _buildSelector(
        value: _addButtonEnabled,
        text: 'Add button',
        setter: (v) => _addButtonEnabled = v);
  }

  Widget _buildSelector(
      {required bool value,
      required String text,
      required Function(bool value) setter}) {
    return Row(children: [
      Checkbox(
          value: value,
          onChanged: (v) {
            if (v != null) {
              setState(() {
                setter(v);
              });
            }
          }),
      Text(text)
    ]);
  }
}

class PositionChooser extends StatelessWidget {
  const PositionChooser(
      {super.key, required this.currentPosition, required this.onSelected});

  final TabBarPosition currentPosition;
  final Function(TabBarPosition newPosition) onSelected;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = TabBarPosition.values.map<Widget>((value) {
      return ChoiceChip(
          label: Text(value.name),
          selected: currentPosition == value,
          onSelected: (selected) => onSelected(value));
    }).toList();

    return Wrap(spacing: 8, runSpacing: 4, children: children);
  }
}

class SideTabsLayoutChooser extends StatelessWidget {
  const SideTabsLayoutChooser(
      {super.key,
      required this.currentLayout,
      required this.onSelected,
      required this.currentPosition});

  final SideTabsLayout currentLayout;
  final TabBarPosition currentPosition;
  final Function(SideTabsLayout newLayout) onSelected;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = SideTabsLayout.values.map<Widget>((value) {
      return ChoiceChip(
          label: Text(value.name),
          selected: currentLayout == value,
          onSelected: currentPosition.isVertical
              ? (selected) => onSelected(value)
              : null);
    }).toList();

    return Wrap(spacing: 8, runSpacing: 4, children: children);
  }
}

enum ThemeName { classic, underline, minimalist, folder }

class ThemeChooser extends StatelessWidget {
  const ThemeChooser(
      {super.key, required this.currentTheme, required this.onSelected});

  final ThemeName currentTheme;
  final Function(ThemeName themeName) onSelected;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = ThemeName.values.map<Widget>((value) {
      return ChoiceChip(
          label: Text(value.name),
          selected: currentTheme == value,
          onSelected: (selected) => onSelected(value));
    }).toList();

    return Wrap(spacing: 8, runSpacing: 4, children: children);
  }
}

class BrightnessChooser extends StatelessWidget {
  const BrightnessChooser(
      {super.key, required this.currentBrightness, required this.onSelected});

  final Brightness currentBrightness;
  final Function(Brightness brightness) onSelected;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = Brightness.values.map<Widget>((value) {
      return ChoiceChip(
          label: Text(value.name),
          selected: currentBrightness == value,
          onSelected: (selected) => onSelected(value));
    }).toList();

    return Wrap(spacing: 8, runSpacing: 4, children: children);
  }
}

void das() {
  TabbedViewController controller =
      TabbedViewController([TabData(text: 'MyTab', value: 'myTab')]);

  TabbedViewTheme(
    data: TabbedViewThemeData.classic(
      tabStyleResolver: MyTabStyleResolver(),
    ),
    child: TabbedView(controller: controller),
  );
}

class MyTabStyleResolver extends MinimalistTabStyleResolver {

  @override
  Color? backgroundColor(TabStyleContext context) {
    if(context.index==1) {
      if(context.status==TabStatus.selected) {
        return Colors.green.shade900;
      }
      if(context.status==TabStatus.hovered) {
        return Colors.green.shade200;
      }
    }
    return null;
  }

  @override
  Color? fontColor(TabStyleContext context) {
    if (context.tab.value == 'myTab') {
      switch (context.status) {
        case TabStatus.selected:
          return Colors.green.shade700;
        case TabStatus.hovered:
          return Colors.green.shade400;
        case TabStatus.normal:
          return Colors.green.shade200;
      }
    }
    // default theme color
    return null;
  }
}
