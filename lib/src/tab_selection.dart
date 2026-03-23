import 'tab_data.dart';

class TabSelection {
  const TabSelection({required this.index, required this.tab});

  final int index;
  final TabData tab;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabSelection &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          tab == other.tab;

  @override
  int get hashCode => Object.hash(index, tab);
}
