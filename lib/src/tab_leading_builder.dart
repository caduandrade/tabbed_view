import 'package:flutter/widgets.dart';
import 'package:tabbed_view/src/tab_status.dart';

/// Signature for a function that builds a leading widget in tab.
typedef TabLeadingBuilder = Widget? Function(
    BuildContext context, TabStatus status);
