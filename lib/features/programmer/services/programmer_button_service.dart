import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../calculator/calculator_provider.dart';
import '../programmer_provider.dart';

/// Service to handle button press logic for programmer calculator mode
class ProgrammerButtonService {
  final WidgetRef _ref;

  ProgrammerButtonService(this._ref);

  /// Handle button press based on label
  void handleButtonPress(String label, ProgrammerState programmerState) {
    final calculator = _ref.read(calculatorProvider.notifier);

    switch (label) {
      // Hexadecimal digits
      case 'A':
      case 'B':
      case 'C':
      case 'D':
      case 'E':
      case 'F':
        calculator.inputDigit(int.parse(label, radix: 16));
        break;

      // Decimal digits
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        calculator.inputDigit(int.parse(label));
        break;

      // Decimal point
      case '.':
        calculator.inputDecimal();
        break;

      // Basic operations
      case '+':
        calculator.add();
        break;
      case '-':
        calculator.subtract();
        break;
      case '×':
        calculator.multiply();
        break;
      case '÷':
        calculator.divide();
        break;
      case '%':
        calculator.percent();
        break;

      // Parentheses
      case '(':
        calculator.openParen();
        break;
      case ')':
        calculator.closeParen();
        break;

      // Equals
      case '=':
        calculator.equals();
        break;

      // Clear operations
      case 'C/CE':
        calculator.clearEntry();
        break;

      // Backspace
      case 'DEL':
        calculator.backspace();
        break;

      // Shift operations
      case '<<':
        _handleLeftShift(programmerState.shiftMode);
        break;
      case '>>':
        _handleRightShift(programmerState.shiftMode);
        break;

      // Negate
      case '±':
        calculator.inputNegate();
        break;
    }
  }

  /// Handle left shift operation based on current shift mode
  void _handleLeftShift(ShiftMode shiftMode) {
    final calculator = _ref.read(calculatorProvider.notifier);
    switch (shiftMode) {
      case ShiftMode.arithmetic:
      case ShiftMode.logical:
        calculator.leftShift();
        break;
      case ShiftMode.rotate:
        calculator.rotateLeft();
        break;
      case ShiftMode.rotateCarry:
        calculator.rotateLeftCarry();
        break;
    }
  }

  /// Handle right shift operation based on current shift mode
  void _handleRightShift(ShiftMode shiftMode) {
    final calculator = _ref.read(calculatorProvider.notifier);
    switch (shiftMode) {
      case ShiftMode.arithmetic:
        calculator.rightShiftArithmetic();
        break;
      case ShiftMode.logical:
        calculator.rightShiftLogical();
        break;
      case ShiftMode.rotate:
        calculator.rotateRight();
        break;
      case ShiftMode.rotateCarry:
        calculator.rotateRightCarry();
        break;
    }
  }

  /// Check if a button should be disabled based on current base mode
  bool isButtonDisabled(String label, ProgrammerState state) {
    // Decimal point is always disabled in programmer mode
    if (label == '.') return true;

    // Define available digits for each base
    switch (state.currentBase) {
      case ProgrammerBase.hex:
        // Hex: 0-9, A-F are all available
        return false;

      case ProgrammerBase.dec:
        // Decimal: 0-9 available, A-F disabled
        return ['A', 'B', 'C', 'D', 'E', 'F'].contains(label);

      case ProgrammerBase.oct:
        // Octal: 0-7 available, 8-9 and A-F disabled
        return ['8', '9', 'A', 'B', 'C', 'D', 'E', 'F'].contains(label);

      case ProgrammerBase.bin:
        // Binary: 0-1 available, 2-9 and A-F disabled
        return ['2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'].contains(label);
    }
  }
}
