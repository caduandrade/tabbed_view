import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'dart:math' as math;

/// The tab data.
///
/// The text displayed on the tab is defined by [text] parameter.
///
/// The optional [value] parameter allows associate the tab to any value.
///
/// The optional [content] parameter defines the content of the tab.
///
/// The [closable] parameter defines whether the close button is visible.
///
/// The [buttons] parameter allows you to define extra buttons in addition
/// to the Close button.
///
/// See also:
///
/// * [TabbedWiew.contentBuilder]
class TabData {
  TabData(
      {this.value,
      required this.text,
      this.buttons,
      this.content,
      this.closable = true});

  final dynamic? value;
  String text;
  List<TabButton>? buttons;
  Widget? content;
  bool closable;
}

/// Configures a tab button.
class TabButton {
  TabButton(
      {required this.icon,
      this.color,
      this.hoverColor,
      this.disabledColor,
      this.onPressed,
      this.menuBuilder,
      this.toolTip});

  final IconData icon;
  final Color? color;
  final Color? hoverColor;
  final Color? disabledColor;
  final VoidCallback? onPressed;
  final TabbedWiewMenuBuilder? menuBuilder;
  final String? toolTip;
}

class TabbedWiewMenuItem {
  TabbedWiewMenuItem({required this.text, this.onSelection});

  final String text;
  final Function? onSelection;
}

typedef TabbedWiewMenuBuilder = List<TabbedWiewMenuItem> Function(
    BuildContext context);

/// The [TabbedWiew] controller.
///
/// Stores tabs and selection tab index.
///
/// When a property is changed, the [TabbedWiew] is notified and updated appropriately.
///
/// Remember to dispose of the [TabbedWiew] when it is no longer needed. This will ensure we discard any resources used by the object.
class TabbedWiewController extends ChangeNotifier {
  factory TabbedWiewController(List<TabData> tabs) {
    return TabbedWiewController._(tabs);
  }

  TabbedWiewController._(this._tabs) {
    if (_tabs.length > 0) {
      _selectedIndex = 0;
    }
  }

  final List<TabData> _tabs;

  int? _selectedIndex;

  TabbedWiewMenuBuilder? _menuBuilder;

  UnmodifiableListView<TabData> get tabs => UnmodifiableListView(_tabs);

  /// The selected tab index
  int? get selectedIndex => _selectedIndex;

  _updateMenu(TabbedWiewMenuBuilder menuBuilder) {
    _menuBuilder = menuBuilder;
    notifyListeners();
  }

  _removeMenu() {
    _menuBuilder = null;
    notifyListeners();
  }

  set selectedIndex(int? tabIndex) {
    if (tabIndex != null) {
      _validateIndex(tabIndex);
    }
    _selectedIndex = tabIndex;
    _menuBuilder = null;
    notifyListeners();
  }

  /// Inserts [TabData] at position [index] in the [tabs].
  ///
  /// The [index] value must be non-negative and no greater than [tabs.length].
  void insertTab(int index, TabData tab) {
    _tabs.insert(index, tab);
    _afterIncTabs();
  }

  /// Adds multiple [TabData].
  addTabs(Iterable<TabData> iterable) {
    _tabs.addAll(iterable);
    _afterIncTabs();
  }

  /// Adds a [TabData].
  addTab(TabData tab) {
    _tabs.add(tab);
    _afterIncTabs();
  }

  _afterIncTabs() {
    if (_tabs.length == 1) {
      _selectedIndex = 0;
    }
    _menuBuilder = null;
    notifyListeners();
  }

  /// Removes a tab.
  removeTab(int tabIndex) {
    _validateIndex(tabIndex);
    _tabs.removeAt(tabIndex);
    if (_tabs.isEmpty) {
      _selectedIndex = null;
    } else if (_selectedIndex != null &&
        (_selectedIndex == tabIndex || _selectedIndex! >= _tabs.length)) {
      _selectedIndex = 0;
    }
    _menuBuilder = null;
    notifyListeners();
  }

  /// Removes all tabs.
  removeTabs() {
    _tabs.clear();
    _selectedIndex = null;
    _menuBuilder = null;
    notifyListeners();
  }

  _validateIndex(int tabIndex) {
    if (tabIndex < 0 || tabIndex >= _tabs.length) {
      throw IndexError(tabIndex, _tabs, 'tabIndex');
    }
  }
}

typedef OnTabClosing = bool Function(int tabIndex);

/// Propagates parameters to internal components.
class _TabbedWiewData {
  _TabbedWiewData(
      {required this.controller,
      required this.theme,
      this.contentBuilder,
      this.onTabClosing,
      required this.selectToEnableButtons,
      this.closeButtonTooltip});

