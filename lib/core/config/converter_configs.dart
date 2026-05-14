import 'package:flutter/material.dart';

import '../theme/app_icons.dart';

/// Configuration for unit converter
class UnitConverterConfig {
  /// Category ID from the converter engine
  final int categoryId;

  /// Page title localization key
  final String titleKey;

  /// Whether to show sign toggle button (±)
  final bool showSignToggle;

  /// Icon for the converter
  final IconData icon;

  const UnitConverterConfig({
    required this.categoryId,
    required this.titleKey,
    required this.icon,
    this.showSignToggle = false,
  });
}

/// Centralized configuration for all unit converters.
///
/// This class maps converter types (route path segments) to their
/// configuration parameters, eliminating the need for separate *ConverterBody
/// wrapper classes.
///
/// Example:
/// ```dart
/// final config = ConverterConfigs.get('volume');
/// // Same as: VolumeConverterBody(config: config)
/// ```
///
/// All converters use the same [UnitConverterBody] implementation,
/// differing only in their configuration parameters.
///
/// See also:
/// - [UnitConverterBody] - The generic converter UI component
/// - [UnitConverterConfig] - Configuration data class
class ConverterConfigs {
  /// All converter configurations keyed by their type identifier.
  ///
  /// Keys match the route path segments used in go_router:
  /// - '/converter/volume' -> 'volume'
  /// - '/converter/temperature' -> 'temperature'
  ///
  /// Note: Default units are now determined dynamically from the engine:
  /// - Unit 1: First unit from the engine's unit list
  /// - Unit 2: Last unit from the engine's unit list
  /// Users can change units, and their selections are persisted.
  static const Map<String, UnitConverterConfig> all = {
    'volume': UnitConverterConfig(
      categoryId: 11,
      titleKey: 'volumeConverterTitle',
      icon: CalculatorIcons.volume,
    ),
    'temperature': UnitConverterConfig(
      categoryId: 2,
      titleKey: 'temperatureConverterTitle',
      showSignToggle: true,
      icon: CalculatorIcons.temperature,
    ),
    'length': UnitConverterConfig(
      categoryId: 0,
      titleKey: 'lengthConverterTitle',
      icon: CalculatorIcons.length,
    ),
    'weight': UnitConverterConfig(
      categoryId: 1,
      titleKey: 'weightConverterTitle',
      icon: CalculatorIcons.weight,
    ),
    'energy': UnitConverterConfig(
      categoryId: 3,
      titleKey: 'energyConverterTitle',
      icon: CalculatorIcons.energy,
    ),
    'area': UnitConverterConfig(
      categoryId: 4,
      titleKey: 'areaConverterTitle',
      icon: CalculatorIcons.area,
    ),
    'speed': UnitConverterConfig(
      categoryId: 5,
      titleKey: 'speedConverterTitle',
      icon: CalculatorIcons.speed,
    ),
    'time': UnitConverterConfig(
      categoryId: 6,
      titleKey: 'timeConverterTitle',
      icon: CalculatorIcons.time,
    ),
    'power': UnitConverterConfig(
      categoryId: 7,
      titleKey: 'powerConverterTitle',
      showSignToggle: true,
      icon: CalculatorIcons.power,
    ),
    'data': UnitConverterConfig(
      categoryId: 8,
      titleKey: 'dataConverterTitle',
      icon: CalculatorIcons.data,
    ),
    'pressure': UnitConverterConfig(
      categoryId: 9,
      titleKey: 'pressureConverterTitle',
      icon: CalculatorIcons.pressure,
    ),
    'angle': UnitConverterConfig(
      categoryId: 10,
      titleKey: 'angleConverterTitle',
      showSignToggle: true,
      icon: CalculatorIcons.angle,
    ),
  };

  static UnitConverterConfig get(String type) {
    return all[type]!;
  }

  static List<String> get allTypes => all.keys.toList();
}
