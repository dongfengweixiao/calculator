/// View mode enum
/// Represents the different calculator modes available in the UI
enum ViewMode {
  /// Standard calculator mode
  standard,

  /// Scientific calculator mode
  scientific,

  /// Programmer calculator mode
  programmer,

  /// Date calculation mode
  dateCalculation,

  /// Volume converter mode
  volumeConverter,

  /// Temperature converter mode
  temperatureConverter,

  /// Length converter mode
  lengthConverter,

  /// Weight converter mode
  weightConverter,

  /// Energy converter mode
  energyConverter,

  /// Area converter mode
  areaConverter,

  /// Speed converter mode
  speedConverter,

  /// Time converter mode
  timeConverter,

  /// Power converter mode
  powerConverter,

  /// Data converter mode
  dataConverter,

  /// Pressure converter mode
  pressureConverter,

  /// Angle converter mode
  angleConverter,
}

/// Extension on ViewMode to provide conversion and display methods
extension ViewModeExtension on ViewMode {
  /// Get the localization key for the view mode
  String get localizationKey {
    switch (this) {
      case ViewMode.standard:
        return 'standardMode';
      case ViewMode.scientific:
        return 'scientificMode';
      case ViewMode.programmer:
        return 'programmerMode';
      case ViewMode.dateCalculation:
        return 'dateCalculationMode';
      case ViewMode.volumeConverter:
        return 'volumeConverterMode';
      case ViewMode.temperatureConverter:
        return 'temperatureConverterMode';
      case ViewMode.lengthConverter:
        return 'lengthConverterMode';
      case ViewMode.weightConverter:
        return 'weightConverterMode';
      case ViewMode.energyConverter:
        return 'energyConverterMode';
      case ViewMode.areaConverter:
        return 'areaConverterMode';
      case ViewMode.speedConverter:
        return 'speedConverterMode';
      case ViewMode.timeConverter:
        return 'timeConverterMode';
      case ViewMode.powerConverter:
        return 'powerConverterMode';
      case ViewMode.dataConverter:
        return 'dataConverterMode';
      case ViewMode.pressureConverter:
        return 'pressureConverterMode';
      case ViewMode.angleConverter:
        return 'angleConverterMode';
    }
  }

  /// Get the icon label for the view mode
  String get iconLabel {
    switch (this) {
      case ViewMode.standard:
        return 'STD';
      case ViewMode.scientific:
        return 'SCI';
      case ViewMode.programmer:
        return 'PROG';
      case ViewMode.dateCalculation:
        return 'DATE';
      case ViewMode.volumeConverter:
        return 'VOLUME';
      case ViewMode.temperatureConverter:
        return 'TEMP';
      case ViewMode.lengthConverter:
        return 'LENGTH';
      case ViewMode.weightConverter:
        return 'WEIGHT';
      case ViewMode.energyConverter:
        return 'ENERGY';
      case ViewMode.areaConverter:
        return 'AREA';
      case ViewMode.speedConverter:
        return 'SPEED';
      case ViewMode.timeConverter:
        return 'TIME';
      case ViewMode.powerConverter:
        return 'POWER';
      case ViewMode.dataConverter:
        return 'DATA';
      case ViewMode.pressureConverter:
        return 'PRESSURE';
      case ViewMode.angleConverter:
        return 'ANGLE';
    }
  }
}
