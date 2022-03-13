[![](https://img.shields.io/pub/v/tabbed_view.svg)](https://pub.dev/packages/tabbed_view) ![](https://github.com/caduandrade/tabbed_view/actions/workflows/test.yml/badge.svg) [![](https://img.shields.io/badge/demo-try%20it%20out-blue)](https://caduandrade.github.io/tabbed_view_demo/) [![](https://img.shields.io/badge/Flutter-%E2%9D%A4-red)](https://flutter.dev/) [![](https://img.shields.io/badge/donate-crypto-green)](#support-this-project)

# Tabbed view

Flutter widget inspired by the classic Desktop-style tab component. Supports customizable themes.

![](https://caduandrade.github.io/tabbed_view/main_classic_v2.png)

![](https://caduandrade.github.io/tabbed_view/main_dark_v2.png)

![](https://caduandrade.github.io/tabbed_view/main_mobile_v2.png)

![](https://caduandrade.github.io/tabbed_view/main_minimalist_v2.png)

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
  * [Draggable](#draggable-tab-builder)
  * [Keep alive](#keep-alive)
* [Tabs area](#tabs-area)
  * [Tabs area buttons](#tabs-area-buttons)
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

![](https://caduandrade.github.io/tabbed_view/get_started_v2.gif)

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

![](https://caduandrade.github.io/tabbed_view/tab_button_icon_data.png)

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

![](https://caduandrade.github.io/tabbed_view/tab_button_icon_path.png)

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

![](https://caduandrade.github.io/tabbed_view/tab_button_override_theme_color.png)

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

![](https://caduandrade.github.io/tabbed_view/tab_menu_button.png)

### Non-closable tab

```dart
    var tabs = [
      TabData(text: 'Tab'),
      TabData(text: 'Non-closable tab', closable: false)
    ];
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
```

![](https://caduandrade.github.io/tabbed_view/non_closable_tab.png)

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
    _onTabSelection(int? newTabIndex) {
      print('The new selected tab is $newTabIndex.');
    }

    List<TabData> tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];
    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs),
        onTabSelection: _onTabSelection);
```

### Draggable tab builder

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      Widget tabContent = Center(child: Text('Content $i'));
      tabs.add(TabData(text: 'Tab $i', content: tabContent));
    }
    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs),
        draggableTabBuilder: (int tabIndex, TabData tab, Widget tabWidget) {
          return Draggable<String>(
              child: tabWidget,
              feedback: Material(
                  child: Container(
                      child: Text(tab.text),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(border: Border.all()))),
              data: tab.text,
              dragAnchorStrategy: (Draggable<Object> draggable,
                  BuildContext context, Offset position) {
                return Offset.zero;
              });
        });
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

![](https://caduandrade.github.io/tabbed_view/tabs_area_buttons.png)

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

![](https://caduandrade.github.io/tabbed_view/tab_text_style.png)

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

![](https://caduandrade.github.io/tabbed_view/tab_alignment.png)

### Themes - Tabs area

#### Color

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic();
    themeData.tabsArea.color = Colors.green[100];

    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](https://caduandrade.github.io/tabbed_view/tabs_area_color.png)

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

![](https://caduandrade.github.io/tabbed_view/tabs_area_gaps.png)

#### Buttons area

##### Button icon for the hidden tabs menu

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic()
      ..tabsArea.menuIcon =
          IconProvider.data(Icons.arrow_drop_down_circle_outlined);

    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](https://caduandrade.github.io/tabbed_view/tabs_area_menu_button.png)

### Themes - Menu

#### Max width

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic()
      ..menu.maxWidth = 100;
    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](https://caduandrade.github.io/tabbed_view/menu_max_width.png)

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

![](https://caduandrade.github.io/tabbed_view/menu_ellipsis.png)

### Default themes

####  Classic theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme =
        TabbedViewTheme(child: tabbedView, data: TabbedViewThemeData.classic());
```

![](https://caduandrade.github.io/tabbed_view/classic_theme_v2.png)

#####  Classic theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.classic(colorSet: Colors.green));
```

![](https://caduandrade.github.io/tabbed_view/classic_theme_color_set_v2.png)

####  Dark theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme =
        TabbedViewTheme(child: tabbedView, data: TabbedViewThemeData.dark());
```

![](https://caduandrade.github.io/tabbed_view/dark_theme_v2.png)

#####  Dark theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.dark(colorSet: Colors.indigo));
```

![](https://caduandrade.github.io/tabbed_view/dark_theme_color_set_v2.png)

####  Mobile theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme =
        TabbedViewTheme(child: tabbedView, data: TabbedViewThemeData.mobile());
```

![](https://caduandrade.github.io/tabbed_view/mobile_theme_v2.png)

#####  Mobile theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.mobile(colorSet: Colors.blueGrey));
```

![](https://caduandrade.github.io/tabbed_view/mobile_theme_color_set_v2.png)

#####  Mobile theme - Accent color

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.mobile(accentColor: Colors.green[700]!));
```

![](https://caduandrade.github.io/tabbed_view/mobile_theme_accent_color.png)

####  Minimalist theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView, data: TabbedViewThemeData.minimalist());
```

![](https://caduandrade.github.io/tabbed_view/minimalist_theme_v2.png)

#####  Minimalist theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.minimalist(colorSet: Colors.blue));
```

![](https://caduandrade.github.io/tabbed_view/minimalist_theme_color_set_v2.png)

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

![](https://caduandrade.github.io/tabbed_view/theme_from_scratch_v2.png)

## Support this project

### Bitcoin

[bc1qhqy84y45gya58gtfkvrvass38k4mcyqnav803h](https://www.blockchain.com/pt/btc/address/bc1qhqy84y45gya58gtfkvrvass38k4mcyqnav803h)

### Ethereum (ERC-20) or Binance Smart Chain (BEP-20)

[0x9eB815FD4c88A53322304143A9Aa8733D3369985](https://etherscan.io/address/0x9eb815fd4c88a53322304143a9aa8733d3369985)

### Helium

[13A2fDqoApT9VnoxFjHWcy8kPQgVFiVnzps32MRAdpTzvs3rq68](https://explorer.helium.com/accounts/13A2fDqoApT9VnoxFjHWcy8kPQgVFiVnzps32MRAdpTzvs3rq68)