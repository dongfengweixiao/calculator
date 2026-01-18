import 'dart:math' as math;
import 'dart:core';

/// Extension methods on [double]
///
/// Provides double precision floating-point utilities for calculator operations.
extension DoubleX on double {
  /// Checks if the double is an integer (no decimal part)
  bool get isInteger {
    return this == truncateToDouble();
  }

  /// Checks if the double is negative
  bool get isNegative {
    return this < 0;
  }

  /// Checks if the double is positive
  bool get isPositive {
    return this > 0;
  }

  /// Checks if the double is zero (with tolerance for floating point errors)
  bool get isZero {
    return abs() < 1e-10;
  }

  /// Returns the absolute value
  double abs() {
    return math.sqrt(math.pow(this, 2));
  }

  /// Checks if this value is close to another value (within tolerance)
  bool isCloseTo(double other, {double tolerance = 1e-10}) {
    return (this - other).abs() < tolerance;
  }

  /// Formats the double to a string with specified precision
  String toPrecisionString(int precision) {
    if (isInteger) {
      return toInt().toString();
    }

    // Convert to string with specified precision
    final formatted = toStringAsFixed(precision);

    // Remove trailing zeros
    if (formatted.contains('.')) {
      return formatted.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }

    return formatted;
  }

  /// Formats the double to a string with automatic precision
  /// Removes trailing zeros and unnecessary decimal point
  String toAutoPrecisionString({int maxPrecision = 10}) {
    if (isInteger) {
      return toInt().toString();
    }

    // Try progressively smaller precision until we find the minimum needed
    for (int i = maxPrecision; i > 0; i--) {
      final rounded = toStringAsFixed(i);
      final parsed = double.tryParse(rounded);
      if (parsed != null && isCloseTo(parsed, tolerance: math.pow(10, -i - 1).toDouble())) {
        // Remove trailing zeros
        final cleaned = rounded.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
        return cleaned;
      }
    }

    // Fallback to integer if close enough
    if (isCloseTo(round().toDouble())) {
      return round().toString();
    }

    return toString();
  }

  /// Returns the double formatted with thousand separators
  String toFormattedString({String separator = ','}) {
    // All doubles are numeric, so we can skip this check

    final parts = toString().split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Format integer part with separators
    final formattedInteger = _formatIntegerPart(integerPart, separator);

    return '$formattedInteger$decimalPart';
  }

  String _formatIntegerPart(String integerPart, String separator) {
    if (integerPart == '0') return '0';

    final isNegative = integerPart.startsWith('-');
    final digits = isNegative ? integerPart.substring(1) : integerPart;

    if (digits.length <= 3) return integerPart;

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(separator);
      }
      buffer.write(digits[i]);
    }

    return isNegative ? '-$buffer' : buffer.toString();
  }

  /// Squares the double
  double squared() {
    return this * this;
  }

  /// Cubes the double
  double cubed() {
    return this * this * this;
  }

  /// Returns the sign of the double (-1, 0, or 1)
  int get sign {
    if (isZero) return 0;
    return isNegative ? -1 : 1;
  }

  /// Clamps the value between a minimum and maximum
  double clamp(double min, double max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Returns the percentage of this value relative to total
  /// Example: 50.percentageOf(200) returns 25.0
  double percentageOf(double total) {
    if (total == 0) return 0;
    return (this / total) * 100;
  }

  /// Returns the value as a percentage of this value
  /// Example: 200.fromPercentage(25) returns 50.0
  double fromPercentage(double percentage) {
    return (this * percentage) / 100;
  }

  /// Checks if the double is a finite number (not infinity or NaN)
  bool get isFinite {
    return !isNaN && !isInfinite;
  }

  /// Checks if the double is NaN (Not a Number)
  bool get isNaN {
    return (this - this) != 0;
  }

  /// Checks if the double is positive or negative infinity
  bool get isInfinite {
    return (this == double.infinity) || (this == double.negativeInfinity);
  }

  /// Converts the double to a percentage string
  /// Example: 0.1234.toPercentageString() returns "12.34%"
  String toPercentageString({int precision = 2}) {
    return '${(this * 100).toPrecisionString(precision)}%';
  }
}

/// Extension methods on nullable [double]
extension DoubleNullableX on double? {
  /// Returns true if the double is null, zero, or NaN
  bool get isNullOrZero {
    return this == null || (this != null && (this!.isZero || this!.isNaN));
  }

  /// Returns the double or a default value if null
  double orDefault(double defaultValue) {
    return this ?? defaultValue;
  }

  /// Returns the double or 0.0 if null
  double get orZero {
    return this ?? 0.0;
  }
}
