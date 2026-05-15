import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../../core/theme/app_icons.dart';
import 'shared_buttons.dart';

/// 标准计算器显示控件按钮行
///
/// 使用 flutter_layout_grid 实现 1行×4列:
/// ```
///    Col 0      Col 1      Col 2      Col 3
///   ┌─────────┬─────────┬─────────┬─────────┐
///   │    %     │   CE    │    C    │    ⌫    │
///   └─────────┴─────────┴─────────┴─────────┘
/// ```
class StandardDisplayControls extends StatelessWidget {
  final VoidCallback? onPercent;
  final VoidCallback? onClearEntry;
  final VoidCallback? onClear;
  final VoidCallback? onBackspace;

  const StandardDisplayControls({
    super.key,
    this.onPercent,
    this.onClearEntry,
    this.onClear,
    this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr],
      columnGap: 4,
      rowGap: 0,
      children: [
        PercentButton(
          onPressed: onPercent,
        ).withGridPlacement(columnStart: 0, rowStart: 0),
        ClearEntryButton(
          onPressed: onClearEntry,
        ).withGridPlacement(columnStart: 1, rowStart: 0),
        ClearButton(
          onPressed: onClear,
        ).withGridPlacement(columnStart: 2, rowStart: 0),
        BackSpaceButton(
          onPressed: onBackspace,
        ).withGridPlacement(columnStart: 3, rowStart: 0),
      ],
    );
  }
}

// PercentButton is now imported from shared_buttons.dart

/// CE 清除输入按钮
class ClearEntryButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ClearEntryButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CalcButton(
      onPressed: onPressed,
      child: const Text('CE', style: TextStyle(fontSize: 16)),
    );
  }
}

/// C 全部清除按钮
class ClearButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ClearButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CalcButton(
      onPressed: onPressed,
      child: const Text('C', style: TextStyle(fontSize: 16)),
    );
  }
}

/// ⌫ 退格按钮
class BackSpaceButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackSpaceButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CalcButton(
      onPressed: onPressed,
      child: Icon(CalculatorIcons.backspace, size: 20),
    );
  }
}
