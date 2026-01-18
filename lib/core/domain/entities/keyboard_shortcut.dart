import 'package:flutter/services.dart';

/// Keyboard shortcut model representing a single key binding
class KeyboardShortcut {
  final String id;
  final String name;
  final String description;
  final LogicalKeyboardKey defaultKey;
  final List<LogicalKeyboardKey> modifiers; // Control, Alt, Shift
  final String category; // 'basic', 'common', 'scientific', 'programmer'
  final String mode; // 'all', 'standard', 'scientific', 'programmer'

  const KeyboardShortcut({
    required this.id,
    required this.name,
    required this.description,
    required this.defaultKey,
    this.modifiers = const [],
    required this.category,
    required this.mode,
  });

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'keyId': defaultKey.keyId,
      'keyLabel': defaultKey.keyLabel,
      'modifiers': modifiers.map((k) => k.keyId).toList(),
      'category': category,
      'mode': mode,
    };
  }

  /// Create from map (from storage)
  factory KeyboardShortcut.fromMap(Map<String, dynamic> map) {
    final keyId = map['keyId'] as int;
    final key = LogicalKeyboardKey.findKeyByKeyId(keyId);

    return KeyboardShortcut(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      defaultKey: key ?? LogicalKeyboardKey.space, // Fallback to space instead of unknown
      modifiers: (map['modifiers'] as List<dynamic>?)
              ?.map((id) => LogicalKeyboardKey.findKeyByKeyId(id as int) ?? LogicalKeyboardKey.space)
              .toList() ??
          [],
      category: map['category'] as String? ?? 'basic',
      mode: map['mode'] as String? ?? 'all',
    );
  }

  /// Create a copy with a different key
  KeyboardShortcut copyWith({LogicalKeyboardKey? newKey}) {
    return KeyboardShortcut(
      id: id,
      name: name,
      description: description,
      defaultKey: newKey ?? defaultKey,
      modifiers: modifiers,
      category: category,
      mode: mode,
    );
  }

  /// Get display label for the shortcut
  String getDisplayLabel() {
    final parts = <String>[];
    for (final modifier in modifiers) {
      if (modifier == LogicalKeyboardKey.controlLeft ||
          modifier == LogicalKeyboardKey.controlRight) {
        parts.add('Ctrl');
      } else if (modifier == LogicalKeyboardKey.altLeft ||
          modifier == LogicalKeyboardKey.altRight) {
        parts.add('Alt');
      } else if (modifier == LogicalKeyboardKey.shiftLeft ||
          modifier == LogicalKeyboardKey.shiftRight) {
        parts.add('Shift');
      }
    }
    parts.add(defaultKey.keyLabel);
    return parts.join(' + ');
  }
}

/// Category for organizing shortcuts
enum ShortcutCategory {
  basic('Basic Input'),
  common('Common Shortcuts'),
  scientific('Scientific'),
  programmer('Programmer'),
  all('All Categories');

  final String name;

  const ShortcutCategory(this.name);
}
