import 'package:flutter/material.dart';

import 'tab_style_context.dart';

/// Provides per-tab style overrides on top of a [TabbedViewThemeData].
///
/// By default, a [TabbedViewThemeData] (i.e., a tab theme/renderer) applies
/// a uniform appearance to all tabs. A [TabStyleResolver] allows selectively
/// overriding visual properties for an individual tab without changing the
/// global theme.
///
/// This resolver is optional and, when provided by a theme, is consulted
/// during style resolution for each tab and [TabStatus]. Implementations may
/// return `null` to defer to the theme’s default behavior for a given property.
///
/// The base class defines only the subset of styling that is common across
/// themes (e.g., text color, padding, button colors/backgrounds). Concrete
/// themes may expose specialized subclasses with additional APIs for
/// theme-specific capabilities (e.g., multiple background colors, gradients).
///
/// Notes:
/// - Overrides are applied per tab and per status.
/// - Returning `null` means “no override” for that property.
/// - This API is intended for superficial style adjustments; structural
///   differences remain the responsibility of the theme.
abstract class TabStyleResolver {
  const TabStyleResolver();

  /// Returns the text color for the tab label, or `null` to use the theme default.
  Color? fontColor(TabStyleContext context) => null;

  /// Returns the padding for the tab content, or `null` to use the theme default.
  EdgeInsetsGeometry? padding(TabStyleContext context) => null;

  /// Returns the padding when the tab has no buttons, or `null` to use the theme default.
  EdgeInsetsGeometry? paddingWithoutButton(TabStyleContext context) => null;

  /// Returns the button icon color, or `null` to use the theme default.
  Color? buttonColor(TabStyleContext context) => null;

  /// Returns the hovered button icon color, or `null` to use the theme default.
  Color? hoveredButtonColor(TabStyleContext context) => null;

  /// Returns the disabled button icon color, or `null` to use the theme default.
  Color? disabledButtonColor(TabStyleContext context) => null;

  /// Returns the button background decoration, or `null` to use the theme default.
  Decoration? buttonBackground(TabStyleContext context) => null;

  /// Returns the hovered button background decoration, or `null` to use the theme default.
  Decoration? hoveredButtonBackground(TabStyleContext context) => null;

  /// Returns the disabled button background decoration, or `null` to use the theme default.
  Decoration? disabledButtonBackground(TabStyleContext context) => null;
}

class UnderlineTabStyleResolver extends TabStyleResolver {
  /// Returns the underline color, or `null` to use the theme default.
  Color? underlineColor(TabStyleContext context) => null;

  /// Returns the background color, or `null` to use the theme default.
  Color? backgroundColor(TabStyleContext context) => null;
}

class MinimalistTabStyleResolver extends TabStyleResolver {
  /// Returns the background color, or `null` to use the theme default.
  Color? backgroundColor(TabStyleContext context) => null;
}

class FolderTabStyleResolver extends TabStyleResolver {
  /// Returns the selected background color, or `null` to use the theme default.
  Color? backgroundColor(TabStyleContext context) => null;
}
