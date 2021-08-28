class TabbedViewThemeConstants {
  static const double minimalIconSize = 8;
  static const double defaultIconSize = 10;

  static double normalize(double buttonIconSize) {
    if (buttonIconSize >= TabbedViewThemeConstants.minimalIconSize) {
      return buttonIconSize;
    }
    return TabbedViewThemeConstants.minimalIconSize;
  }
}
