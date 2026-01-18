import 'package:flutter/material.dart';

/// Extension methods on [ThemeData]
///
/// Provides convenient theme-related utilities.
extension ThemeDataX on ThemeData {
  /// Checks if the theme is in light mode
  bool get isLight {
    return brightness == Brightness.light;
  }

  /// Checks if the theme is in dark mode
  bool get isDark {
    return brightness == Brightness.dark;
  }

  /// Gets the primary color with adjusted contrast based on theme brightness
  Color get contrastyPrimary {
    return isLight ? primaryColor : colorScheme.onPrimary;
  }

  /// Gets the standard page header text style
  TextStyle get pageHeaderStyle {
    return textTheme.headlineSmall ??
        TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        );
  }

  /// Gets the standard page description text style
  TextStyle get pageHeaderDescription {
    return textTheme.bodyMedium ??
        TextStyle(
          fontSize: 14,
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        );
  }

  /// Gets the standard page subtitle text style
  TextStyle get pageHeaderSubtitleStyle {
    return textTheme.titleMedium ??
        TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface.withValues(alpha: 0.8),
        );
  }

  /// Gets the body text style
  TextStyle get bodyTextStyle {
    return textTheme.bodyMedium ??
        TextStyle(
          fontSize: 14,
          color: colorScheme.onSurface,
        );
  }

  /// Gets the caption text style
  TextStyle get captionTextStyle {
    return textTheme.bodySmall ??
        TextStyle(
          fontSize: 12,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        );
  }
}
