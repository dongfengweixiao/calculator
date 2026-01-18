import 'package:flutter/material.dart';
import '../../core/theme/app_icons.dart';
import '../../l10n/app_localizations.dart';

/// Navigation item configuration
///
/// Represents a single navigation item with its route path, icon,
/// and localization key.
class NavItemConfig {
  /// The route path for this navigation item
  final String route;

  /// Icon to display in the sidebar
  final IconData icon;

  /// Localization key getter function
  final String Function(AppLocalizations) titleKey;

  const NavItemConfig({
    required this.route,
    required this.icon,
    required this.titleKey,
  });
}

/// Navigation category group configuration
class NavCategoryConfig {
  /// The localized name of this category group
  final String Function(AppLocalizations) nameKey;

  /// Navigation items in this category
  final List<NavItemConfig> items;

  const NavCategoryConfig({
    required this.nameKey,
    required this.items,
  });
}

/// All navigation categories configured for the app
///
/// This replaces the ViewMode-based navigation with a route-based
/// configuration that works with go_router.
final List<NavCategoryConfig> navCategoriesConfig = [
  // Calculator Routes
  NavCategoryConfig(
    nameKey: (l10n) => '计算器',
    items: const [
      NavItemConfig(
        route: '/standard',
        icon: CalculatorIcons.standardCalculator,
        titleKey: _standardTitle,
      ),
      NavItemConfig(
        route: '/scientific',
        icon: CalculatorIcons.scientificCalculator,
        titleKey: _scientificTitle,
      ),
      NavItemConfig(
        route: '/programmer',
        icon: CalculatorIcons.programmerCalculator,
        titleKey: _programmerTitle,
      ),
      NavItemConfig(
        route: '/date-calculation',
        icon: CalculatorIcons.dateCalculation,
        titleKey: _dateCalculationTitle,
      ),
    ],
  ),

  // Converter Routes
  NavCategoryConfig(
    nameKey: (l10n) => '转换器',
    items: const [
      NavItemConfig(
        route: '/converter/volume',
        icon: CalculatorIcons.volume,
        titleKey: _volumeTitle,
      ),
      NavItemConfig(
        route: '/converter/temperature',
        icon: CalculatorIcons.temperature,
        titleKey: _temperatureTitle,
      ),
      NavItemConfig(
        route: '/converter/length',
        icon: CalculatorIcons.length,
        titleKey: _lengthTitle,
      ),
      NavItemConfig(
        route: '/converter/weight',
        icon: CalculatorIcons.weight,
        titleKey: _weightTitle,
      ),
      NavItemConfig(
        route: '/converter/energy',
        icon: CalculatorIcons.energy,
        titleKey: _energyTitle,
      ),
      NavItemConfig(
        route: '/converter/area',
        icon: CalculatorIcons.area,
        titleKey: _areaTitle,
      ),
      NavItemConfig(
        route: '/converter/speed',
        icon: CalculatorIcons.speed,
        titleKey: _speedTitle,
      ),
      NavItemConfig(
        route: '/converter/time',
        icon: CalculatorIcons.time,
        titleKey: _timeTitle,
      ),
      NavItemConfig(
        route: '/converter/power',
        icon: CalculatorIcons.powerConverter,
        titleKey: _powerTitle,
      ),
      NavItemConfig(
        route: '/converter/data',
        icon: CalculatorIcons.data,
        titleKey: _dataTitle,
      ),
      NavItemConfig(
        route: '/converter/pressure',
        icon: CalculatorIcons.pressure,
        titleKey: _pressureTitle,
      ),
      NavItemConfig(
        route: '/converter/angle',
        icon: CalculatorIcons.angle,
        titleKey: _angleTitle,
      ),
    ],
  ),
];

// Title key functions for each route
String _standardTitle(AppLocalizations l10n) => l10n.standardMode;
String _scientificTitle(AppLocalizations l10n) => l10n.scientificMode;
String _programmerTitle(AppLocalizations l10n) => l10n.programmerMode;
String _dateCalculationTitle(AppLocalizations l10n) => l10n.dateCalculationMode;
String _volumeTitle(AppLocalizations l10n) => l10n.volumeConverterMode;
String _temperatureTitle(AppLocalizations l10n) => l10n.temperatureConverterMode;
String _lengthTitle(AppLocalizations l10n) => l10n.lengthConverterMode;
String _weightTitle(AppLocalizations l10n) => l10n.weightConverterMode;
String _energyTitle(AppLocalizations l10n) => l10n.energyConverterMode;
String _areaTitle(AppLocalizations l10n) => l10n.areaConverterMode;
String _speedTitle(AppLocalizations l10n) => l10n.speedConverterMode;
String _timeTitle(AppLocalizations l10n) => l10n.timeConverterMode;
String _powerTitle(AppLocalizations l10n) => l10n.powerConverterMode;
String _dataTitle(AppLocalizations l10n) => l10n.dataConverterMode;
String _pressureTitle(AppLocalizations l10n) => l10n.pressureConverterMode;
String _angleTitle(AppLocalizations l10n) => l10n.angleConverterMode;

/// Extension to get localized title from a route path
extension RouteTitleExtension on String {
  /// Get the localized title for this route path
  String? getTitleForRoute(AppLocalizations l10n) {
    for (final category in navCategoriesConfig) {
      for (final item in category.items) {
        if (item.route == this) {
          return item.titleKey(l10n);
        }
      }
    }
    return null;
  }
}
