import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dialog for recording keyboard shortcuts
/// Allows user to press a key combination to set a new shortcut
class ShortcutRecorderDialog extends StatefulWidget {
  final String currentShortcut;
  final Function(LogicalKeyboardKey key, Set<LogicalKeyboardKey> modifiers)
      onShortcutRecorded;

  const ShortcutRecorderDialog({
    super.key,
    required this.currentShortcut,
    required this.onShortcutRecorded,
  });

  @override
  State<ShortcutRecorderDialog> createState() =>
      _ShortcutRecorderDialogState();
}

class _ShortcutRecorderDialogState extends State<ShortcutRecorderDialog> {
  LogicalKeyboardKey? _recordedKey;
  final Set<LogicalKeyboardKey> _pressedModifiers = {};
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    // Start recording immediately
    _startRecording();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordedKey = null;
      _pressedModifiers.clear();
    });
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final key = event.logicalKey;

    // Check if it's a modifier key
    if (key == LogicalKeyboardKey.controlLeft ||
        key == LogicalKeyboardKey.controlRight ||
        key == LogicalKeyboardKey.altLeft ||
        key == LogicalKeyboardKey.altRight ||
        key == LogicalKeyboardKey.shiftLeft ||
        key == LogicalKeyboardKey.shiftRight) {
      setState(() {
        _pressedModifiers.add(key);
      });
      return true;
    }

    // If it's a regular key, record it
    if (_isValidShortcutKey(key)) {
      setState(() {
        _recordedKey = key;
      });
      _stopRecording();

      // Notify parent after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          widget.onShortcutRecorded(_recordedKey!, _pressedModifiers);
          Navigator.of(context).pop();
        }
      });

      return true;
    }

    return false;
  }

  bool _isValidShortcutKey(LogicalKeyboardKey key) {
    // Exclude special keys that shouldn't be shortcuts
    if (key == LogicalKeyboardKey.tab ||
        key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.escape ||
        key == LogicalKeyboardKey.metaLeft ||
        key == LogicalKeyboardKey.metaRight ||
        key == LogicalKeyboardKey.capsLock ||
        key == LogicalKeyboardKey.numLock ||
        key == LogicalKeyboardKey.scrollLock ||
        key == LogicalKeyboardKey.printScreen) {
      return false;
    }
    return true;
  }

  void _cancelRecording() {
    _stopRecording();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _stopRecording();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modifierNames = <String>[];
    if (_pressedModifiers.contains(LogicalKeyboardKey.controlLeft) ||
        _pressedModifiers.contains(LogicalKeyboardKey.controlRight)) {
      modifierNames.add('Ctrl');
    }
    if (_pressedModifiers.contains(LogicalKeyboardKey.altLeft) ||
        _pressedModifiers.contains(LogicalKeyboardKey.altRight)) {
      modifierNames.add('Alt');
    }
    if (_pressedModifiers.contains(LogicalKeyboardKey.shiftLeft) ||
        _pressedModifiers.contains(LogicalKeyboardKey.shiftRight)) {
      modifierNames.add('Shift');
    }

    return AlertDialog(
      title: const Text('Record Shortcut'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Press a key combination...'),
          const SizedBox(height: 16),
          if (_isRecording)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.keyboard,
                    size: 32,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 8),
                  if (modifierNames.isNotEmpty)
                    Text(
                      '${modifierNames.join(' + ')} + ...',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    )
                  else
                    Text(
                      'Press any key...',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                ],
              ),
            ),
          if (_recordedKey != null) ...[
            const SizedBox(height: 16),
            Text(
              'Recorded: ${modifierNames.isNotEmpty ? '${modifierNames.join(' + ')} + ' : ''}${_recordedKey!.keyLabel}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _cancelRecording,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
