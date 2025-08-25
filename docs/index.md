# Tabbed view (2.0.0)

Flutter widget inspired by the classic Desktop-style tab component. Supports customizable themes.

![](main_classic_v2.png)

![](main_dark_v2.png)

![](main_mobile_v2.png)

![](main_minimalist_v2.png)

* [Migrating to 2.0.0](#migrating-to-200)
* [Get started](#get-started)
  * [Content builder](#content-builder)
  * [Close button tooltip](#close-button-tooltip)
* [Tab](#tab)
  * [Adding buttons](#adding-buttons)
    * [Icon data](#icon-data)
    * [Icon path](#icon-path)
    * [Overriding theme color](#overriding-theme-color)
    * [Menu button](#menu-button)
  * [Non-closable tab](#non-closable-tab)
  * [Close interceptor](#close-interceptor)
  * [Close listener](#close-listener)
  * [Selection listener](#selection-listener)
  * [Secondary tap (right-click)](#secondary-tap-right-click-on-tab)
  * [Leading](#tab-leading-widget)
  * [Draggable](#draggable-tab-builder)
  * [Keep alive](#keep-alive)
* [Tabs area](#tabs-area)
  * [Tabs area buttons](#tabs-area-buttons)
  * [Trailing widget](#trailing-widget)
* [Themes](#themes)
  * [Tab](#themes---tab)
    * [Text style](#text-style)
    * [Alignment](#alignment)
  * [Tabs area](#themes---tabs-area)
    * [Color](#color)
    * [Tab gaps](#tab-gaps)
    * [Buttons area](#buttons-area)
      * [Button icon for the hidden tabs menu](#button-icon-for-the-hidden-tabs-menu)
  * [Menu](#themes---menu)
    * [Max width](#max-width)
    * [Ellipsis on text overflow](#ellipsis-on-text-overflow)
  * [Hidden tabs menu item builder](#hidden-tabs-menu-item-builder)
  * [Default themes](#default-themes)
    *  [Classic theme](#classic-theme)
       *  [Color set](#classic-theme---color-set)
    *  [Dark theme](#dark-theme)
       *  [Color set](#dark-theme---color-set)
    *  [Mobile theme](#mobile-theme)
       *  [Color set](#mobile-theme---color-set)
       *  [Accent color](#mobile-theme---accent-color)
    *  [Minimalist theme](#minimalist-theme)
       *  [Color set](#minimalist-theme---color-set)
  * [Theme from scratch](#theme-from-scratch)
* [Support this project](#support-this-project)

## Migrating to 2.0.0

Version 2.0.0 introduces significant improvements, including support for left, right, and bottom tab bar positions. This required some breaking changes to the theming system and callbacks.

### 1. Updating Custom Themes

The biggest change is how borders are defined in themes. Previously, themes used hardcoded `Border` objects that didn't adapt to different tab bar positions. Now, themes define a single `BorderSide` that the widgets use to draw the correct border dynamically.

**Action required:** You must update your custom themes.

**Example: Migrating a `TabThemeData`**

*Before (v1.x):*
```dart
// This created a border that only worked for top-positioned tabs.
themeData.tab.selectedStatus.decoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.blue),
    left: BorderSide(color: Colors.blue),
    right: BorderSide(color: Colors.blue)
  )
);
```

*After (v2.0.0):*
```dart
// The widget now builds the correct 3-sided border automatically.
themeData.tab.selectedStatus.border = BorderSide(color: Colors.blue);
```

Refer to the `classic_theme.dart` or `minimalist_theme.dart` for a complete example of a theme that merges with the content area. Refer to `dark_theme.dart` or `mobile_theme.dart` for an "indicator" style border.

### 2. Updating `onTabSelection` Callback

The `onTabSelection` callback now provides the full `TabData` object, which is more useful than just the index.

*Before (v1.x):* `onTabSelection: (int? tabIndex) { ... }`
*After (v2.0.0):* `onTabSelection: (TabData? tabData) { ... }`

## Get started

The *TabbedViewTheme.classic()* method builds the default theme.

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      Widget tabContent = Center(child: Text('Content $i'));
      tabs.add(TabData(text: 'Tab $i', content: tabContent));
    }
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
```

![](get_started_v2.gif)

### Content builder

It allows creating the contents of the tab dynamically during the selection event.

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];

    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs),
        contentBuilder: (BuildContext context, int tabIndex) {
          int i = tabIndex + 1;
          return Center(child: Text('Content $i'));
        });
```

### Close button tooltip

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];
    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs),
        closeButtonTooltip: 'Click here to close the tab');
```

## Tab

### Adding buttons

#### Icon data

```dart
    TabData tab = TabData(text: 'Tab', buttons: [
      TabButton(
          icon: IconProvider.data(Icons.star),
          onPressed: () => showSnackBar(context: context, msg: 'Hello!'))
    ]);

    TabbedView tabbedView = TabbedView(controller: TabbedViewController([tab]));
```

![](tab_button_icon_data.png)

#### Icon path

```dart
    TabData tab = TabData(text: 'Tab', buttons: [
      TabButton(
          icon: IconProvider.path(_path),
          onPressed: () => showSnackBar(context: context, msg: 'Hello!'))
    ]);
    TabbedView tabbedView = TabbedView(controller: TabbedViewController([tab]));
```

```dart
  Path _path(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.1);
    path.lineTo(size.width * 0.9, size.height * 0.1);
    path.lineTo(size.width * 0.9, size.height * 0.9);
    path.lineTo(size.width * 0.1, size.height * 0.9);
    path.close();
    return path;
  }
```

![](tab_button_icon_path.png)

#### Overriding theme color

```dart
    var tabs = [
      TabData(text: 'Tab', buttons: [
        TabButton(
            icon: IconProvider.data(Icons.star),
            color: Colors.green,
            onPressed: () => showSnackBar(context: context, msg: 'Hello!'))
      ])
    ];
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
```

![](tab_button_override_theme_color.png)

#### Menu button

```dart
    var tabs = [
      TabData(text: 'Tab', buttons: [
        TabButton(
            icon: IconProvider.path(TabbedViewIcons.menu),
            menuBuilder: (context) {
              return [
                TabbedViewMenuItem(
                    text: 'Menu item 1',
                    onSelection: () =>
                        showSnackBar(context: context, msg: 'menu item 1')),
                TabbedViewMenuItem(
                    text: 'Menu item 2',
                    onSelection: () =>
                        showSnackBar(context: context, msg: 'menu item 2'))
              ];
            })
      ])
    ];
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
```

![](tab_menu_button.png)

### Non-closable tab

```dart
    var tabs = [
      TabData(text: 'Tab'),
      TabData(text: 'Non-closable tab', closable: false)
    ];
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
```

![](non_closable_tab.png)

### Close interceptor

```dart
    bool _tabCloseInterceptor(int tabIndex) {
      if (tabIndex == 0) {
        print('The tab $tabIndex is busy and cannot be closed.');
        return false;
      }
      return true;
    }

    List<TabData> tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];
    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs),
        tabCloseInterceptor: _tabCloseInterceptor);
```

### Close listener

```dart
    List<TabData> tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];
    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs),
        onTabClose: (index, tabData) {
          print('$index: ' + tabData.text);
        });
```

### Selection listener

```dart
    _onTabSelection(TabData? newTab) {
      if (newTab != null) {
        // The controller's selectedIndex is updated before this callback is invoked.
        print('The new selected tab is ${newTab.text} at index ${_controller.selectedIndex}.');
        // You can use newTab.value for routing
      } else {
        print('No tab selected.');
      }
    }

    List<TabData> tabs = [
      TabData(text: 'Tab 1', value: 'tab1'),
      TabData(text: 'Tab 2', value: 'tab2'),
      TabData(text: 'Tab 3', value: 'tab3')
    ];
    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs),
        onTabSelection: _onTabSelection);
```

### Secondary tap (right-click) on tab: Use onTabSecondaryTap to listen for right-click events on a tab. 
```dart 
  TabbedView(
    controller: controller,
    onTabSecondaryTap: (index, tabData, details) {
      // Show a context menu, for example.
      print('Right-clicked on ${tabData.text}');
    },
  ); 
```


### Tab leading widget

```dart
    List<TabData> tabs = [
      TabData(
          text: 'Tab 1',
          leading: (context, status) => Icon(Icons.star, size: 16)),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
```

![](tab_leading_v1.png)

### Draggable tab builder

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      Widget tabContent = Center(child: Text('Content $i'));
      tabs.add(TabData(text: 'Tab $i', content: tabContent));
    }
    _controller = TabbedViewController(tabs);
```

```dart
    TabbedView tabbedView = TabbedView(
        controller: _controller,
        onDraggableBuild: (int tabIndex, TabData tabData) {
          return DraggableConfig(
              feedback: Container(
                  child: Text(tabData.text),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(border: Border.all())));
        });

    DragTarget<TabData> dragTarget = DragTarget(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return Container(
          padding: EdgeInsets.all(8),
          color: Colors.yellow[100],
          child: Center(
              child: ListTile(
                  title: Text('Drop here'),
                  subtitle: Text('Last dropped tab: ${_acceptedData ?? ''}'))),
        );
      },
      onAccept: (TabData data) {
        setState(() {
          _acceptedData = data.text;
        });
      },
    );
```

### Keep alive

The `keepAlive` parameter indicates whether to keep the tab content widget in memory even if it is not visible. Indicated to prevent loss of state due to tree change by tab selection.  If enabled, the Widget will continue to be instantiated in the tree but will remain invisible.  The default value is `FALSE`.

## Tabs area

### Tabs area buttons

```dart
    TabbedViewController controller = TabbedViewController([]);

    TabbedView tabbedView = TabbedView(
        controller: controller,
        tabsAreaButtonsBuilder: (context, tabsCount) {
          List<TabButton> buttons = [];
          buttons.add(TabButton(
              icon: IconProvider.data(Icons.add),
              onPressed: () {
                int millisecond = DateTime.now().millisecondsSinceEpoch;
                controller.addTab(TabData(text: '$millisecond'));
              }));
          if (tabsCount > 0) {
            buttons.add(TabButton(
                icon: IconProvider.data(Icons.delete),
                onPressed: () {
                  if (controller.selectedIndex != null) {
                    controller.removeTab(controller.selectedIndex!);
                  }
                }));
          }
          return buttons;
        });
```

![](tabs_area_buttons.png)

### Trailing widget

You can add a custom widget at the end of the tabs area using the `trailing` property. This widget will be positioned and rotated correctly for all tab bar positions.

```dart
TabbedView(
  controller: controller,
  trailing: Padding(
    padding: const EdgeInsets.all(4),
    child: Icon(Icons.more_vert),
  ),
);
```

## Themes

### Themes - Tab

#### Text style

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
    ];

    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));

    TabbedViewThemeData themeData = TabbedViewThemeData.classic()
      ..tab.textStyle = TextStyle(fontSize: 20, color: Colors.blue);
    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](tab_text_style.png)

#### Alignment

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
    ];

    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));

    TabbedViewThemeData themeData = TabbedViewThemeData.classic();
    themeData.tab
      ..textStyle = TextStyle(fontSize: 20)
      ..verticalAlignment = VerticalAlignment.top;

    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](tab_alignment.png)

### Themes - Tabs area

#### Color

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic();
    themeData.tabsArea.color = Colors.green[100];

    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](tabs_area_color.png)

#### Tab gaps

* Gap before the tabs (allows negative value).
* Gap between tabs (allows negative value).
* Minimum gap after tabs. Separates the last tab and the buttons area.

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic();
    themeData.tabsArea
      ..initialGap = 20
      ..middleGap = 5
      ..minimalFinalGap = 5;

    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](tabs_area_gaps.png)

#### Buttons area

##### Button icon for the hidden tabs menu

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic()
      ..tabsArea.menuIcon =
          IconProvider.data(Icons.arrow_drop_down_circle_outlined);

    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](tabs_area_menu_button.png)

### Themes - Menu

#### Max width

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic()
      ..menu.maxWidth = 100;
    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](menu_max_width.png)

#### Ellipsis on text overflow

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3'),
      TabData(
          text: 'The name of the tab is so long that it doesn'
              't fit on the menu')
    ];
    TabbedViewController controller = TabbedViewController(tabs);

    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic()
      ..menu.ellipsisOverflowText = true;
    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](menu_ellipsis.png)

### Hidden tabs menu item builder

It allows you to customize the menu item for hidden tabs.

```dart
    TabbedView tabbedView = TabbedView(
        controller: controller,
        hiddenTabsMenuItemBuilder: (context, tabIndex, tabData) {
          final theme = TabbedViewTheme.of(context);
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final textStyle = isDark ? theme.menu.textStyleDark : theme.menu.textStyle;
          return Padding(
            padding: theme.menu.menuItemPadding,
            child: Row(
              children: [
                Icon(Icons.tab, size: 16, color: textStyle?.color),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${tabData.text} (index $tabIndex)',
                    style: textStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        });
```

### Default themes

####  Classic theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme =
        TabbedViewTheme(child: tabbedView, data: TabbedViewThemeData.classic());
```

![](classic_theme_v2.png)

#####  Classic theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.classic(colorSet: Colors.green));
```

![](classic_theme_color_set_v2.png)

####  Dark theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme =
        TabbedViewTheme(child: tabbedView, data: TabbedViewThemeData.dark());
```

![](dark_theme_v2.png)

#####  Dark theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.dark(colorSet: Colors.indigo));
```

![](dark_theme_color_set_v2.png)

####  Mobile theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme =
        TabbedViewTheme(child: tabbedView, data: TabbedViewThemeData.mobile());
```

![](mobile_theme_v2.png)

#####  Mobile theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.mobile(colorSet: Colors.blueGrey));
```

![](mobile_theme_color_set_v2.png)

#####  Mobile theme - Accent color

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.mobile(accentColor: Colors.green[700]!));
```

![](mobile_theme_accent_color.png)

####  Minimalist theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView, data: TabbedViewThemeData.minimalist());
```

![](minimalist_theme_v2.png)

#####  Minimalist theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.minimalist(colorSet: Colors.blue));
```

![](minimalist_theme_color_set_v2.png)

### Theme from scratch

It is possible to create an entire theme from scratch.

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];
    TabbedViewController controller = TabbedViewController(tabs);
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData();
    themeData.tabsArea
      ..border = Border(bottom: BorderSide(color: Colors.green[700]!, width: 3))
      ..middleGap = 6;

    Radius radius = Radius.circular(10.0);
    BorderRadiusGeometry? borderRadius =
        BorderRadius.only(topLeft: radius, topRight: radius);

    themeData.tab
      ..padding = EdgeInsets.fromLTRB(10, 4, 10, 4)
      ..buttonsOffset = 8
      ..decoration = BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green[100],
          borderRadius: borderRadius)
      ..selectedStatus.decoration =
          BoxDecoration(color: Colors.green[200], borderRadius: borderRadius)
      ..highlightedStatus.decoration =
          BoxDecoration(color: Colors.green[50], borderRadius: borderRadius);

    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](theme_from_scratch_v2.png)

## Support this project

### Bitcoin

[bc1qhqy84y45gya58gtfkvrvass38k4mcyqnav803h](https://www.blockchain.com/pt/btc/address/bc1qhqy84y45gya58gtfkvrvass38k4mcyqnav803h)

### Ethereum (ERC-20) or Binance Smart Chain (BEP-20)

[0x9eB815FD4c88A53322304143A9Aa8733D3369985](https://etherscan.io/address/0x9eb815fd4c88a53322304143a9aa8733d3369985)

### Solana

[7vp45LoQXtLYFXXKx8wQGnzYmhcnKo1TmfqUgMX45Ad8](https://explorer.solana.com/address/7vp45LoQXtLYFXXKx8wQGnzYmhcnKo1TmfqUgMX45Ad8)

### Helium

[13A2fDqoApT9VnoxFjHWcy8kPQgVFiVnzps32MRAdpTzvs3rq68](https://explorer.helium.com/accounts/13A2fDqoApT9VnoxFjHWcy8kPQgVFiVnzps32MRAdpTzvs3rq68)