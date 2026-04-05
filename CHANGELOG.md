## 3.1.0

* `TabData`
  * Added `listenable` and `textProvider` for reactive UI updates.
* `TabsAreaThemeData`
  * Added `lastVisibleTabBehavior` to configure how the last remaining tab behaves when there is no space available.
* `LastVisibleTabBehavior`
  * New enum with two modes: hide (moves the tab to the overflow menu) and shrink (keeps the tab visible by reducing its width).
* Bugfix
  * `TabsAreaCrossAxisAlignment`
    * Enum was not exported.

## 3.0.0

* `TabDecoration`
  * Added support for custom tab shape.

* `TabbedViewThemeData`
  * Added a new predefined theme: `folder`. 

* `TabThemeData`
  * Added a `maxLines` parameter to allow text wrapping in tab labels, specifically designed to work in conjunction with `maxMainSize` constraints.

* `TabStyleResolver`
  * Added to provides per-tab style overrides on top of a `TabThemeData`.
  * Added support for changing the tab background color in some predefined themes.

* `TabbedView`
    * Added `TabbedView.declarative` constructor for declarative (external state) usage.

### Breaking Changes

* `TabbedView`
    * Renamed `contentBuilder` property to `viewBuilder`.
      * Updated property type from `IndexedWidgetBuilder` to `TabViewBuilder`.
      * Now receives `TabData` instead of tab index.

* `TabData`
    * Added required `id` property to uniquely identify tabs.
    * Hid `key` and `uniqueKey` properties from the public API.
    * Updated `value` property type from `dynamic` to `Object?`.
    * Renamed `content` property to `view`.
    * Per-tab styling overrides have been moved from `TabData` to `TabThemeData`.
        * The following properties were **removed** from `TabData`:
            * `normalStatusTheme`
            * `selectedStatusTheme`
            * `hoveredStatusTheme`
* `TabStatus`
    * Renamed `normal` value to `unselected`.

* `TabDecorationBuilder`
    * Replaced `TabStatus` parameter with `TabStyleContext`.

* `OnDraggableBuild`
    * Removed `controller` parameter.

* `CanDrop`
    * Removed `target` parameter.

* `OnBeforeDropAccept`
    * Removed `target` parameter.

* `OnTabSelection`
    * Renamed to `OnTabSelected`.
    * Updated callback signature from `(int? tabIndex, TabData? tabData)` to `(TabSelection? selection)`.    

* `OnTabRemove`
    * Renamed to `OnTabRemoved`.

* `OnTabReorder`
    * Renamed to `OnTabMoved`.

* `TabbedViewController`
    * Renamed `onTabSelection` property to `onTabSelected`.
    * Renamed `onTabRemove` property to `onTabRemoved`.
    * Renamed `onTabReorder` property to `onTabReordered`.

* `DraggableData`
    * Renamed to `DraggableTabData`.
    * Removed `controller` property.
    * Renamed `tabData` property to `tab`.

## 2.1.0

* `TabData`
  * Added the `tooltip` property.

## 2.0.0

* `TabbedView`
  * Removed the `hiddenTabsMenuItemBuilder` property.
  * Removed the `tabSelectInterceptor` property.
* `TabbedViewController`
  * Moved `reorderEnable` property to `TabbedView`.
  * Moved `onReorder` property to `TabbedView`.
  * New methods:
    * `selectTab(TabData tab)`
    * `getTabByValue(dynamic value)`
    * `selectTabByValue(dynamic value)`
* `TabStatus`
  * Renamed `highlighted` value to `hovered`.
* `TabData`
  * Renamed and refactored `buttons` property to `buttonsBuilder` to use the builder pattern.
* `TabButton`
  * The constructor was replaced by two separate constructors: `TabButton.icon` and `TabButton.menu`.
* `TabRemoveInterceptor`
  * ̀Added the `BuildContext` parameter.
* `OnTabSelection`
  * ̀Added the `tabData` parameter.
