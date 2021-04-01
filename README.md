# tabbed_view

[![pub](https://img.shields.io/pub/v/tabbed_view.svg)](https://pub.dev/packages/tabbed_view)

Flutter widget inspired by the classic Desktop-style tab component. Supports customizable themes.

![lightcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/light_cut.png)
![darkcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/dark_cut.png)
![mobilecut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile_cut.png)
![minimalistcut](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/minimalist_cut.png)

The *TabbedView* renders the presentation of the model.

The *TabbedViewModel* stores the tab data as name, content, buttons or any dynamic value.

## Get started

The default theme is *TabbedViewTheme.light()*.

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }
    TabbedWiew tabbedView = TabbedWiew(model: TabbedWiewModel(tabs));
```

![light](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/light.gif)

## Content builder

It allows creating the contents of the tab dynamically during the selection event.

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 5; i++) {
      tabs.add(TabData(text: 'Tab $i'));
    }

    TabbedWiew tabbedView = TabbedWiew(
        model: TabbedWiewModel(tabs),
        contentBuilder: (BuildContext context, int tabIndex) {
          int i = tabIndex + 1;
          return Center(child: Text('Content $i'));
        });
```

## Tab

### Extra button

```dart
    TabData tab = TabData(text: 'Tab', buttons: [
      TabButton(icon: Icons.star, onPressed: () => print('Hello!'))
    ]);
    TabbedWiew tabbedView = TabbedWiew(model: TabbedWiewModel([tab]));
```

![tabbutton](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/tab_button.png)

### Removing the close button

```dart
    var tabs = [
      TabData(text: 'Tab'),
      TabData(text: 'Non-closable tab', closable: false)
    ];
    TabbedWiew tabbedView = TabbedWiew(model: TabbedWiewModel(tabs));
```

![nonclosabletab](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/nonclosable_tab.png)

## Themes

### Tabs area

#### Color

* The default *TabsAreaTheme* color is null.

```dart
    var tabs = [TabData(text: 'Tab 1'), TabData(text: 'Tab 2')];

    TabbedViewTheme theme = TabbedViewTheme.minimalist();
    theme.tabsArea.color = Colors.green[100];

    TabbedWiew tabbedView =
        TabbedWiew(model: TabbedWiewModel(tabs), theme: theme);
```

![tabsareacolor](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/tabs_area_color.png)

#### Tab gaps

* Gap before the tabs (allows negative value).
* Gap between tabs (allows negative value).
* Minimum gap after tabs. Separates the last tab and the buttons area.

```dart
    TabbedViewTheme theme = TabbedViewTheme.light();

    theme.tabsArea
      ..initialGap = 20
      ..middleGap = 5
      ..minimalFinalGap = 5;

    TabbedWiew tabbedView = TabbedWiew(model: model, theme: theme);
```

![customgap](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/custom_gap.png)

### Predefined themes

####  Dark theme

```dart
    TabbedWiew tabbedView =
        TabbedWiew(model: model, theme: TabbedViewTheme.dark());
```

![dark](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/dark.gif)

####  Mobile theme

```dart
    TabbedWiew tabbedView =
        TabbedWiew(model: model, theme: TabbedViewTheme.mobile());
```

![mobile](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/mobile.gif)

## Agenda for the next few days

* Complete documentation and examples to cover all available features.
* Release the final version (1.0.0). The API may have some small changes.