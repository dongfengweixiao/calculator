import 'programmer_provider.dart';

/// Utility class for converting bit arrays to string representations
/// Following Microsoft Calculator architecture: work with strings, not numbers
class BitConverter {
  /// Convert bit values array to binary string representation
  /// bitValues[0] represents bit 63 (MSB), bitValues[63] represents bit 0 (LSB)
  ///
  /// This generates a binary string directly from the bit array,
  /// which will then be passed to wincalc_engine for proper base conversion.
  /// The engine handles all signed/unsigned formatting based on word size.
  static String bitValuesToBinaryString(List<bool> bitValues, WordSize wordSize) {
    // Generate binary string from MSB to LSB
    // Only include bits up to wordSize.bits
    final buffer = StringBuffer();
    for (int i = wordSize.bits - 1; i >= 0; i--) {
      // bitValues[0] = bit 63 (MSB), bitValues[63] = bit 0 (LSB)
      final arrayIndex = 63 - i;
      buffer.write(bitValues[arrayIndex] ? '1' : '0');
    }
    return buffer.toString();
  }
}