  final TabbedWiewController controller;
  final TabbedViewTheme theme;
  final IndexedWidgetBuilder? contentBuilder;
  final OnTabClosing? onTabClosing;
  final bool selectToEnableButtons;
  final String? closeButtonTooltip;
}

/// Widget inspired by the classic Desktop-style tab component.
///
/// Supports customizable themes.
///
/// Parameters:
/// * [selectToEnableButtons]: allows buttons to be clicked only if the tab is
///   selected. The default value is [TRUE].
/// * [closeButtonTooltip]: optional tooltip for the close button.
class TabbedWiew extends StatefulWidget {
  TabbedWiew(
      {required TabbedWiewController controller,
      TabbedViewTheme? theme,
      IndexedWidgetBuilder? contentBuilder,
      OnTabClosing? onTabClosing,
      bool selectToEnableButtons = true,
      String? closeButtonTooltip})
      : this._data = _TabbedWiewData(
            controller: controller,
            theme: theme == null ? TabbedViewTheme.light() : theme,
            contentBuilder: contentBuilder,
            onTabClosing: onTabClosing,
            selectToEnableButtons: selectToEnableButtons,
            closeButtonTooltip: closeButtonTooltip);

  final _TabbedWiewData _data;

  @override
  State<StatefulWidget> createState() => _TabbedWiewState();
}

/// The [TabbedWiew] state.
class _TabbedWiewState extends State<TabbedWiew> {
  @override
  void initState() {
    super.initState();
    widget._data.controller.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(covariant TabbedWiew oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._data.controller != oldWidget._data.controller) {
      oldWidget._data.controller.removeListener(_rebuild);
      widget._data.controller.addListener(_rebuild);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget tabArea = _TabsArea(data: widget._data);
    _ContentArea contentArea = _ContentArea(data: widget._data);
    return Column(children: [
      Flexible(child: tabArea, flex: 0),
      Expanded(child: contentArea, flex: 2)
    ], crossAxisAlignment: CrossAxisAlignment.stretch);
  }

  _rebuild() {
    setState(() {
      // rebuild
    });
  }

  _invertMenuPopupFor(TabButton button) {
    TabbedWiewController controller = widget._data.controller;
    if (controller._menuBuilder == null && button.menuBuilder != null) {
      controller._updateMenu(button.menuBuilder!);
    } else {
      controller._removeMenu();
    }
  }

  @override
  void dispose() {
    widget._data.controller.removeListener(_rebuild);
    super.dispose();
  }
}

/// Widget for menu.
class _TabbedViewMenuWidget extends StatefulWidget {
  const _TabbedViewMenuWidget({required this.controller, required this.data});

  final TabbedWiewController controller;
  final _TabbedWiewData data;

  @override
  State<StatefulWidget> createState() => _TabbedViewMenuWidgetState();
}

/// State for [_TabbedViewMenuWidget].
class _TabbedViewMenuWidgetState extends State<_TabbedViewMenuWidget> {
  @override
  Widget build(BuildContext context) {
    MenuTheme menuTheme = widget.data.theme.menu;
    List<TabbedWiewMenuItem> items = widget.controller._menuBuilder!(context);
    bool hasDivider =
        menuTheme.dividerThickness > 0 && menuTheme.dividerColor != null;
    int itemCount = items.length;
    if (hasDivider) {
      itemCount += items.length - 1;
    }
    ListView list = ListView.builder(
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          int itemIndex = index;
          if (hasDivider) {
            itemIndex = index ~/ 2;
            if (index.isOdd) {
              return Divider(
                  height: menuTheme.dividerThickness,
                  color: menuTheme.dividerColor,
                  thickness: menuTheme.dividerThickness);
            }
          }
          return InkWell(
              child: Container(
                  padding: menuTheme.menuItemPadding,
                  child: Text(items[itemIndex].text,
                      overflow: menuTheme.ellipsisOverflowText
                          ? TextOverflow.ellipsis
                          : null)),
              hoverColor: menuTheme.hoverColor,
              onTap: () {
                widget.controller._removeMenu();
                Function? onSelection = items[itemIndex].onSelection;
                if (onSelection != null) {
                  onSelection();
                }
              });
        });

    return Container(
        margin: menuTheme.margin,
        padding: menuTheme.padding,
        child: Material(
            child: list,
            textStyle: menuTheme.textStyle,
            color: Colors.transparent),
        decoration:
            BoxDecoration(color: menuTheme.color, border: menuTheme.border));
  }
}

// Container widget for the tab content and menu.
class _ContentArea extends StatelessWidget {
  _ContentArea({required this.data});

  final _TabbedWiewData data;

