import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:logging/logging.dart';
import 'package:wincalc_engine/wincalc_engine.dart';
import '../../../features/calculator/calculator_provider.dart';
import '../../../features/scientific/scientific_provider.dart';
import '../../../features/programmer/programmer_provider.dart';
import '../../../core/domain/entities/angle_type.dart';
import '../calculator_service.dart';
import '../../../shared/navigation/navigation_provider.dart';

abstract class ConverterKeyboardCallback {
  void onNumber(String number);
  void onBackspace();
  void onClear();
  void onNegate();
}

class KeyboardHandler {
  static final _log = Logger('KeyboardHandler');

  final WidgetRef ref;
  final BuildContext context;

  ConverterKeyboardCallback? _converterCallback;

  KeyboardHandler(this.ref, this.context) {
    _log.info('KeyboardHandler created');
  }

  void registerConverterCallback(ConverterKeyboardCallback? callback) {
    _converterCallback = callback;
    _log.fine('Converter callback ${callback != null ? "registered" : "unregistered"}');
  }

  Map<HotKey, VoidCallback> get hotKeyBindings {
    final bindings = <HotKey, VoidCallback>{};

    bindings.addAll(_getDigitKeys());
    bindings.addAll(_getOperatorKeys());
    bindings.addAll(_getFunctionKeys());
    bindings.addAll(_getCommonShortcuts());
    bindings.addAll(_getScientificShortcuts());
    bindings.addAll(_getProgrammerShortcuts());
    bindings.addAll(_getConverterInputKeys());

    _log.fine('Generated ${bindings.length} hotkey bindings');
    return bindings;
  }

  bool _isConverterPage() {
    final routerState = GoRouterState.of(context);
    final path = routerState.uri.path;
    final isConverter = path.startsWith('/converter/');
    _log.fine('Route check: $path -> isConverter: $isConverter');
    return isConverter;
  }

  Map<HotKey, VoidCallback> _getDigitKeys() {
    final calculator = ref.read(calculatorProvider.notifier);
    final bindings = <HotKey, VoidCallback>{};

    for (int i = 0; i <= 9; i++) {
      final digit = i;
      bindings[HotKey(
        key: _getDigitKey(digit),
        identifier: 'digit_$digit',
        scope: HotKeyScope.inapp,
      )] = () {
        _log.fine('Digit key pressed: $digit');
        return calculator.inputDigit(digit);
      };
      bindings[HotKey(
        key: _getNumpadKey(digit),
        identifier: 'numpad_$digit',
        scope: HotKeyScope.inapp,
      )] = () {
        _log.fine('Numpad digit pressed: $digit');
        return calculator.inputDigit(digit);
      };
    }

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyA,
      identifier: 'hex_A',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Hex digit A pressed');
      return calculator.inputDigit(10);
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.keyB,
      identifier: 'hex_B',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Hex digit B pressed');
      return calculator.inputDigit(11);
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.keyC,
      identifier: 'hex_C',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Hex digit C pressed');
      return calculator.inputDigit(12);
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.keyD,
      identifier: 'hex_D',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Hex digit D pressed');
      return calculator.inputDigit(13);
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.keyE,
      identifier: 'hex_E',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Hex digit E pressed');
      return calculator.inputDigit(14);
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.keyF,
      identifier: 'hex_F',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Hex digit F pressed');
      return calculator.inputDigit(15);
    };

