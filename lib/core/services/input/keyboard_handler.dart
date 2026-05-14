import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

import '../../../../app/view/routing_manager.dart';
import '../../../../common/page_ids.dart';
import '../../../../features/calculators/calculator_model.dart';

/// 计算器键盘快捷键处理器
///
/// 使用 flutter_it 从 DI 容器获取 Model，
/// 通过 hotkey_manager 注册全局快捷键。
class KeyboardHandler {
  /// 已注册的热键列表，用于清理
  final List<HotKey> _registeredHotKeys = [];

  /// 获取当前计算器 Model
  CalculatorModel get _model => di<CalculatorModel>();

  /// 生成并注册所有热键绑定
  Future<void> registerAll() async {
    await hotKeyManager.unregisterAll();
    _registeredHotKeys.clear();

    final bindings = <HotKey, VoidCallback>{};
    bindings.addAll(_getDigitKeys());
    bindings.addAll(_getOperatorKeys());
    bindings.addAll(_getFunctionKeys());
    bindings.addAll(_getCommonShortcuts());

    for (final entry in bindings.entries) {
      await hotKeyManager.register(
        entry.key,
        keyDownHandler: (_) => entry.value(),
      );
      _registeredHotKeys.add(entry.key);
    }

    debugPrint(
      '[KeyboardHandler] Registered ${_registeredHotKeys.length} hotkeys',
    );
  }

  /// 注销所有热键
  Future<void> unregisterAll() async {
    for (final hotKey in _registeredHotKeys) {
      await hotKeyManager.unregister(hotKey);
    }
    debugPrint(
      '[KeyboardHandler] Unregistered ${_registeredHotKeys.length} hotkeys',
    );
    _registeredHotKeys.clear();
  }

  // ============================================================
  // 数字键 (0-9 + Numpad)
  // ============================================================

  Map<HotKey, VoidCallback> _getDigitKeys() {
    final bindings = <HotKey, VoidCallback>{};

    for (int i = 0; i <= 9; i++) {
      final digit = i;
      bindings[HotKey(
        key: _getDigitKey(digit),
        identifier: 'digit_$digit',
        scope: HotKeyScope.inapp,
      )] = () {
        _model.inputDigit(digit);
      };
      bindings[HotKey(
        key: _getNumpadKey(digit),
        identifier: 'numpad_$digit',
        scope: HotKeyScope.inapp,
      )] = () {
        _model.inputDigit(digit);
      };
    }

    return bindings;
  }

  // ============================================================
  // 运算符键 (+, -, *, /, Enter, =, %)
  // ============================================================

