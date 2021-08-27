import 'dart:ui';

/// [TabbedView] icons
class TabbedViewIcons {
  TabbedViewIcons._();

  static Path close(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.1100000, 0);
    path.lineTo(size.width, size.height * 0.8900000);
    path.lineTo(size.width * 0.8900000, size.height);
    path.lineTo(0, size.height * 0.1100000);
    path.close();
    path.moveTo(size.width * 0.8900000, 0);
    path.lineTo(size.width, size.height * 0.1100000);
    path.lineTo(size.width * 0.1100000, size.height);
    path.lineTo(0, size.height * 0.8900000);
    path.close();
    return path;
  }

  static Path menu(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.05000000, size.height * 0.2400000);
    path.lineTo(size.width * 0.9500000, size.height * 0.2400000);
    path.lineTo(size.width * 0.5000000, size.height * 0.7600000);
    path.close();
    return path;
  }
}