  @override
  Widget build(BuildContext context) {
    TabbedWiewController controller = data.controller;
    ContentAreaTheme contentAreaTheme = data.theme.contentArea;
    Widget? child;
    if (controller.selectedIndex != null) {
      TabData tab = controller.tabs[controller.selectedIndex!];
      if (data.contentBuilder != null) {
        child = data.contentBuilder!(context, controller.selectedIndex!);
      } else {
        child = tab.content;
      }
    }

    if (controller._menuBuilder != null) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        List<Widget> children = [];
        children.add(Positioned.fill(
            child: Container(child: child, padding: contentAreaTheme.padding)));
        children.add(Positioned.fill(child: _Glass(data)));
        children.add(Positioned(
            child: LimitedBox(
                maxWidth:
                    math.min(data.theme.menu.maxWidth, constraints.maxWidth),
                child:
                    _TabbedViewMenuWidget(controller: controller, data: data)),
            right: 0,
            top: 0,
            bottom: 0));
        Widget listener = NotificationListener<SizeChangedLayoutNotification>(
            child: SizeChangedLayoutNotifier(child: Stack(children: children)),
            onNotification: (n) {
              scheduleMicrotask(() {
                controller._removeMenu();
              });
              return true;
            });
        return Container(
            child: listener, decoration: contentAreaTheme.decoration);
      });
    }

    return Container(
        child: child,
        decoration: contentAreaTheme.decoration,
        padding: contentAreaTheme.padding);
  }
}

class _Glass extends StatelessWidget {
  _Glass(this.data);

  final _TabbedWiewData data;

  @override
  Widget build(BuildContext context) {
    Widget? child;
    if (data.theme.menu.blur) {
      child = BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(color: Colors.transparent));
    }
    return ClipRect(
        child: GestureDetector(
            child: child, onTap: () => data.controller._removeMenu()));
  }
}

/// Widget for the tabs and buttons.
class _TabsArea extends StatefulWidget {
  const _TabsArea({required this.data});

  final _TabbedWiewData data;

  @override
  State<StatefulWidget> createState() => _TabsAreaState();
}

/// The [_TabsArea] state.
class _TabsAreaState extends State<_TabsArea> {
  int? _highlightedIndex;

  final _HiddenTabs hiddenTabs = _HiddenTabs();

  @override
  Widget build(BuildContext context) {
    TabbedWiewController controller = widget.data.controller;
    TabsAreaTheme tabsAreaTheme = widget.data.theme.tabsArea;
    List<Widget> children = [];
    for (int index = 0; index < controller.tabs.length; index++) {
      _TabStatus status = _getStatusFor(index);
      children.add(_TabWidget(
          index: index,
          status: status,
          data: widget.data,
          updateHighlightedIndex: _updateHighlightedIndex));
    }
    Widget tabsAreaLayout = _TabsAreaLayout(
        children: children,
        buttonsAreaBuilder: _buttonsAreaBuilder,
        theme: widget.data.theme,
        hiddenTabs: hiddenTabs,
        selectedTabIndex: controller.selectedIndex);
    tabsAreaLayout = ClipRect(child: tabsAreaLayout);

    Decoration? decoration;
    if (tabsAreaTheme.color != null || tabsAreaTheme.border != null) {
      decoration = BoxDecoration(
          color: tabsAreaTheme.color, border: tabsAreaTheme.border);
    }
    return Container(
        child: MouseRegion(child: tabsAreaLayout), decoration: decoration);
  }

  Widget _buttonsAreaBuilder(BuildContext context) {
    ButtonsAreaTheme buttonsAreaTheme = widget.data.theme.tabsArea.buttonsArea;
    Widget buttonsArea;

    if (hiddenTabs.hasHiddenTabs) {
      TabButton hiddenTabsMenuButton = TabButton(
          icon: buttonsAreaTheme.hiddenTabsMenuButtonIcon,
          menuBuilder: _hiddenTabsMenuBuilder);
      buttonsArea = _TabButtonWidget(
          button: hiddenTabsMenuButton,
          enabled: true,
          colors: buttonsAreaTheme.buttonColors,
          iconSize: buttonsAreaTheme.buttonIconSize);

      EdgeInsetsGeometry? margin;
      if (buttonsAreaTheme.offset > 0) {
        margin = EdgeInsets.only(left: buttonsAreaTheme.offset);
      }
      if (buttonsAreaTheme.decoration != null ||
          buttonsAreaTheme.padding != null ||
          margin != null) {
        buttonsArea = Container(
            child: buttonsArea,
            decoration: buttonsAreaTheme.decoration,
            padding: buttonsAreaTheme.padding,
            margin: margin);
      }
    } else {
      buttonsArea = Container();
    }
    return buttonsArea;
  }

