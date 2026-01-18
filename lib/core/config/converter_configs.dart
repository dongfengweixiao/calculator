import '../../shared/widgets/unit_converter_body.dart';

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
  static const Map<String, UnitConverterConfig> all = {
    'volume': UnitConverterConfig(
      categoryId: 11,
      titleKey: 'volumeConverterTitle',
      defaultUnit1: 'Liters',
      defaultUnit2: 'Milliliters',
    ),
    'temperature': UnitConverterConfig(
      categoryId: 1,
      titleKey: 'temperatureConverterTitle',
      defaultUnit1: 'Celsius',
      defaultUnit2: 'Fahrenheit',
      showSignToggle: true,
    ),
    'length': UnitConverterConfig(
      categoryId: 3,
      titleKey: 'lengthConverterTitle',
      defaultUnit1: 'Meters',
      defaultUnit2: 'Feet',
    ),
    'weight': UnitConverterConfig(
      categoryId: 2,
      titleKey: 'weightConverterTitle',
      defaultUnit1: 'Kilograms',
      defaultUnit2: 'Pounds',
    ),
    'energy': UnitConverterConfig(
      categoryId: 6,
      titleKey: 'energyConverterTitle',
      defaultUnit1: 'Joules',
      defaultUnit2: 'Calories',
    ),
    'area': UnitConverterConfig(
      categoryId: 7,
      titleKey: 'areaConverterTitle',
      defaultUnit1: 'Square Meters',
      defaultUnit2: 'Square Feet',
    ),
    'speed': UnitConverterConfig(
      categoryId: 9,
      titleKey: 'speedConverterTitle',
      defaultUnit1: 'Meters per second',
      defaultUnit2: 'Kilometers per hour',
    ),
    'time': UnitConverterConfig(
      categoryId: 10,
      titleKey: 'timeConverterTitle',
      defaultUnit1: 'Seconds',
      defaultUnit2: 'Minutes',
    ),
    'power': UnitConverterConfig(
      categoryId: 8,
      titleKey: 'powerConverterTitle',
      defaultUnit1: 'Watts',
      defaultUnit2: 'Horsepower',
    ),
    'data': UnitConverterConfig(
      categoryId: 12,
      titleKey: 'dataConverterTitle',
      defaultUnit1: 'Bytes',
      defaultUnit2: 'Bits',
    ),
    'pressure': UnitConverterConfig(
      categoryId: 13,
      titleKey: 'pressureConverterTitle',
      defaultUnit1: 'Pascals',
      defaultUnit2: 'Atmospheres',
    ),
    'angle': UnitConverterConfig(
      categoryId: 14,
      titleKey: 'angleConverterTitle',
      defaultUnit1: 'Degrees',
      defaultUnit2: 'Radians',
    ),
  };

  static UnitConverterConfig get(String type) {
    return all[type]!;
  }

  static List<String> get allTypes => all.keys.toList();
}
