import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_code/language_code.dart';
import '../../core/services/persistence/preferences_service.dart';

/// Locale state
class LocaleState {
  /// Current language code ('en', 'zh', or 'system')
  final String languageCode;

  /// Current locale (null means follow system)
  final Locale? locale;

  const LocaleState({
    this.languageCode = AppLocale.system,
    this.locale,
  });

  LocaleState copyWith({String? languageCode, Locale? locale}) {
    return LocaleState(
      languageCode: languageCode ?? this.languageCode,
      locale: locale ?? this.locale,
    );
  }
}

/// Locale notifier
class LocaleNotifier extends Notifier<LocaleState> {
  @override
  LocaleState build() {
    // Load saved language from persistence
    final savedLanguage = _loadLanguage();
    return _getStateForLanguage(savedLanguage);
  }

  /// Load language from persistence
  String _loadLanguage() {
    final savedLanguage = PreferencesService.getLanguage();
    return savedLanguage ?? AppLocale.system;
  }

  /// Get state for a given language code
  LocaleState _getStateForLanguage(String languageCode) {
    switch (languageCode) {
      case AppLocale.english:
        return const LocaleState(
          languageCode: AppLocale.english,
          locale: Locale('en'),
        );
      case AppLocale.chinese:
        return const LocaleState(
          languageCode: AppLocale.chinese,
          locale: Locale('zh'),
        );
      case AppLocale.system:
      default:
        return const LocaleState(
          languageCode: AppLocale.system,
          locale: null,
        );
    }
  }

  /// Set language
  void setLanguage(String languageCode) {
    // Save to persistence
    PreferencesService.setLanguage(languageCode);

    // Update state
    state = _getStateForLanguage(languageCode);
  }

  /// Get the actual locale to use (resolves 'system' to platform locale)
  Locale? getResolvedLocale() {
    if (state.languageCode == AppLocale.system) {
      // Return null to let MaterialApp use system locale
      return null;
    }
    return state.locale;
  }
}

/// Locale provider
final localeProvider = NotifierProvider<LocaleNotifier, LocaleState>(
  LocaleNotifier.new,
);

/// Provider for the resolved locale (used in MaterialApp)
final resolvedLocaleProvider = Provider<Locale?>((ref) {
  return ref.read(localeProvider.notifier).getResolvedLocale();
});

/// Provider for list of supported languages (for settings UI)
///
/// Dynamically generates language options using the language_code package
/// to get native language names, avoiding the need for manual translations.
final supportedLanguagesProvider = Provider<List<LanguageOption>>((ref) {
  return [
    // System option (follow system locale)
    LanguageOption(
      code: AppLocale.system,
      nativeName: 'Follow System',
      englishName: 'Follow System',
      locale: null,
      flagEmoji: '🌐',
    ),
    // English
    LanguageOption(
      code: AppLocale.english,
      nativeName: LanguageCodes.en.nativeName,
      englishName: LanguageCodes.en.englishName,
      locale: const Locale('en'),
      flagEmoji: '🇺🇸',
    ),
    // Chinese
    LanguageOption(
      code: AppLocale.chinese,
      nativeName: LanguageCodes.zh.nativeName,
      englishName: LanguageCodes.zh.englishName,
      locale: const Locale('zh'),
      flagEmoji: '🇨🇳',
    ),
  ];
});

/// Language option for settings UI
class LanguageOption {
  final String code;
  final String nativeName;
  final String englishName;
  final Locale? locale;
  final String flagEmoji;

  const LanguageOption({
    required this.code,
    required this.nativeName,
    required this.englishName,
    this.locale,
    required this.flagEmoji,
  });

  /// Get display name based on current locale
  /// Shows native name if current locale matches, otherwise shows English name
  String getDisplayName(Locale? currentLocale) {
    if (code == AppLocale.system) {
      return nativeName;
    }

    // Show native name if the current locale matches this language
    if (locale != null && currentLocale != null) {
      if (currentLocale.languageCode == locale!.languageCode) {
        return nativeName;
      }
    }

    // Otherwise show English name for better usability
    return englishName;
  }
}