  Map<HotKey, VoidCallback> _getOperatorKeys() {
    final bindings = <HotKey, VoidCallback>{};

    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadAdd,
      identifier: 'numpad_add',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.add();

    bindings[HotKey(
      key: PhysicalKeyboardKey.minus,
      identifier: 'minus',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.subtract();

    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadSubtract,
      identifier: 'numpad_subtract',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.subtract();

    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadMultiply,
      identifier: 'numpad_multiply',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.multiply();

    bindings[HotKey(
      key: PhysicalKeyboardKey.digit8,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_multiply',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.multiply();

    bindings[HotKey(
      key: PhysicalKeyboardKey.slash,
      identifier: 'slash',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.divide();

    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadDivide,
      identifier: 'numpad_divide',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.divide();

    bindings[HotKey(
      key: PhysicalKeyboardKey.enter,
      identifier: 'enter',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.equals();

    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadEnter,
      identifier: 'numpad_enter',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.equals();

    bindings[HotKey(
      key: PhysicalKeyboardKey.equal,
      identifier: 'equal',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.equals();

    bindings[HotKey(
      key: PhysicalKeyboardKey.digit5,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_percent',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.percent();

    return bindings;
  }

  // ============================================================
  // 功能键 (Escape, Delete, Backspace, ., F9)
  // ============================================================

  Map<HotKey, VoidCallback> _getFunctionKeys() {
    final bindings = <HotKey, VoidCallback>{};

    bindings[HotKey(
      key: PhysicalKeyboardKey.escape,
      identifier: 'escape_clear',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.clear();

    bindings[HotKey(
      key: PhysicalKeyboardKey.delete,
      identifier: 'delete_clear_entry',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.clearEntry();

    bindings[HotKey(
      key: PhysicalKeyboardKey.backspace,
      identifier: 'backspace',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.backspace();

    bindings[HotKey(
      key: PhysicalKeyboardKey.period,
      identifier: 'period',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.inputDecimal();

    bindings[HotKey(
      key: PhysicalKeyboardKey.numpadDecimal,
      identifier: 'numpad_decimal',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.inputDecimal();

    bindings[HotKey(
      key: PhysicalKeyboardKey.f9,
      identifier: 'f9_negate',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.inputNegate();

    return bindings;
  }

  // ============================================================
  // 常用快捷键 (函数、内存操作、模式切换)
  // ============================================================

  Map<HotKey, VoidCallback> _getCommonShortcuts() {
    final bindings = <HotKey, VoidCallback>{};

    // 函数
    bindings[HotKey(
      key: PhysicalKeyboardKey.keyR,
      identifier: 'key_r_reciprocal',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.reciprocal();

    bindings[HotKey(
      key: PhysicalKeyboardKey.digit2,
      modifiers: [HotKeyModifier.shift],
      identifier: 'shift_2_square_root',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.squareRoot();

    // 内存操作
    bindings[HotKey(
      key: PhysicalKeyboardKey.keyM,
      modifiers: [HotKeyModifier.control],
      identifier: 'ctrl_m_memory_store',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.memoryStore();

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyP,
      modifiers: [HotKeyModifier.control],
      identifier: 'ctrl_p_memory_add',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.memoryAdd();

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyQ,
      modifiers: [HotKeyModifier.control],
      identifier: 'ctrl_q_memory_subtract',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.memorySubtract();

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyR,
      modifiers: [HotKeyModifier.control],
      identifier: 'ctrl_r_memory_recall',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.memoryRecall();

    bindings[HotKey(
      key: PhysicalKeyboardKey.keyL,
      modifiers: [HotKeyModifier.control],
      identifier: 'ctrl_l_memory_clear',
      scope: HotKeyScope.inapp,
    )] = () =>
        _model.memoryClear();

    // 模式切换 (Alt+1/2/3)
    bindings[HotKey(
      key: PhysicalKeyboardKey.digit1,
      modifiers: [HotKeyModifier.alt],
      identifier: 'alt_1_standard_mode',
      scope: HotKeyScope.inapp,
    )] = () =>
        _navigateTo(PageIDs.standard);

    bindings[HotKey(
      key: PhysicalKeyboardKey.digit2,
      modifiers: [HotKeyModifier.alt],
      identifier: 'alt_2_scientific_mode',
      scope: HotKeyScope.inapp,
    )] = () =>
        _navigateTo(PageIDs.scientific);

    bindings[HotKey(
      key: PhysicalKeyboardKey.digit3,
      modifiers: [HotKeyModifier.alt],
      identifier: 'alt_3_programmer_mode',
      scope: HotKeyScope.inapp,
    )] = () =>
        _navigateTo(PageIDs.programmer);

    return bindings;
  }

  // ============================================================
  // 辅助方法
  // ============================================================

  void _navigateTo(String pageId) {
    di<RoutingManager>().push(pageId: pageId);
  }

  PhysicalKeyboardKey _getDigitKey(int digit) {
    return switch (digit) {
      0 => PhysicalKeyboardKey.digit0,
      1 => PhysicalKeyboardKey.digit1,
      2 => PhysicalKeyboardKey.digit2,
      3 => PhysicalKeyboardKey.digit3,
      4 => PhysicalKeyboardKey.digit4,
      5 => PhysicalKeyboardKey.digit5,
      6 => PhysicalKeyboardKey.digit6,
      7 => PhysicalKeyboardKey.digit7,
      8 => PhysicalKeyboardKey.digit8,
      9 => PhysicalKeyboardKey.digit9,
      _ => PhysicalKeyboardKey.digit0,
    };
  }

  PhysicalKeyboardKey _getNumpadKey(int digit) {
    return switch (digit) {
      0 => PhysicalKeyboardKey.numpad0,
      1 => PhysicalKeyboardKey.numpad1,
      2 => PhysicalKeyboardKey.numpad2,
      3 => PhysicalKeyboardKey.numpad3,
      4 => PhysicalKeyboardKey.numpad4,
      5 => PhysicalKeyboardKey.numpad5,
      6 => PhysicalKeyboardKey.numpad6,
      7 => PhysicalKeyboardKey.numpad7,
      8 => PhysicalKeyboardKey.numpad8,
      9 => PhysicalKeyboardKey.numpad9,
      _ => PhysicalKeyboardKey.numpad0,
    };
  }
}
