import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  runApp(TabbedViewExample());
}

class TabbedViewExample extends StatelessWidget {
  const TabbedViewExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: TabbedViewExamplePage());
  }
}

class TabbedViewExamplePage extends StatefulWidget {
  const TabbedViewExamplePage({Key? key}) : super(key: key);

  @override
  TabbedViewExamplePageState createState() => TabbedViewExamplePageState();
}

class TabbedViewExamplePageState extends State<TabbedViewExamplePage> {
  late TabbedViewController _controller;
  TabBarPosition _position = TabBarPosition.top;
  String _themeName = 'mobile';
  bool _useStackedLayout = true;

  @override
  void initState() {
    super.initState();
    List<TabData> tabs = [];

    tabs.add(TabData(
      text: 'Tab 1',
      leading: (context, status) => Icon(Icons.star, size: 16),
      content: Padding(padding: EdgeInsets.all(8), child: Text('Hello')),
      // All TabData properties with default values or examples
      buttons: [
        TabButton(
            icon: IconProvider.data(Icons.info),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Info button clicked!')));
            })
      ],
      closable: true,
      keepAlive: false,
      draggable: true,
      value: null,
      textSize: null,
    ));
    tabs.add(TabData(
        text: 'Tab 2',
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
        content: Padding(
            padding: EdgeInsets.all(8),
            child: Text('Content for the long tab'))));

    _controller = TabbedViewController(tabs);
  }

  TabbedViewThemeData _getTheme() {
    switch (_themeName) {
      case 'classic':
        return TabbedViewThemeData.classic(
            colorSet: Colors.blueGrey, borderColor: Colors.black);
      case 'dark':
        return TabbedViewThemeData.dark(colorSet: Colors.grey, fontSize: 13);
      case 'minimalist':
        return TabbedViewThemeData.minimalist(colorSet: Colors.blueGrey);
      case 'mobile':
      default:
        return TabbedViewThemeData.mobile(
            colorSet: Colors.blueGrey, accentColor: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget trailingWidget = Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Text('Trailing text'),
    );

    // Configuring the [TabbedView] with all available properties.
    TabbedView tabbedView = TabbedView(
      trailing: trailingWidget,
      controller: _controller,
      onTabSecondaryTap: (index, tabData, details) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Right-clicked on tab #$index: "${tabData.text}"')));
      },
      tabBarPosition: _position,
      contentBuilder: null,
      onTabSelection: (tabData) {},
      onTabClose: (index, tabData) {},
      tabCloseInterceptor: (index, tabData) {
        if (tabData.text == 'Tab 1') {
          return false;
        }
        return true;
      },
      tabSelectInterceptor: (newIndex) {
        return true;
      },
      tabsAreaButtonsBuilder: (context, tabsCount) {
        return [
          TabButton(
              icon: IconProvider.data(Icons.add),
              onPressed: () {
                _controller.addTab(TabData(
                    text: 'New Tab',
                    content: Center(child: Text('Content of New Tab'))));
              })
        ];
      },
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
      hiddenTabsMenuItemBuilder: (context, tabIndex, tabData) {
        // Example of a custom menu item.
        // The default menu item is in:
        // lib/src/internal/tabs_area/hidden_tabs_menu_widget.dart
        final theme = TabbedViewTheme.of(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textStyle =
            isDark ? theme.menu.textStyleDark : theme.menu.textStyle;
        return Padding(
          padding: theme.menu.menuItemPadding,
          child: Row(
            children: [
              Icon(Icons.tab, size: 16, color: textStyle?.color),
              SizedBox(width: 8),
              Expanded(
                child: Text('${tabData.text} (index $tabIndex)',
                    style: textStyle, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        );
      },
      closeButtonTooltip: 'Close this tab',
      tabsAreaVisible: true,
      contentClip: true,
      dragScope: null,
    );

    TabbedViewThemeData themeData = _getTheme();
    // Customizing the theme.
    // The `copyWith` method allows you to customize the theme from a predefined one.
    themeData = themeData.copyWith(
        tab: themeData.tab.copyWith(
            verticalLayoutStyle: _useStackedLayout
                ? VerticalTabLayoutStyle.stacked
                : VerticalTabLayoutStyle.inline,
            rotateCaptionsInVerticalTabs: _useStackedLayout,
            showCloseIconWhenNotFocused: true,
            maxWidth: 200,
            maxTextWidth: 100,
            // Making the close button visible on unfocused tabs by using the
            // same colors as the selected tab's buttons.
            // The button color is derived from the selected tab's font color,
            // which acts as an accent. Use a default color if fontColor is null.
            normalButtonColor:
                themeData.tab.selectedStatus.fontColor ?? Colors.black,
            // Use a slightly modified color for the hover state for visual feedback.
            hoverButtonColor:
                (themeData.tab.selectedStatus.fontColor ?? Colors.black)
                    .withAlpha(200)));

    Widget example = Column(children: [
      _buildButtons(),
      SizedBox(height: 10),
      Expanded(child: TabbedViewTheme(data: themeData, child: tabbedView))
    ]);

    return Scaffold(
        appBar: AppBar(title: Text('TabbedView Example (All properties)')),
        body: Container(padding: EdgeInsets.all(10), child: example));
  }

  Widget _buildButtons() {
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildPositionButtons(), _buildThemeButtons()]),
      _buildOptionCheckboxes()
    ]);
  }

  Widget _buildOptionCheckboxes() {
    return Row(children: [
      Checkbox(
          value: _useStackedLayout,
          onChanged: (value) => setState(() => _useStackedLayout = value!)),
      Text('Use stacked layout for vertical tabs')
    ]);
  }

  Widget _buildPositionButtons() {
    return Wrap(spacing: 8, runSpacing: 4, children: [
      ChoiceChip(
        label: Text('Top'),
        selected: _position == TabBarPosition.top,
        onSelected: (selected) =>
            setState(() => _position = TabBarPosition.top),
      ),
      ChoiceChip(
        label: Text('Bottom'),
        selected: _position == TabBarPosition.bottom,
        onSelected: (selected) =>
            setState(() => _position = TabBarPosition.bottom),
      ),
      ChoiceChip(
        label: Text('Left'),
        selected: _position == TabBarPosition.left,
        onSelected: (selected) =>
            setState(() => _position = TabBarPosition.left),
      ),
      ChoiceChip(
        label: Text('Right'),
        selected: _position == TabBarPosition.right,
        onSelected: (selected) =>
            setState(() => _position = TabBarPosition.right),
      )
    ]);
  }

  Widget _buildThemeButtons() {
    return DropdownButton<String>(
        value: _themeName,
        items: [
          DropdownMenuItem(value: 'mobile', child: Text('Mobile')),
          DropdownMenuItem(value: 'classic', child: Text('Classic')),
          DropdownMenuItem(value: 'dark', child: Text('Dark')),
          DropdownMenuItem(value: 'minimalist', child: Text('Minimalist'))
        ],
        onChanged: (value) => setState(() => _themeName = value!));
  }
}
