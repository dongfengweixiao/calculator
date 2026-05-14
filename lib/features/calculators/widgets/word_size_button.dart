import 'package:flutter/material.dart';

import '../word_size_types.dart';

/// 位宽文本
String _wordSizeLabel(WordSize size) => switch (size) {
  WordSize.qword => 'QWORD',
  WordSize.dword => 'DWORD',
  WordSize.word => 'WORD',
  WordSize.byte => 'BYTE',
};

/// 位宽切换按钮
///
/// 点击循环切换: QWORD → DWORD → WORD → BYTE → QWORD
class WordSizeButton extends StatefulWidget {
  final WordSize initialSize;
  final ValueChanged<WordSize>? onChanged;

  const WordSizeButton({
    super.key,
    this.initialSize = WordSize.qword,
    this.onChanged,
  });

  @override
  State<WordSizeButton> createState() => _WordSizeButtonState();
}

class _WordSizeButtonState extends State<WordSizeButton> {
  late WordSize _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialSize;
  }

  void _cycle() {
    final next = WordSize.values[(_current.index + 1) % WordSize.values.length];
    setState(() => _current = next);
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: _cycle,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          _wordSizeLabel(_current),
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