  List<TabbedWiewMenuItem> _hiddenTabsMenuBuilder(BuildContext context) {
    List<TabbedWiewMenuItem> list = [];
    hiddenTabs.indexes.sort();
    for (int index in hiddenTabs.indexes) {
      TabData tab = widget.data.controller.tabs[index];
      list.add(TabbedWiewMenuItem(
          text: tab.text,
          onSelection: () => widget.data.controller.selectedIndex = index));
    }
    return list;
  }

  _TabStatus _getStatusFor(int tabIndex) {
    TabbedWiewController controller = widget.data.controller;
    if (controller.tabs.isEmpty || tabIndex >= controller.tabs.length) {
      throw Exception('Invalid tab index: $tabIndex');
    }

    if (controller.selectedIndex != null &&
        controller.selectedIndex == tabIndex) {
      return _TabStatus.selected;
    } else if (_highlightedIndex != null && _highlightedIndex == tabIndex) {
      return _TabStatus.highlighted;
    }
    return _TabStatus.normal;
  }

  _updateHighlightedIndex(int? tabIndex) {
    if (_highlightedIndex != tabIndex) {
      setState(() {
        _highlightedIndex = tabIndex;
      });
    }
  }
}

/// Listener for the tabs with the mouse over.
typedef _UpdateHighlightedIndex = void Function(int? tabIndex);

/// Inner enum for tab status.
enum _TabStatus { selected, highlighted, normal, disabled }

/// The tab widget. Displays the tab text and its buttons.
class _TabWidget extends StatelessWidget {
  const _TabWidget(
      {required this.index,
      required this.status,
      required this.data,
      required this.updateHighlightedIndex});

  final int index;
  final _TabStatus status;
  final _TabbedWiewData data;
  final _UpdateHighlightedIndex updateHighlightedIndex;

  @override
  Widget build(BuildContext context) {
    TabData tab = data.controller.tabs[index];
    TabsAreaTheme tabsAreaTheme = data.theme.tabsArea;
    TabTheme tabTheme = tabsAreaTheme.tab;
    TabStatusTheme statusTheme = _getTabThemeFor(status);
    ButtonColors buttonColors = statusTheme.buttonColors != null
        ? statusTheme.buttonColors!
        : tabTheme.buttonColors;

    TextStyle? textStyle = tabTheme.textStyle;
    if (statusTheme.fontColor != null) {
      if (textStyle != null) {
        textStyle = textStyle.copyWith(color: statusTheme.fontColor);
      } else {
        textStyle = TextStyle(color: statusTheme.fontColor);
      }
    }
    List<Widget> textAndButtons = [Text(tab.text, style: textStyle)];

    bool buttonsEnabled = data.selectToEnableButtons == false ||
        (data.selectToEnableButtons && status == _TabStatus.selected);
    if (tab.closable ||
        (tab.buttons != null && tab.buttons!.length > 0) &&
            tabTheme.buttonsOffset > 0) {
      textAndButtons.add(SizedBox(width: tabTheme.buttonsOffset));
    }
    bool hasButtons = tab.buttons != null && tab.buttons!.length > 0;

    if (hasButtons) {
      for (int i = 0; i < tab.buttons!.length; i++) {
        TabButton button = tab.buttons![i];
        textAndButtons.add(_TabButtonWidget(
            button: button,
            enabled: buttonsEnabled,
            colors: buttonColors,
            iconSize: tabTheme.buttonIconSize));
        if (i < tab.buttons!.length - 1 && tabTheme.buttonsGap > 0) {
          textAndButtons.add(SizedBox(width: tabTheme.buttonsGap));
        }
      }
    }
    if (tab.closable) {
      if (hasButtons && tabTheme.buttonsGap > 0) {
        textAndButtons.add(SizedBox(width: tabTheme.buttonsGap));
      }
      TabButton closeButton = TabButton(
          icon: tabsAreaTheme.closeButtonIcon,
          onPressed: () => _onClose(context, index),
          toolTip: data.closeButtonTooltip);

      textAndButtons.add(_TabButtonWidget(
          button: closeButton,
          enabled: buttonsEnabled,
          colors: buttonColors,
          iconSize: tabTheme.buttonIconSize));
    }

    CrossAxisAlignment? alignment;
    switch (tabTheme.verticalAlignment) {
      case VerticalAlignment.top:
        alignment = CrossAxisAlignment.start;
        break;
      case VerticalAlignment.center:
        alignment = CrossAxisAlignment.center;
        break;
      case VerticalAlignment.bottom:
        alignment = CrossAxisAlignment.end;
    }
    Widget textAndButtonsContainer =
        Row(children: textAndButtons, crossAxisAlignment: alignment);

    BoxDecoration? decoration = statusTheme.decoration ?? tabTheme.decoration;

    EdgeInsetsGeometry? padding = tabsAreaTheme.tab.padding;
    if (statusTheme.padding != null) {
      padding = statusTheme.padding;
    }

    Container tabContainer = Container(
        child: textAndButtonsContainer,
        padding: padding,
        decoration: decoration);

    GestureDetector gestureDetector = GestureDetector(
        onTap: () => data.controller.selectedIndex = index,
        child: tabContainer);

    MouseRegion mouseRegion = MouseRegion(
        onHover: (details) => updateHighlightedIndex(index),
        onExit: (details) => updateHighlightedIndex(null),
        child: gestureDetector);

    return mouseRegion;
  }

