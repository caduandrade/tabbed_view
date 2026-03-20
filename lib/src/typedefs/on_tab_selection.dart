import '../tab_data.dart';

/// Event that will be triggered when the tab selection is changed.
typedef OnTabSelection = void Function(TabSelection? selection);

class TabSelection {
  const TabSelection({required this.tabIndex, required this.tabData});

  final int tabIndex;
  final TabData tabData;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabSelection &&
          runtimeType == other.runtimeType &&
          tabIndex == other.tabIndex &&
          tabData == other.tabData;

  @override
  int get hashCode => Object.hash(tabIndex, tabData);
}
