import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// Name for the standard calculator mode
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standardMode;

  /// Name for the scientific calculator mode
  ///
  /// In en, this message translates to:
  /// **'Scientific'**
  String get scientificMode;

  /// Name for the programmer calculator mode
  ///
  /// In en, this message translates to:
  /// **'Programmer'**
  String get programmerMode;

  /// Name for the date calculation mode
  ///
  /// In en, this message translates to:
  /// **'Date Calculation'**
  String get dateCalculationMode;

  /// Name for the volume converter mode
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volumeConverterMode;

  /// History panel tab label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Memory panel tab label
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memory;

  /// Title shown when history is empty
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryTitle;

  /// Message shown when history is empty
  ///
  /// In en, this message translates to:
  /// **'No history records yet'**
  String get noHistoryMessage;

  /// Title shown when memory is empty
  ///
  /// In en, this message translates to:
  /// **'Memory is empty'**
  String get noMemoryTitle;

  /// Message shown when memory is empty
  ///
  /// In en, this message translates to:
  /// **'No data in memory'**
  String get noMemoryMessage;

  /// Hint shown when memory is empty
  ///
  /// In en, this message translates to:
  /// **'Use memory buttons to store numbers'**
  String get noMemoryHint;

  /// Degree angle unit
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get degree;

  /// Radian angle unit
  ///
  /// In en, this message translates to:
  /// **'Radian'**
  String get radian;

  /// Gradian angle unit
  ///
  /// In en, this message translates to:
  /// **'Grad'**
  String get gradian;

  /// Shift operation
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get shift;

  /// Bitwise operation
  ///
  /// In en, this message translates to:
  /// **'Bitwise'**
  String get bitwise;

  /// Full keypad input mode
  ///
  /// In en, this message translates to:
  /// **'Full Keypad'**
  String get fullKeypad;

  /// Bit flip input mode
  ///
  /// In en, this message translates to:
  /// **'Bit Flip'**
  String get bitFlip;

  /// Arithmetic shift mode
  ///
  /// In en, this message translates to:
  /// **'Arithmetic Shift'**
  String get arithmeticShift;

  /// Logical shift mode
  ///
  /// In en, this message translates to:
  /// **'Logical Shift'**
  String get logicalShift;

  /// Rotate shift mode
  ///
  /// In en, this message translates to:
  /// **'Rotate Shift'**
  String get rotateShift;

  /// Rotate through carry shift mode
  ///
  /// In en, this message translates to:
  /// **'Rotate Through Carry'**
  String get rotateCarryShift;

  /// Hexadecimal
  ///
  /// In en, this message translates to:
  /// **'HEX'**
  String get hex;

  /// Decimal
  ///
  /// In en, this message translates to:
  /// **'DEC'**
  String get dec;

  /// Octal
  ///
  /// In en, this message translates to:
  /// **'OCT'**
  String get oct;

  /// Binary
  ///
  /// In en, this message translates to:
  /// **'BIN'**
  String get bin;

  /// Quadword
  ///
  /// In en, this message translates to:
  /// **'QWORD'**
  String get qword;

  /// Doubleword
  ///
  /// In en, this message translates to:
  /// **'DWORD'**
  String get dword;

  /// Word
  ///
  /// In en, this message translates to:
  /// **'WORD'**
  String get word;

  /// Byte
  ///
  /// In en, this message translates to:
  /// **'BYTE'**
  String get byte;

  /// Title for date calculation page
  ///
  /// In en, this message translates to:
  /// **'Date Calculation'**
  String get dateCalculationTitle;

  /// Option to calculate difference between two dates
  ///
  /// In en, this message translates to:
  /// **'Calculate Difference Between Dates'**
  String get calculateDifferenceBetweenDates;

  /// Option to add or subtract duration from a date
  ///
  /// In en, this message translates to:
  /// **'Add or Subtract from Date'**
  String get addOrSubtractFromDate;

  /// Label for the starting date in date difference calculation
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// Label for the ending date in date difference calculation
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// Label for the starting date in add/subtract calculation
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// Add operation for date calculation
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Subtract operation for date calculation
  ///
  /// In en, this message translates to:
  /// **'Subtract'**
  String get subtract;

  /// Years time unit
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// Months label for date offset
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// Days time unit
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// Label for date difference result
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get difference;

  /// Label for calculation result
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// Placeholder text when no date is selected
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// Message shown when dates are not selected
  ///
  /// In en, this message translates to:
  /// **'Select both dates'**
  String get selectBothDates;

  /// Singular form of year
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// Plural form of years
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years_plural;

  /// Singular form of month
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// Plural form of months
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months_plural;

  /// Singular form of week
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// Plural form of weeks
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get weeks_plural;

  /// Singular form of day
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// Plural form of days
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days_plural;

  /// Title for volume converter page
  ///
  /// In en, this message translates to:
  /// **'Volume Converter'**
  String get volumeConverterTitle;

  /// Label for from unit field
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromUnit;

  /// Label for to unit field
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toUnit;

  /// Cubic meters unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Meters'**
  String get cubicMeters;

  /// Cubic centimeters unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Centimeters'**
  String get cubicCentimeters;

  /// Cubic millimeters unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Millimeters'**
  String get cubicMillimeters;

  /// Cubic yards unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Yards'**
  String get cubicYards;

  /// Liters unit
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get liters;

  /// Milliliters unit
  ///
  /// In en, this message translates to:
  /// **'Milliliters'**
  String get milliliters;

  /// Cubic feet unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Feet'**
  String get cubicFeet;

  /// Cubic inches unit
  ///
  /// In en, this message translates to:
  /// **'Cubic Inches'**
  String get cubicInches;

  /// US gallons unit
  ///
  /// In en, this message translates to:
  /// **'US Gallons'**
  String get usGallons;

  /// UK gallons unit
  ///
  /// In en, this message translates to:
  /// **'UK Gallons'**
  String get ukGallons;

  /// US fluid ounces unit
  ///
  /// In en, this message translates to:
  /// **'US Fluid Ounces'**
  String get usFluidOunces;

  /// UK fluid ounces unit
  ///
  /// In en, this message translates to:
  /// **'UK Fluid Ounces'**
  String get ukFluidOunces;

  /// Tablespoons unit
  ///
  /// In en, this message translates to:
  /// **'Tablespoons'**
  String get tablespoons;

  /// Teaspoons unit
  ///
  /// In en, this message translates to:
  /// **'Teaspoons'**
  String get teaspoons;

  /// US quarts unit
  ///
  /// In en, this message translates to:
  /// **'US Quarts'**
  String get usQuarts;

  /// US pints unit
  ///
  /// In en, this message translates to:
  /// **'US Pints'**
  String get usPints;

  /// US cups unit
  ///
  /// In en, this message translates to:
  /// **'US Cups'**
  String get usCups;

  /// Imperial gallons unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Gallons'**
  String get imperialGallons;

  /// Imperial quarts unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Quarts'**
  String get imperialQuarts;

  /// Imperial pints unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Pints'**
  String get imperialPints;

  /// Imperial tablespoons unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Tablespoons'**
  String get imperialTablespoons;

  /// Imperial teaspoons unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Teaspoons'**
  String get imperialTeaspoons;

  /// Imperial fluid ounces unit
  ///
  /// In en, this message translates to:
  /// **'Imperial Fluid Ounces'**
  String get imperialFluidOunces;

  /// US tablespoons unit
  ///
  /// In en, this message translates to:
  /// **'US Tablespoons'**
  String get usTablespoons;

  /// US teaspoons unit
  ///
  /// In en, this message translates to:
  /// **'US Teaspoons'**
  String get usTeaspoons;

  /// Metric cups unit
  ///
  /// In en, this message translates to:
  /// **'Metric Cups'**
  String get metricCups;

  /// Name for the temperature converter mode
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperatureConverterMode;

  /// Title for temperature converter page
  ///
  /// In en, this message translates to:
  /// **'Temperature Converter'**
  String get temperatureConverterTitle;

  /// Celsius temperature unit
  ///
  /// In en, this message translates to:
  /// **'Celsius'**
  String get celsius;

  /// Fahrenheit temperature unit
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit'**
  String get fahrenheit;

  /// Kelvin temperature unit
  ///
  /// In en, this message translates to:
  /// **'Kelvin'**
  String get kelvin;

  /// Name for the length converter mode
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get lengthConverterMode;

  /// Title for length converter page
  ///
  /// In en, this message translates to:
  /// **'Length Converter'**
  String get lengthConverterTitle;

  /// Name for the weight converter mode
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightConverterMode;

  /// Title for weight converter page
  ///
  /// In en, this message translates to:
  /// **'Weight Converter'**
  String get weightConverterTitle;

  /// Name for the energy converter mode
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energyConverterMode;

  /// Title for energy converter page
  ///
  /// In en, this message translates to:
  /// **'Energy Converter'**
  String get energyConverterTitle;

  /// Name for the area converter mode
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get areaConverterMode;

  /// Title for area converter page
  ///
  /// In en, this message translates to:
  /// **'Area Converter'**
  String get areaConverterTitle;

  /// Name for the speed converter mode
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speedConverterMode;

  /// Title for speed converter page
  ///
  /// In en, this message translates to:
  /// **'Speed Converter'**
  String get speedConverterTitle;

  /// Name for the time converter mode
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeConverterMode;

  /// Title for time converter page
  ///
  /// In en, this message translates to:
  /// **'Time Converter'**
  String get timeConverterTitle;

  /// Name for the power converter mode
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get powerConverterMode;

  /// Title for power converter page
  ///
  /// In en, this message translates to:
  /// **'Power Converter'**
  String get powerConverterTitle;

  /// Name for the data converter mode
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get dataConverterMode;

  /// Title for data converter page
  ///
  /// In en, this message translates to:
  /// **'Data Converter'**
  String get dataConverterTitle;

  /// Name for the pressure converter mode
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressureConverterMode;

  /// Title for pressure converter page
  ///
  /// In en, this message translates to:
  /// **'Pressure Converter'**
  String get pressureConverterTitle;

  /// Name for the angle converter mode
  ///
  /// In en, this message translates to:
  /// **'Angle'**
  String get angleConverterMode;

  /// Title for angle converter page
  ///
  /// In en, this message translates to:
  /// **'Angle Converter'**
  String get angleConverterTitle;

  /// Meters length unit
  ///
  /// In en, this message translates to:
  /// **'Meters'**
  String get meters;

  /// Kilometers length unit
  ///
  /// In en, this message translates to:
  /// **'Kilometers'**
  String get kilometers;

  /// Centimeters length unit
  ///
  /// In en, this message translates to:
  /// **'Centimeters'**
  String get centimeters;

  /// Millimeters length unit
  ///
  /// In en, this message translates to:
  /// **'Millimeters'**
  String get millimeters;

  /// Micrometers length unit
  ///
  /// In en, this message translates to:
  /// **'Micrometers'**
  String get micrometers;

  /// Nanometers length unit
  ///
  /// In en, this message translates to:
  /// **'Nanometers'**
  String get nanometers;

  /// Miles length unit
  ///
  /// In en, this message translates to:
  /// **'Miles'**
  String get miles;

  /// Yards length unit
  ///
  /// In en, this message translates to:
  /// **'Yards'**
  String get yards;

  /// Feet length unit
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get feet;

  /// Inches length unit
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get inches;

  /// Kilograms weight unit
  ///
  /// In en, this message translates to:
  /// **'Kilograms'**
  String get kilograms;

  /// Grams weight unit
  ///
  /// In en, this message translates to:
  /// **'Grams'**
  String get grams;

  /// Milligrams weight unit
  ///
  /// In en, this message translates to:
  /// **'Milligrams'**
  String get milligrams;

  /// Metric tons weight unit
  ///
  /// In en, this message translates to:
  /// **'Metric Tons'**
  String get metricTons;

  /// Pounds weight unit
  ///
  /// In en, this message translates to:
  /// **'Pounds'**
  String get pounds;

  /// Ounces weight unit
  ///
  /// In en, this message translates to:
  /// **'Ounces'**
  String get ounces;

  /// Stones weight unit
  ///
  /// In en, this message translates to:
  /// **'Stones'**
  String get stones;

  /// Joules energy unit
  ///
  /// In en, this message translates to:
  /// **'Joules'**
  String get joules;

  /// Kilojoules energy unit
  ///
  /// In en, this message translates to:
  /// **'Kilojoules'**
  String get kilojoules;

  /// Calories energy unit
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// Kilocalories energy unit
  ///
  /// In en, this message translates to:
  /// **'Kilocalories'**
  String get kilocalories;

  /// Watt-hours energy unit
  ///
  /// In en, this message translates to:
  /// **'Watt-hours'**
  String get wattHours;

  /// Kilowatt-hours energy unit
  ///
  /// In en, this message translates to:
  /// **'Kilowatt-hours'**
  String get kilowattHours;

  /// Electronvolts energy unit
  ///
  /// In en, this message translates to:
  /// **'Electronvolts'**
  String get electronvolts;

  /// British thermal units energy unit
  ///
  /// In en, this message translates to:
  /// **'British thermal units'**
  String get britishThermalUnits;

  /// Square meters area unit
  ///
  /// In en, this message translates to:
  /// **'Square Meters'**
  String get squareMeters;

  /// Square kilometers area unit
  ///
  /// In en, this message translates to:
  /// **'Square Kilometers'**
  String get squareKilometers;

  /// Square centimeters area unit
  ///
  /// In en, this message translates to:
  /// **'Square Centimeters'**
  String get squareCentimeters;

  /// Hectares area unit
  ///
  /// In en, this message translates to:
  /// **'Hectares'**
  String get hectares;

  /// Square miles area unit
  ///
  /// In en, this message translates to:
  /// **'Square Miles'**
  String get squareMiles;

  /// Square yards area unit
  ///
  /// In en, this message translates to:
  /// **'Square Yards'**
  String get squareYards;

  /// Square feet area unit
  ///
  /// In en, this message translates to:
  /// **'Square Feet'**
  String get squareFeet;

  /// Square inches area unit
  ///
  /// In en, this message translates to:
  /// **'Square Inches'**
  String get squareInches;

  /// Acres area unit
  ///
  /// In en, this message translates to:
  /// **'Acres'**
  String get acres;

  /// Meters per second speed unit
  ///
  /// In en, this message translates to:
  /// **'Meters per second'**
  String get metersPerSecond;

  /// Kilometers per hour speed unit
  ///
  /// In en, this message translates to:
  /// **'Kilometers per hour'**
  String get kilometersPerHour;

  /// Miles per hour speed unit
  ///
  /// In en, this message translates to:
  /// **'Miles per hour'**
  String get milesPerHour;

  /// Feet per second speed unit
  ///
  /// In en, this message translates to:
  /// **'Feet per second'**
  String get feetPerSecond;

  /// Knots speed unit
  ///
  /// In en, this message translates to:
  /// **'Knots'**
  String get knots;

  /// Mach speed unit
  ///
  /// In en, this message translates to:
  /// **'Mach'**
  String get mach;

  /// Seconds time unit
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// Milliseconds time unit
  ///
  /// In en, this message translates to:
  /// **'Milliseconds'**
  String get milliseconds;

  /// Microseconds time unit
  ///
  /// In en, this message translates to:
  /// **'Microseconds'**
  String get microseconds;

  /// Nanoseconds time unit
  ///
  /// In en, this message translates to:
  /// **'Nanoseconds'**
  String get nanoseconds;

  /// Minutes time unit
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// Hours time unit
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// Weeks time unit
  ///
  /// In en, this message translates to:
  /// **'Weeks'**
  String get weeks;

  /// Watts power unit
  ///
  /// In en, this message translates to:
  /// **'Watts'**
  String get watts;

  /// Kilowatts power unit
  ///
  /// In en, this message translates to:
  /// **'Kilowatts'**
  String get kilowatts;

  /// Megawatts power unit
  ///
  /// In en, this message translates to:
  /// **'Megawatts'**
  String get megawatts;

  /// Horsepower (metric) power unit
  ///
  /// In en, this message translates to:
  /// **'Horsepower (metric)'**
  String get horsepowerMetric;

  /// BTU per minute power unit
  ///
  /// In en, this message translates to:
  /// **'BTU per minute'**
  String get btuPerMinute;

  /// Bytes data unit
  ///
  /// In en, this message translates to:
  /// **'Bytes'**
  String get bytes;

  /// Kilobytes data unit
  ///
  /// In en, this message translates to:
  /// **'Kilobytes'**
  String get kilobytes;

  /// Megabytes data unit
  ///
  /// In en, this message translates to:
  /// **'Megabytes'**
  String get megabytes;

  /// Gigabytes data unit
  ///
  /// In en, this message translates to:
  /// **'Gigabytes'**
  String get gigabytes;

  /// Terabytes data unit
  ///
  /// In en, this message translates to:
  /// **'Terabytes'**
  String get terabytes;

  /// Petabytes data unit
  ///
  /// In en, this message translates to:
  /// **'Petabytes'**
  String get petabytes;

  /// Tebibytes data unit
  ///
  /// In en, this message translates to:
  /// **'Tebibytes'**
  String get tebibytes;

  /// Pebibytes data unit
  ///
  /// In en, this message translates to:
  /// **'Pebibytes'**
  String get pebibytes;

  /// Bits data unit
  ///
  /// In en, this message translates to:
  /// **'Bits'**
  String get bits;

  /// Kibibytes data unit
  ///
  /// In en, this message translates to:
  /// **'Kibibytes'**
  String get kibibytes;

  /// Mebibytes data unit
  ///
  /// In en, this message translates to:
  /// **'Mebibytes'**
  String get mebibytes;

  /// Gibibytes data unit
  ///
  /// In en, this message translates to:
  /// **'Gibibytes'**
  String get gibibytes;

  /// Pascals pressure unit
  ///
  /// In en, this message translates to:
  /// **'Pascals'**
  String get pascals;

  /// Kilopascals pressure unit
  ///
  /// In en, this message translates to:
  /// **'Kilopascals'**
  String get kilopascals;

  /// Bars pressure unit
  ///
  /// In en, this message translates to:
  /// **'Bars'**
  String get bars;

  /// Atmospheres pressure unit
  ///
  /// In en, this message translates to:
  /// **'Atmospheres'**
  String get atmospheres;

  /// Pounds per square inch pressure unit
  ///
  /// In en, this message translates to:
  /// **'Pounds per square inch'**
  String get poundsPerSquareInch;

  /// Millimeters of mercury pressure unit
  ///
  /// In en, this message translates to:
  /// **'Millimeters of mercury'**
  String get millimetersOfMercury;

  /// Degrees angle unit
  ///
  /// In en, this message translates to:
  /// **'Degrees'**
  String get degreesAngle;

  /// Radians angle unit
  ///
  /// In en, this message translates to:
  /// **'Radians'**
  String get radians;

  /// Gradians angle unit
  ///
  /// In en, this message translates to:
  /// **'Gradians'**
  String get gradians;

  /// Turns angle unit
  ///
  /// In en, this message translates to:
  /// **'Turns'**
  String get turns;

  /// Angstroms length unit
  ///
  /// In en, this message translates to:
  /// **'Angstroms'**
  String get angstroms;

  /// Nautical miles length unit
  ///
  /// In en, this message translates to:
  /// **'Nautical miles'**
  String get nauticalMiles;

  /// Carats weight unit
  ///
  /// In en, this message translates to:
  /// **'Carats'**
  String get carats;

  /// Centigrams weight unit
  ///
  /// In en, this message translates to:
  /// **'Centigrams'**
  String get centigrams;

  /// Decigrams weight unit
  ///
  /// In en, this message translates to:
  /// **'Decigrams'**
  String get decigrams;

  /// Decagrams weight unit
  ///
  /// In en, this message translates to:
  /// **'Decagrams'**
  String get decagrams;

  /// Hectograms weight unit
  ///
  /// In en, this message translates to:
  /// **'Hectograms'**
  String get hectograms;

  /// Short tons weight unit
  ///
  /// In en, this message translates to:
  /// **'Short tons'**
  String get shortTons;

  /// Foot-pounds energy unit
  ///
  /// In en, this message translates to:
  /// **'Foot-pounds'**
  String get footPounds;

  /// Square millimeters area unit
  ///
  /// In en, this message translates to:
  /// **'Square millimeters'**
  String get squareMillimeters;

  /// Centimeters per second speed unit
  ///
  /// In en, this message translates to:
  /// **'Centimeters per second'**
  String get centimetersPerSecond;

  /// Horsepower (US) power unit
  ///
  /// In en, this message translates to:
  /// **'Horsepower (US)'**
  String get horsepowerUs;

  /// Foot-pounds/minute power unit
  ///
  /// In en, this message translates to:
  /// **'Foot-pounds/minute'**
  String get footPoundsPerMinute;

  /// Nibbles data unit
  ///
  /// In en, this message translates to:
  /// **'Nibbles'**
  String get nibbles;

  /// Kilobits data unit
  ///
  /// In en, this message translates to:
  /// **'Kilobits'**
  String get kilobits;

  /// Kibibits data unit
  ///
  /// In en, this message translates to:
  /// **'Kibibits'**
  String get kibibits;

  /// Megabits data unit
  ///
  /// In en, this message translates to:
  /// **'Megabits'**
  String get megabits;

  /// Mebibits data unit
  ///
  /// In en, this message translates to:
  /// **'Mebibits'**
  String get mebibits;

  /// Gigabits data unit
  ///
  /// In en, this message translates to:
  /// **'Gigabits'**
  String get gigabits;

  /// Gibibits data unit
  ///
  /// In en, this message translates to:
  /// **'Gibibits'**
  String get gibibits;

  /// Terabits data unit
  ///
  /// In en, this message translates to:
  /// **'Terabits'**
  String get terabits;

  /// Tebibits data unit
  ///
  /// In en, this message translates to:
  /// **'Tebibits'**
  String get tebibits;

  /// Petabits data unit
  ///
  /// In en, this message translates to:
  /// **'Petabits'**
  String get petabits;

  /// Pebibits data unit
  ///
  /// In en, this message translates to:
  /// **'Pebibits'**
  String get pebibits;

  /// Exabits data unit
  ///
  /// In en, this message translates to:
  /// **'Exabits'**
  String get exabits;

  /// Exbibits data unit
  ///
  /// In en, this message translates to:
  /// **'Exbibits'**
  String get exbibits;

  /// Zetabits data unit
  ///
  /// In en, this message translates to:
  /// **'Zetabits'**
  String get zetabits;

  /// Zebibits data unit
  ///
  /// In en, this message translates to:
  /// **'Zebibits'**
  String get zebibits;

  /// Yottabits data unit
  ///
  /// In en, this message translates to:
  /// **'Yottabits'**
  String get yottabits;

  /// Yobibits data unit
  ///
  /// In en, this message translates to:
  /// **'Yobibits'**
  String get yobibits;

  /// Exabytes data unit
  ///
  /// In en, this message translates to:
  /// **'Exabytes'**
  String get exabytes;

  /// Exbibytes data unit
  ///
  /// In en, this message translates to:
  /// **'Exbibytes'**
  String get exbibytes;

  /// Zetabytes data unit
  ///
  /// In en, this message translates to:
  /// **'Zetabytes'**
  String get zetabytes;

  /// Zebibytes data unit
  ///
  /// In en, this message translates to:
  /// **'Zebibytes'**
  String get zebibytes;

  /// Yottabytes data unit
  ///
  /// In en, this message translates to:
  /// **'Yottabytes'**
  String get yottabytes;

  /// Yobibytes data unit
  ///
  /// In en, this message translates to:
  /// **'Yobibytes'**
  String get yobibytes;

  /// Teaspoons (US) volume unit
  ///
  /// In en, this message translates to:
  /// **'Teaspoons (US)'**
  String get teaspoonsUs;

  /// Tablespoons (US) volume unit
  ///
  /// In en, this message translates to:
  /// **'Tablespoons (US)'**
  String get tablespoonsUs;

  /// Fluid ounces (US) volume unit
  ///
  /// In en, this message translates to:
  /// **'Fluid ounces (US)'**
  String get fluidOuncesUs;

  /// Cups (US) volume unit
  ///
  /// In en, this message translates to:
  /// **'Cups (US)'**
  String get cupsUs;

  /// Pints (US) volume unit
  ///
  /// In en, this message translates to:
  /// **'Pints (US)'**
  String get pintsUs;

  /// Quarts (US) volume unit
  ///
  /// In en, this message translates to:
  /// **'Quarts (US)'**
  String get quartsUs;

  /// Gallons (US) volume unit
  ///
  /// In en, this message translates to:
  /// **'Gallons (US)'**
  String get gallonsUs;

  /// Teaspoons (UK) volume unit
  ///
  /// In en, this message translates to:
  /// **'Teaspoons (UK)'**
  String get teaspoonsUk;

  /// Tablespoons (UK) volume unit
  ///
  /// In en, this message translates to:
  /// **'Tablespoons (UK)'**
  String get tablespoonsUk;

  /// Fluid ounces (UK) volume unit
  ///
  /// In en, this message translates to:
  /// **'Fluid ounces (UK)'**
  String get fluidOuncesUk;

  /// Pints (UK) volume unit
  ///
  /// In en, this message translates to:
  /// **'Pints (UK)'**
  String get pintsUk;

  /// Quarts (UK) volume unit
  ///
  /// In en, this message translates to:
  /// **'Quarts (UK)'**
  String get quartsUk;

  /// Gallons (UK) volume unit
  ///
  /// In en, this message translates to:
  /// **'Gallons (UK)'**
  String get gallonsUk;

  /// Coffee cups volume unit
  ///
  /// In en, this message translates to:
  /// **'Coffee cups'**
  String get coffeeCups;

  /// Bathtubs volume unit
  ///
  /// In en, this message translates to:
  /// **'Bathtubs'**
  String get bathtubs;

  /// Swimming pools volume unit
  ///
  /// In en, this message translates to:
  /// **'Swimming pools'**
  String get swimmingPools;

  /// Paperclips whimsical length unit
  ///
  /// In en, this message translates to:
  /// **'Paperclips'**
  String get paperclips;

  /// Hands whimsical length unit
  ///
  /// In en, this message translates to:
  /// **'Hands'**
  String get handsWhimsical;

  /// Jumbo jets whimsical length unit
  ///
  /// In en, this message translates to:
  /// **'Jumbo jets'**
  String get jumboJets;

  /// Snowflakes whimsical weight unit
  ///
  /// In en, this message translates to:
  /// **'Snowflakes'**
  String get snowflakes;

  /// Soccer balls whimsical weight unit
  ///
  /// In en, this message translates to:
  /// **'Soccer balls'**
  String get soccerBalls;

  /// Elephants whimsical weight unit
  ///
  /// In en, this message translates to:
  /// **'Elephants'**
  String get elephants;

  /// Whales whimsical weight unit
  ///
  /// In en, this message translates to:
  /// **'Whales'**
  String get whales;

  /// Batteries whimsical energy unit
  ///
  /// In en, this message translates to:
  /// **'Batteries'**
  String get batteries;

  /// Bananas whimsical energy unit
  ///
  /// In en, this message translates to:
  /// **'Bananas'**
  String get bananas;

  /// Slices of cake whimsical energy unit
  ///
  /// In en, this message translates to:
  /// **'Slices of cake'**
  String get slicesOfCake;

  /// Hands whimsical area unit
  ///
  /// In en, this message translates to:
  /// **'Hands'**
  String get handsArea;

  /// Papers whimsical area unit
  ///
  /// In en, this message translates to:
  /// **'Papers'**
  String get papers;

  /// Soccer fields whimsical area unit
  ///
  /// In en, this message translates to:
  /// **'Soccer fields'**
  String get soccerFields;

  /// Castles whimsical area unit
  ///
  /// In en, this message translates to:
  /// **'Castles'**
  String get castles;

  /// Pyeong whimsical area unit
  ///
  /// In en, this message translates to:
  /// **'Pyeong'**
  String get pyeong;

  /// Turtles whimsical speed unit
  ///
  /// In en, this message translates to:
  /// **'Turtles'**
  String get turtles;

  /// Horses whimsical speed unit
  ///
  /// In en, this message translates to:
  /// **'Horses'**
  String get horsesWhimsical;

  /// Jets whimsical speed unit
  ///
  /// In en, this message translates to:
  /// **'Jets'**
  String get jets;

  /// Light bulbs whimsical power unit
  ///
  /// In en, this message translates to:
  /// **'Light bulbs'**
  String get lightBulbs;

  /// Horses whimsical power unit
  ///
  /// In en, this message translates to:
  /// **'Horses'**
  String get horsesPower;

  /// Train engines whimsical power unit
  ///
  /// In en, this message translates to:
  /// **'Train engines'**
  String get trainEngines;

  /// Floppy disks whimsical data unit
  ///
  /// In en, this message translates to:
  /// **'Floppy disks'**
  String get floppyDisks;

  /// CDs whimsical data unit
  ///
  /// In en, this message translates to:
  /// **'CDs'**
  String get cds;

  /// DVDs whimsical data unit
  ///
  /// In en, this message translates to:
  /// **'DVDs'**
  String get dvds;

  /// Name for the settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsMode;

  /// Title for the settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Placeholder text for the settings page
  ///
  /// In en, this message translates to:
  /// **'Settings functionality coming soon...'**
  String get settingsPlaceholder;

  /// Theme mode setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeMode;

  /// Light theme mode option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme mode option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// System theme mode option (follow system theme)
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// General settings section title
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// Application name label
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get settingsAppNameLabel;

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get settingsAppName;

  /// Application version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsAppVersionLabel;

  /// Application version number
  ///
  /// In en, this message translates to:
  /// **'v0.9.0'**
  String get settingsAppVersion;

  /// Copyright information
  ///
  /// In en, this message translates to:
  /// **'© 2025 Calculator Project. All rights reserved.'**
  String get settingsCopyright;

  /// Feedback section title
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get settingsFeedback;

  /// Send email option
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get settingsSendEmail;

  /// Submit ticket option
  ///
  /// In en, this message translates to:
  /// **'Submit Ticket'**
  String get settingsSubmitTicket;

  /// Privacy section title
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// Privacy policy content
  ///
  /// In en, this message translates to:
  /// **'We respect and protect your privacy:\n\n• No personal information is collected\n• No data is transmitted over the network\n• All data is stored locally on your device\n• No third-party tracking tools are used'**
  String get settingsPrivacyContent;

  /// Acknowledgements section title
  ///
  /// In en, this message translates to:
  /// **'Acknowledgements'**
  String get settingsAcknowledgements;

  /// Acknowledgements content
  ///
  /// In en, this message translates to:
  /// **'This project is based on the following open source projects:\n• Flutter - Cross-platform UI framework\n• wincalc_engine - Windows Calculator engine\n• Riverpod - State management\n• go_router - Routing management'**
  String get settingsAcknowledgementsContent;

  /// App icon source label
  ///
  /// In en, this message translates to:
  /// **'App Icon'**
  String get settingsIconSource;

  /// App icon source content prefix
  ///
  /// In en, this message translates to:
  /// **'Thanks to'**
  String get settingsIconSourceContent;

  /// Streamline Icons brand name
  ///
  /// In en, this message translates to:
  /// **'Streamline Icons'**
  String get settingsIconSourceLink;

  /// App icon source content suffix
  ///
  /// In en, this message translates to:
  /// **'for the beautiful icon'**
  String get settingsIconSourceSuffix;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language option to follow system setting
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get languageSystem;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Chinese language option
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
