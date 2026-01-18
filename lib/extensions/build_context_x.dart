import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

/// Extension methods on [BuildContext]
///
/// Provides convenient access to theme, localization, and media query information.
extension BuildContextX on BuildContext {
  /// Get the calculator theme from the context
  CalculatorTheme get theme {
    return CalculatorThemeProvider.of(this);
  }

  /// Get the app localizations from the context
  AppLocalizations get l10n {
    return AppLocalizations.of(this);
  }

  /// Get the media query data from the context
  MediaQueryData get mediaQuery {
    return MediaQuery.of(this);
  }

  /// Get the screen size from the context
  Size get screenSize {
    return mediaQuery.size;
  }

  /// Get the screen width from the context
  double get screenWidth {
    return screenSize.width;
  }

  /// Get the screen height from the context
  double get screenHeight {
    return screenSize.height;
  }

  /// Check if the current orientation is portrait
  bool get isPortrait {
    return mediaQuery.orientation == Orientation.portrait;
  }

  /// Check if the current orientation is landscape
  bool get isLandscape {
    return mediaQuery.orientation == Orientation.landscape;
  }

  /// Check if the window is small (width < 600)
  bool get isSmallWindow {
    return screenWidth < 600;
  }

  /// Check if the window is medium (600 <= width < 900)
  bool get isMediumWindow {
    return screenWidth >= 600 && screenWidth < 900;
  }

  /// Check if the window is wide (width >= 768)
  bool get isWideWindow {
    return screenWidth >= 768;
  }

  /// Check if the device is a tablet
  /// Returns true if the shortest side is >= 600dp
  bool get isTablet {
    final size = mediaQuery.size;
    final shortestSide = size.width < size.height ? size.width : size.height;
    return shortestSide >= 600;
  }

  /// Check if the device is a phone
  /// Returns true if the shortest side is < 600dp
  bool get isPhone {
    return !isTablet;
  }

  /// Check if the device is a mobile platform
  bool get isMobile {
    return Theme.of(this).platform == TargetPlatform.iOS ||
        Theme.of(this).platform == TargetPlatform.android;
  }

  /// Check if the device is a desktop platform
  bool get isDesktop {
    return Theme.of(this).platform == TargetPlatform.windows ||
        Theme.of(this).platform == TargetPlatform.macOS ||
        Theme.of(this).platform == TargetPlatform.linux;
  }

  /// Get the text theme from the context
  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }

  /// Check if the current theme is light mode
  bool get isLightMode {
    return theme.brightness == Brightness.light;
  }

  /// Check if the current theme is dark mode
  bool get isDarkMode {
    return theme.brightness == Brightness.dark;
  }
}