  _onClose(BuildContext context, int index) {
    if (data.onTabClosing == null || data.onTabClosing!(index)) {
      data.controller.removeTab(index);
      _TabbedWiewState? tabbedWiewState =
          context.findAncestorStateOfType<_TabbedWiewState>();
      tabbedWiewState?._rebuild();
    }
  }

  TabStatusTheme _getTabThemeFor(_TabStatus status) {
    TabsAreaTheme tabsAreaTheme = data.theme.tabsArea;
    switch (status) {
      case _TabStatus.selected:
        return tabsAreaTheme.tab.selectedStatus;
      case _TabStatus.highlighted:
        return tabsAreaTheme.tab.highlightedStatus;
      case _TabStatus.normal:
        return tabsAreaTheme.tab.normalStatus;
      case _TabStatus.disabled:
        return tabsAreaTheme.tab.disabledStatus;
    }
  }
}

/// Widget for tab buttons. Used for any tab button such as the close button.
class _TabButtonWidget extends StatefulWidget {
  _TabButtonWidget(
      {required this.button,
      required this.enabled,
      required this.iconSize,
      required this.colors});

  final TabButton button;
  final double iconSize;
  final ButtonColors colors;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _TabButtonWidgetState();
}

/// The [_TabButtonWidget] state.
class _TabButtonWidgetState extends State<_TabButtonWidget> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    Color color = widget.button.color != null
        ? widget.button.color!
        : widget.colors.normal;

    Color hoverColor = widget.button.hoverColor != null
        ? widget.button.hoverColor!
        : widget.colors.hover;

    bool hasEvent =
        widget.button.onPressed != null || widget.button.menuBuilder != null;

    if (hasEvent == false || widget.enabled == false) {
      Color disabledColor = widget.button.disabledColor != null
          ? widget.button.disabledColor!
          : widget.colors.disabled;
      return Icon(widget.button.icon,
          color: disabledColor, size: widget.iconSize);
    }

    Color finalColor = _hover ? hoverColor : color;
    Widget icon =
        Icon(widget.button.icon, color: finalColor, size: widget.iconSize);

    VoidCallback? onPressed = widget.button.onPressed;
    if (widget.button.menuBuilder != null) {
      onPressed = () {
        _TabbedWiewState? tabbedWiewState =
            context.findAncestorStateOfType<_TabbedWiewState>();
        tabbedWiewState?._invertMenuPopupFor(widget.button);
      };
    }

    if (widget.button.toolTip != null) {
      icon = Tooltip(
          message: widget.button.toolTip!,
          child: icon,
          waitDuration: Duration(milliseconds: 500));
    }

    return MouseRegion(
        onEnter: _onEnter,
        onExit: _onExit,
        child: GestureDetector(child: icon, onTap: onPressed));
  }

  _onEnter(PointerEnterEvent event) {
    setState(() {
      _hover = true;
    });
  }

  _onExit(PointerExitEvent event) {
    setState(() {
      _hover = false;
    });
  }
}

/// Inner widget for [_TabsArea] layout.
/// Displays the popup menu button for tabs hidden due to lack of space.
/// The selected [_TabWidget] will always be visible.
class _TabsAreaLayout extends MultiChildRenderObjectWidget {
  _TabsAreaLayout(
      {Key? key,
      required WidgetBuilder buttonsAreaBuilder,
      required List<Widget> children,
      required this.theme,
      required this.hiddenTabs,
      required this.selectedTabIndex})
      : super(
          key: key,
          children: [
            ...children,
            LayoutBuilder(
              builder: (context, constraints) {
                return buttonsAreaBuilder(context);
              },
            ),
          ],
        );

  final TabbedViewTheme theme;
  final _HiddenTabs hiddenTabs;
  final int? selectedTabIndex;

  @override
  _TabsAreaLayoutElement createElement() {
    return _TabsAreaLayoutElement(this);
  }

  @override
  _TabsAreaLayoutRenderBox createRenderObject(BuildContext context) {
    return _TabsAreaLayoutRenderBox(theme, hiddenTabs, selectedTabIndex);
  }

  @override
  void updateRenderObject(
      BuildContext context, _TabsAreaLayoutRenderBox renderObject) {
    renderObject..tabsAreaTheme = theme.tabsArea;
    renderObject..hiddenTabs = hiddenTabs;
    renderObject..selectedTabIndex = selectedTabIndex;
  }
}