* Theme
  * Refactored theming system to fully support all tab bar positions (`top`, `bottom`, `left`, `right`).
    * Added `TabBarPosition` enum to represent the bar positions.
    * Added `SideTabsLayout` to define how side-positioned tabs (left or right) are laid out (rotated or stacked).
  * Renamed `Mobile` theme to `Underline`
  * Removed `Dark` theme.
  * Added brightness support.
  * The theme data classes are now mutable.
  * `TabbedViewThemeData`
    * New properties:
      * `divider`: The border that separates the content area from the tab bar.
  * `TabsAreaThemeData`
    * Renamed `normalButtonColor` property to `buttonColor`.
    * Renamed `hoverButtonColor` property to `hoveredButtonColor`.
    * Renamed `hoverButtonBackground` property to `hoveredButtonBackground`.
    * Allowed null `hoveredButtonColor` to inherit default color.
    * New properties:
      * `crossAxisFit`: Defines how the cross axis will fit within the tabs area.
      * `crossAxisAlignment`: Defines the alignment of tabs in relation to the main content.
      * `tabHeaderExtentSize`: Defines how tab headers are sized relative to each other along their extent.
    * Removed properties:
      * `gapBottomBorder`
      * `gapSideBorder`̀
  * `TabStatusThemeData`
    * Renamed `normalButtonColor` property to `buttonColor`.
    * Renamed `hoverButtonBackground` property to `hoveredButtonBackground`.
  * `TabThemeData`
    * Renamed `highlightedStatus` property to `hoveredStatus`.
    * Renamed `normalButtonColor` property to `buttonColor`.
    * Renamed `hoverButtonColor` property to `hoveredButtonColor`.
    * Renamed `hoverButtonBackground` property to `hoveredButtonBackground`.
    * Allowed null `hoveredButtonColor` to inherit default color.
  * `TabThemeData` and `TabStatusThemeData`
    * Removed properties:
      * `innerBottomBorder`
      * `innerTopBorder`
      * `decoration`
      * `margin`
    * New properties:
      * `decorationBuilder`: A builder for creating complex and composable tab decorators.
      * `maxMainSize`: The maximum main size of the tab.
      * `sideTabsLayout`: Define how side-positioned tabs (left or right) are laid out.
  * `ContentAreaThemeData`
    * New properties:
      * `border`: The border around the outer side of the tab content area, excluding the side adjacent to the tabs.
      * `borderRadius`: The radius used to round the corners.  
  * Replaced `HiddenTabsMenuThemeData` with `TabbedViewMenuThemeData`.
* Special thanks to Patrick Legacy for his great contributions to this release.

## 1.22.1

* Bugfix
  * Tab width doesn't grow to fit the new title set by `TabData.text`.

## 1.22.0

* `TabData`
  * Added the ability to override tab themes.

## 1.21.0

* `TabbedView`
  * Providing `TabData` in `tabCloseInterceptor`.
  * Adding `dragScope` for drag rejection.

## 1.20.0

