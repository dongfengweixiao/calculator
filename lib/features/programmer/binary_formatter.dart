/// Binary formatting utility for programmer calculator mode
class BinaryFormatter {
  /// Format binary value with spaces every 4 bits
  /// Example: "1001101" -> "0100 1101"
  /// The Text widget will handle wrapping automatically
  static String format(String binaryValue) {
    if (binaryValue.isEmpty) return '';

    // Remove any existing spaces from the calculator engine output
    final cleaned = binaryValue.replaceAll(' ', '');

    // Pad with leading zeros to make length a multiple of 4
    final targetLength = (cleaned.length + 3) ~/ 4 * 4;
    final padded = cleaned.padLeft(targetLength, '0');

    // Process from right to left in groups of 4 bits
    final groups = <String>[];
    for (int i = padded.length; i > 0; i -= 4) {
      final start = i - 4;
      final end = i;
      groups.insert(0, padded.substring(start, end));
    }

    // Join groups with spaces (no manual newlines, let Text widget handle wrapping)
    return groups.join(' ');
  }
}
