import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/keyboard_shortcut.dart';

part 'keyboard_config_service.g.dart';

/// Keyboard configuration provider
///
/// Provides keyboard shortcuts configuration
@riverpod
class KeyboardConfigService extends _$KeyboardConfigService {
  static const String _storageKey = 'keyboard_shortcuts';

  @override
  List<KeyboardShortcut> build() {
    // Initialize with defaults
    // The actual load will happen asynchronously
    return _getDefaultShortcuts();
  }

  /// Get default shortcuts configuration
  static List<KeyboardShortcut> _getDefaultShortcuts() {
    return [
      // Basic Input
      KeyboardShortcut(
        id: 'digit_0',
        name: 'Digit 0',
        description: 'Input digit 0',
        defaultKey: LogicalKeyboardKey.digit0,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'digit_1',
        name: 'Digit 1',
        description: 'Input digit 1',
        defaultKey: LogicalKeyboardKey.digit1,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'digit_2',
        name: 'Digit 2',
        description: 'Input digit 2',
        defaultKey: LogicalKeyboardKey.digit2,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'digit_3',
        name: 'Digit 3',
        description: 'Input digit 3',
        defaultKey: LogicalKeyboardKey.digit3,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'digit_4',
        name: 'Digit 4',
        description: 'Input digit 4',
        defaultKey: LogicalKeyboardKey.digit4,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'digit_5',
        name: 'Digit 5',
        description: 'Input digit 5',
        defaultKey: LogicalKeyboardKey.digit5,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'digit_6',
        name: 'Digit 6',
        description: 'Input digit 6',
        defaultKey: LogicalKeyboardKey.digit6,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'digit_7',
        name: 'Digit 7',
        description: 'Input digit 7',
        defaultKey: LogicalKeyboardKey.digit7,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'digit_8',
        name: 'Digit 8',
        description: 'Input digit 8',
        defaultKey: LogicalKeyboardKey.digit8,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'digit_9',
        name: 'Digit 9',
        description: 'Input digit 9',
        defaultKey: LogicalKeyboardKey.digit9,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'add',
        name: 'Add',
        description: 'Addition',
        defaultKey: LogicalKeyboardKey.add,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'subtract',
        name: 'Subtract',
        description: 'Subtraction',
        defaultKey: LogicalKeyboardKey.minus,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'multiply',
        name: 'Multiply',
        description: 'Multiplication',
        defaultKey: LogicalKeyboardKey.numpadMultiply,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'divide',
        name: 'Divide',
        description: 'Division',
        defaultKey: LogicalKeyboardKey.slash,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'equals',
        name: 'Equals',
        description: 'Calculate result',
        defaultKey: LogicalKeyboardKey.enter,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'clear',
        name: 'Clear',
        description: 'Clear all',
        defaultKey: LogicalKeyboardKey.escape,
        category: 'basic',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'decimal',
        name: 'Decimal Point',
        description: 'Decimal point',
        defaultKey: LogicalKeyboardKey.period,
        category: 'basic',
        mode: 'all',
      ),

      // Common Shortcuts
      KeyboardShortcut(
        id: 'reciprocal',
        name: 'Reciprocal',
        description: '1/x',
        defaultKey: LogicalKeyboardKey.keyR,
        category: 'common',
        mode: 'all',
      ),
      KeyboardShortcut(
        id: 'square_root',
        name: 'Square Root',
        description: '√x',
        defaultKey: LogicalKeyboardKey.digit2, // Using 2 as square root placeholder
        category: 'common',
        mode: 'all',
      ),

      // Scientific Shortcuts
      KeyboardShortcut(
        id: 'sin',
        name: 'Sine',
        description: 'sin',
        defaultKey: LogicalKeyboardKey.keyS,
        category: 'scientific',
        mode: 'scientific',
      ),
      KeyboardShortcut(
        id: 'cos',
        name: 'Cosine',
        description: 'cos',
        defaultKey: LogicalKeyboardKey.keyO,
        category: 'scientific',
        mode: 'scientific',
      ),
      KeyboardShortcut(
        id: 'tan',
        name: 'Tangent',
        description: 'tan',
        defaultKey: LogicalKeyboardKey.keyT,
        category: 'scientific',
        mode: 'scientific',
      ),
      KeyboardShortcut(
        id: 'log',
        name: 'Logarithm',
        description: 'log',
        defaultKey: LogicalKeyboardKey.keyL,
        category: 'scientific',
        mode: 'scientific',
      ),
      KeyboardShortcut(
        id: 'ln',
        name: 'Natural Logarithm',
        description: 'ln',
        defaultKey: LogicalKeyboardKey.keyN,
        category: 'scientific',
        mode: 'scientific',
      ),
      KeyboardShortcut(
        id: 'power',
        name: 'Power',
        description: 'x^y',
        defaultKey: LogicalKeyboardKey.keyY,
        category: 'scientific',
        mode: 'scientific',
      ),
      KeyboardShortcut(
        id: 'square',
        name: 'Square',
        description: 'x²',
        defaultKey: LogicalKeyboardKey.keyQ,
        category: 'scientific',
        mode: 'scientific',
      ),
      KeyboardShortcut(
        id: 'cube',
        name: 'Cube',
        description: 'x³',
        defaultKey: LogicalKeyboardKey.keyC,
        category: 'scientific',
        mode: 'scientific',
      ),
      KeyboardShortcut(
        id: 'pi',
        name: 'Pi',
        description: 'π',
        defaultKey: LogicalKeyboardKey.keyP,
        category: 'scientific',
        mode: 'scientific',
      ),

      // Programmer Shortcuts
      KeyboardShortcut(
        id: 'hex_a',
        name: 'Hex A',
        description: 'Hexadecimal digit A',
        defaultKey: LogicalKeyboardKey.keyA,
        category: 'programmer',
        mode: 'programmer',
      ),
      KeyboardShortcut(
        id: 'hex_b',
        name: 'Hex B',
        description: 'Hexadecimal digit B',
        defaultKey: LogicalKeyboardKey.keyB,
        category: 'programmer',
        mode: 'programmer',
      ),
      KeyboardShortcut(
        id: 'hex_c',
        name: 'Hex C',
        description: 'Hexadecimal digit C',
        defaultKey: LogicalKeyboardKey.keyC,
        category: 'programmer',
        mode: 'programmer',
      ),
      KeyboardShortcut(
        id: 'hex_d',
        name: 'Hex D',
        description: 'Hexadecimal digit D',
        defaultKey: LogicalKeyboardKey.keyD,
        category: 'programmer',
        mode: 'programmer',
      ),
      KeyboardShortcut(
        id: 'hex_e',
        name: 'Hex E',
        description: 'Hexadecimal digit E',
        defaultKey: LogicalKeyboardKey.keyE,
        category: 'programmer',
        mode: 'programmer',
      ),
      KeyboardShortcut(
        id: 'hex_f',
        name: 'Hex F',
        description: 'Hexadecimal digit F',
        defaultKey: LogicalKeyboardKey.keyF,
        category: 'programmer',
        mode: 'programmer',
      ),
    ];
  }

