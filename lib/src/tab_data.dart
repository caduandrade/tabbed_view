import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'tab_leading_builder.dart';
import 'typedefs/tab_buttons_builder.dart';

/// The tab data.
///
/// The text displayed on the tab is defined by [text] parameter.
///
/// The [id] defines the identity of the tab and must be stable across
///  rebuilds. It is used internally to manage selection, reordering, and
///   state preservation.
///
/// The optional [value] parameter allows associate the tab to any value.
///
/// The optional [view] is the content associated with this tab, displayed
/// in the main area of a [TabbedView] when the tab is selected.
///
/// This is not the visual representation of the tab itself (such as its
/// label or icon), but the primary content shown for this tab.
///
/// If a [viewBuilder] is provided to [TabbedView], it takes precedence
/// over this property.
///
/// The [closable] parameter defines whether the Close button is visible.
///
/// The [buttonsBuilder] parameter allows you to define extra buttons in addition
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
/// The [textProvider] parameter if defined, overrides the static text property.
/// While it is called during the initial build, it is highly recommended to use
/// it in conjunction with the [listenable] to enable reactive updates to the tab label.
///
/// When used with [TabbedView.declarative], changes to this object
/// do not automatically trigger UI updates. The caller must rebuild
/// the [TabbedView] with updated data.
///
/// See also:
///
/// * [TabbedView.viewBuilder]
class TabData extends ChangeNotifier {
  TabData({
    required this.id,
    Object? value,
    String? text,
    this.textProvider,
    String? tooltip,
    TabButtonsBuilder? buttonsBuilder,
    Widget? view,
    this.listenable,
    TabLeadingBuilder? leading,
    bool closable = true,
    double? textSize,
    this.draggable = true,
    this.keepAlive = false,
  })  : _value = value,
        _text = text,
        _tooltip = tooltip,
        _leading = leading,
        _closable = closable,
        _view = view,
        _buttonsBuilder = buttonsBuilder,
        _textSize = textSize != null ? math.max(0, textSize) : null,
        _tabKey = ValueKey(id),
        _contentKey = keepAlive ? GlobalObjectKey(id) : ValueKey(id);

  /// The unique identifier of this tab.
  final Object id;

  /// Identifies the content of the tab in the tree
  final Key _tabKey;

  final Listenable? listenable;

  final TabTextProvider? textProvider;

  /// Identifies the content of the tab in the tree
  final Key _contentKey;
  final bool keepAlive;

  final bool draggable;

  Object? _value;
  Object? get value => _value;
  set value(Object? value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }

  TabButtonsBuilder? _buttonsBuilder;
  TabButtonsBuilder? get buttonsBuilder => _buttonsBuilder;
  set buttonsBuilder(TabButtonsBuilder? value) {
    _buttonsBuilder = value;
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

  Widget? _view;
  Widget? get view => _view;
  set view(Widget? view) {
    if (_view != view) {
      _view = view;
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

  String? _tooltip;
  String? get tooltip => _tooltip;
  set tooltip(String? value) {
    if (_tooltip != value) {
      _tooltip = value;
      notifyListeners();
    }
  }

  String? _text;
  String? get text => _text;
  set text(String? value) {
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
}

typedef TabTextProvider = String Function();

@internal
class TabDataHelper {
  static Key contentKey(TabData tab) => tab._contentKey;
  static Key tabKey(TabData tab) => tab._tabKey;

  static bool assertUniqueIds(List<TabData> tabs) {
    final seen = <Object>{};

    for (final tab in tabs) {
      if (!seen.add(tab.id)) {
        throw FlutterError(
          'Duplicate TabData id detected: ${tab.id}. '
          'Each tab must have a unique id.',
        );
      }
    }
    return true;
  }
}
