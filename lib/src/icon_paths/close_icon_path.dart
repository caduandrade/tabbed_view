import 'dart:ui';

import 'package:tabbed_view/src/icon_path.dart';

/// Close icon
class CloseIconPath extends IconPath {
  const CloseIconPath();

  @override
  Path build(Size size) {
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
}
