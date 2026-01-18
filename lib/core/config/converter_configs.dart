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
  /// Note: Default units are now determined dynamically from the engine:
  /// - Unit 1: First unit from the engine's unit list
  /// - Unit 2: Last unit from the engine's unit list
  /// Users can change units, and their selections are persisted.
  static const Map<String, UnitConverterConfig> all = {
    'volume': UnitConverterConfig(
      categoryId: 11,
      titleKey: 'volumeConverterTitle',
    ),
    'temperature': UnitConverterConfig(
      categoryId: 2,
      titleKey: 'temperatureConverterTitle',
      showSignToggle: true,
    ),
    'length': UnitConverterConfig(
      categoryId: 0,
      titleKey: 'lengthConverterTitle',
    ),
    'weight': UnitConverterConfig(
      categoryId: 1,
      titleKey: 'weightConverterTitle',
    ),
    'energy': UnitConverterConfig(
      categoryId: 3,
      titleKey: 'energyConverterTitle',
    ),
    'area': UnitConverterConfig(
      categoryId: 4,
      titleKey: 'areaConverterTitle',
    ),
    'speed': UnitConverterConfig(
      categoryId: 5,
      titleKey: 'speedConverterTitle',
    ),
    'time': UnitConverterConfig(
      categoryId: 6,
      titleKey: 'timeConverterTitle',
    ),
    'power': UnitConverterConfig(
      categoryId: 7,
      titleKey: 'powerConverterTitle',
    ),
    'data': UnitConverterConfig(
      categoryId: 8,
      titleKey: 'dataConverterTitle',
    ),
    'pressure': UnitConverterConfig(
      categoryId: 9,
      titleKey: 'pressureConverterTitle',
    ),
    'angle': UnitConverterConfig(
      categoryId: 10,
      titleKey: 'angleConverterTitle',
    ),
  };

  static UnitConverterConfig get(String type) {
    return all[type]!;
  }

  static List<String> get allTypes => all.keys.toList();
}
