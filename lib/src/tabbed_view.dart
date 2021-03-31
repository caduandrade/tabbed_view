import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'dart:math' as math;

class _TabbedWiewScope {
  _TabbedWiewScope(
      {required this.theme,
      required this.model,
      this.contentBuilder,
      this.onTabClosing,
      required this.selectToEnableButtons,
      this.closeButtonTooltip});

  final TabbedViewTheme theme;
  final TabbedWiewModel model;
  final IndexedWidgetBuilder? contentBuilder;
  final OnTabClosing? onTabClosing;
  final bool selectToEnableButtons;
  final String? closeButtonTooltip;
}

class TabbedWiew extends StatefulWidget {
  TabbedWiew(
      {TabbedViewTheme? theme,
      required TabbedWiewModel model,
      IndexedWidgetBuilder? contentBuilder,
      OnTabClosing? onTabClosing,
      bool selectToEnableButtons = true,
      String? closeButtonTooltip})
      : this._scope = _TabbedWiewScope(
            theme: theme == null ? TabbedViewTheme.light() : theme,
            model: model,
            contentBuilder: contentBuilder,
            onTabClosing: onTabClosing,
            selectToEnableButtons: selectToEnableButtons,
            closeButtonTooltip: closeButtonTooltip);

  final _TabbedWiewScope _scope;

  @override
  State<StatefulWidget> createState() => _TabbedWiewState();
}

class _TabbedWiewState extends State<TabbedWiew> {
  @override
  Widget build(BuildContext context) {
    _TabbedWiewScope scope = widget._scope;
    Widget tabArea =
        _TabsArea(scope: scope, notifyTabbedWidgetChange: _notifyChange);
    _ContentArea contentArea = _ContentArea(scope: scope);
    return Column(
        children: [tabArea, Expanded(child: contentArea)],
        crossAxisAlignment: CrossAxisAlignment.stretch);
  }

  _notifyChange() {
    setState(() {
      // rebuild
    });
  }
}

class _ContentArea extends StatelessWidget {
  _ContentArea({required this.scope});

  final _TabbedWiewScope scope;

  @override
  Widget build(BuildContext context) {
    ContentAreaTheme contentAreaTheme = scope.theme.contentArea;
    Widget? child;
    if (scope.model.selectedIndex != null) {
      TabData tab = scope.model.tabs[scope.model.selectedIndex!];
      if (scope.contentBuilder != null) {
        child = scope.contentBuilder!(context, scope.model.selectedIndex!);
      } else {
        child = tab.content;
      }
    }
    ThemeData theme = Theme.of(context);
    BoxDecoration? decoration;
    if (contentAreaTheme.decoration != null &&
        contentAreaTheme.decoration is BoxDecoration) {
      decoration = contentAreaTheme.decoration! as BoxDecoration;
      if (decoration.color == null) {
        decoration = decoration.copyWith(color: theme.scaffoldBackgroundColor);
      }
    } else {
      decoration = BoxDecoration(color: theme.scaffoldBackgroundColor);
    }
    return Container(
        child: child,
        decoration: decoration,
        padding: contentAreaTheme.padding);
  }
}

class _TabsArea extends StatefulWidget {
  const _TabsArea(
      {Key? key, required this.scope, required this.notifyTabbedWidgetChange})
      : super(key: key);

  final _TabbedWiewScope scope;
  final Function notifyTabbedWidgetChange;

  @override
  State<StatefulWidget> createState() => _TabsAreaState();
}

class _TabsAreaState extends State<_TabsArea> {
  int? _highlightedIndex;

  final _HiddenTabs hiddenTabs = _HiddenTabs();

