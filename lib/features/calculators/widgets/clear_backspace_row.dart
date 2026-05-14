import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'standard_display_controls.dart';

/// 清除/退格按钮行
///
/// 使用 flutter_layout_grid 实现 1行×2列:
/// ```
///    Col 0      Col 1
///   ┌─────────┬─────────┐
///   │  C/CE   │    ⌫    │
///   └─────────┴─────────┘
/// ```
///
/// 默认显示 C（全部清除），[hasEntry] 为 true 时显示 CE（清除输入）。
class ClearBackspaceRow extends StatelessWidget {
  /// 是否存在输入内容（决定显示 C 还是 CE）
  final bool hasEntry;

  final VoidCallback? onClear;
  final VoidCallback? onClearEntry;
  final VoidCallback? onBackspace;

  const ClearBackspaceRow({
    super.key,
    required this.hasEntry,
    required this.onClear,
    this.onClearEntry,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr],
      rowSizes: [1.fr],
      columnGap: 4,
      rowGap: 0,
      children: [
        if (hasEntry)
          ClearEntryButton(
            onPressed: onClearEntry,
          ).withGridPlacement(columnStart: 0, rowStart: 0)
        else
          ClearButton(
            onPressed: onClear,
          ).withGridPlacement(columnStart: 0, rowStart: 0),
        BackSpaceButton(
          onPressed: onBackspace,
        ).withGridPlacement(columnStart: 1, rowStart: 0),
      ],
    );
  }
}
