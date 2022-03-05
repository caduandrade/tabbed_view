## 1.10.1

* Removing unused argument `normalStatus` from `TabThemeData`.

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
  * `ButtonsAreaThemeData` attributes moved to `TabsAreaThemeData`
  * `TabButton`
    * `icon` parameter renamed to `iconData`
  * `TabsAreaThemeData`
    * `closeButtonIcon` renamed to `closeIconData`
    * `hiddenTabsMenuButtonIcon` renamed to `menuIconData`
    * `tab` attribute moved to `TabbedViewThemeData`
    * `closeIconData` attribute moved to `TabThemeData`
    * `closeIconPath` attribute moved to `TabThemeData`

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