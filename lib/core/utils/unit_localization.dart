import '../../l10n/app_localizations.dart';

/// Mapping from engine unit names to localized display names
/// Used for volume converter and other unit converters
class UnitLocalization {
  /// Get localized display name for a unit
  ///
  /// [unitName] - The English name returned from the engine
  /// [l10n] - The AppLocalizations instance
  ///
  /// Returns the localized name if mapping exists, otherwise returns the original name
  static String getLocalizedUnitName(String unitName, AppLocalizations l10n) {
    return _getUnitName(unitName, l10n) ?? unitName;
  }

  /// Get localized unit name by mapping
  static String? _getUnitName(String unitName, AppLocalizations l10n) {
    switch (unitName) {
      // Volume units
      case 'Cubic meters':
        return l10n.cubicMeters;
      case 'Cubic centimeters':
        return l10n.cubicCentimeters;
      case 'Cubic millimeters':
        return l10n.cubicMillimeters;
      case 'Cubic yards':
        return l10n.cubicYards;
      case 'Liters':
        return l10n.liters;
      case 'Milliliters':
        return l10n.milliliters;
      case 'Cubic feet':
        return l10n.cubicFeet;
      case 'Cubic inches':
        return l10n.cubicInches;
      case 'Gallons (US)':
        return l10n.gallonsUs;
      case 'US gallons':
        return l10n.usGallons;
      case 'Gallons (UK)':
        return l10n.gallonsUk;
      case 'UK gallons':
        return l10n.ukGallons;
      case 'Fluid ounces (US)':
        return l10n.fluidOuncesUs;
      case 'US fluid ounces':
        return l10n.usFluidOunces;
      case 'Fluid ounces (UK)':
        return l10n.fluidOuncesUk;
      case 'UK fluid ounces':
        return l10n.ukFluidOunces;
      case 'Tablespoons (US)':
        return l10n.tablespoonsUs;
      case 'Tablespoons':
        return l10n.tablespoons;
      case 'Teaspoons (US)':
        return l10n.teaspoonsUs;
      case 'Teaspoons':
        return l10n.teaspoons;
      case 'Quarts (US)':
        return l10n.quartsUs;
      case 'US quarts':
        return l10n.usQuarts;
      case 'Pints (US)':
        return l10n.pintsUs;
      case 'US pints':
        return l10n.usPints;
      case 'Cups (US)':
        return l10n.cupsUs;
      case 'US cups':
        return l10n.usCups;
      case 'Quarts (UK)':
        return l10n.quartsUk;
      case 'Imperial quarts':
        return l10n.imperialQuarts;
      case 'Pints (UK)':
        return l10n.pintsUk;
      case 'Imperial pints':
        return l10n.imperialPints;
      case 'Tablespoons (UK)':
        return l10n.tablespoonsUk;
      case 'Imperial tablespoons':
        return l10n.imperialTablespoons;
      case 'Teaspoons (UK)':
        return l10n.teaspoonsUk;
      case 'Imperial teaspoons':
        return l10n.imperialTeaspoons;
      case 'Imperial gallons':
        return l10n.imperialGallons;
      case 'Imperial fluid ounces':
        return l10n.imperialFluidOunces;
      case 'US tablespoons':
        return l10n.usTablespoons;
      case 'US teaspoons':
        return l10n.usTeaspoons;
      case 'Metric cups':
        return l10n.metricCups;
      case 'Coffee cups':
        return l10n.coffeeCups;
      case 'Bathtubs':
        return l10n.bathtubs;
      case 'Swimming pools':
        return l10n.swimmingPools;
      // Temperature units
      case 'Celsius':
        return l10n.celsius;
      case 'Fahrenheit':
        return l10n.fahrenheit;
      case 'Kelvin':
        return l10n.kelvin;
      // Length units
      case 'Angstroms':
        return l10n.angstroms;
      case 'Meters':
        return l10n.meters;
      case 'Kilometers':
        return l10n.kilometers;
      case 'Centimeters':
        return l10n.centimeters;
      case 'Millimeters':
        return l10n.millimeters;
      case 'Micrometers':
        return l10n.micrometers;
      case 'Nanometers':
        return l10n.nanometers;
      case 'Nautical miles':
        return l10n.nauticalMiles;
      case 'Miles':
        return l10n.miles;
      case 'Yards':
        return l10n.yards;
      case 'Feet':
        return l10n.feet;
      case 'Inches':
        return l10n.inches;
      case 'Paperclips':
        return l10n.paperclips;
      case 'Hands':
        return l10n.handsWhimsical;
      case 'Jumbo jets':
        return l10n.jumboJets;
      // Weight units
      case 'Carats':
        return l10n.carats;
      case 'Centigrams':
        return l10n.centigrams;
      case 'Decigrams':
        return l10n.decigrams;
      case 'Decagrams':
        return l10n.decagrams;
      case 'Hectograms':
        return l10n.hectograms;
      case 'Kilograms':
        return l10n.kilograms;
      case 'Grams':
        return l10n.grams;
      case 'Milligrams':
        return l10n.milligrams;
      case 'Metric tons':
        return l10n.metricTons;
      case 'Short tons':
        return l10n.shortTons;
      case 'Pounds':
        return l10n.pounds;
      case 'Ounces':
        return l10n.ounces;
      case 'Stones':
        return l10n.stones;
      case 'Snowflakes':
        return l10n.snowflakes;
      case 'Soccer balls':
        return l10n.soccerBalls;
      case 'Elephants':
        return l10n.elephants;
      case 'Whales':
        return l10n.whales;
      // Energy units
      case 'Joules':
        return l10n.joules;
      case 'Kilojoules':
        return l10n.kilojoules;
      case 'Calories':
        return l10n.calories;
      case 'Kilocalories':
        return l10n.kilocalories;
      case 'Watt-hours':
        return l10n.wattHours;
      case 'Kilowatt-hours':
        return l10n.kilowattHours;
      case 'Electronvolts':
        return l10n.electronvolts;
      case 'Foot-pounds':
        return l10n.footPounds;
      case 'British thermal units':
        return l10n.britishThermalUnits;
      case 'Batteries':
        return l10n.batteries;
      case 'Bananas':
        return l10n.bananas;
      case 'Slices of cake':
        return l10n.slicesOfCake;
      // Area units
      case 'Square millimeters':
        return l10n.squareMillimeters;
      case 'Square meters':
        return l10n.squareMeters;
      case 'Square kilometers':
        return l10n.squareKilometers;
      case 'Square centimeters':
        return l10n.squareCentimeters;
      case 'Hectares':
        return l10n.hectares;
      case 'Square miles':
        return l10n.squareMiles;
      case 'Square yards':
        return l10n.squareYards;
      case 'Square feet':
        return l10n.squareFeet;
      case 'Square inches':
        return l10n.squareInches;
      case 'Acres':
        return l10n.acres;
      // Note: 'Hands' is already handled in length units (line ~138)
      // case 'Hands':
      //   return l10n.handsArea;
      case 'Papers':
        return l10n.papers;
      case 'Soccer fields':
        return l10n.soccerFields;
      case 'Castles':
        return l10n.castles;
      case 'Pyeong':
        return l10n.pyeong;
      // Speed units
      case 'Centimeters per second':
        return l10n.centimetersPerSecond;
      case 'Meters per second':
        return l10n.metersPerSecond;
      case 'Kilometers per hour':
        return l10n.kilometersPerHour;
      case 'Miles per hour':
        return l10n.milesPerHour;
      case 'Feet per second':
        return l10n.feetPerSecond;
      case 'Knots':
        return l10n.knots;
      case 'Mach':
        return l10n.mach;
      case 'Turtles':
        return l10n.turtles;
      case 'Horses':
        return l10n.horsesWhimsical;
      case 'Jets':
        return l10n.jets;
      // Time units
      case 'Seconds':
        return l10n.seconds;
      case 'Milliseconds':
        return l10n.milliseconds;
      case 'Microseconds':
        return l10n.microseconds;
      case 'Nanoseconds':
        return l10n.nanoseconds;
      case 'Minutes':
        return l10n.minutes;
      case 'Hours':
        return l10n.hours;
      case 'Days':
        return l10n.days;
      case 'Weeks':
        return l10n.weeks;
      case 'Years':
        return l10n.years;
      // Power units
      case 'Watts':
        return l10n.watts;
      case 'Kilowatts':
        return l10n.kilowatts;
      case 'Megawatts':
        return l10n.megawatts;
      case 'Horsepower (US)':
        return l10n.horsepowerUs;
      case 'Horsepower (metric)':
        return l10n.horsepowerMetric;
      case 'Foot-pounds/minute':
        return l10n.footPoundsPerMinute;
      case 'BTU/minute':
        return l10n.btuPerMinute;
      case 'BTU per minute':
        return l10n.btuPerMinute;
      case 'Light bulbs':
        return l10n.lightBulbs;
      // Note: 'Horses' is already handled in speed units (line ~250)
      // case 'Horses':
      //   return l10n.horsesPower;
      case 'Train engines':
        return l10n.trainEngines;
      // Data units
      case 'Bits':
        return l10n.bits;
      case 'Nibbles':
        return l10n.nibbles;
      case 'Bytes':
        return l10n.bytes;
      case 'Kilobits':
        return l10n.kilobits;
      case 'Kibibits':
        return l10n.kibibits;
      case 'Kilobytes':
        return l10n.kilobytes;
      case 'Kibibytes':
        return l10n.kibibytes;
      case 'Megabits':
        return l10n.megabits;
      case 'Mebibits':
        return l10n.mebibits;
      case 'Megabytes':
        return l10n.megabytes;
      case 'Mebibytes':
        return l10n.mebibytes;
      case 'Gigabits':
        return l10n.gigabits;
      case 'Gibibits':
        return l10n.gibibits;
      case 'Gigabytes':
        return l10n.gigabytes;
      case 'Gibibytes':
        return l10n.gibibytes;
      case 'Terabits':
        return l10n.terabits;
      case 'Tebibits':
        return l10n.tebibits;
      case 'Terabytes':
        return l10n.terabytes;
      case 'Tebibytes':
        return l10n.tebibytes;
      case 'Petabits':
        return l10n.petabits;
      case 'Pebibits':
        return l10n.pebibits;
      case 'Petabytes':
        return l10n.petabytes;
      case 'Pebibytes':
        return l10n.pebibytes;
      case 'Exabits':
        return l10n.exabits;
      case 'Exbibits':
        return l10n.exbibits;
      case 'Exabytes':
        return l10n.exabytes;
      case 'Exbibytes':
        return l10n.exbibytes;
      case 'Zetabits':
        return l10n.zetabits;
      case 'Zebibits':
        return l10n.zebibits;
      case 'Zetabytes':
        return l10n.zetabytes;
      case 'Zebibytes':
        return l10n.zebibytes;
      case 'Yottabits':
        return l10n.yottabits;
      case 'Yobibits':
        return l10n.yobibits;
      case 'Yottabytes':
        return l10n.yottabytes;
      case 'Yobibytes':
        return l10n.yobibytes;
      case 'Floppy disks':
        return l10n.floppyDisks;
      case 'CDs':
        return l10n.cds;
      case 'DVDs':
        return l10n.dvds;
      // Pressure units
      case 'Pascals':
        return l10n.pascals;
      case 'Kilopascals':
        return l10n.kilopascals;
      case 'Bars':
        return l10n.bars;
      case 'Atmospheres':
        return l10n.atmospheres;
      case 'Pounds per square inch':
        return l10n.poundsPerSquareInch;
      case 'Millimeters of mercury':
        return l10n.millimetersOfMercury;
      // Angle units
      case 'Degrees':
        return l10n.degreesAngle;
      case 'Radians':
        return l10n.radians;
      case 'Gradians':
        return l10n.gradians;
      case 'Turns':
        return l10n.turns;
      default:
        return null;
    }
  }
}