  @override
  Widget build(BuildContext context) {
    TabbedWiewModel model = widget.scope.model;
    TabsAreaTheme tabsAreaTheme = widget.scope.theme.tabsArea;
    List<Widget> children = [];
    for (int index = 0; index < model.tabs.length; index++) {
      _TabStatus status = _getStatusFor(index);
      children.add(_TabWidget(
          index: index,
          status: status,
          scope: widget.scope,
          updateHighlightedIndex: _updateHighlightedIndex,
          notifyTabbedWidgetChange: widget.notifyTabbedWidgetChange));
    }
    Widget tabsAreaLayout = _TabsAreaLayout(
        children: children,
        buttonsAreaBuilder: _buttonsAreaBuilder,
        theme: widget.scope.theme,
        hiddenTabs: hiddenTabs,
        selectedTabIndex: model.selectedIndex);
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
    ButtonsAreaTheme buttonsAreaTheme = widget.scope.theme.tabsArea.buttonsArea;
    Widget buttonsArea;

    if (hiddenTabs.hasHiddenTabs) {
      TabButton menuTabsButton = TabButton(
          icon: buttonsAreaTheme.menuTabsButtonIcon,
          popupMenuItemBuilder: _buildTabsMenu,
          onPopupMenuItemSelected: _onTabsMenuItemSelected);
      buttonsArea = _TabButtonWidget(
          button: menuTabsButton,
          enabled: true,
          theme: buttonsAreaTheme.button);

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

  _onTabsMenuItemSelected(int index) {
    setState(() {
      widget.scope.model.selectedIndex = index;
    });
  }

  List<PopupMenuEntry<int>> _buildTabsMenu(BuildContext context) {
    List<PopupMenuEntry<int>> list = [];
    hiddenTabs.indexes.sort();
    for (int index in hiddenTabs.indexes) {
      TabData tab = widget.scope.model.tabs[index];
      list.add(PopupMenuItem<int>(
        value: index,
        child: Text(tab.text),
      ));
    }
    return list;
  }

  _TabStatus _getStatusFor(int tabIndex) {
    TabbedWiewModel model = widget.scope.model;
    if (model.tabs.isEmpty || tabIndex >= model.tabs.length) {
      throw Exception('Invalid tab index: $tabIndex');
    }

    if (model.selectedIndex != null && model.selectedIndex == tabIndex) {
      return _TabStatus.selected;
    } else if (_highlightedIndex != null && _highlightedIndex == tabIndex) {
      return _TabStatus.highlighted;
    }
    return _TabStatus.normal;
  }

  _updateHighlightedIndex(int? tabIndex) {
    setState(() {
      _highlightedIndex = tabIndex;
    });
  }
}

typedef _UpdateHighlightedIndex = void Function(int? tabIndex);

enum _TabStatus { selected, highlighted, normal, disabled }

class _TabWidget extends StatelessWidget {
  const _TabWidget(
      {required this.index,
      required this.status,
      required this.scope,
      required this.updateHighlightedIndex,
      required this.notifyTabbedWidgetChange});

  final int index;
  final _TabStatus status;
  final _TabbedWiewScope scope;
  final _UpdateHighlightedIndex updateHighlightedIndex;
  final Function notifyTabbedWidgetChange;

  @override
  Widget build(BuildContext context) {
    TabData data = scope.model.tabs[index];
    TabsAreaTheme tabsAreaTheme = scope.theme.tabsArea;
    TabTheme tabTheme = tabsAreaTheme.tab;
    TabStatusTheme statusTheme = _getTabThemeFor(status);

    TextStyle? textStyle = tabTheme.textStyle;
    if (statusTheme.fontColor != null) {
      if (textStyle != null) {
        textStyle = textStyle.copyWith(color: statusTheme.fontColor);
      } else {
        textStyle = TextStyle(color: statusTheme.fontColor);
      }
    }
    List<Widget> textAndButtons = [Text(data.text, style: textStyle)];

    bool buttonsEnabled = scope.selectToEnableButtons == false ||
        (scope.selectToEnableButtons && status == _TabStatus.selected);
    if (data.closable ||
        (data.buttons != null && data.buttons!.length > 0) &&
            tabTheme.buttonsOffset > 0) {
      textAndButtons.add(SizedBox(width: tabTheme.buttonsOffset));
    }
    bool hasButtons = data.buttons != null && data.buttons!.length > 0;
    TabButtonTheme buttonTheme = tabTheme.button;
    if (hasButtons) {
      for (int i = 0; i < data.buttons!.length; i++) {
        TabButton button = data.buttons![i];
        textAndButtons.add(_TabButtonWidget(
            button: button, enabled: buttonsEnabled, theme: buttonTheme));
        if (i < data.buttons!.length - 1 && tabTheme.buttonsGap > 0) {
          textAndButtons.add(SizedBox(width: tabTheme.buttonsGap));
        }
      }
    }
    if (data.closable) {
      if (hasButtons && tabTheme.buttonsGap > 0) {
        textAndButtons.add(SizedBox(width: tabTheme.buttonsGap));
      }
      TabButton closeButton = TabButton(
          icon: tabsAreaTheme.closeButtonIcon,
          onPressed: () => _onClose(index),
          toolTip: scope.closeButtonTooltip);

      textAndButtons.add(_TabButtonWidget(
          button: closeButton, enabled: buttonsEnabled, theme: buttonTheme));
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
    if (decoration == null) {
      decoration =
          BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor);
    } else if (decoration.color == null) {
      decoration =
          decoration.copyWith(color: Theme.of(context).scaffoldBackgroundColor);
    }

    EdgeInsetsGeometry? padding = tabsAreaTheme.tab.padding;
    if (statusTheme.padding != null) {
      padding = statusTheme.padding;
    }

    Container tabContainer = Container(
        child: textAndButtonsContainer,
        padding: padding,
        decoration: decoration);

    GestureDetector gestureDetector =
        GestureDetector(onTap: _onClick, child: tabContainer);

    MouseRegion mouseRegion = MouseRegion(
        onEnter: (details) => _onEnter(details, context),
        onExit: (details) => _onExit(details, context),
        child: gestureDetector);

    return mouseRegion;
  }

  _onClick() {
    scope.model.selectedIndex = index;
    notifyTabbedWidgetChange();
  }

  _onEnter(PointerEnterEvent details, BuildContext context) {
    updateHighlightedIndex(index);
  }

  _onExit(PointerExitEvent details, BuildContext context) {
    updateHighlightedIndex(null);
  }

  _onClose(int index) {
    if (scope.onTabClosing == null || scope.onTabClosing!(index)) {
      scope.model.remove(index);
      notifyTabbedWidgetChange();
    }
  }

  TabStatusTheme _getTabThemeFor(_TabStatus status) {
    TabsAreaTheme tabsAreaTheme = scope.theme.tabsArea;
    switch (status) {
      case _TabStatus.selected:
        return tabsAreaTheme.tab.selected;
      case _TabStatus.highlighted:
        return tabsAreaTheme.tab.highlighted;
      case _TabStatus.normal:
        return tabsAreaTheme.tab.normal;
      case _TabStatus.disabled:
        return tabsAreaTheme.tab.disabled;
    }
  }
}

class _TabButtonWidget extends StatefulWidget {
  _TabButtonWidget(
      {required this.button, required this.enabled, required this.theme});

  final TabButton button;
  final TabButtonTheme theme;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _TabButtonWidgetState();
}

class _TabButtonWidgetState extends State<_TabButtonWidget> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    Color color =
        widget.button.color != null ? widget.button.color! : widget.theme.color;

    Color hoverColor = widget.button.hoverColor != null
        ? widget.button.hoverColor!
        : widget.theme.hoverColor;

    bool hasEvent = widget.button.onPressed != null ||
        (widget.button.popupMenuItemBuilder != null &&
            widget.button.onPopupMenuItemSelected != null);

    if (hasEvent == false || widget.enabled == false) {
      Color disabledColor = widget.button.disabledColor != null
          ? widget.button.disabledColor!
          : widget.theme.disabledColor;
      return Icon(widget.button.icon,
          color: disabledColor, size: widget.theme.iconSize);
    }

    Color finalColor = _hover ? hoverColor : color;
    Widget icon = Icon(widget.button.icon,
        color: finalColor, size: widget.theme.iconSize);

    if (widget.button.popupMenuItemBuilder != null) {
      // Can't disable tooltip.
      // Waiting for https://github.com/flutter/flutter/issues/60418
      return PopupMenuButton<int>(
        child: icon,
        tooltip: widget.button.toolTip,
        onSelected: widget.button.onPopupMenuItemSelected,
        itemBuilder: widget.button.popupMenuItemBuilder!,
      );
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
        child: GestureDetector(child: icon, onTap: widget.button.onPressed));
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

class _HiddenTabs {
  List<int> indexes = [];
  bool get hasHiddenTabs => indexes.isNotEmpty;
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

  double requiredTabWidth(int index) {
    RenderBox tab = _tabs[index];
    if (index < _tabs.length - 1) {
      return tab.size.width + tabsAreaTheme.middleGap;
    }
    return tab.size.width + tabsAreaTheme.minimalFinalGap;
  }

  double requiredTotalWidth() {
    double width = 0;
    for (int i = 0; i < _tabs.length; i++) {
      width += requiredTabWidth(i);
    }
    return width;
  }

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
    RenderBox? tabsAreaButtons = lastChild!;
    double lastGapWidth =
        size.width - left - tabsAreaButtons.size.width + offset.dx;
    if (lastGapWidth > 0 && gapBorderPaint != null) {
      canvas.drawRect(
          Rect.fromLTWH(
              left, topGap, lastGapWidth, tabsAreaTheme.gapBottomBorder.width),
          gapBorderPaint);
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

extension _TabsAreaLayoutParentDataGetter on RenderObject {
  _TabsAreaLayoutParentData tabsAreaLayoutParentData() {
    return this.parentData as _TabsAreaLayoutParentData;
  }
}
