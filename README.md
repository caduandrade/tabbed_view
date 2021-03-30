# tabbed_view

[![pub](https://img.shields.io/pub/v/tabbed_view.svg)](https://pub.dev/packages/tabbed_view)

Widget inspired by the classic Desktop-style tab component. Supports customizable themes.

![intro](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/intro.png)

The *TabbedView* renders the presentation of the model.
The *TabbedViewModel* stores the tab data as name, content, buttons or any dynamic value.
The default theme is *TabbedViewTheme.light()*.

```dart
    List<TabData> tabs = [];
    for (var i = 1; i < 7; i++) {
      tabs.add(
          TabData(text: 'Tab $i', content: Center(child: Text('Content $i'))));
    }
    TabbedWiew tabbedView = TabbedWiew(model: TabbedWiewModel(tabs));
```

![intro](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/light.gif)

**Content builder**

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

**Dark theme**

```dart
    TabbedWiew tabbedView =
        TabbedWiew(model: model, theme: TabbedViewTheme.dark());
```

![intro](https://raw.githubusercontent.com/caduandrade/images/main/tabbed_view/dark.gif)

### Agenda for the next few days

* Complete documentation and examples to cover all available features.
* Release the final version. The API can be changed.