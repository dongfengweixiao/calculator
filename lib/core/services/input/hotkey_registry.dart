import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:wincalc_engine/wincalc_engine.dart';
import 'package:logging/logging.dart';
import '../../../features/calculator/calculator_provider.dart';
import '../../../features/scientific/scientific_provider.dart';
import '../../../features/programmer/programmer_provider.dart';
import '../../domain/entities/angle_type.dart';
import '../../services/calculator_service.dart';

/// Logger for hotkey registration and events
final log = Logger('HotkeyRegistry');

/// Registry for managing calculator hotkeys using hotkey_manager
///
/// This class provides a unified interface for registering all calculator
/// shortcuts as hotkeys, including F-keys which cannot be captured by
/// Flutter's standard keyboard event system.
class HotkeyRegistry {
  final WidgetRef ref;
  final BuildContext context;

  HotkeyRegistry(this.ref, this.context);

  bool _isInitialized = false;

  /// Initialize hotkeys for the specified calculator mode
  Future<void> initializeForMode(CalculatorMode mode) async {
    log.info('🎯 [HotkeyRegistry] Initializing for mode: $mode');

    if (_isInitialized) {
      log.info('  🔄 Unregistering all previous hotkeys...');
      await unregisterAll();
    }

    // Register all mode-independent hotkeys
    log.info('  📝 Registering basic keys...');
    await _registerBasicKeys();

    log.info('  ⌨️  Registering common shortcuts...');
    await _registerCommonShortcuts();

    // Register mode-specific hotkeys
    switch (mode) {
      case CalculatorMode.standard:
        log.info('  🔢 Standard mode - no additional hotkeys');
        break;
      case CalculatorMode.scientific:
        log.info('  🔬 Scientific mode - registering scientific hotkeys');
        await _registerScientificHotkeys();
        break;
      case CalculatorMode.programmer:
        log.info('  💻 Programmer mode - registering programmer hotkeys');
        await _registerProgrammerHotkeys();
        break;
    }

    _isInitialized = true;
    log.info('✅ [HotkeyRegistry] Initialization complete for $mode');
  }

  /// Unregister all hotkeys
  Future<void> unregisterAll() async {
    await hotKeyManager.unregisterAll();
    _isInitialized = false;
  }

