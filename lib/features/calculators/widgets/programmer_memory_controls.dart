import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'shared_buttons.dart';
import '../word_size_types.dart';
import 'word_size_button.dart';

/// 键盘模式
enum KeypadMode { fullKeypad, bitFlip }

/// 程序员计算器内存控件行
///
/// 使用 flutter_layout_grid 实现 1行×5列:
/// ```
///    Col 0      Col 1     Col 2~3       Col 4     Col 5
///   ┌────────┬────────┬──────────────┬────────┬────────┐
///   │  Full  │  Bit   │   QWORD      │   MS   │   M▾   │
///   │ Keypad │  Flip  │  (占2列)     │        │        │
///   └────────┴────────┴──────────────┴────────┴────────┘
/// ```
class ProgrammerMemoryControls extends StatefulWidget {
  final KeypadMode initialMode;
  final ValueChanged<KeypadMode>? onModeChanged;
  final ValueChanged<WordSize>? onWordSizeChanged;
  final VoidCallback? onMemoryStore;
  final VoidCallback? onMemory;

  const ProgrammerMemoryControls({
    super.key,
    this.initialMode = KeypadMode.fullKeypad,
    this.onModeChanged,
    this.onWordSizeChanged,
    this.onMemoryStore,
    this.onMemory,
  });

  @override
  State<ProgrammerMemoryControls> createState() =>
      _ProgrammerMemoryControlsState();
}

class _ProgrammerMemoryControlsState extends State<ProgrammerMemoryControls> {
  late KeypadMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  void _selectMode(KeypadMode mode) {
    if (_mode == mode) return;
    setState(() => _mode = mode);
    widget.onModeChanged?.call(mode);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr],
      columnGap: 4,
      rowGap: 0,
      children: [
        FullKeypadButton(
          isSelected: _mode == KeypadMode.fullKeypad,
          onPressed: () => _selectMode(KeypadMode.fullKeypad),
        ).withGridPlacement(columnStart: 0, rowStart: 0),
        BitFlipModeButton(
          isSelected: _mode == KeypadMode.bitFlip,
          onPressed: () => _selectMode(KeypadMode.bitFlip),
        ).withGridPlacement(columnStart: 1, rowStart: 0),
        WordSizeButton(
          onChanged: widget.onWordSizeChanged,
        ).withGridPlacement(columnStart: 2, rowStart: 0, columnSpan: 2),
        MemStoreButton(
          onPressed: widget.onMemoryStore,
        ).withGridPlacement(columnStart: 4, rowStart: 0),
        MemoryPanelButton(
          onPressed: widget.onMemory,
        ).withGridPlacement(columnStart: 5, rowStart: 0),
      ],
    );
  }
}

// FullKeypadButton is now imported from shared_buttons.dart

// BitFlipButton is now imported from shared_buttons.dart

// MemStoreButton is now imported from shared_buttons.dart

// MemoryPanelButton is now imported from shared_buttons.dart
