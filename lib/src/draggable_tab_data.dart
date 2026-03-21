import 'package:meta/meta.dart';

import 'internal/tabbed_view_source.dart';
import 'tab_data.dart';
import 'tabbed_view.dart';

class DraggableTabData {
  DraggableTabData._(
      {required TabbedViewSource source,
      required TabbedViewDelegate delegate,
      required this.tab,
      required this.dragScope})
      : _source = source,
        _delegate = delegate;

  final TabbedViewSource _source;
  final TabbedViewDelegate _delegate;
  final TabData tab;
  final String? dragScope;
}

@internal
class DraggableTabDataHelper {
  static DraggableTabData build(
          {required TabbedViewSource source,
          required TabbedViewDelegate delegate,
          required TabData tab,
          required String? dragScope}) =>
      DraggableTabData._(
          source: source, delegate: delegate, tab: tab, dragScope: dragScope);
  static TabbedViewSource source({required DraggableTabData draggable}) =>
      draggable._source;
  static TabbedViewDelegate delegate({required DraggableTabData draggable}) =>
      draggable._delegate;
}
