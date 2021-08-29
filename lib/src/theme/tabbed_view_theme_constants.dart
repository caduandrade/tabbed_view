class TabbedViewThemeConstants {
  static const double minimalIconSize = 6;
  static const double defaultIconSize = 16;

  static double normalize(double buttonIconSize) {
    if (buttonIconSize >= TabbedViewThemeConstants.minimalIconSize) {
      return buttonIconSize;
    }
    return TabbedViewThemeConstants.minimalIconSize;
  }
}
