import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wincalc_engine/wincalc_engine.dart';
import '../../../features/calculator/calculator_provider.dart';
import '../../services/calculator_service.dart';

/// Keyboard event handler for calculator input
///
/// Handles global keyboard events at the AppShell level and maps them
/// to calculator operations. Supports all calculator modes with
/// mode-specific shortcuts.
class KeyboardHandler {
  final WidgetRef ref;
  final BuildContext context;

  KeyboardHandler(this.ref, this.context);

  /// Main keyboard event handling entry point
  KeyEventResult handleKeyEvent(KeyEvent event) {
    // Only handle key down events, ignore repeat and up events
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    // Get current calculator mode
    final currentMode = _getCurrentCalculatorMode();

    // Dispatch to appropriate handler
    return _mapKeyToAction(event, currentMode);
  }

  /// Get current calculator mode from route
  CalculatorMode? _getCurrentCalculatorMode() {
    final routerState = GoRouterState.of(context);
    final path = routerState.uri.path;

    switch (path) {
      case '/standard':
        return CalculatorMode.standard;
      case '/scientific':
        return CalculatorMode.scientific;
      case '/programmer':
        return CalculatorMode.programmer;
      default:
        return null;
    }
  }

  /// Map key events to calculator actions based on current mode
  KeyEventResult _mapKeyToAction(KeyDownEvent event, CalculatorMode? mode) {
    final key = event.logicalKey;

    // Phase 1: Basic digits and operators (all modes)
    if (_handleBasicKeys(event, key)) {
      return KeyEventResult.handled;
    }

    // Phase 2: Common shortcuts (all modes)
    if (_handleCommonShortcuts(event, key)) {
      return KeyEventResult.handled;
    }

    // Phase 3: Scientific calculator shortcuts
    if (mode == CalculatorMode.scientific) {
      if (_handleScientificShortcuts(event, key)) {
        return KeyEventResult.handled;
      }
    }

    // Phase 4: Programmer calculator shortcuts
    if (mode == CalculatorMode.programmer) {
      if (_handleProgrammerShortcuts(event, key)) {
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  /// Helper to check if Alt is pressed
  bool _isAltPressed() {
    return HardwareKeyboard.instance.physicalKeysPressed.any((key) =>
      key == PhysicalKeyboardKey.altLeft ||
      key == PhysicalKeyboardKey.altRight
    );
  }

  /// Helper to check if Control (or Meta on Mac) is pressed
  bool _isControlPressed() {
    return HardwareKeyboard.instance.physicalKeysPressed.any((key) =>
      key == PhysicalKeyboardKey.controlLeft ||
      key == PhysicalKeyboardKey.controlRight ||
      key == PhysicalKeyboardKey.metaLeft ||
      key == PhysicalKeyboardKey.metaRight
    );
  }

  /// Helper to check if Shift is pressed
  bool _isShiftPressed() {
    return HardwareKeyboard.instance.physicalKeysPressed.any((key) =>
      key == PhysicalKeyboardKey.shiftLeft ||
      key == PhysicalKeyboardKey.shiftRight
    );
  }

  /// Phase 1: Basic key handling
  ///
  /// Handles digits, operators, and basic editing keys
  /// Available in all calculator modes
  bool _handleBasicKeys(KeyDownEvent event, LogicalKeyboardKey key) {
    final calculator = ref.read(calculatorProvider.notifier);

    // Skip handling if Alt or Ctrl is pressed (these are for shortcuts)
    if (_isAltPressed() || _isControlPressed()) {
      return false;
    }

    // For digit keys with Shift, check if they're shortcuts first
    if (_isShiftPressed()) {
      // Shift+2 = @ for square root
      // Shift+3 = # for cube
      // Shift+6 = ^ for power
      // Shift+7 = & for bitwise AND
      // Shift+, = < for left shift
      // Shift+. = > for right shift
      // Shift+\ = | for bitwise OR
      // Shift+` = ~ for bitwise NOT
      if (key == LogicalKeyboardKey.digit2 ||
          key == LogicalKeyboardKey.digit3 ||
          key == LogicalKeyboardKey.digit6 ||
          key == LogicalKeyboardKey.digit7 ||
          key == LogicalKeyboardKey.comma ||
          key == LogicalKeyboardKey.period ||
          key == LogicalKeyboardKey.backslash ||
          key == LogicalKeyboardKey.backquote) {
        return false; // Let shortcut handlers deal with these
      }
    }

    // Digit keys 0-9 (top row)
    if (key == LogicalKeyboardKey.digit0) {
      calculator.inputDigit(0);
      return true;
    }
    if (key == LogicalKeyboardKey.digit1) {
      calculator.inputDigit(1);
      return true;
    }
    if (key == LogicalKeyboardKey.digit2) {
      calculator.inputDigit(2);
      return true;
    }
    if (key == LogicalKeyboardKey.digit3) {
      calculator.inputDigit(3);
      return true;
    }
    if (key == LogicalKeyboardKey.digit4) {
      calculator.inputDigit(4);
      return true;
    }
    if (key == LogicalKeyboardKey.digit5) {
      calculator.inputDigit(5);
      return true;
    }
    if (key == LogicalKeyboardKey.digit6) {
      calculator.inputDigit(6);
      return true;
    }
    if (key == LogicalKeyboardKey.digit7) {
      calculator.inputDigit(7);
      return true;
    }
    if (key == LogicalKeyboardKey.digit8) {
      calculator.inputDigit(8);
      return true;
    }
    if (key == LogicalKeyboardKey.digit9) {
      calculator.inputDigit(9);
      return true;
    }

    // Numpad digits 0-9
    if (key == LogicalKeyboardKey.numpad0) {
      calculator.inputDigit(0);
      return true;
    }
    if (key == LogicalKeyboardKey.numpad1) {
      calculator.inputDigit(1);
      return true;
    }
    if (key == LogicalKeyboardKey.numpad2) {
      calculator.inputDigit(2);
      return true;
    }
    if (key == LogicalKeyboardKey.numpad3) {
      calculator.inputDigit(3);
      return true;
    }
    if (key == LogicalKeyboardKey.numpad4) {
      calculator.inputDigit(4);
      return true;
    }
    if (key == LogicalKeyboardKey.numpad5) {
      calculator.inputDigit(5);
      return true;
    }
    if (key == LogicalKeyboardKey.numpad6) {
      calculator.inputDigit(6);
      return true;
    }
    if (key == LogicalKeyboardKey.numpad7) {
      calculator.inputDigit(7);
      return true;
    }
    if (key == LogicalKeyboardKey.numpad8) {
      calculator.inputDigit(8);
      return true;
    }
    if (key == LogicalKeyboardKey.numpad9) {
      calculator.inputDigit(9);
      return true;
    }

    // Operators
    if (key == LogicalKeyboardKey.add || key == LogicalKeyboardKey.numpadAdd) {
      calculator.add();
      return true;
    }

    if (key == LogicalKeyboardKey.minus ||
        key == LogicalKeyboardKey.numpadSubtract) {
      calculator.subtract();
      return true;
    }

    if (key == LogicalKeyboardKey.numpadMultiply) {
      calculator.multiply();
      return true;
    }

    if (key == LogicalKeyboardKey.numpadDivide || key == LogicalKeyboardKey.slash) {
      calculator.divide();
      return true;
    }

    // Special keys
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.equal) {
      calculator.equals();
      return true;
    }

    if (key == LogicalKeyboardKey.escape) {
      calculator.clear();
      return true;
    }

    if (key == LogicalKeyboardKey.delete) {
      calculator.clearEntry();
      return true;
    }

    if (key == LogicalKeyboardKey.backspace) {
      calculator.backspace();
      return true;
    }

    if (key == LogicalKeyboardKey.period ||
        key == LogicalKeyboardKey.numpadDecimal) {
      calculator.inputDecimal();
      return true;
    }

    if (key == LogicalKeyboardKey.f9) {
      calculator.inputNegate();
      return true;
    }

    // Let F2-F8 and F12 pass through to mode-specific handlers
    if (key == LogicalKeyboardKey.f2 ||
        key == LogicalKeyboardKey.f3 ||
        key == LogicalKeyboardKey.f4 ||
        key == LogicalKeyboardKey.f5 ||
        key == LogicalKeyboardKey.f6 ||
        key == LogicalKeyboardKey.f7 ||
        key == LogicalKeyboardKey.f8 ||
        key == LogicalKeyboardKey.f12) {
      return false; // Let scientific/programmer handlers deal with these
    }

    return false;
  }

  /// Phase 2: Common shortcuts
  ///
  /// Mode switching, memory operations, and common functions
  /// Available in all calculator modes
  bool _handleCommonShortcuts(KeyDownEvent event, LogicalKeyboardKey key) {
    final calculator = ref.read(calculatorProvider.notifier);
    final isAltPressed = _isAltPressed();
    final isCtrlPressed = _isControlPressed();

    // Mode switching (Alt + 1-5)
    if (isAltPressed && !isCtrlPressed) {
      if (key == LogicalKeyboardKey.digit1) {
        _navigateTo('/standard');
        return true;
      }
      if (key == LogicalKeyboardKey.digit2) {
        _navigateTo('/scientific');
        return true;
      }
      if (key == LogicalKeyboardKey.digit3) {
        _navigateTo('/programmer');
        return true;
      }
      if (key == LogicalKeyboardKey.digit4) {
        _navigateTo('/date-calculation');
        return true;
      }
      if (key == LogicalKeyboardKey.digit5) {
        // Navigate to graphing calculator (if exists)
        return true;
      }
    }

    // Memory operations (Ctrl + M/P/Q/R/L)
    if (isCtrlPressed && !isAltPressed) {
      if (key == LogicalKeyboardKey.keyM) {
        calculator.memoryStore();
        return true;
      }
      if (key == LogicalKeyboardKey.keyP) {
        calculator.memoryAdd();
        return true;
      }
      if (key == LogicalKeyboardKey.keyQ) {
        calculator.memorySubtract();
        return true;
      }
      if (key == LogicalKeyboardKey.keyR) {
        calculator.memoryRecall();
        return true;
      }
      if (key == LogicalKeyboardKey.keyL) {
        calculator.memoryClear();
        return true;
      }
    }

    // Common functions (no modifiers)
    if (!isCtrlPressed && !isAltPressed) {
      // Note: R key is handled here, but conflicts with mode switching Alt+1
      // We only handle R when Alt is not pressed
      if (key == LogicalKeyboardKey.keyR) {
        calculator.reciprocal();
        return true;
      }
      if (key == LogicalKeyboardKey.digit2 && _isShiftPressed()) {
        // Shift+2 = @
        calculator.squareRoot();
        return true;
      }
    }

    return false;
  }

  /// Navigate to specified route
  void _navigateTo(String path) {
    context.go(path);
  }

  /// Phase 3: Scientific calculator shortcuts
  ///
  /// Trigonometric, exponential, logarithmic functions
  /// Only active in scientific mode
  bool _handleScientificShortcuts(KeyDownEvent event, LogicalKeyboardKey key) {
    final calculator = ref.read(calculatorProvider.notifier);
    final isCtrlPressed = _isControlPressed();
    final isShiftPressed = _isShiftPressed();

    // Trigonometric functions (no modifiers or Shift for inverse)
    if (!isCtrlPressed && !_isAltPressed()) {
      if (key == LogicalKeyboardKey.keyS) {
        if (isShiftPressed) {
          calculator.asin(); // Shift+S = inverse sine
        } else {
          calculator.sin();
        }
        return true;
      }
      if (key == LogicalKeyboardKey.keyO) {
        if (isShiftPressed) {
          calculator.acos(); // Shift+O = inverse cosine
        } else {
          calculator.cos();
        }
        return true;
      }
      if (key == LogicalKeyboardKey.keyT) {
        if (isShiftPressed) {
          calculator.atan(); // Shift+T = inverse tangent
        } else {
          calculator.tan();
        }
        return true;
      }
    }

    // Hyperbolic functions (Ctrl + O/S/T)
    if (isCtrlPressed && !_isAltPressed() && !isShiftPressed) {
      if (key == LogicalKeyboardKey.keyO) {
        calculator.cosh();
        return true;
      }
      if (key == LogicalKeyboardKey.keyS) {
        calculator.sinh();
        return true;
      }
      if (key == LogicalKeyboardKey.keyT) {
        calculator.tanh();
        return true;
      }
    }

    // Exponential and logarithmic functions
    if (!isCtrlPressed && !_isAltPressed()) {
      if (key == LogicalKeyboardKey.keyL) {
        calculator.log();
        return true;
      }
      if (key == LogicalKeyboardKey.keyN) {
        calculator.ln();
        return true;
      }
      if (key == LogicalKeyboardKey.keyX) {
        calculator.exp();
        return true;
      }
      if (key == LogicalKeyboardKey.keyY) {
        calculator.power();
        return true;
      }
      if (key == LogicalKeyboardKey.digit6 && isShiftPressed) {
        // Shift+6 = ^ for power
        calculator.power();
        return true;
      }
    }

    // More exponential functions with Ctrl
    if (isCtrlPressed && !_isAltPressed() && !isShiftPressed) {
      if (key == LogicalKeyboardKey.keyN) {
        calculator.powE(); // e^x
        return true;
      }
      if (key == LogicalKeyboardKey.keyG) {
        calculator.pow10(); // 10^x
        return true;
      }
      if (key == LogicalKeyboardKey.keyY) {
        calculator.yRoot(); // y√x
        return true;
      }
    }

    // Other scientific functions
    if (!isCtrlPressed && !_isAltPressed()) {
      if (key == LogicalKeyboardKey.keyQ) {
        calculator.square(); // x²
        return true;
      }
      if (key == LogicalKeyboardKey.digit3 && isShiftPressed) {
        calculator.cube(); // Shift+3 = # for x³
        return true;
      }
      if (key == LogicalKeyboardKey.keyD) {
        calculator.mod(); // modulo
        return true;
      }
      if (key == LogicalKeyboardKey.keyP) {
        calculator.pi(); // π
        return true;
      }
    }

    return false;
  }

  /// Phase 4: Programmer calculator shortcuts
  ///
  /// Base conversion, bitwise operations, shifts
  /// Only active in programmer mode
  bool _handleProgrammerShortcuts(KeyDownEvent event, LogicalKeyboardKey key) {
    final calculator = ref.read(calculatorProvider.notifier);
    final isCtrlPressed = _isControlPressed();
    final isShiftPressed = _isShiftPressed();

    // Hexadecimal input (A-F)
    if (!isCtrlPressed && !_isAltPressed()) {
      final keyLabel = key.keyLabel.toLowerCase();
      if (keyLabel.length == 1) {
        final charCode = keyLabel.codeUnitAt(0);
        if (charCode >= 97 && charCode <= 102) {
          // a-f
          calculator.inputDigit(10 + (charCode - 97)); // A=10, B=11, ..., F=15
          return true;
        }
      }
    }

    // Word size (F2/F3/F4/F12)
    if (!isCtrlPressed && !_isAltPressed() && !isShiftPressed) {
      if (key == LogicalKeyboardKey.f2) {
        calculator.setDword();
        return true;
      }
      if (key == LogicalKeyboardKey.f3) {
        calculator.setWord();
        return true;
      }
      if (key == LogicalKeyboardKey.f4) {
        calculator.setByte();
        return true;
      }
      if (key == LogicalKeyboardKey.f12) {
        calculator.setQword();
        return true;
      }
    }

    // Radix/base (F5/F6/F7/F8)
    if (!isCtrlPressed && !_isAltPressed() && !isShiftPressed) {
      if (key == LogicalKeyboardKey.f5) {
        calculator.setRadix(CalcRadixType.CALC_RADIX_HEX);
        return true;
      }
      if (key == LogicalKeyboardKey.f6) {
        calculator.setRadix(CalcRadixType.CALC_RADIX_DECIMAL);
        return true;
      }
      if (key == LogicalKeyboardKey.f7) {
        calculator.setRadix(CalcRadixType.CALC_RADIX_OCTAL);
        return true;
      }
      if (key == LogicalKeyboardKey.f8) {
        calculator.setRadix(CalcRadixType.CALC_RADIX_BINARY);
        return true;
      }
    }

    // Bitwise operations
    if (!isCtrlPressed && !_isAltPressed()) {
      if (key == LogicalKeyboardKey.digit7 && isShiftPressed) {
        calculator.bitwiseAnd(); // Shift+7 = &
        return true;
      }
      if (key == LogicalKeyboardKey.backslash && isShiftPressed) {
        calculator.bitwiseOr(); // Shift+\ = |
        return true;
      }
      if (key == LogicalKeyboardKey.backquote && isShiftPressed) {
        calculator.bitwiseNot(); // Shift+` = ~
        return true;
      }
    }

    // Shift and rotate operations
    if (!isCtrlPressed && !_isAltPressed()) {
      if (key == LogicalKeyboardKey.comma && isShiftPressed) {
        calculator.leftShift(); // Shift+, = <
        return true;
      }
      if (key == LogicalKeyboardKey.period && isShiftPressed) {
        calculator.rightShiftArithmetic(); // Shift+. = >
        return true;
      }
      if (key == LogicalKeyboardKey.keyJ) {
        calculator.rotateLeft();
        return true;
      }
      if (key == LogicalKeyboardKey.keyK) {
        calculator.rotateRight();
        return true;
      }
    }

    return false;
  }
}
