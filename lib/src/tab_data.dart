import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tab_button.dart';
import 'package:tabbed_view/src/tab_leading_builder.dart';
import 'package:tabbed_view/src/tabbed_view_controller.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// The tab data.
///
/// The text displayed on the tab is defined by [text] parameter.
///
/// The optional [value] parameter allows associate the tab to any value.
///
/// The optional [content] parameter defines the content of the tab.
///
/// The [closable] parameter defines whether the Close button is visible.
///
/// The [buttons] parameter allows you to define extra buttons in addition
/// to the Close button.
///
/// The [keepAlive] parameter indicates whether to keep the tab content widget
/// in memory even if it is not visible. Indicated to prevent loss of state
/// due to tree change by tab selection. If enabled, the Widget will
/// continue to be instantiated in the tree but will remain invisible.
/// The default value is `FALSE`.
/// A more efficient alternative is to keep the data in [TabData]'s [value]
/// parameter as long as the [TabbedViewController] is being kept in the
/// state of its class.
///
/// The [normalStatusTheme] overrides the default theme for the tab
/// when it's in its regular state.
///
/// The [selectedStatusTheme] overrides the default theme to customize the
/// appearance of the tab when it is currently selected.
///
/// The [highlightedStatusTheme] overrides the default theme to change
/// the visual look of the tab when it's in a highlighted state.
///
/// See also:
///
/// * [TabbedView.contentBuilder]
class TabData extends ChangeNotifier with TabIndex {
  TabData(
      {dynamic value,
      required String text,
      List<TabButton>? buttons,
      Widget? content,
      TabLeadingBuilder? leading,
      bool closable = true,
      double? textSize,
      this.draggable = true,
      this.keepAlive = false,
      this.normalStatusTheme,
      this.highlightedStatusTheme,
      this.selectedStatusTheme})
      : _value = value,
        _text = text,
        _leading = leading,
        _closable = closable,
        _content = content,
        _buttons = buttons,
        _textSize = textSize != null ? math.max(0, textSize) : null,
        key = keepAlive ? GlobalKey() : UniqueKey();

  /// Identifies the content of the tab in the tree
  final Key key;
  final bool keepAlive;

  final bool draggable;

  dynamic _value;

  dynamic get value => _value;

  set value(dynamic value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }

  List<TabButton>? _buttons;

  List<TabButton>? get buttons => _buttons;

  set buttons(List<TabButton>? buttons) {
    _buttons = buttons;
    notifyListeners();
  }

  TabLeadingBuilder? _leading;

  TabLeadingBuilder? get leading => _leading;

  set leading(TabLeadingBuilder? leading) {
    if (_leading != leading) {
      _leading = leading;
      notifyListeners();
    }
  }

  Widget? _content;

  Widget? get content => _content;

  set content(Widget? content) {
    if (_content != content) {
      _content = content;
      notifyListeners();
    }
  }

  bool _closable;

  bool get closable => _closable;

  set closable(bool value) {
    if (_closable != value) {
      _closable = value;
      notifyListeners();
    }
  }

  String _text;

  String get text => _text;

  set text(String value) {
    if (_text != value) {
      _text = value;
      notifyListeners();
    }
  }

  double? _textSize;

  double? get textSize => _textSize;

  set textSize(double? value) {
    if (value != null) {
      value = math.max(value, 0);
    }
    if (_textSize != value) {
      _textSize = value;
      notifyListeners();
    }
  }

  final TabStatusThemeData? normalStatusTheme;
  final TabStatusThemeData? selectedStatusTheme;
  final TabStatusThemeData? highlightedStatusTheme;

  /// Gets the theme of a tab according to its status.
  TabStatusThemeData? getTabThemeFor(TabStatus status) {
    switch (status) {
      case TabStatus.normal:
        return normalStatusTheme;
      case TabStatus.selected:
        return selectedStatusTheme;
      case TabStatus.highlighted:
        return highlightedStatusTheme;
    }
  }

  final UniqueKey uniqueKey = UniqueKey();
}
