/// Extension methods on [String]
///
/// Provides string manipulation and validation utilities.
extension StringX on String {
  /// Capitalizes the first letter of the string
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first letter of each word
  String get everyWordCapitalized {
    return split(' ').map((word) => word.capitalized).join(' ');
  }

  /// Checks if the string represents a valid number
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Checks if the string represents a valid integer
  bool get isInt {
    return int.tryParse(this) != null;
  }

  /// Removes leading zeros from a number string
  /// Example: "00123" -> "123", "0.001" -> "0.001"
  String get removeLeadingZeros {
    if (isEmpty) return this;

    // Handle negative numbers
    if (startsWith('-')) {
      final withoutSign = substring(1);
      if (withoutSign.removeAllWhitespace == '0') return this;
      return '-${withoutSign.removeLeadingZeros}';
    }

    // Handle decimal numbers
    if (contains('.')) {
      final parts = split('.');
      final integerPart = parts[0].removeLeadingZeros;
      final decimalPart = parts[1];
      if (integerPart == '0') {
        return '0.$decimalPart';
      }
      return '$integerPart.$decimalPart';
    }

    // Handle regular integers
    final withoutZeros = replaceFirst(RegExp(r'^0+(?=0)'), '');
    if (withoutZeros.isEmpty) return '0';
    return withoutZeros;
  }

  /// Removes all whitespace from the string
  String get removeAllWhitespace {
    return replaceAll(RegExp(r'\s'), '');
  }

  /// Checks if the string is empty or contains only whitespace
  bool get isBlank {
    return trim().isEmpty;
  }

  /// Formats a number string with thousand separators
  /// Example: "1234567.89" -> "1,234,567.89"
  String formatNumber({String separator = ','}) {
    if (!isNumeric) return this;

    final parts = split('.');
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

    // Remove existing separators
    final cleanDigits = digits.replaceAll(RegExp(r'[^0-9]'), '');

    // Add new separators
    final buffer = StringBuffer();
    for (int i = 0; i < cleanDigits.length; i++) {
      if (i > 0 && (cleanDigits.length - i) % 3 == 0) {
        buffer.write(separator);
      }
      buffer.write(cleanDigits[i]);
    }

    return isNegative ? '-$buffer' : buffer.toString();
  }

  /// Removes trailing zeros after decimal point
  /// Example: "1.2300" -> "1.23", "1.00" -> "1"
  String get removeTrailingZeros {
    if (!contains('.')) return this;

    final parts = split('.');
    if (parts.length != 2) return this;

    final integerPart = parts[0];
    var decimalPart = parts[1];

    // Remove trailing zeros
    decimalPart = decimalPart.replaceAll(RegExp(r'0+$'), '');

    // If decimal part is empty, return only integer part
    if (decimalPart.isEmpty) {
      return integerPart;
    }

    return '$integerPart.$decimalPart';
  }

  /// Checks if this string is the same as another, ignoring case
  bool isSameIgnoreCase(String other) {
    return toLowerCase() == other.toLowerCase();
  }

  /// Truncates the string to a maximum length and adds ellipsis if needed
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }
}

/// Extension methods on nullable [String]
extension StringNullableX on String? {
  /// Returns true if the string is null or empty
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  /// Returns true if the string is null, empty, or contains only whitespace
  bool get isNullOrBlank {
    return this == null || this!.isBlank;
  }

  /// Returns the string or a default value if null
  String orDefault(String defaultValue) {
    return this ?? defaultValue;
  }

  /// Returns the string or an empty string if null
  String get orEmpty {
    return this ?? '';
  }
}
