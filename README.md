[![](https://img.shields.io/pub/v/tabbed_view.svg)](https://pub.dev/packages/tabbed_view) ![](https://github.com/caduandrade/tabbed_view/actions/workflows/test.yml/badge.svg) [![](https://img.shields.io/badge/demo-try%20it%20out-blue)](https://caduandrade.github.io/tabbed_view_demo/) [![](https://img.shields.io/badge/Flutter-%E2%9D%A4-red)](https://flutter.dev/)

# Tabbed view

Flutter widget inspired by the classic Desktop-style tab component. Supports customizable themes.

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/classic_cut.png)
![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/dark_cut.png)
![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile_cut.png)
![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/minimalist_cut.png)
![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/from_the_scratch_cut.png)

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
    * [Ellipsis on overflow text](#ellipsis-on-overflow-text)
  * [Default themes](#default-themes)
    *  [Classic theme](#classic-theme)
       *  [Color set](#classic-theme---color-set)
    *  [Dark theme](#dark-theme)
       *  [Color set](#dark-theme---color-set)
    *  [Mobile theme](#mobile-theme)
       *  [Color set](#mobile-theme---color-set)
       *  [Highlighted tab color](#mobile-theme---highlighted-tab-color)
    *  [Minimalist theme](#minimalist-theme)
       *  [Color set](#minimalist-theme---color-set)
  * [Theme from scratch](#theme-from-scratch)

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

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/classic.gif)

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
          iconData: Icons.star,
          onPressed: () => showSnackBar(context: context, msg: 'Hello!'))
    ]);

    TabbedView tabbedView = TabbedView(controller: TabbedViewController([tab]));
    // using material design icon patterns
    TabbedViewThemeData themeData = TabbedViewThemeData.classic()
      ..materialDesign();
    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](./screenshots/tab_button_icon_data.png)

#### Icon path

```dart
    TabData tab = TabData(text: 'Tab', buttons: [
      TabButton(
          iconPath: _path,
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

![](./screenshots/tab_button_icon_path.png)

#### Overriding theme color

```dart
    var tabs = [
      TabData(text: 'Tab', buttons: [
        TabButton(
            iconData: Icons.star,
            color: Colors.green,
            onPressed: () => showSnackBar(context: context, msg: 'Hello!'))
      ])
    ];
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));

    // using material design icon patterns
    TabbedViewThemeData themeData = TabbedViewThemeData.classic()
      ..materialDesign();
    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](./screenshots/tab_button_override_theme_color.png)

#### Menu button

```dart
    var tabs = [
      TabData(text: 'Tab', buttons: [
        TabButton(
            iconPath: TabbedViewIcons.menu,
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

![](./screenshots/tab_menu_button.png)

### Non-closable tab

```dart
    var tabs = [
      TabData(text: 'Tab'),
      TabData(text: 'Non-closable tab', closable: false)
    ];
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
```

![](./screenshots/non_closable_tab.png)

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

A more efficient alternative is to keep the data in `TabData`'s `value` parameter as long as the `TabbedViewController` is being kept in the state of its class.

## Tabs area

### Tabs area buttons

```dart
    TabbedViewController controller = TabbedViewController([]);

    TabbedView tabbedView = TabbedView(
        controller: controller,
        tabsAreaButtonsBuilder: (context, tabsCount) {
          List<TabButton> buttons = [];
          buttons.add(TabButton(
              iconData: Icons.add,
              onPressed: () {
                int millisecond = DateTime.now().millisecondsSinceEpoch;
                controller.addTab(TabData(text: '$millisecond'));
              }));
          if (tabsCount > 0) {
            buttons.add(TabButton(
                iconData: Icons.delete,
                onPressed: () {
                  if (controller.selectedIndex != null) {
                    controller.removeTab(controller.selectedIndex!);
                  }
                }));
          }
          return buttons;
        });

    // using material design icon patterns
    TabbedViewThemeData themeData = TabbedViewThemeData.classic()
      ..materialDesign();
    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](./screenshots/tabs_area_buttons.png)

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

![](./screenshots/tab_text_style.png)

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

![](./screenshots/tab_alignment.png)

### Themes - Tabs area

#### Color

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic();
    themeData.tabsArea.color = Colors.green[100];

    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](./screenshots/tabs_area_color.png)

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

![](./screenshots/tabs_area_gaps.png)

#### Buttons area

##### Button icon for the hidden tabs menu

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic()
      ..tabsArea.menuIconData = Icons.arrow_drop_down_circle_outlined;

    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/hidden_tabs_button_icon.png)

### Themes - Menu

#### Max width

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewThemeData themeData = TabbedViewThemeData.classic()
      ..menu.maxWidth = 100;
    TabbedViewTheme theme = TabbedViewTheme(child: tabbedView, data: themeData);
```

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/menu_max_width.png)

#### Ellipsis on overflow text

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

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/menu_ellipsis.png)

### Default themes

####  Classic theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme =
        TabbedViewTheme(child: tabbedView, data: TabbedViewThemeData.classic());
```

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/classic.gif)

#####  Classic theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.classic(colorSet: Colors.green));
```

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/classic_color_set.png)

####  Dark theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme =
        TabbedViewTheme(child: tabbedView, data: TabbedViewThemeData.dark());
```

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/dark.gif)

#####  Dark theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.dark(colorSet: Colors.indigo));
```

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/dark_color_set.png)

####  Mobile theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme =
        TabbedViewTheme(child: tabbedView, data: TabbedViewThemeData.mobile());
```

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile.gif)

#####  Mobile theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.mobile(colorSet: Colors.blueGrey));
```

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile_color_set.png)

#####  Mobile theme - Highlighted tab color

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.mobile(
            highlightedTabColor: Colors.green[700]!));
```

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile_highlighted_color.png)

####  Minimalist theme

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView, data: TabbedViewThemeData.minimalist());
```

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/minimalist.gif)

#####  Minimalist theme - Color set

```dart
    TabbedView tabbedView = TabbedView(controller: controller);

    TabbedViewTheme theme = TabbedViewTheme(
        child: tabbedView,
        data: TabbedViewThemeData.minimalist(colorSet: Colors.blue));
```

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/minimalist_change_color.png)

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

![](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/from_the_scratch_cut.png)