    _log.fine('Generated ${bindings.length} digit key bindings');
    return bindings;
  }

  Map<HotKey, VoidCallback> _getConverterInputKeys() {
    final bindings = <HotKey, VoidCallback>{};

    if (_isConverterPage() && _converterCallback != null) {
      _log.fine('Setting up converter input keys');
      for (int i = 0; i <= 9; i++) {
        final digit = i.toString();
        bindings[HotKey(
          key: _getDigitKey(i),
          identifier: 'converter_digit_$digit',
          scope: HotKeyScope.inapp,
        )] = () {
          _log.fine('Converter number input: $digit');
          return _converterCallback!.onNumber(digit);
        };
        bindings[HotKey(
          key: _getNumpadKey(i),
          identifier: 'converter_numpad_$digit',
          scope: HotKeyScope.inapp,
        )] = () {
          _log.fine('Converter numpad input: $digit');
          return _converterCallback!.onNumber(digit);
        };
      }

      bindings[HotKey(
        key: PhysicalKeyboardKey.period,
        identifier: 'converter_period',
        scope: HotKeyScope.inapp,
      )] = () {
        _log.fine('Converter decimal point input');
        return _converterCallback!.onNumber('.');
      };
      bindings[HotKey(
        key: PhysicalKeyboardKey.numpadDecimal,
        identifier: 'converter_numpad_decimal',
        scope: HotKeyScope.inapp,
      )] = () {
        _log.fine('Converter numpad decimal input');
        return _converterCallback!.onNumber('.');
      };

      bindings[HotKey(
        key: PhysicalKeyboardKey.backspace,
        identifier: 'converter_backspace',
        scope: HotKeyScope.inapp,
      )] = () {
        _log.fine('Converter backspace');
        return _converterCallback!.onBackspace();
      };

      bindings[HotKey(
        key: PhysicalKeyboardKey.escape,
        identifier: 'converter_escape',
        scope: HotKeyScope.inapp,
      )] = () {
        _log.fine('Converter clear (Escape)');
        return _converterCallback!.onClear();
      };
      bindings[HotKey(
        key: PhysicalKeyboardKey.delete,
        identifier: 'converter_delete',
        scope: HotKeyScope.inapp,
      )] = () {
        _log.fine('Converter clear (Delete)');
        return _converterCallback!.onClear();
      };

      bindings[HotKey(
        key: PhysicalKeyboardKey.f9,
        identifier: 'converter_f9',
        scope: HotKeyScope.inapp,
      )] = () {
        _log.fine('Converter negate (F9)');
        try {
          _converterCallback!.onNegate();
        } catch (e) {
          _log.warning('Converter negate not supported', e);
        }
      };

      _log.fine('Generated ${bindings.length} converter input key bindings');
    } else {
      _log.fine('Skipping converter input keys: page=$_isConverterPage(), callback=$_converterCallback');
    }

    return bindings;
  }

  Map<HotKey, VoidCallback> _getOperatorKeys() {
    final calculator = ref.read(calculatorProvider.notifier);
    final bindings = <HotKey, VoidCallback>{};

    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadAdd,
      identifier: 'numpad_add',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Operator key pressed: numpad add');
      return calculator.add();
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.minus,
      identifier: 'minus',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Operator key pressed: minus');
      return calculator.subtract();
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadSubtract,
      identifier: 'numpad_subtract',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Operator key pressed: numpad subtract');
      return calculator.subtract();
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadMultiply,
      identifier: 'numpad_multiply',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Operator key pressed: numpad multiply');
      return calculator.multiply();
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.digit8,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_multiply',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Operator key pressed: shift+* multiply');
      return calculator.multiply();
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.slash,
      identifier: 'slash',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Operator key pressed: slash');
      return calculator.divide();
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadDivide,
      identifier: 'numpad_divide',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Operator key pressed: numpad divide');
      return calculator.divide();
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.enter,
      identifier: 'enter',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Operator key pressed: enter equals');
      return calculator.equals();
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadEnter,
      identifier: 'numpad_enter',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Operator key pressed: numpad enter equals');
      return calculator.equals();
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.equal,
      identifier: 'equal',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Operator key pressed: equal equals');
      return calculator.equals();
    };
    bindings[HotKey(
      key: PhysicalKeyboardKey.digit5,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_percent',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Operator key pressed: shift+% percent');
      return calculator.percent();
    };

    return bindings;
  }

  Map<HotKey, VoidCallback> _getFunctionKeys() {
    final calculator = ref.read(calculatorProvider.notifier);
    final bindings = <HotKey, VoidCallback>{};

    bindings[HotKey(
      key: PhysicalKeyboardKey.escape,
      identifier: 'escape_clear',
      scope: HotKeyScope.inapp,
    )] = () =>
        calculator.clear();
    bindings[HotKey(
      key: PhysicalKeyboardKey.delete,
      identifier: 'delete_clear_entry',
      scope: HotKeyScope.inapp,
    )] = () =>
        calculator.clearEntry();
    bindings[HotKey(
      key: PhysicalKeyboardKey.backspace,
      identifier: 'backspace',
      scope: HotKeyScope.inapp,
    )] = () =>
        calculator.backspace();
    bindings[HotKey(
      key: PhysicalKeyboardKey.period,
      identifier: 'period',
      scope: HotKeyScope.inapp,
    )] = () =>
        calculator.inputDecimal();
    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadDecimal,
      identifier: 'numpad_decimal',
      scope: HotKeyScope.inapp,
    )] = () =>
        calculator.inputDecimal();
    bindings[HotKey(
      key: PhysicalKeyboardKey.digit9,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_open_paren',
      scope: HotKeyScope.inapp,
    )] = () =>
        calculator.openParen();
    bindings[HotKey(
      key: PhysicalKeyboardKey.digit0,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_close_paren',
      scope: HotKeyScope.inapp,
    )] = () =>
        calculator.closeParen();
    bindings[HotKey(
      key: PhysicalKeyboardKey.f9,
      identifier: 'f9_negate',
      scope: HotKeyScope.inapp,
    )] = () =>
        calculator.inputNegate();

    return bindings;
  }

  Map<HotKey, VoidCallback> _getCommonShortcuts() {
    final calculator = ref.read(calculatorProvider.notifier);
    final bindings = <HotKey, VoidCallback>{};

    // 常用函数
    bindings[HotKey(
      key: PhysicalKeyboardKey.keyR,
      identifier: 'key_r_reciprocal',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: reciprocal (R)');
      return calculator.reciprocal();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.digit2,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_2_square_root',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: square root (Shift+2)');
      return calculator.squareRoot();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.space,
      identifier: 'space_repeat',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: repeat last input (Space)');
      return _repeatLastInput();
    };

    // 内存操作
    bindings[HotKey(
      key: PhysicalKeyboardKey.keyM,
      modifiers: [HotKeyModifier.control],
      identifier: 'ctrl_m_memory_store',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: memory store (Ctrl+M)');
      return calculator.memoryStore();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyP,
      modifiers: [HotKeyModifier.control],
      identifier: 'ctrl_p_memory_add',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: memory add (Ctrl+P)');
      return calculator.memoryAdd();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyQ,
      modifiers: [HotKeyModifier.control],
      identifier: 'ctrl_q_memory_subtract',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: memory subtract (Ctrl+Q)');
      return calculator.memorySubtract();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyR,
      modifiers: [HotKeyModifier.control],
      identifier: 'ctrl_r_memory_recall',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: memory recall (Ctrl+R)');
      return calculator.memoryRecall();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyL,
      modifiers: [HotKeyModifier.control],
      identifier: 'ctrl_l_memory_clear',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: memory clear (Ctrl+L)');
      return calculator.memoryClear();
    };

    // 模式切换
    bindings[HotKey(
      key: PhysicalKeyboardKey.digit1,
      modifiers: [HotKeyModifier.alt],
      identifier: 'alt_1_standard_mode',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: switch to standard mode (Alt+1)');
      return _navigateTo('/standard');
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.digit2,
      modifiers: [HotKeyModifier.alt],
      identifier: 'alt_2_scientific_mode',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: switch to scientific mode (Alt+2)');
      return _navigateTo('/scientific');
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.digit3,
      modifiers: [HotKeyModifier.alt],
      identifier: 'alt_3_programmer_mode',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: switch to programmer mode (Alt+3)');
      return _navigateTo('/programmer');
    };

    // 历史面板控制
    bindings[HotKey(
      key: PhysicalKeyboardKey.keyH,
      modifiers: [HotKeyModifier.control],
      identifier: 'ctrl_h_toggle_history',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: toggle history panel (Ctrl+H)');
      return _toggleHistoryPanel();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.arrowUp,
      identifier: 'arrow_up_history_prev',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: navigate history up (ArrowUp)');
      return _navigateHistory(-1);
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.arrowDown,
      identifier: 'arrow_down_history_next',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: navigate history down (ArrowDown)');
      return _navigateHistory(1);
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyD,
      modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
      identifier: 'ctrl_shift_d_clear_history',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Common shortcut: clear history (Ctrl+Shift+D)');
      return _clearHistory();
    };

    _log.fine('Generated ${bindings.length} common shortcut bindings');
    return bindings;
  }

  Map<HotKey, VoidCallback> _getScientificShortcuts() {
    final calculator = ref.read(calculatorProvider.notifier);
    final bindings = <HotKey, VoidCallback>{};

    _log.fine('Generating scientific calculator shortcuts...');

    // Note: F2, F3, F4 conflict with programmer mode shortcuts
    // They will be handled in _getProgrammerShortcuts with mode checking

    bindings[HotKey(
      key: PhysicalKeyboardKey.f3,
      identifier: 'f3_degree',
      scope: HotKeyScope.inapp,
    )] = () {
      final currentMode = ref.read(calculatorProvider).mode;
      if (currentMode != CalculatorMode.scientific) {
        _log.fine('F3 ignored (not in scientific mode, current: $currentMode)');
        return;
      }

      _log.fine('Scientific shortcut: F3 - Degree mode');
      calculator.setAngleType(AngleType.degree.value);

      // Verify and sync from engine
      final actualAngleType = calculator.service.getAngleType();
      final angleTypeEnum = AngleType.fromValue(actualAngleType);
      ref.read(scientificProvider.notifier).setAngleType(angleTypeEnum);

      _log.fine('Synced scientific provider to Degree mode (engine confirmed: $actualAngleType)');
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.f4,
      identifier: 'f4_radian',
      scope: HotKeyScope.inapp,
    )] = () {
      final currentMode = ref.read(calculatorProvider).mode;
      if (currentMode != CalculatorMode.scientific) {
        _log.fine('F4 ignored (not in scientific mode, current: $currentMode)');
        return;
      }

      _log.fine('Scientific shortcut: F4 - Radian mode');
      calculator.setAngleType(AngleType.radian.value);

      // Verify and sync from engine
      final actualAngleType = calculator.service.getAngleType();
      final angleTypeEnum = AngleType.fromValue(actualAngleType);
      ref.read(scientificProvider.notifier).setAngleType(angleTypeEnum);

      _log.fine('Synced scientific provider to Radian mode (engine confirmed: $actualAngleType)');
    };

    // Note: F5 is handled by _getProgrammerShortcuts to avoid conflict
    // The handler will check the current mode and call the appropriate function
    bindings[HotKey(
      key: PhysicalKeyboardKey.keyS,
      identifier: 'key_s_sin',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Scientific shortcut: S - sin');
      calculator.sin();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyO,
      identifier: 'key_o_cos',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Scientific shortcut: O - cos');
      calculator.cos();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyT,
      identifier: 'key_t_tan',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Scientific shortcut: T - tan');
      calculator.tan();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyO,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_key_o_asin',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Scientific shortcut: Shift+O - asin');
      calculator.asin();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyS,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_key_s_acos',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Scientific shortcut: Shift+S - acos');
      calculator.acos();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyT,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_key_t_atan',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Scientific shortcut: Shift+T - atan');
      calculator.atan();
    };

    _log.fine('Generated ${bindings.length} scientific shortcut bindings');
    return bindings;
  }

  Map<HotKey, VoidCallback> _getProgrammerShortcuts() {
    final calculator = ref.read(calculatorProvider.notifier);
    final bindings = <HotKey, VoidCallback>{};

    _log.fine('Generating programmer calculator shortcuts...');

    // Word size shortcuts (F2, F3, F4, F12)
    // Mapping according to plan: F2->DWORD, F3->WORD, F4->BYTE, F12->QWORD
    // These conflict with scientific mode shortcuts, so we check current mode
    bindings[HotKey(
      key: PhysicalKeyboardKey.f2,
      identifier: 'f2_dword',
      scope: HotKeyScope.inapp,
    )] = () {
      final currentMode = ref.read(calculatorProvider).mode;
      if (currentMode != CalculatorMode.programmer) {
        _log.fine('F2 ignored (not in programmer mode, current: $currentMode)');
        return;
      }

      _log.fine('Programmer shortcut: F2 - DWORD (32-bit)');
      calculator.setDword();

      // Sync with programmer provider
      ref.read(programmerProvider.notifier).setWordSize(WordSize.dword);

      _log.fine('Synced programmer provider to DWORD');
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.f3,
      identifier: 'f3_word',
      scope: HotKeyScope.inapp,
    )] = () {
      final currentMode = ref.read(calculatorProvider).mode;
      if (currentMode != CalculatorMode.programmer) {
        _log.fine('F3 ignored (not in programmer mode, current: $currentMode)');
        return;
      }

      _log.fine('Programmer shortcut: F3 - WORD (16-bit)');
      calculator.setWord();

      // Sync with programmer provider
      ref.read(programmerProvider.notifier).setWordSize(WordSize.word);

      _log.fine('Synced programmer provider to WORD');
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.f4,
      identifier: 'f4_byte',
      scope: HotKeyScope.inapp,
    )] = () {
      final currentMode = ref.read(calculatorProvider).mode;
      if (currentMode != CalculatorMode.programmer) {
        _log.fine('F4 ignored (not in programmer mode, current: $currentMode)');
        return;
      }

      _log.fine('Programmer shortcut: F4 - BYTE (8-bit)');
      calculator.setByte();

      // Sync with programmer provider
      ref.read(programmerProvider.notifier).setWordSize(WordSize.byte);

      _log.fine('Synced programmer provider to BYTE');
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.f12,
      identifier: 'f12_qword',
      scope: HotKeyScope.inapp,
    )] = () {
      final currentMode = ref.read(calculatorProvider).mode;
      if (currentMode != CalculatorMode.programmer) {
        _log.fine('F12 ignored (not in programmer mode, current: $currentMode)');
        return;
      }

      _log.fine('Programmer shortcut: F12 - QWORD (64-bit)');
      calculator.setQword();

      // Sync with programmer provider
      ref.read(programmerProvider.notifier).setWordSize(WordSize.qword);

      _log.fine('Synced programmer provider to QWORD');
    };

    // F5 has dual functionality based on mode:
    // - Scientific mode: Set Gradian
    // - Programmer mode: Set Hexadecimal
    bindings[HotKey(
      key: PhysicalKeyboardKey.f5,
      identifier: 'f5_mode_switch',
      scope: HotKeyScope.inapp,
    )] = () {
      final currentMode = ref.read(calculatorProvider).mode;
      _log.fine('Programmer shortcut: F5 pressed, current mode: $currentMode');
      if (currentMode == CalculatorMode.scientific) {
        _log.fine('Programmer shortcut: F5 - Gradian mode (scientific)');
        calculator.setAngleType(AngleType.gradian.value);

        // Verify and sync from engine
        final actualAngleType = calculator.service.getAngleType();
        final angleTypeEnum = AngleType.fromValue(actualAngleType);
        ref.read(scientificProvider.notifier).setAngleType(angleTypeEnum);

        _log.fine('Synced scientific provider to Gradian mode (engine confirmed: $actualAngleType)');
      } else if (currentMode == CalculatorMode.programmer) {
        _log.fine('Programmer shortcut: F5 - Hexadecimal radix (programmer)');
        calculator.setRadix(CalcRadixType.CALC_RADIX_HEX);

        // Read from engine and sync
        final actualRadix = calculator.service.getRadix();
        final baseEnum = ProgrammerBase.fromValue(actualRadix);
        ref.read(programmerProvider.notifier).setCurrentBase(baseEnum);

        _log.fine('Synced programmer provider to HEX (engine confirmed: $actualRadix)');
      } else {
        _log.fine('Programmer shortcut: F5 ignored (not in scientific or programmer mode)');
      }
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.f6,
      identifier: 'f6_decimal',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Programmer shortcut: F6 - Decimal radix');
      calculator.setRadix(CalcRadixType.CALC_RADIX_DECIMAL);

      // Read from engine and sync
      final actualRadix = calculator.service.getRadix();
      final baseEnum = ProgrammerBase.fromValue(actualRadix);
      ref.read(programmerProvider.notifier).setCurrentBase(baseEnum);

      _log.fine('Synced programmer provider to DEC (engine confirmed: $actualRadix)');
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.f7,
      identifier: 'f7_octal',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Programmer shortcut: F7 - Octal radix');
      calculator.setRadix(CalcRadixType.CALC_RADIX_OCTAL);

      // Read from engine and sync
      final actualRadix = calculator.service.getRadix();
      final baseEnum = ProgrammerBase.fromValue(actualRadix);
      ref.read(programmerProvider.notifier).setCurrentBase(baseEnum);

      _log.fine('Synced programmer provider to OCT (engine confirmed: $actualRadix)');
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.f8,
      identifier: 'f8_binary',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Programmer shortcut: F8 - Binary radix');
      calculator.setRadix(CalcRadixType.CALC_RADIX_BINARY);

      // Read from engine and sync
      final actualRadix = calculator.service.getRadix();
      final baseEnum = ProgrammerBase.fromValue(actualRadix);
      ref.read(programmerProvider.notifier).setCurrentBase(baseEnum);

      _log.fine('Synced programmer provider to BIN (engine confirmed: $actualRadix)');
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.digit7,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_7_and',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Programmer shortcut: Shift+7 - bitwise AND');
      calculator.bitwiseAnd();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.backslash,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_backslash_or',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Programmer shortcut: Shift+| - bitwise OR');
      calculator.bitwiseOr();
    };

    bindings[HotKey(
      key: PhysicalKeyboardKey.digit1,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_1_not',
      scope: HotKeyScope.inapp,
    )] = () {
      _log.fine('Programmer shortcut: Shift+1 - bitwise NOT');
      calculator.bitwiseNot();
    };

    _log.fine('Generated ${bindings.length} programmer shortcut bindings');
    return bindings;
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

  PhysicalKeyboardKey _getNumpadKey(int digit) {
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

  void _repeatLastInput() {
    // TODO: 实现重复最后输入逻辑
    _log.fine('Repeat last input requested');
  }

  /// 导航到指定路由
  void _navigateTo(String path) {
    _log.fine('Navigating to: $path');
    GoRouter.of(context).go(path);
  }

  /// 切换历史面板显示状态
  void _toggleHistoryPanel() {
    _log.fine('Toggling history panel');
    ref.read(navigationProvider.notifier).toggleHistoryPanel();
  }

  /// 导航历史记录
  /// direction: -1 表示上一个，1 表示下一个
  void _navigateHistory(int direction) {
    _log.fine('Navigating history: direction=$direction');
    // TODO: 实现历史记录导航逻辑
    // 需要与历史面板组件集成
  }

  /// 清除历史记录
  void _clearHistory() {
    _log.fine('Clearing history');
    final calculator = ref.read(calculatorProvider.notifier);
    calculator.clearHistory();
  }
}
