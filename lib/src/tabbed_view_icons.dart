import 'dart:ui';

/// [TabbedView] icons
class TabbedViewIcons {
  TabbedViewIcons._();

  static Path close(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.2500000, size.height * 0.2000000);
    path.lineTo(size.width * 0.8000000, size.height * 0.7500000);
    path.lineTo(size.width * 0.7500000, size.height * 0.8000000);
    path.lineTo(size.width * 0.2000000, size.height * 0.2500000);
    path.close();
    path.moveTo(size.width * 0.7500000, size.height * 0.2000000);
    path.lineTo(size.width * 0.8000000, size.height * 0.2500000);
    path.lineTo(size.width * 0.2500000, size.height * 0.8000000);
    path.lineTo(size.width * 0.2000000, size.height * 0.7500000);
    path.close();
    return path;
  }

  static Path menu(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.1500000, size.height * 0.3500000);
    path.lineTo(size.width * 0.8500000, size.height * 0.3500000);
    path.lineTo(size.width * 0.5000000, size.height * 0.7000000);
    path.close();
    return path;
  }

  static Path menuUp(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.7);
    path.lineTo(size.width * 0.85, size.height * 0.7);
    path.lineTo(size.width * 0.5, size.height * 0.35);
    path.close();
    return path;
  }

  static Path menuLeft(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.70, size.height * 0.15);
    path.lineTo(size.width * 0.70, size.height * 0.85);
    path.lineTo(size.width * 0.35, size.height * 0.50);
    path.close();
    return path;
  }

  static Path menuRight(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.35, size.height * 0.15);
    path.lineTo(size.width * 0.35, size.height * 0.85);
    path.lineTo(size.width * 0.70, size.height * 0.50);
    path.close();
    return path;
  }
}
