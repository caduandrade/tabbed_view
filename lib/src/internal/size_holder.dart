import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// A container used to "leak" the size of a specific inner component
/// (the tab header: text + buttons) to a distant ancestor layout.
///
/// In [tabbed_view], the widget tree for a tab often involves multiple
/// layers of decoration (e.g., [Container], [Padding], [DecoratedBox]).
/// When the main layout [RenderBox] performs its [performLayout] pass,
/// it only has direct access to the [Size] of the immediate child (the decorated tab).
///
/// Because the main layout needs the intrinsic size of the content alone
/// to perform calculations—such as determining the "largest tab" size or
/// calculating shrink thresholds—it cannot "reach inside" to get the
/// size of sub-widgets/grandkids.
///
/// The [SizeHolder], paired with a proxy [RenderObject], captures the
/// precise [Size] of the inner header during the layout phase and
/// stores it here, making it accessible to the ancestor without
/// requiring expensive multiple layout passes or complex tree walking.
@internal
class SizeHolder {
  Size? size;
}
