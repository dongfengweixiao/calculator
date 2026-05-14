import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'clear_backspace_row.dart';
import 'number_pad.dart';

/// 单位换算操作符组件
///
/// 使用 flutter_layout_grid 实现 5行×3列 的布局:
/// ```
///     Col 0    Col 1    Col 2
///    ┌────────┬────────┬────────┐
/// R0 │        │        │        │
///    ├────────┼────────┼────────┤
/// R1 │   7    │   8    │   9    │
///    ├────────┼────────┼────────┤
/// R2 │   4    │   5    │   6    │
///    ├────────┼────────┼────────┤
/// R3 │   1    │   2    │   3    │
///    ├────────┼────────┼────────┤
/// R4 │   ±    │   0    │   .    │
///    └────────┴────────┴────────┘
/// ```
class CalculatorConverterOperators extends StatelessWidget {
  /// 数字按钮回调
  final void Function(int digit)? onDigit;

  /// 小数点按钮回调
  final VoidCallback? onDecimal;

  /// 正负号按钮回调
  final VoidCallback? onNegate;

  /// 是否显示正负号按钮
  final bool showNegate;

  /// 清除按钮回调
  final VoidCallback? onClear;

  /// 清除输入按钮回调
  final VoidCallback? onClearEntry;

  /// 退格按钮回调
  final VoidCallback? onBackspace;

  /// 是否存在输入内容（决定显示 C 还是 CE）
  final bool hasEntry;

  const CalculatorConverterOperators({
    super.key,
    this.onDigit,
    this.onDecimal,
    this.onNegate,
    this.showNegate = true,
    this.onClear,
    this.onClearEntry,
    this.onBackspace,
    this.hasEntry = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr, 4.fr], // 第1行显示ClearBackspaceRow，第2-5行显示数字键盘
      columnGap: 4,
      rowGap: 4,
      children: [
        // Row 0 - 预留空间 (C0)
        Container().withGridPlacement(
          columnStart: 0,
          rowStart: 0,
        ),
        // Row 0 - ClearBackspaceRow (C1-C2)
        ClearBackspaceRow(
          hasEntry: hasEntry,
          onClear: onClear,
          onClearEntry: onClearEntry,
          onBackspace: onBackspace,
        ).withGridPlacement(
          columnStart: 1,
          rowStart: 0,
          columnSpan: 2,
        ),
        // Row 1-4 - 复用NumberPad组件
        NumberPad(
          onDigit: onDigit,
          onDecimal: onDecimal,
          onNegate: onNegate,
          showNegate: showNegate,
        ).withGridPlacement(columnStart: 0, rowStart: 1, columnSpan: 3),
      ],
    );
  }
}