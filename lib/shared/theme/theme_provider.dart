import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/persistence/preferences_service.dart';

/// App theme mode (light, dark, system)
enum AppThemeMode { light, dark, system }

/// Extension to convert AppThemeMode to Flutter's ThemeMode
extension AppThemeModeX on AppThemeMode {
  ThemeMode toFlutterThemeMode() {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

/// Theme state
class ThemeState {
  final AppThemeMode mode;
  final CalculatorTheme theme;

  const ThemeState({
    this.mode = AppThemeMode.dark,
    this.theme = CalculatorTheme.dark,
  });

  ThemeState copyWith({AppThemeMode? mode, CalculatorTheme? theme}) {
    return ThemeState(mode: mode ?? this.mode, theme: theme ?? this.theme);
  }
}

/// Theme notifier
class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    // Load saved theme mode from persistence
    final savedMode = _loadThemeMode();
    return ThemeState(mode: savedMode, theme: _getThemeForMode(savedMode));
  }

  /// Load theme mode from persistence
  AppThemeMode _loadThemeMode() {
    final savedMode = PreferencesService.getThemeMode();
    return savedMode ?? AppThemeMode.dark;
  }

  /// Get theme for a given mode
  CalculatorTheme _getThemeForMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return CalculatorTheme.light;
      case AppThemeMode.dark:
        return CalculatorTheme.dark;
      case AppThemeMode.system:
        // For system mode, we'll determine the actual theme based on platform brightness
        // The actual theme will be resolved by MaterialApp.themeMode
        return CalculatorTheme.dark; // Default fallback
    }
  }

  /// Set theme mode
  void setThemeMode(AppThemeMode mode) {
    // Save to persistence
    PreferencesService.setThemeMode(mode);

    // Update state
    state = ThemeState(mode: mode, theme: _getThemeForMode(mode));
  }

  /// Toggle between light and dark (ignoring system mode)
  void toggleTheme() {
    final newMode = state.mode == AppThemeMode.dark ? AppThemeMode.light : AppThemeMode.dark;
    setThemeMode(newMode);
  }
}

/// Theme provider
final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

/// Convenience provider for just the calculator theme
final calculatorThemeProvider = Provider<CalculatorTheme>((ref) {
  return ref.watch(themeProvider).theme;
});

/// Convenience provider for Flutter's Brightness
final brightnessProvider = Provider<Brightness>((ref) {
  return ref.watch(themeProvider).theme.brightness;
});

/// Provider for Flutter's ThemeMode (used in MaterialApp)
final flutterThemeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeProvider).mode.toFlutterThemeMode();
});