  /// Register basic input keys (digits, operators, special keys)
  /// Available in all modes
  Future<void> _registerBasicKeys() async {
    final calculator = ref.read(calculatorProvider.notifier);

    // Digits 0-9 (main keyboard) - using inapp scope to avoid conflicts
    for (int i = 0; i <= 9; i++) {
      final digit = i;
      await hotKeyManager.register(
        HotKey(
          key: _getDigitKey(i),
          identifier: 'digit_$i',
          scope: HotKeyScope.inapp,
        ),
        keyDownHandler: (_) => calculator.inputDigit(digit),
      );
    }

    // Numpad digits 0-9
    for (int i = 0; i <= 9; i++) {
      final digit = i;
      await hotKeyManager.register(
        HotKey(
          key: _getNumpadDigitKey(i),
          identifier: 'numpad_$i',
          scope: HotKeyScope.inapp,
        ),
        keyDownHandler: (_) => calculator.inputDigit(digit),
      );
    }

    // Operators
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.numpadAdd, identifier: 'add', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.add(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.minus, identifier: 'subtract', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.subtract(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.numpadSubtract, identifier: 'numpad_subtract', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.subtract(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.numpadMultiply, identifier: 'multiply', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.multiply(),
    );
    // Main keyboard * (Shift+8) for multiplication
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit8,
        modifiers: [HotKeyModifier.shift],
        identifier: 'multiply_shift8',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.multiply(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.slash, identifier: 'divide', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.divide(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.numpadDivide, identifier: 'numpad_divide', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.divide(),
    );

    // Special keys
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.enter, identifier: 'equals', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.equals(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.numpadEnter, identifier: 'numpad_equals', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.equals(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.equal, identifier: 'equal_sign', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.equals(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.escape, identifier: 'clear', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.clear(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.delete, identifier: 'clear_entry', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.clearEntry(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.backspace, identifier: 'backspace', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.backspace(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.period, identifier: 'decimal', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.inputDecimal(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.numpadDecimal, identifier: 'numpad_decimal', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.inputDecimal(),
    );

    // F9 for negate
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.f9, identifier: 'f9_negate', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.inputNegate(),
    );

    // Parentheses: ( = Shift+0, ) = Shift+9
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit9,
        modifiers: [HotKeyModifier.shift],
        identifier: 'open_paren',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.openParen(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit0,
        modifiers: [HotKeyModifier.shift],
        identifier: 'close_paren',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.closeParen(),
    );

    // Percent: % = Shift+5
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit5,
        modifiers: [HotKeyModifier.shift],
        identifier: 'percent',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.percent(),
    );
  }

  PhysicalKeyboardKey _getDigitKey(int digit) {
    switch (digit) {
      case 0:
        return PhysicalKeyboardKey.digit0;
      case 1:
        return PhysicalKeyboardKey.digit1;
      case 2:
        return PhysicalKeyboardKey.digit2;
      case 3:
        return PhysicalKeyboardKey.digit3;
      case 4:
        return PhysicalKeyboardKey.digit4;
      case 5:
        return PhysicalKeyboardKey.digit5;
      case 6:
        return PhysicalKeyboardKey.digit6;
      case 7:
        return PhysicalKeyboardKey.digit7;
      case 8:
        return PhysicalKeyboardKey.digit8;
      case 9:
        return PhysicalKeyboardKey.digit9;
      default:
        return PhysicalKeyboardKey.digit0;
    }
  }

  PhysicalKeyboardKey _getNumpadDigitKey(int digit) {
    switch (digit) {
      case 0:
        return PhysicalKeyboardKey.numpad0;
      case 1:
        return PhysicalKeyboardKey.numpad1;
      case 2:
        return PhysicalKeyboardKey.numpad2;
      case 3:
        return PhysicalKeyboardKey.numpad3;
      case 4:
        return PhysicalKeyboardKey.numpad4;
      case 5:
        return PhysicalKeyboardKey.numpad5;
      case 6:
        return PhysicalKeyboardKey.numpad6;
      case 7:
        return PhysicalKeyboardKey.numpad7;
      case 8:
        return PhysicalKeyboardKey.numpad8;
      case 9:
        return PhysicalKeyboardKey.numpad9;
      default:
        return PhysicalKeyboardKey.numpad0;
    }
  }

  /// Register common shortcuts (mode switching, memory operations)
  /// Available in all modes
  Future<void> _registerCommonShortcuts() async {
    final calculator = ref.read(calculatorProvider.notifier);

    // Mode switching: Alt + 1-5
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit1,
        modifiers: [HotKeyModifier.alt],
        identifier: 'mode_standard',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => GoRouter.of(context).go('/standard'),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit2,
        modifiers: [HotKeyModifier.alt],
        identifier: 'mode_scientific',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => GoRouter.of(context).go('/scientific'),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit3,
        modifiers: [HotKeyModifier.alt],
        identifier: 'mode_programmer',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => GoRouter.of(context).go('/programmer'),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit4,
        modifiers: [HotKeyModifier.alt],
        identifier: 'mode_date',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => GoRouter.of(context).go('/date-calculation'),
    );

    // Memory operations: Ctrl + M/P/Q/R/L
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyM,
        modifiers: [HotKeyModifier.control],
        identifier: 'memory_store',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.memoryStore(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyP,
        modifiers: [HotKeyModifier.control],
        identifier: 'memory_add',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.memoryAdd(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyQ,
        modifiers: [HotKeyModifier.control],
        identifier: 'memory_subtract',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.memorySubtract(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyR,
        modifiers: [HotKeyModifier.control],
        identifier: 'memory_recall',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.memoryRecall(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyL,
        modifiers: [HotKeyModifier.control],
        identifier: 'memory_clear',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.memoryClear(),
    );

    // Common functions
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyR, identifier: 'reciprocal', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.reciprocal(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit2,
        modifiers: [HotKeyModifier.shift],
        identifier: 'square_root',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.squareRoot(),
    );
  }

  /// Register scientific calculator specific hotkeys
  Future<void> _registerScientificHotkeys() async {
    final calculator = ref.read(calculatorProvider.notifier);

    log.info('🔬 [HotkeyRegistry] Registering scientific calculator hotkeys...');

    // Helper function to sync angle type from engine to UI
    void syncAngleType() {
      // Read angle type from engine (DEG=0, RAD=1, GRAD=2)
      final engineAngleType = calculator.service.getAngleType();

      // Map engine value to AngleType enum
      final angleType = switch (engineAngleType) {
        0 => AngleType.degree,
        1 => AngleType.radian,
        2 => AngleType.gradian,
        _ => AngleType.degree, // Default to DEG
      };

      // Update UI state
      ref.read(scientificProvider.notifier).setAngleType(angleType);
      log.info('  🔄 Synced angle type from engine: $engineAngleType -> $angleType');
    }

    // Angle mode: F3/F4/F5 for DEG/RAD/GRAD
    try {
      await hotKeyManager.register(
        HotKey(key: PhysicalKeyboardKey.f3, identifier: 'sci_deg', scope: HotKeyScope.inapp),
        keyDownHandler: (_) {
          log.info('✅ F3 pressed - DEG mode');
          calculator.setAngleType(0);
          syncAngleType();
        },
      );
      log.info('  ✅ F3 (DEG) registered');
    } catch (e) {
      log.info('  ❌ F3 registration failed: $e');
    }

    try {
      await hotKeyManager.register(
        HotKey(key: PhysicalKeyboardKey.f4, identifier: 'sci_rad', scope: HotKeyScope.inapp),
        keyDownHandler: (_) {
          log.info('✅ F4 pressed - RAD mode');
          calculator.setAngleType(1);
          syncAngleType();
        },
      );
      log.info('  ✅ F4 (RAD) registered');
    } catch (e) {
      log.info('  ❌ F4 registration failed: $e');
    }

    try {
      await hotKeyManager.register(
        HotKey(key: PhysicalKeyboardKey.f5, identifier: 'sci_grad', scope: HotKeyScope.inapp),
        keyDownHandler: (_) {
          log.info('✅ F5 pressed - GRAD mode');
          calculator.setAngleType(2);
          syncAngleType();
        },
      );
      log.info('  ✅ F5 (GRAD) registered');
    } catch (e) {
      log.info('  ❌ F5 registration failed: $e');
    }

    // Trigonometric functions: S/O/T
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyS, identifier: 'sci_sin', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.sin(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyO, identifier: 'sci_cos', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.cos(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyT, identifier: 'sci_tan', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.tan(),
    );

    // Inverse trigonometric: Shift + S/O/T
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyS,
        modifiers: [HotKeyModifier.shift],
        identifier: 'sci_asin',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.asin(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyO,
        modifiers: [HotKeyModifier.shift],
        identifier: 'sci_acos',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.acos(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyT,
        modifiers: [HotKeyModifier.shift],
        identifier: 'sci_atan',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.atan(),
    );

    // Hyperbolic: Ctrl + O/S/T
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyO,
        modifiers: [HotKeyModifier.control],
        identifier: 'sci_cosh',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.cosh(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyS,
        modifiers: [HotKeyModifier.control],
        identifier: 'sci_sinh',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.sinh(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyT,
        modifiers: [HotKeyModifier.control],
        identifier: 'sci_tanh',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.tanh(),
    );

    // Logarithmic: L/N
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyL, identifier: 'sci_log', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.log(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyN, identifier: 'sci_ln', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.ln(),
    );

    // Exponential with Ctrl: Ctrl+N/G/Y
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyN,
        modifiers: [HotKeyModifier.control],
        identifier: 'sci_pow_e',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.powE(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyG,
        modifiers: [HotKeyModifier.control],
        identifier: 'sci_pow_10',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.pow10(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.keyY,
        modifiers: [HotKeyModifier.control],
        identifier: 'sci_y_root',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.yRoot(),
    );

    // Other scientific functions
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyX, identifier: 'sci_exp', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.exp(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyY, identifier: 'sci_power', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.power(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit6,
        modifiers: [HotKeyModifier.shift],
        identifier: 'sci_power_shift6',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.power(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyQ, identifier: 'sci_square', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.square(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit3,
        modifiers: [HotKeyModifier.shift],
        identifier: 'sci_cube',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.cube(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyP, identifier: 'sci_pi', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.pi(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyD, identifier: 'sci_mod', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.mod(),
    );

    // Additional scientific functions
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit1,
        modifiers: [HotKeyModifier.shift],
        identifier: 'sci_factorial',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.factorial(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyM, identifier: 'sci_dms', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.dms(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyV, identifier: 'sci_fe_toggle', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.toggleFE(),
    );
  }

  /// Register programmer calculator specific hotkeys
  Future<void> _registerProgrammerHotkeys() async {
    final calculator = ref.read(calculatorProvider.notifier);

    log.info('💻 [HotkeyRegistry] Registering programmer calculator hotkeys...');

    // Helper function to sync word width from engine to UI
    void syncWordWidth() {
      // Read word width from engine (QWORD=0, DWORD=1, WORD=2, BYTE=3)
      final engineWordWidth = calculator.service.getWordWidth();

      // Map engine value to WordSize enum
      final wordSize = switch (engineWordWidth) {
        0 => WordSize.qword,
        1 => WordSize.dword,
        2 => WordSize.word,
        3 => WordSize.byte,
        _ => WordSize.dword, // Default to DWORD
      };

      // Update UI state
      ref.read(programmerProvider.notifier).setWordSize(wordSize);
      log.info('  🔄 Synced word width from engine: $engineWordWidth -> $wordSize');
    }

    // Word size: F2/F3/F4/F12
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.f2, identifier: 'prog_dword', scope: HotKeyScope.inapp),
      keyDownHandler: (_) {
        log.info('✅ F2 pressed - DWORD');
        calculator.setDword();
        syncWordWidth();
      },
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.f3, identifier: 'prog_word', scope: HotKeyScope.inapp),
      keyDownHandler: (_) {
        log.info('✅ F3 pressed - WORD');
        calculator.setWord();
        syncWordWidth();
      },
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.f4, identifier: 'prog_byte', scope: HotKeyScope.inapp),
      keyDownHandler: (_) {
        log.info('✅ F4 pressed - BYTE');
        calculator.setByte();
        syncWordWidth();
      },
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.f12, identifier: 'prog_qword', scope: HotKeyScope.inapp),
      keyDownHandler: (_) {
        log.info('✅ F12 pressed - QWORD');
        calculator.setQword();
        syncWordWidth();
      },
    );

    // Radix/base: F5/F6/F7/F8
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.f5, identifier: 'prog_hex', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.setRadix(CalcRadixType.CALC_RADIX_HEX),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.f6, identifier: 'prog_decimal', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.setRadix(CalcRadixType.CALC_RADIX_DECIMAL),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.f7, identifier: 'prog_octal', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.setRadix(CalcRadixType.CALC_RADIX_OCTAL),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.f8, identifier: 'prog_binary', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.setRadix(CalcRadixType.CALC_RADIX_BINARY),
    );

    // Hexadecimal input: A-F
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyA, identifier: 'prog_hex_a', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.inputDigit(10),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyB, identifier: 'prog_hex_b', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.inputDigit(11),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyC, identifier: 'prog_hex_c', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.inputDigit(12),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyD, identifier: 'prog_hex_d', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.inputDigit(13),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyE, identifier: 'prog_hex_e', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.inputDigit(14),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyF, identifier: 'prog_hex_f', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.inputDigit(15),
    );

    // Bitwise operations
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.digit7,
        modifiers: [HotKeyModifier.shift],
        identifier: 'prog_and',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.bitwiseAnd(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.backslash,
        modifiers: [HotKeyModifier.shift],
        identifier: 'prog_or',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.bitwiseOr(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.backquote,
        modifiers: [HotKeyModifier.shift],
        identifier: 'prog_not',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.bitwiseNot(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyD, identifier: 'prog_mod', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.mod(),
    );

    // Shift and rotate
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.comma,
        modifiers: [HotKeyModifier.shift],
        identifier: 'prog_lsh',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.leftShift(),
    );
    await hotKeyManager.register(
      HotKey(
        key: PhysicalKeyboardKey.period,
        modifiers: [HotKeyModifier.shift],
        identifier: 'prog_rsh',
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => calculator.rightShiftArithmetic(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyJ, identifier: 'prog_rol', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.rotateLeft(),
    );
    await hotKeyManager.register(
      HotKey(key: PhysicalKeyboardKey.keyK, identifier: 'prog_ror', scope: HotKeyScope.inapp),
      keyDownHandler: (_) => calculator.rotateRight(),
    );
  }
}
