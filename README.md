# tabbed_view

[![pub](https://img.shields.io/pub/v/tabbed_view.svg)](https://pub.dev/packages/tabbed_view)

Flutter widget inspired by the classic Desktop-style tab component. Supports customizable themes.

![lightcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/light_cut.png)
![darkcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/dark_cut.png)
![mobilecut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile_cut.png)
![minimalistcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/minimalist_cut.png)
![fromthescratchcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/from_the_scratch_cut.png)

The *TabbedView* renders the presentation of the model.

The *TabbedViewModel* stores the tab data as name, content, buttons or any dynamic value.

## Get started

The default theme is *TabbedViewTheme.light()*.

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      Widget tabContent = Center(child: Text('Content $i'));
      tabs.add(TabData(text: 'Tab $i', content: tabContent));
    }
    TabbedWiew tabbedView = TabbedWiew(controller: TabbedWiewController(tabs));
```

![light](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/light.gif)

### Content builder

It allows creating the contents of the tab dynamically during the selection event.

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
      TabData(text: 'Tab 3')
    ];

    TabbedWiew tabbedView = TabbedWiew(
        controller: TabbedWiewController(tabs),
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
    TabbedWiew tabbedView = TabbedWiew(
        controller: TabbedWiewController(tabs),
        closeButtonTooltip: 'Click here to close the tab');
```

## Tab

### Extra button

```dart
    TabData tab = TabData(text: 'Tab', buttons: [
      TabButton(icon: Icons.star, onPressed: () => print('Hello!'))
    ]);
    TabbedWiew tabbedView = TabbedWiew(controller: TabbedWiewController([tab]));
```

![tabbutton](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/tab_button.png)

### Extra button - overriding theme color

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
    TabbedWiew tabbedView = TabbedWiew(controller: TabbedWiewController(tabs));
```

![tabbuttoncolor](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/tab_button_color.png)

### Removing the close button

```dart
    var tabs = [
      TabData(text: 'Tab'),
      TabData(text: 'Non-closable tab', closable: false)
    ];
    TabbedWiew tabbedView = TabbedWiew(controller: TabbedWiewController(tabs));
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
    TabbedWiew tabbedView = TabbedWiew(
        controller: TabbedWiewController(tabs), onTabClosing: _onTabClosing);
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
    TabbedWiew tabbedView = TabbedWiew(
        controller: TabbedWiewController(tabs),
        onTabSelection: _onTabSelection);
```

## Tabs area

### Buttons

```dart
    TabbedWiewController controller = TabbedWiewController([]);

    TabbedWiew tabbedView = TabbedWiew(
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

### Tab

#### Text style

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
    ];

    TabbedViewTheme theme = TabbedViewTheme.light();
    theme.tabsArea.tab.textStyle = TextStyle(fontSize: 20, color: Colors.blue);

    TabbedWiew tabbedView =
        TabbedWiew(controller: TabbedWiewController(tabs), theme: theme);
```

![tabtextstyle](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/tab_text_style.png)

#### Alignment

```dart
    var tabs = [
      TabData(text: 'Tab 1'),
      TabData(text: 'Tab 2'),
    ];

    TabbedViewTheme theme = TabbedViewTheme.light();
    theme.tabsArea.tab
      ..textStyle = TextStyle(fontSize: 20)
      ..verticalAlignment = VerticalAlignment.top;

    TabbedWiew tabbedView =
        TabbedWiew(controller: TabbedWiewController(tabs), theme: theme);
```

![topalignment](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/top_alignment.png)

### Tabs area

#### Color

* The default *TabsAreaTheme* color is null.

```dart
    var tabs = [TabData(text: 'Tab 1'), TabData(text: 'Tab 2')];

    TabbedViewTheme theme = TabbedViewTheme.minimalist();
    theme.tabsArea.color = Colors.green[100];

    TabbedWiew tabbedView =
        TabbedWiew(controller: TabbedWiewController(tabs), theme: theme);
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

    TabbedViewTheme theme = TabbedViewTheme.light();
    theme.tabsArea
      ..initialGap = 20
      ..middleGap = 5
      ..minimalFinalGap = 5;

    TabbedWiew tabbedView =
        TabbedWiew(controller: TabbedWiewController(tabs), theme: theme);
```

![customgap](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/custom_gap.png)

#### Buttons area

##### Button icon for the hidden tabs menu

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }

    TabbedViewTheme theme = TabbedViewTheme.light();
    theme.tabsArea.buttonsArea.hiddenTabsMenuButtonIcon =
        Icons.arrow_drop_down_circle_outlined;

    TabbedWiew tabbedView =
        TabbedWiew(controller: TabbedWiewController(tabs), theme: theme);
```

![hiddentabsbuttonicon](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/hidden_tabs_button_icon.png)

### Menu

#### Max width

```dart
    List<TabData> tabs = [];
    for (int i = 1; i < 11; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }

    TabbedViewTheme theme = TabbedViewTheme.light()..menu.maxWidth = 100;

    TabbedWiew tabbedView =
        TabbedWiew(controller: TabbedWiewController(tabs), theme: theme);
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

    TabbedViewTheme theme = TabbedViewTheme.light()
      ..menu.ellipsisOverflowText = true;

    TabbedWiew tabbedView =
        TabbedWiew(controller: TabbedWiewController(tabs), theme: theme);
```

![menuellipsis](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/menu_ellipsis.png)

### Predefined themes

####  Dark theme

```dart
    TabbedWiew tabbedView =
            TabbedWiew(controller: controller, theme: TabbedViewTheme.dark());
```

![dark](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/dark.gif)

####  Mobile theme

```dart
    TabbedWiew tabbedView =
        TabbedWiew(controller: controller, theme: TabbedViewTheme.mobile());
```

![mobile](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile.gif)

####  Minimalist theme

```dart
    TabbedWiew tabbedView =
        TabbedWiew(controller: controller, theme: TabbedViewTheme.minimalist());
```

![minimalist](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/minimalist.gif)

####  Minimalist theme - Color set

```dart
    TabbedWiew tabbedView = TabbedWiew(
        controller: controller,
        theme: TabbedViewTheme.minimalist(colors: Colors.blue));
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

    TabbedWiew tabbedView =
        TabbedWiew(controller: TabbedWiewController(tabs), theme: theme);
```

![fromthescratchcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/from_the_scratch_cut.png)

## Agenda for the next few days

* Complete documentation and examples to cover all available features.
* Release the final version (1.0.0). The API may have some small changes.