* Added support for asynchronous tab close interception in `TabCloseInterceptor.

## 1.19.1

* Bugfix
  * Error setting text size

## 1.19.0

* Allows you to define a maximum width for the tab text.

## 1.18.1

* Bugfix
  * Fields in hidden tabs continue to receive focus when pressing TAB.

## 1.18.0

* Highlighting the tab's drop position.
* Allow dragging to reorder tabs to the last position.
* Allow dragging tabs between different `TabbedView` instances.
* Bugfix
  * Incorrect state for the index of the highlighted tab after being closed.

### Changes

* Change in the signature of `OnDraggableBuild`.
  * From: `(int tabIndex, TabData tabData)`
  * To: `(TabbedViewController controller, int tabIndex, TabData tabData)`
* `Draggable` will always be `DraggableData` type: `Draggable<DraggableData>`
* `TabsAreaThemeData`
  * New property: `dropColor`.

## 1.17.0

* Tab reordering
* `TabbedViewController`
  * New methods
    * `setTabs`
    * `reorderTab`
    * `selectedTab`
  * New property: `reorderEnable`
* New callback: `OnReorder` 
* `TabThemeData`
  * New properties
    * `draggingDecoration`
    * `draggingOpacity`
* `TabData`
  * New property: `draggable`
* New class: `DraggableConfig`
* New typedef: `OnDraggableBuild`
* `TabbedView`
  * The `draggableTabBuilder` has been replaced by `onDraggableBuild`
    * Automatic creation of a `Draggable<TabData>`
* `TabData`
  * The `uniqueKey` property has been renamed to `key`.
* Minimum sdk version required: 2.19.0

### Migrating custom drag feedback

From:
```dart
    TabbedView tabbedView = TabbedView(
        controller: _controller,
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
To:
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
```

## 1.16.0+1

* Removing the use of deprecated constructor.

## 1.16.0

* Tab leading widget

## 1.15.0

* Adding properties
  * `TabbedView.tabsAreaVisible`
  * `TabsAreaThemeData.visible`
  * `ContentAreaThemeData.decorationNoTabsArea`
* Bugfix
  * Implementing `hashCode` and `==` of the theme data. 

## 1.14.0+1

* Stopping using deprecated `hashValues` method.

## 1.14.0

* Renaming `MenuThemeData` to `TabbedViewMenuThemeData`
  * Avoiding conflict with next Flutter version.

## 1.13.0+1

* Formatting code.

## 1.13.0

* Adding interceptor for tab selection.

## 1.12.0

* Adding `getTabByIndex` method in `TabbedViewController`.
* Allowing update the following `TabData` properties: `buttons`, `closable`, `content`, `text` and `value`.

## 1.11.1

* Bugfix
  * Removing theme settings values equal to inherited ones
    * Mobile theme
      * `tab.highlightedStatus.decoration`
      * `tab.selectedStatus.decoration`

## 1.11.0

* Removing unused argument `normalStatus` from `TabThemeData`.
* `paddingWithoutButton` setting in `TabThemeData` and `TabStatusThemeData`

## 1.10.0+1

* Removing unnecessary imports

## 1.10.0

* API change
  * `ButtonColors` has been split into `normalButtonColor`, `hoverButtonColor` and `disabledButtonColor`
  * New buttons theme configurations:  
    * `buttonPadding`, `normalButtonBackground`, `hoverButtonBackground` and `disabledButtonBackground`
* Default themes have been changed to use buttons decoration
* Bug fix
  * Selected tab not being painted on top
  * Changed mouse cursor over selected tab

## 1.9.0

* Padding added to path icons to conform to Material Design standards
  * Gap of the buttons removed from the default themes
* API change
  * `IconProvider` to hold an `IconPath` or an `IconData` in the themes and `TabButton`

## 1.8.0+1

* README update

## 1.8.0

* New icons
* Default themes adjustments, such as gaps and paddings
* `buttonsGap` setting in `TabsAreaThemeData`
* `IconPath` to be used in icons drawing
* `iconSize` setting in `TabButton`
* API changes
  * `minimalIconSize` and `defaultIconSize` constants moved from `TabbedViewThemeData` to `TabbedViewThemeConstants`
  * `ButtonsAreaThemeData` properties moved to `TabsAreaThemeData`
  * `TabButton`
    * `icon` parameter renamed to `iconData`
  * `TabsAreaThemeData`
    * `closeButtonIcon` renamed to `closeIconData`
    * `hiddenTabsMenuButtonIcon` renamed to `menuIconData`
    * `tab` property moved to `TabbedViewThemeData`
    * `closeIconData` property moved to `TabThemeData`
    * `closeIconPath` property moved to `TabThemeData`

## 1.7.0

* `TabButton` padding

## 1.6.0

* API changes
  * `menuBuilder` has been removed from `TabbedViewController`
* Bug fix
  * Error building menu with empty list of `TabbedViewMenuItem`

## 1.5.0

* API changes
  * `OnTabClosing` typedef renamed to `TabCloseInterceptor`
  * Added `OnTabClose` typedef

## 1.4.0

* API changes
  * `TabbedViewTheme` refactored to be a widget following the same pattern used by Flutter's `Theme`
  * Old theme classes have been renamed
    * `TabbedViewTheme` to `TabbedViewThemeData`
    * `TabsAreaTheme` to `TabsAreaThemeData`
    * `ContentAreaTheme` to `ContentAreaThemeData`
    * `MenuTheme` to `MenuThemeData`
    * `ButtonsAreaTheme` to `ButtonsAreaThemeData`
    * `TabTheme` to `TabThemeData`
    * `TabStatusTheme` to `TabStatusThemeData`

## 1.3.1

* Bug fix
  * Tabs area overflow

## 1.3.0

* Feature for clipping tab content
* Bug fix
  * Tab area without performing the layout after tab selection

## 1.2.1

* Bug fix
  * Tabs area overflow

## 1.2.0

* Added `keepAlive` parameter to prevent loss of tab content state due to tree change during tab selection event.

## 1.1.2

* Bug fix
  * Overlap between tabs and button area

## 1.1.1

* Class name has been fixed (how embarrassing)
  * `TabbedWiew` has been renamed to `TabbedView`
  
## 1.1.0+1

* README update

## 1.1.0

* Draggable tab builder
* Bug fix
  * Divisor between tabs and content starting drawing at wrong offset

## 1.0.0+2

* README update

## 1.0.0+1

* README update

## 1.0.0

* Final version

## 0.7.0

* Tabs area buttons builder
* Theme changes
  * `light` theme has been renamed to `classic` theme

## 0.6.0

* Theme changes

## 0.5.0

* Theme changes
* Documentation
* Menu builder
* `TabbedWiewModel` has been changed to `TabbedWiewController`

## 0.4.0

* API has been changed to simplify changing themes

## 0.3.0

* Theme changes
* New themes

## 0.2.0

* First version

## 0.1.0

* Package creation