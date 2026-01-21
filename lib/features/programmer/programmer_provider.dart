import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wincalc_engine/wincalc_engine.dart';
import '../calculator/calculator_provider.dart';
import '../../core/services/calculator_service.dart';

/// Shift mode enum
enum ShiftMode {
  arithmetic('算术移位'),
  logical('逻辑移位'),
  rotate('旋转循环移位'),
  rotateCarry('带进位旋转循环移位');

  final String label;
  const ShiftMode(this.label);
}

/// Programmer number base type
enum ProgrammerBase {
  hex(16, 'HEX'),
  dec(10, 'DEC'),
  oct(8, 'OCT'),
  bin(2, 'BIN');

  final int value;
  final String label;

  const ProgrammerBase(this.value, this.label);

  /// Create ProgrammerBase from engine radix value
  static ProgrammerBase fromValue(int value) {
    return ProgrammerBase.values.firstWhere(
      (base) => base.value == value,
      orElse: () => ProgrammerBase.dec,
    );
  }
}

/// Programmer word size type
enum WordSize {
  qword(64, 'QWORD'),
  dword(32, 'DWORD'),
  word(16, 'WORD'),
  byte(8, 'BYTE');

  final int bits;
  final String label;

  const WordSize(this.bits, this.label);

  /// Create WordSize from engine value (bits)
  static WordSize fromValue(int value) {
    return WordSize.values.firstWhere(
      (size) => size.bits == value,
      orElse: () => WordSize.qword,
    );
  }
}

/// Programmer input mode
enum ProgrammerInputMode {
  fullKeypad,
  bitFlip;

  String get label {
    switch (this) {
      case ProgrammerInputMode.fullKeypad:
        return '全键盘';
      case ProgrammerInputMode.bitFlip:
        return '位翻转';
    }
  }
}

/// Programmer calculator state
class ProgrammerState {
  final ProgrammerBase currentBase;
  final String hexValue;
  final String decValue;
  final String octValue;
  final String binValue;
  final WordSize wordSize;
  final ProgrammerInputMode inputMode;
  final ShiftMode shiftMode;

  /// Bit values for bit flip mode (64 bits)
  /// bitValues[0] represents bit 63 (MSB, 2^63)
  /// bitValues[63] represents bit 0 (LSB, 2^0)
  final List<bool> bitValues;

  const ProgrammerState({
    required this.currentBase,
    required this.hexValue,
    required this.decValue,
    required this.octValue,
    required this.binValue,
    required this.wordSize,
    required this.inputMode,
    required this.shiftMode,
    required this.bitValues,
  });

  ProgrammerState copyWith({
    ProgrammerBase? currentBase,
    String? hexValue,
    String? decValue,
    String? octValue,
    String? binValue,
    WordSize? wordSize,
    ProgrammerInputMode? inputMode,
    ShiftMode? shiftMode,
    List<bool>? bitValues,
  }) {
    return ProgrammerState(
      currentBase: currentBase ?? this.currentBase,
      hexValue: hexValue ?? this.hexValue,
      decValue: decValue ?? this.decValue,
      octValue: octValue ?? this.octValue,
      binValue: binValue ?? this.binValue,
      wordSize: wordSize ?? this.wordSize,
      inputMode: inputMode ?? this.inputMode,
      shiftMode: shiftMode ?? this.shiftMode,
      bitValues: bitValues ?? this.bitValues,
    );
  }
}

/// Programmer calculator state notifier
class ProgrammerNotifier extends Notifier<ProgrammerState> {
  bool _initialized = false;

