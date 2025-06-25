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

    _controller = TabbedViewController(tabs);
  }

  @override
  Widget build(BuildContext context) {
    // Configuring the [TabbedView] with all available properties.
    TabbedView tabbedView = TabbedView(
      controller: _controller,
      tabBarPosition: TabBarPosition.left,
      contentBuilder: null,
      onTabSelection: (newIndex) {},
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
      closeButtonTooltip: 'Close this tab',
      tabsAreaVisible: true,
      contentClip: true,
      dragScope: null,
    );

    TabbedViewThemeData originalTheme = TabbedViewThemeData.mobile();
    originalTheme = originalTheme.copyWith(
        tab: originalTheme.tab.copyWith(rotateCharactersInVerticalTabs: true));
    TabbedViewThemeData themeData = TabbedViewThemeData(
      tabsArea: TabsAreaThemeData(
        color: originalTheme.tabsArea.color,
        border: originalTheme.tabsArea.border,
        initialGap: originalTheme.tabsArea.initialGap,
        middleGap: originalTheme.tabsArea.middleGap,
        minimalFinalGap: originalTheme.tabsArea.minimalFinalGap,
        menuIcon: originalTheme.tabsArea.menuIcon,
        visible: originalTheme.tabsArea.visible,
        dropColor: originalTheme.tabsArea.dropColor,
        equalHeights: originalTheme.tabsArea.equalHeights,
      ),
      tab: TabThemeData(
        // Properties for individual tabs.
        closeIcon: originalTheme.tab.closeIcon,
        normalButtonColor: originalTheme.tab.normalButtonColor,
        hoverButtonColor: originalTheme.tab.hoverButtonColor,
        disabledButtonColor: originalTheme.tab.disabledButtonColor,
        normalButtonBackground: originalTheme.tab.normalButtonBackground,
        hoverButtonBackground: originalTheme.tab.hoverButtonBackground,
        disabledButtonBackground: originalTheme.tab.disabledButtonBackground,
        buttonIconSize: originalTheme.tab.buttonIconSize,
        verticalAlignment: originalTheme.tab.verticalAlignment,
        buttonsOffset: originalTheme.tab.buttonsOffset,
        buttonPadding: originalTheme.tab.buttonPadding,
        buttonsGap: originalTheme.tab.buttonsGap,
        decoration: originalTheme.tab.decoration,
        draggingDecoration: originalTheme.tab.draggingDecoration,
        draggingOpacity: originalTheme.tab.draggingOpacity,
        innerBottomBorder: originalTheme.tab.innerBottomBorder,
        innerTopBorder: originalTheme.tab.innerTopBorder,
        textStyle: originalTheme.tab.textStyle,
        padding: originalTheme.tab.padding,
        paddingWithoutButton: originalTheme.tab.paddingWithoutButton,
        margin: originalTheme.tab.margin,
        rotateCharactersInVerticalTabs:
            originalTheme.tab.rotateCharactersInVerticalTabs,
        selectedStatus: TabStatusThemeData(
          decoration: originalTheme.tab.selectedStatus.decoration,
          innerTopBorder: originalTheme.tab.selectedStatus.innerTopBorder,
          innerBottomBorder: originalTheme.tab.selectedStatus.innerBottomBorder,
          fontColor: originalTheme.tab.selectedStatus.fontColor,
          padding: originalTheme.tab.selectedStatus.padding,
          paddingWithoutButton:
              originalTheme.tab.selectedStatus.paddingWithoutButton,
          margin: originalTheme.tab.selectedStatus.margin,
          normalButtonColor: originalTheme.tab.selectedStatus.normalButtonColor,
          hoverButtonColor: originalTheme.tab.selectedStatus.hoverButtonColor,
          disabledButtonColor:
              originalTheme.tab.selectedStatus.disabledButtonColor,
          normalButtonBackground:
              originalTheme.tab.selectedStatus.normalButtonBackground,
          hoverButtonBackground:
              originalTheme.tab.selectedStatus.hoverButtonBackground,
          disabledButtonBackground:
              originalTheme.tab.selectedStatus.disabledButtonBackground,
        ),
        highlightedStatus: originalTheme.tab.highlightedStatus,
        disabledStatus: originalTheme.tab.disabledStatus,
      ),
      contentArea: ContentAreaThemeData(
        // Properties for the content area respective to the tabs.
        // Defaults are inferred from `content_area.dart`.
        decoration: originalTheme.contentArea.decoration,
        decorationNoTabsArea: originalTheme.contentArea.decorationNoTabsArea,
        padding: originalTheme.contentArea.padding,
      ),
      menu: TabbedViewMenuThemeData(
        // Properties for the hidden tabs menu.
        blur: originalTheme.menu.blur,
        maxWidth: originalTheme.menu.maxWidth,
        ellipsisOverflowText: originalTheme.menu.ellipsisOverflowText,
      ),
    );

    Widget w = TabbedViewTheme(data: themeData, child: tabbedView);
    return Scaffold(
        appBar: AppBar(title: Text('TabbedView Example (All properties)')),
        body: Container(padding: EdgeInsets.all(32), child: w));
  }
}
