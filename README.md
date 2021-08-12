[![pub](https://img.shields.io/pub/v/tabbed_view.svg)](https://pub.dev/packages/tabbed_view) [![pub2](https://img.shields.io/badge/Flutter-%E2%9D%A4-red)](https://flutter.dev/)

# Tabbed view

Flutter widget inspired by the classic Desktop-style tab component. Supports customizable themes.

![classiccut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/classic_cut.png)
![darkcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/dark_cut.png)
![mobilecut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile_cut.png)
![minimalistcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/minimalist_cut.png)
![fromthescratchcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/from_the_scratch_cut.png)

* [Get started](#get-started)
  * [Content builder](#content-builder)
  * [Close button tooltip](#close-button-tooltip)
* [Tab](#tab)
  * [Adding buttons](#adding-buttons)
    * [Overriding theme color](#overriding-theme-color)
  * [Removing the close button](#removing-the-close-button)
  * [Close listener](#close-listener)
  * [Selection listener](#selection-listener)
  * [Draggable](#draggable-tab-builder)
  * [Keep alive](#keep-alive)
* [Tabs area](#tabs-area)
  * [Tabs area buttons](#tabs-area-buttons)
* [Themes](#themes)
  * [Themes - Tab](#themes---tab)
    * [Text style](#text-style)
    * [Alignment](#alignment)
  * [Themes - Tabs area](#themes---tabs-area)
    * [Color](#color)
    * [Tab gaps](#tab-gaps)
    * [Buttons area](#buttons-area)
      * [Button icon for the hidden tabs menu](#button-icon-for-the-hidden-tabs-menu)
  * [Themes - Menu](#themes---menu)
    * [Max width](#max-width)
    * [Ellipsis on overflow text](#ellipsis-on-overflow-text)
  * [Predefined themes](#predefined-themes)
    *  [Classic theme](#classic-theme)
      *  [Classic theme - Color set](#classic-theme---color-set)
    *  [Dark theme](#dark-theme)
      *  [Dark theme - Color set](#dark-theme---color-set)
    *  [Mobile theme](#mobile-theme)
      *  [Mobile theme - Color set](#mobile-theme---color-set)
      *  [Mobile theme - Highlighted tab color](#mobile-theme---highlighted-tab-color)
    *  [Minimalist theme](#minimalist-theme)
      *  [Minimalist theme - Color set](#minimalist-theme---color-set)
  * [Creating new theme](#creating-new-theme)

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

![classic](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/classic.gif)

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

```dart
    TabData tab = TabData(text: 'Tab', buttons: [
      TabButton(icon: Icons.star, onPressed: () => print('Hello!'))
    ]);
    TabbedView tabbedView = TabbedView(controller: TabbedViewController([tab]));
```

![tabbutton](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/tab_button.png)

#### Overriding theme color

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2', buttons: [
        TabButton(
            icon: Icons.star,
            color: Colors.green,
            onPressed: () => print('Hello!'))
      ])
    ];
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
```

![tabbuttoncolor](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/tab_button_color.png)

### Removing the close button

```dart
    var tabs = [
      TabData(text: 'Tab'),
      TabData(text: 'Non-closable tab', closable: false)
    ];
    TabbedView tabbedView = TabbedView(controller: TabbedViewController(tabs));
```

![nonclosabletab](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/nonclosable_tab.png)

### Close listener

```dart
    bool _onTabClosing(int tabIndex) {
      if (tabIndex == 0) {
        print('The tab $tabIndex is busy and cannot be closed.');
        return false;
      }
      print('Closing tab $tabIndex...');
      return true;
    }

    List<TabData> tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];
    TabbedView tabbedView = TabbedView(
        controller: TabbedViewController(tabs), onTabClosing: _onTabClosing);
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
              icon: Icons.add,
              onPressed: () {
                int millisecond = DateTime.now().millisecondsSinceEpoch;
                controller.addTab(TabData(text: '$millisecond'));
              }));
          if (tabsCount > 0) {
            buttons.add(TabButton(
                icon: Icons.delete,
                onPressed: () {
                  if (controller.selectedIndex != null) {
                    controller.removeTab(controller.selectedIndex!);
                  }
                }));
          }
          return buttons;
        });
```

![tabsareabuttons](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/tabs_area_buttons.gif)

## Themes

### Themes - Tab

#### Text style

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
    ];

    TabbedViewTheme theme = TabbedViewTheme.classic();
    theme.tabsArea.tab.textStyle = TextStyle(fontSize: 20, color: Colors.blue);

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
```

![tabtextstyle](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/tab_text_style.png)

#### Alignment

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
    ];

    TabbedViewTheme theme = TabbedViewTheme.classic();
    theme.tabsArea.tab
      ..textStyle = TextStyle(fontSize: 20)
      ..verticalAlignment = VerticalAlignment.top;

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
```

![topalignment](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/top_alignment.png)

### Themes - Tabs area

#### Color

* The default *TabsAreaTheme* color is null.

```dart
    var tabs = [TabData(text: 'Tab 1'), TabData(text: 'Tab 2')];

    TabbedViewTheme theme = TabbedViewTheme.minimalist();
    theme.tabsArea.color = Colors.green[100];

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
```

![tabsareacolor](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/tabs_area_color.png)

#### Tab gaps

* Gap before the tabs (allows negative value).
* Gap between tabs (allows negative value).
* Minimum gap after tabs. Separates the last tab and the buttons area.

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }

    TabbedViewTheme theme = TabbedViewTheme.classic();
    theme.tabsArea
      ..initialGap = 20
      ..middleGap = 5
      ..minimalFinalGap = 5;

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
```

![customgap](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/custom_gap.png)

#### Buttons area

##### Button icon for the hidden tabs menu

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }

    TabbedViewTheme theme = TabbedViewTheme.classic();
    theme.tabsArea.buttonsArea.hiddenTabsMenuButtonIcon =
        Icons.arrow_drop_down_circle_outlined;

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
```

![hiddentabsbuttonicon](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/hidden_tabs_button_icon.png)

### Themes - Menu

#### Max width

```dart
    List<TabData> tabs = [];
    for (int i = 1; i < 11; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }

    TabbedViewTheme theme = TabbedViewTheme.classic()..menu.maxWidth = 100;

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
```

![menumaxwidth](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/menu_max_width.png)

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

    TabbedViewTheme theme = TabbedViewTheme.classic()
      ..menu.ellipsisOverflowText = true;

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
```

![menuellipsis](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/menu_ellipsis.png)

### Predefined themes

####  Classic theme

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(TabData(text: 'Tab $i', content:  Center(child: Text('Content $i'))));
    }
    TabbedViewController controller = TabbedViewController(tabs);

    TabbedView tabbedView = TabbedView(
        controller: controller,
        theme: TabbedViewTheme.classic());
```

![classic2](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/classic.gif)

#####  Classic theme - Color set

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(TabData(text: 'Tab $i', content:  Center(child: Text('Content $i'))));
    }
    TabbedViewController controller = TabbedViewController(tabs);

    TabbedViewTheme theme = TabbedViewTheme.classic(colorSet: Colors.green);

    TabbedView tabbedView = TabbedView(
        controller: controller,
        theme: theme);
```

![classiccolorset](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/classic_color_set.png)

####  Dark theme

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }
    TabbedViewController controller = TabbedViewController(tabs);

    var contentBuilder = (BuildContext context, int index) {
      int i = index + 1;
      Text text = Text('Content $i', style: TextStyle(color: Colors.white));
      return Center(child: text);
    };

    TabbedView tabbedView = TabbedView(
        controller: controller,
        contentBuilder: contentBuilder,
        theme: TabbedViewTheme.dark());

    Container container = Container(child: tabbedView, color: Colors.black);
```

![dark](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/dark.gif)

#####  Dark theme - Color set

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }
    TabbedViewController controller = TabbedViewController(tabs);

    var contentBuilder = (BuildContext context, int index) {
      int i = index + 1;
      Text text = Text('Content $i', style: TextStyle(color: Colors.white));
      return Center(child: text);
    };

    TabbedViewTheme theme = TabbedViewTheme.dark(colorSet: Colors.indigo);

    TabbedView tabbedView = TabbedView(
        controller: controller, contentBuilder: contentBuilder, theme: theme);

    Container container = Container(child: tabbedView, color: Colors.black12);
```

![darkcolorset](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/dark_color_set.png)

####  Mobile theme

```dart
    TabbedView tabbedView =
        TabbedView(controller: controller, theme: TabbedViewTheme.mobile());
```

![mobile](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile.gif)

#####  Mobile theme - Color set

```dart
    TabbedViewTheme theme = TabbedViewTheme.mobile(colorSet: Colors.blueGrey);
    TabbedView tabbedView = TabbedView(controller: controller, theme: theme);
```

![mobilecolorset](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile_color_set.png)

#####  Mobile theme - Highlighted tab color

```dart
    TabbedViewTheme theme =
        TabbedViewTheme.mobile(highlightedTabColor: Colors.green[700]!);
    TabbedView tabbedView = TabbedView(controller: controller, theme: theme);
```

![mobilehighlightedcolor](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile_highlighted_color.png)

####  Minimalist theme

```dart
    TabbedView tabbedView =
        TabbedView(controller: controller, theme: TabbedViewTheme.minimalist());
```

![minimalist](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/minimalist.gif)

#####  Minimalist theme - Color set

```dart
    TabbedView tabbedView = TabbedView(
        controller: controller,
        theme: TabbedViewTheme.minimalist(colorSet: Colors.blue));
```

![minimalistchangecolor](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/minimalist_change_color.png)

### Creating new theme

It is possible to create an entire theme from scratch.

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];

    TabbedViewTheme theme = TabbedViewTheme();
    theme.tabsArea
      ..border = Border(bottom: BorderSide(color: Colors.green[700]!, width: 3))
      ..middleGap = 6;

    Radius radius = Radius.circular(10.0);
    BorderRadiusGeometry? borderRadius =
        BorderRadius.only(topLeft: radius, topRight: radius);

    theme.tabsArea.tab
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

    TabbedView tabbedView =
        TabbedView(controller: TabbedViewController(tabs), theme: theme);
```

![fromthescratchcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/from_the_scratch_cut.png)