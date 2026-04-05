/// Strategy for handling the last visible tab when there is
/// no available space in the tab bar.
enum LastVisibleTabBehavior {
  /// The last tab will be hidden and moved to the overflow menu.
  hide,

  /// The last tab will remain visible but will shrink its width
  /// to fit the remaining space.
  shrink
}
