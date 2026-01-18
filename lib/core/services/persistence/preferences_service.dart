import 'package:shared_preferences/shared_preferences.dart';

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

  /// Private constructor to prevent instantiation
  PreferencesService._();
}