/// The [_TabsAreaLayout] element.
class _TabsAreaLayoutElement extends MultiChildRenderObjectElement {
  _TabsAreaLayoutElement(_TabsAreaLayout widget) : super(widget);

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    children.forEach((child) {
      if (child.renderObject != null) {
        _TabsAreaLayoutParentData parentData =
            child.renderObject!.parentData as _TabsAreaLayoutParentData;
        if (parentData.visible) {
          visitor(child);
        }
      }
    });
  }
}

/// Holds the hidden tab indexes.
class _HiddenTabs {
  List<int> indexes = [];
  bool get hasHiddenTabs => indexes.isNotEmpty;
}

/// Constraints with value for [_TabsAreaLayout].
class _TabsAreaButtonsBoxConstraints extends BoxConstraints {
  _TabsAreaButtonsBoxConstraints({
    required _HiddenTabs hiddenTabs,
    required BoxConstraints constraints,
  })   : this.hasHiddenTabs = hiddenTabs.hasHiddenTabs,
        super(
            minWidth: constraints.minWidth,
            maxWidth: constraints.maxWidth,
            minHeight: constraints.minHeight,
            maxHeight: constraints.maxHeight);

  final bool hasHiddenTabs;

  @override
  bool operator ==(dynamic other) {
    assert(debugAssertIsValid());
    if (identical(this, other)) return true;
    if (other is! _TabsAreaButtonsBoxConstraints) return false;
    final _TabsAreaButtonsBoxConstraints typedOther = other;
    assert(typedOther.debugAssertIsValid());
    return hasHiddenTabs == typedOther.hasHiddenTabs &&
        minWidth == typedOther.minWidth &&
        maxWidth == typedOther.maxWidth &&
        minHeight == typedOther.minHeight &&
        maxHeight == typedOther.maxHeight;
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return hashValues(minWidth, maxWidth, minHeight, maxHeight, hasHiddenTabs);
  }
}

/// Parent data for [_TabsAreaLayoutRenderBox] class.
class _TabsAreaLayoutParentData extends ContainerBoxParentData<RenderBox> {
  bool visible = false;
  bool selected = false;

  double leftBorderHeight = 0;
  double rightBorderHeight = 0;

  reset() {
    visible = false;
    selected = false;

    leftBorderHeight = 0;
    rightBorderHeight = 0;
  }
}

/// Utility class to find out which tabs may be visible.
/// Calculates the required width and sets the offset value.
class _VisibleTabs {
  _VisibleTabs(this.tabsAreaTheme);

  final TabsAreaTheme tabsAreaTheme;

  List<RenderBox> _tabs = [];

  add(RenderBox tab) {
    _tabs.add(tab);
  }

  int get length => _tabs.length;

  RenderBox get(int index) {
    return _tabs[index];
  }

  /// Updates the offset given the tab width, initial offset and gap values.
  updateOffsets(BoxConstraints constraints, Size tabsAreaButtonsSize) {
    double offset = tabsAreaTheme.initialGap;
    for (int i = 0; i < _tabs.length; i++) {
      RenderBox tab = _tabs[i];
      _TabsAreaLayoutParentData tabParentData = tab.tabsAreaLayoutParentData();

      tabParentData.offset = Offset(offset, tabParentData.offset.dy);

      if (i < _tabs.length - 1) {
        offset += tab.size.width + tabsAreaTheme.middleGap;
      } else {
        offset += tab.size.width + tabsAreaTheme.minimalFinalGap;
      }
    }
  }

  /// Calculates the required width for the tab. Includes the gap values
  /// on the right.
  double requiredTabWidth(int index) {
    RenderBox tab = _tabs[index];
    if (index < _tabs.length - 1) {
      return tab.size.width + tabsAreaTheme.middleGap;
    }
    return tab.size.width + tabsAreaTheme.minimalFinalGap;
  }

  /// Calculates the required width for all tabs.
  double requiredTotalWidth() {
    double width = 0;
    for (int i = 0; i < _tabs.length; i++) {
      width += requiredTabWidth(i);
    }
    return width;
  }

  /// Removes the last non-selected tab. Returns the removed tab index.
  int? removeLastNonSelected() {
    int index = _tabs.length - 1;
    while (index >= 0) {
      RenderBox tab = _tabs[index];
      _TabsAreaLayoutParentData parentData =
          tab.parentData as _TabsAreaLayoutParentData;
      if (parentData.selected == false) {
        _tabs.removeAt(index);
        return index;
      }
      index--;
    }
    return null;
  }
}