  @override
  ProgrammerState build() {
    // Read initial word size from engine to ensure sync
    WordSize initialWordSize = WordSize.qword; // Default
    try {
      final calculatorNotifier = ref.read(calculatorProvider.notifier);
      final engineWordSize = calculatorNotifier.service.getWordSize();

      // Map engine value to WordSize enum
      initialWordSize = WordSize.fromValue(engineWordSize);
    } catch (e) {
      // Fallback to default if engine is not ready
      initialWordSize = WordSize.qword;
    }

    return ProgrammerState(
      currentBase: ProgrammerBase.dec,
      hexValue: '0',
      decValue: '0',
      octValue: '0',
      binValue: '0',
      wordSize: initialWordSize,
      inputMode: ProgrammerInputMode.fullKeypad,
      shiftMode: ShiftMode.logical,
      bitValues: List.generate(64, (index) => false),
    );
  }

  /// Initialize programmer mode settings when activated
  /// This should be called when switching to programmer mode
  void initialize() {
    if (!_initialized) {
      final calculator = ref.read(calculatorProvider.notifier);

      ref.read(calculatorProvider.notifier).setMode(CalculatorMode.programmer);
      calculator.setQword();
      _setRadixForBase(state.currentBase);
      _initialized = true;
    }
  }

  /// Update all base values directly from calculator engine
  /// This is the preferred method for programmer mode as it gets results
  /// directly from wincalc_engine's base conversion functions
  ///
  /// Following Microsoft Calculator architecture: work with strings from engine,
  /// parse to BigInt only for bit array calculation (UI needs)
  void updateValuesFromCalculator() {
    final calculator = ref.read(calculatorProvider.notifier);
    final hexVal = calculator.getResultHex();
    final decVal = calculator.getResultDec();
    final octVal = calculator.getResultOct();
    final binVal = calculator.getResultBin();

    // Parse hex value as BigInt to update bit values
    // Use hex because it's always unsigned and handles all word sizes correctly
    try {
      // Remove spaces from hex string for parsing
      final cleanHex = hexVal.replaceAll(' ', '');
      final bigIntValue = BigInt.tryParse(cleanHex, radix: 16);

      if (bigIntValue != null) {
        // Update bit values using BigInt (no overflow issues)
        final newBitValues = List<bool>.generate(64, (index) {
          final bitNumber = 63 - index; // 0 is LSB, 63 is MSB
          return (bigIntValue >> bitNumber) & BigInt.one == BigInt.one;
        });

        state = state.copyWith(
          hexValue: hexVal,
          decValue: decVal,
          octValue: octVal,
          binValue: binVal,
          bitValues: newBitValues,
        );
      } else {
        // If parsing fails, just update the display values without bit array
        state = state.copyWith(
          hexValue: hexVal,
          decValue: decVal,
          octValue: octVal,
          binValue: binVal,
        );
      }
    } catch (e) {
      // If parsing fails, just update the display values without bit array
      state = state.copyWith(
        hexValue: hexVal,
        decValue: decVal,
        octValue: octVal,
        binValue: binVal,
      );
    }
  }

  /// Toggle a specific bit (bitNumber: 63-0, where 0 is LSB)
  /// Sends command 700 + bitNumber to the engine
  /// For example: bit 0 → command 700, bit 63 → command 763
  void toggleBit(int bitNumber) {
    final calculator = ref.read(calculatorProvider.notifier);
    calculator.toggleBit(bitNumber);
  }

  /// Set calculator engine radix to match programmer base
  void _setRadixForBase(ProgrammerBase base) {
    final calculator = ref.read(calculatorProvider.notifier);
    switch (base) {
      case ProgrammerBase.hex:
        calculator.setRadix(CalcRadixType.CALC_RADIX_HEX);
        break;
      case ProgrammerBase.dec:
        calculator.setRadix(CalcRadixType.CALC_RADIX_DECIMAL);
        break;
      case ProgrammerBase.oct:
        calculator.setRadix(CalcRadixType.CALC_RADIX_OCTAL);
        break;
      case ProgrammerBase.bin:
        calculator.setRadix(CalcRadixType.CALC_RADIX_BINARY);
        break;
    }
  }

  /// Set current base
  void setCurrentBase(ProgrammerBase base) {
    state = state.copyWith(currentBase: base);
    // Sync radix to calculator engine
    _setRadixForBase(base);
    // Update all base values from calculator engine to sync display
    updateValuesFromCalculator();
  }