  /// Load shortcuts from storage
  Future<void> loadShortcuts() async {
    final prefs = await SharedPreferences.getInstance();
    final shortcutsJson = prefs.getStringList(_storageKey);

    if (shortcutsJson == null || shortcutsJson.isEmpty) {
      state = _getDefaultShortcuts();
      return;
    }

    try {
      final shortcuts = shortcutsJson
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .map((map) => KeyboardShortcut.fromMap(map))
          .toList();
      state = shortcuts;
    } catch (e) {
      // If parsing fails, return defaults
      state = _getDefaultShortcuts();
    }
  }

  /// Save shortcuts to storage
  Future<void> saveShortcuts(List<KeyboardShortcut> shortcuts) async {
    final prefs = await SharedPreferences.getInstance();
    final shortcutsJson = shortcuts
        .map((s) => s.toMap())
        .map((map) => jsonEncode(map))
        .toList();

    await prefs.setStringList(_storageKey, shortcutsJson);
    state = shortcuts;
  }

  /// Reset shortcuts to defaults
  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    state = _getDefaultShortcuts();
  }

  /// Get shortcuts by category
  static List<KeyboardShortcut> getShortcutsByCategory(
    List<KeyboardShortcut> shortcuts,
    String category,
  ) {
    return shortcuts
        .where((s) => s.category == category || category == 'all')
        .toList();
  }

  /// Get shortcuts by mode
  static List<KeyboardShortcut> getShortcutsByMode(
    List<KeyboardShortcut> shortcuts,
    String mode,
  ) {
    return shortcuts
        .where((s) => s.mode == mode || s.mode == 'all')
        .toList();
  }
}
