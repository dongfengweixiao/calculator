import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/theme/theme_provider.dart';

/// Supported app locales
class AppLocale {
  /// English locale
  static const english = 'en';

  /// Chinese locale
  static const chinese = 'zh';

  /// Follow system locale
  static const system = 'system';
}

/// Service for persisting user preferences using shared_preferences
class PreferencesService {
  /// Get the singleton instance of SharedPreferences
  static SharedPreferences? _prefs;

  /// Initialize the preferences service
  /// Must be called before using other methods
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure preferences are initialized
  static SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception(
        'PreferencesService not initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  /// Clear all preferences
  static Future<void> clearAll() async {
    await _preferences.clear();
  }

  // ====================================================================
  // Route Persistence
  // ====================================================================

  /// Key for storing the last visited route
  static const String _lastRouteKey = 'last_route';

  /// Save the last visited route
  static Future<void> setLastRoute(String route) async {
    await _preferences.setString(_lastRouteKey, route);
  }

  /// Get the last visited route
  ///
  /// Returns the stored route or null if not found
  static String? getLastRoute() {
    return _preferences.getString(_lastRouteKey);
  }

  /// Clear the last visited route
  static Future<void> clearLastRoute() async {
    await _preferences.remove(_lastRouteKey);
  }

  // ====================================================================
  // Converter Unit Persistence
  // ====================================================================

  /// Prefix for converter unit preferences
  static const String _converterUnitPrefix = 'converter_unit_';

  /// Generate key for storing converter unit selections
  static String _converterUnitKey(String converterType, int unitNumber) {
    return '$_converterUnitPrefix${converterType}_$unitNumber';
  }

  /// Save unit 1 selection for a converter type
  static Future<void> setConverterUnit1(String converterType, String unit) async {
    final key = _converterUnitKey(converterType, 1);
    await _preferences.setString(key, unit);
  }

  /// Save unit 2 selection for a converter type
  static Future<void> setConverterUnit2(String converterType, String unit) async {
    final key = _converterUnitKey(converterType, 2);
    await _preferences.setString(key, unit);
  }

  /// Get saved unit 1 for a converter type
  ///
  /// Returns null if not found
  static String? getConverterUnit1(String converterType) {
    final key = _converterUnitKey(converterType, 1);
    return _preferences.getString(key);
  }

  /// Get saved unit 2 for a converter type
  ///
  /// Returns null if not found
  static String? getConverterUnit2(String converterType) {
    final key = _converterUnitKey(converterType, 2);
    return _preferences.getString(key);
  }

  /// Clear unit selections for a converter type
  static Future<void> clearConverterUnits(String converterType) async {
    await _preferences.remove(_converterUnitKey(converterType, 1));
    await _preferences.remove(_converterUnitKey(converterType, 2));
  }

  // ====================================================================
  // Theme Mode Persistence
  // ====================================================================

  /// Key for storing theme mode preference
  static const String _themeModeKey = 'theme_mode';

  /// Save theme mode preference
  static Future<void> setThemeMode(AppThemeMode mode) async {
    await _preferences.setString(_themeModeKey, mode.name);
  }

  /// Get saved theme mode preference
  ///
  /// Returns null if not found
  static AppThemeMode? getThemeMode() {
    final modeString = _preferences.getString(_themeModeKey);
    if (modeString == null) return null;

    try {
      return AppThemeMode.values.firstWhere(
        (mode) => mode.name == modeString,
      );
    } catch (e) {
      // If the saved value is invalid, return null
      return null;
    }
  }

  /// Clear theme mode preference
  static Future<void> clearThemeMode() async {
    await _preferences.remove(_themeModeKey);
  }

  // ====================================================================
  // Language/Locale Persistence
  // ====================================================================

  /// Key for storing language preference
  static const String _languageKey = 'language';

  /// Save language preference
  static Future<void> setLanguage(String languageCode) async {
    await _preferences.setString(_languageKey, languageCode);
  }

  /// Get saved language preference
  ///
  /// Returns null if not found
  static String? getLanguage() {
    return _preferences.getString(_languageKey);
  }

  /// Clear language preference
  static Future<void> clearLanguage() async {
    await _preferences.remove(_languageKey);
  }

  /// Private constructor to prevent instantiation
  PreferencesService._();
}
