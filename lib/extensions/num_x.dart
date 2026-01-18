import 'dart:core';

/// Extension methods on [num]
///
/// Provides numeric utilities for both int and double.
extension NumX on num {
  /// Checks if the number is zero
  bool get isZero => this == 0;

  /// Checks if the number is negative
  bool get isNegative => this < 0;

  /// Checks if the number is positive
  bool get isPositive => this > 0;

  /// Checks if the number is even (for integers)
  bool get isEven => this % 2 == 0;

  /// Checks if the number is odd (for integers)
  bool get isOdd => this % 2 != 0;

  /// Returns the absolute value
  num get abs => this < 0 ? -this : this;

  /// Squares the number
  num get squared => this * this;

  /// Cubes the number
  num get cubed => this * this * this;

  /// Returns the sign of the number (-1, 0, or 1)
  int get sign {
    if (isZero) return 0;
    return isNegative ? -1 : 1;
  }

  /// Clamps the value between a minimum and maximum
  num clampNum(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Checks if this number is close to another number
  bool isCloseTo(num other, {num tolerance = 1e-10}) {
    return (this - other).abs().toDouble() < tolerance.toDouble();
  }

  /// Returns the number formatted as a string with thousand separators
  String toFormattedString({String separator = ','}) {
    return toDouble().toFormattedString(separator: separator);
  }

  /// Converts the number to a percentage string
  /// Example: 0.25.toPercentageString() returns "25%"
  String toPercentageString({int precision = 2}) {
    return toDouble().toPercentageString(precision: precision);
  }
}

/// Extension methods on [int]
///
/// Provides integer-specific utilities.
extension IntX on int {
  /// Formats the integer with thousand separators
  /// Example: 1234567.formatWithCommas() returns "1,234,567"
  String formatWithCommas() {
    return toDouble().toFormattedString();
  }

  /// Converts to hexadecimal string
  /// Example: 255.toHex() returns "FF"
  String toHex({bool prefix = false}) {
    final hex = toRadixString(16).toUpperCase();
    return prefix ? '0x$hex' : hex;
  }

  /// Converts to binary string
  /// Example: 5.toBinary() returns "101"
  String toBinary({int? padTo}) {
    String binary = toRadixString(2);
    if (padTo != null && binary.length < padTo) {
      binary = binary.padLeft(padTo, '0');
    }
    return binary;
  }

  /// Converts to octal string
  /// Example: 8.toOctal() returns "10"
  String toOctal({bool prefix = false}) {
    final octal = toRadixString(8);
    return prefix ? '0o$octal' : octal;
  }

  /// Gets the number of digits in the integer
  /// Example: 12345.digitCount returns 5
  int get digitCount {
    if (this == 0) return 1;
    return abs().toString().length;
  }

  /// Checks if the integer is a power of 2
  bool get isPowerOf2 {
    if (this <= 0) return false;
    return (this & (this - 1)) == 0;
  }

  /// Rounds up to the nearest multiple of the given number
  /// Example: 11.roundUpTo(5) returns 15
  int roundUpTo(int multiple) {
    if (multiple == 0) return this;
    return ((this + multiple - 1) / multiple).floor() * multiple;
  }

  /// Rounds down to the nearest multiple of the given number
  /// Example: 14.roundDownTo(5) returns 10
  int roundDownTo(int multiple) {
    if (multiple == 0) return this;
    return (this / multiple).floor() * multiple;
  }

  /// Calculates factorial
  /// Example: 5.factorial() returns 120
  int factorial() {
    if (this < 0) throw ArgumentError('Factorial is not defined for negative numbers');
    if (this <= 1) return 1;
    int result = 1;
    for (int i = 2; i <= this; i++) {
      result *= i;
    }
    return result;
  }

  /// Calculates the greatest common divisor with another integer
  int gcd(int other) {
    return _gcd(abs(), other.abs());
  }

  // Euclidean algorithm implementation
  int _gcd(int a, int b) {
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  /// Calculates the least common multiple with another integer
  int lcm(int other) {
    if (this == 0 || other == 0) return 0;
    return ((toDouble() * other) / gcd(other)).abs().round();
  }
}

/// Extension methods on nullable [int]
extension IntNullableX on int? {
  /// Returns true if the int is null or zero
  bool get isNullOrZero {
    return this == null || this == 0;
  }

  /// Returns the int or a default value if null
  int orDefault(int defaultValue) {
    return this ?? defaultValue;
  }

  /// Returns the int or 0 if null
  int get orZero {
    return this ?? 0;
  }
}