  /// Cycle word size and sync with calculator engine
  /// When word size changes:
  /// - From larger to smaller: clear bits beyond new word size
  /// - From smaller to larger: initialize new bits to 1
  void cycleWordSize() {
    final sizes = WordSize.values;
    final currentIndex = sizes.indexOf(state.wordSize);
    final nextIndex = (currentIndex + 1) % sizes.length;
    final newWordSize = sizes[nextIndex];
    final oldWordSize = state.wordSize;

    // Create new bit values based on word size change
    List<bool> newBitValues;
    if (newWordSize.bits > oldWordSize.bits) {
      // Word size increased: initialize new bits to 1
      newBitValues = List<bool>.generate(64, (index) {
        final bitNumber = 63 - index;
        if (bitNumber >= newWordSize.bits) {
          return false;
        } else if (bitNumber >= oldWordSize.bits) {
          return true;
        } else {
          return state.bitValues[index];
        }
      });
    } else {
      // Word size decreased: clear bits beyond new word size
      newBitValues = List<bool>.generate(64, (index) {
        final bitNumber = 63 - index;
        if (bitNumber >= newWordSize.bits) {
          return false;
        } else {
          return state.bitValues[index];
        }
      });
    }

    // Update local state with new bit values
    state = state.copyWith(wordSize: newWordSize, bitValues: newBitValues);

    // Sync with calculator engine
    final calculator = ref.read(calculatorProvider.notifier);
    switch (newWordSize) {
      case WordSize.qword:
        calculator.setQword();
        break;
      case WordSize.dword:
        calculator.setDword();
        break;
      case WordSize.word:
        calculator.setWord();
        break;
      case WordSize.byte:
        calculator.setByte();
        break;
    }
  }

  /// Set word size directly (only updates local state, does not call engine)
  /// This should be used in combination with calculator engine commands
  /// to ensure state stays in sync (similar to how setAngleType works in scientific mode)
  void setWordSize(WordSize newWordSize) {
    final oldWordSize = state.wordSize;

    // Create new bit values based on word size change
    List<bool> newBitValues;
    if (newWordSize.bits > oldWordSize.bits) {
      // Word size increased: initialize new bits to 1
      newBitValues = List<bool>.generate(64, (index) {
        final bitNumber = 63 - index;
        if (bitNumber >= newWordSize.bits) {
          return false;
        } else if (bitNumber >= oldWordSize.bits) {
          return true;
        } else {
          return state.bitValues[index];
        }
      });
    } else {
      // Word size decreased: clear bits beyond new word size
      newBitValues = List<bool>.generate(64, (index) {
        final bitNumber = 63 - index;
        if (bitNumber >= newWordSize.bits) {
          return false;
        } else {
          return state.bitValues[index];
        }
      });
    }

    // Update local state only (caller is responsible for syncing with engine)
    state = state.copyWith(wordSize: newWordSize, bitValues: newBitValues);
  }

  /// Toggle input mode
  void toggleInputMode() {
    final newMode = state.inputMode == ProgrammerInputMode.fullKeypad
        ? ProgrammerInputMode.bitFlip
        : ProgrammerInputMode.fullKeypad;
    state = state.copyWith(inputMode: newMode);
  }

  /// Set shift mode
  void setShiftMode(ShiftMode mode) {
    state = state.copyWith(shiftMode: mode);
  }

  /// Get display value for a base
  String getValueForBase(ProgrammerBase base) {
    switch (base) {
      case ProgrammerBase.hex:
        return state.hexValue;
      case ProgrammerBase.dec:
        return state.decValue;
      case ProgrammerBase.oct:
        return state.octValue;
      case ProgrammerBase.bin:
        return state.binValue;
    }
  }
}

/// Programmer calculator provider
final programmerProvider =
    NotifierProvider<ProgrammerNotifier, ProgrammerState>(() {
      return ProgrammerNotifier();
    });
