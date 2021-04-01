# tabbed_view

[![pub](https://img.shields.io/pub/v/tabbed_view.svg)](https://pub.dev/packages/tabbed_view)

Widget inspired by the classic Desktop-style tab component. Supports customizable themes.

![examples](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/examples.png)

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

### Customizing

#### Tab gaps

* Gap before the tabs.
* Gap between tabs.
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

### Default themes

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