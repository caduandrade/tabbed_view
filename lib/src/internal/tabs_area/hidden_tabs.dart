import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Holds the hidden tab indexes.
@internal
class HiddenTabs extends ChangeNotifier {
  List<int> _indexes = [];

  bool _hasHiddenTabs = false;
  bool get hasHiddenTabs => _hasHiddenTabs;

  List<int> get indexes {
    _indexes.sort();
    return UnmodifiableListView(_indexes);
  }

  void update(List<int> hiddenIndexes) {
    _indexes = hiddenIndexes;
    bool hasHiddenTabs = _indexes.isNotEmpty;
    if (_hasHiddenTabs != hasHiddenTabs) {
      _hasHiddenTabs = hasHiddenTabs;
      Future.microtask(() => notifyListeners());
    }
  }
}