/// The [_TabsAreaLayout] render box.
class _TabsAreaLayoutRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TabsAreaLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TabsAreaLayoutParentData> {
  _TabsAreaLayoutRenderBox(
      TabbedViewTheme theme, this.hiddenTabs, this.selectedTabIndex)
      : this.tabsAreaTheme = theme.tabsArea;

  int? selectedTabIndex;
  TabsAreaTheme tabsAreaTheme;
  _HiddenTabs hiddenTabs;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TabsAreaLayoutParentData) {
      child.parentData = _TabsAreaLayoutParentData();
    }
  }

  @override
  void performLayout() {
    List<RenderBox> children = [];
    // There will always be at least 1 child (tabs area buttons).
    visitChildren((child) {
      int currentIndex = children.length;
      final _TabsAreaLayoutParentData parentData =
          child.tabsAreaLayoutParentData();
      parentData.reset();
      parentData.selected =
          selectedTabIndex != null && selectedTabIndex == currentIndex
              ? true
              : false;
      children.add(child as RenderBox);
    });

    hiddenTabs.indexes.clear();

    // layout all (tabs + tabs area buttons)
    _VisibleTabs visibleTabs = _VisibleTabs(tabsAreaTheme);
    final BoxConstraints childConstraints =
        BoxConstraints.loose(Size(double.infinity, constraints.maxHeight));
    for (int i = 0; i < children.length; i++) {
      RenderBox child = children[i];
      child.layout(childConstraints, parentUsesSize: true);
      if (i < children.length - 1) {
        // ignoring tabs area buttons
        visibleTabs.add(child);
      }
    }

    // lastChild is the tabs area buttons and will always exist and be visible.
    // It can be an empty SizedBox, a single button or a Container with buttons.
    RenderBox tabsAreaButtons = lastChild!;

    double availableWidth = constraints.maxWidth -
        tabsAreaTheme.initialGap -
        tabsAreaButtons.size.width;

    visibleTabs.updateOffsets(constraints, tabsAreaButtons.size);
    while (visibleTabs.length > 1 &&
        visibleTabs.requiredTotalWidth() > availableWidth) {
      int? removedIndex = visibleTabs.removeLastNonSelected();
      if (removedIndex != null) {
        hiddenTabs.indexes.add(removedIndex);
      }
      visibleTabs.updateOffsets(constraints, tabsAreaButtons.size);
    }

    if (hiddenTabs.hasHiddenTabs) {
      // It performs another layout because the component can be changed
      // with hidden tabs.
      tabsAreaButtons.layout(
        _TabsAreaButtonsBoxConstraints(
            hiddenTabs: hiddenTabs, constraints: childConstraints),
        parentUsesSize: true,
      );
      availableWidth = constraints.maxWidth -
          tabsAreaTheme.initialGap -
          tabsAreaButtons.size.width;

      visibleTabs.updateOffsets(constraints, tabsAreaButtons.size);
      while (visibleTabs.length > 1 &&
          visibleTabs.requiredTotalWidth() > availableWidth) {
        int? removedIndex = visibleTabs.removeLastNonSelected();
        if (removedIndex != null) {
          hiddenTabs.indexes.add(removedIndex);
        }
        visibleTabs.updateOffsets(constraints, tabsAreaButtons.size);
      }
    }

    List<RenderBox> visibleChildren = [];
    for (int i = 0; i < visibleTabs.length; i++) {
      RenderBox tab = visibleTabs.get(i);
      final _TabsAreaLayoutParentData tabParentData =
          tab.tabsAreaLayoutParentData();
      tabParentData.visible = true;
      visibleChildren.add(tab);
    }

    if (tabsAreaButtons.size.width > 0) {
      final _TabsAreaLayoutParentData tabsAreaButtonsParentData =
          tabsAreaButtons.tabsAreaLayoutParentData();
      tabsAreaButtonsParentData.visible = true;
      // anchoring tabsAreaButtons to the right
      tabsAreaButtonsParentData.offset =
          Offset(constraints.maxWidth - tabsAreaButtons.size.width, 0);
      visibleChildren.add(tabsAreaButtons);
    }

    // Defines the biggest height to avoid displacement of tabs when
    // changing visibility.
    final double biggestChildHeight = children.fold(
      0,
      (previousValue, child) => math.max(
        previousValue,
        child.size.height,
      ),
    );

    if (tabsAreaTheme.equalHeights == EqualHeights.none) {
      // Aligning visible children.
      for (RenderBox tab in visibleChildren) {
        final _TabsAreaLayoutParentData parentData =
            tab.tabsAreaLayoutParentData();
        parentData.offset =
            Offset(parentData.offset.dx, biggestChildHeight - tab.size.height);
      }
    } else {
      final BoxConstraints childConstraints =
          BoxConstraints.tightFor(height: biggestChildHeight);
      if (tabsAreaTheme.equalHeights == EqualHeights.tabs) {
        int visibleCount = visibleChildren.length;
        if (hiddenTabs.hasHiddenTabs) {
          visibleCount--;
        }
        for (int i = 0; i < visibleCount; i++) {
          RenderBox tab = visibleChildren[i];
          tab.layout(childConstraints, parentUsesSize: true);
          final _TabsAreaLayoutParentData parentData =
              tab.tabsAreaLayoutParentData();
          parentData.offset = Offset(parentData.offset.dx, 0);
        }
        if (hiddenTabs.hasHiddenTabs) {
          RenderBox tabsAreaButtons = visibleChildren.last;
          final _TabsAreaLayoutParentData parentData =
              tabsAreaButtons.tabsAreaLayoutParentData();
          parentData.offset = Offset(parentData.offset.dx,
              biggestChildHeight - tabsAreaButtons.size.height);
        }
      } else if (tabsAreaTheme.equalHeights == EqualHeights.all) {
        for (RenderBox child in visibleChildren) {
          child.layout(childConstraints, parentUsesSize: true);
          final _TabsAreaLayoutParentData parentData =
              child.tabsAreaLayoutParentData();
          parentData.offset = Offset(parentData.offset.dx, 0);
        }
      }
    }

    size =
        constraints.constrain(Size(constraints.maxWidth, biggestChildHeight));
  }

  void visitVisibleChildren(RenderObjectVisitor visitor) {
    visitChildren((child) {
      if (child.tabsAreaLayoutParentData().visible) {
        visitor(child);
      }
    });
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    visitVisibleChildren(visitor);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    List<RenderBox> visibleTabs = [];
    visitVisibleChildren((RenderObject child) {
      final _TabsAreaLayoutParentData childParentData =
          child.tabsAreaLayoutParentData();
      if (childParentData.visible) {
        context.paintChild(child, childParentData.offset + offset);
        if (child != lastChild) {
          visibleTabs.add(child as RenderBox);
        }
      }
    });

    Canvas canvas = context.canvas;

    Paint? gapBorderPaint;
    if (tabsAreaTheme.gapBottomBorder.style == BorderStyle.solid &&
        tabsAreaTheme.gapBottomBorder.width > 0) {
      gapBorderPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = tabsAreaTheme.gapBottomBorder.color;
    }
    double top = offset.dy;
    double left = offset.dx;
    double topGap = top + size.height - tabsAreaTheme.gapBottomBorder.width;

    // initial gap
    if (tabsAreaTheme.initialGap > 0 && gapBorderPaint != null) {
      canvas.drawRect(
          Rect.fromLTWH(left, topGap, tabsAreaTheme.initialGap,
              tabsAreaTheme.gapBottomBorder.width),
          gapBorderPaint);
    }
    left += tabsAreaTheme.initialGap;

    for (int i = 0; i < visibleTabs.length; i++) {
      RenderBox tab = visibleTabs[i];
      _TabsAreaLayoutParentData tabParentData = tab.tabsAreaLayoutParentData();
      if (tabParentData.visible) {
        left += tab.size.width;

        // right gap
        if (tabsAreaTheme.middleGap > 0 && gapBorderPaint != null) {
          canvas.drawRect(
              Rect.fromLTWH(left, topGap, tabsAreaTheme.middleGap,
                  tabsAreaTheme.gapBottomBorder.width),
              gapBorderPaint);
        }
        left += tabsAreaTheme.middleGap;
      }
    }

    // fill last gap
    if (gapBorderPaint != null) {
      double lastX;
      if (visibleTabs.length > 0) {
        RenderBox lastTab = visibleTabs.last;
        _TabsAreaLayoutParentData tabParentData =
            lastTab.tabsAreaLayoutParentData();
        lastX = tabParentData.offset.dx + lastTab.size.width;
      } else {
        lastX = offset.dx + tabsAreaTheme.initialGap;
      }

      RenderBox? tabsAreaButtons = lastChild!;
      double lastGapWidth =
          size.width - lastX - tabsAreaButtons.size.width + offset.dx;
      if (lastGapWidth > 0) {
        canvas.drawRect(
            Rect.fromLTWH(lastX, topGap, lastGapWidth,
                tabsAreaTheme.gapBottomBorder.width),
            gapBorderPaint);
      }
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    visitVisibleChildren((renderObject) {
      final RenderBox child = renderObject as RenderBox;
      final _TabsAreaLayoutParentData childParentData =
          child.tabsAreaLayoutParentData();
      result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
    });

    return false;
  }
}

/// Utility extension to facilitate obtaining parent data.
extension _TabsAreaLayoutParentDataGetter on RenderObject {
  _TabsAreaLayoutParentData tabsAreaLayoutParentData() {
    return this.parentData as _TabsAreaLayoutParentData;
  }
}
