import 'dart:ui';

import 'package:tabbed_view/src/icon_path.dart';

/// Menu icon
class MenuIconPath extends IconPath {
  const MenuIconPath();

  @override
  Path build(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.05000000, size.height * 0.2400000);
    path.lineTo(size.width * 0.9500000, size.height * 0.2400000);
    path.lineTo(size.width * 0.5000000, size.height * 0.7600000);
    path.close();
    return path;
  }
}
