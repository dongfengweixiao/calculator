class PageIDs {
  static const settings = 'settings';
  static const standard = 'standard';
  static const scientific = 'scientific';
  static const programmer = 'programmer';
  // 单位换算类型页面ID
  static const volumeConverter = 'converter_volume';
  static const temperatureConverter = 'converter_temperature';
  static const lengthConverter = 'converter_length';
  static const weightConverter = 'converter_weight';
  static const energyConverter = 'converter_energy';
  static const areaConverter = 'converter_area';
  static const speedConverter = 'converter_speed';
  static const timeConverter = 'converter_time';
  static const powerConverter = 'converter_power';
  static const dataConverter = 'converter_data';
  static const pressureConverter = 'converter_pressure';
  static const angleConverter = 'converter_angle';

  static const replacers = {standard, scientific, programmer};

  static const permanent = {
    standard,
    scientific,
    programmer,
    settings,
    volumeConverter,
    temperatureConverter,
    lengthConverter,
    weightConverter,
    energyConverter,
    areaConverter,
    speedConverter,
    timeConverter,
    powerConverter,
    dataConverter,
    pressureConverter,
    angleConverter,
  };
}
