import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'shared_buttons.dart';

/// 标准计算器函数按钮行
///
/// 使用 flutter_layout_grid 实现 1行×3列:
/// ```
///    Col 0      Col 1      Col 2
///   ┌─────────┬─────────┬─────────┐
///   │   1/x   │   x²    │   √x    │
///   └─────────┴─────────┴─────────┘
/// ```
class StandardFunctions extends StatelessWidget {
  final VoidCallback? onReciprocal;
  final VoidCallback? onSquare;
  final VoidCallback? onSquareRoot;

  const StandardFunctions({
    super.key,
    this.onReciprocal,
    this.onSquare,
    this.onSquareRoot,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr],
      columnGap: 4,
      rowGap: 0,
      children: [
        InvertButton(
          onPressed: onReciprocal,
        ).withGridPlacement(columnStart: 0, rowStart: 0),
        XPower2Button(
          onPressed: onSquare,
        ).withGridPlacement(columnStart: 1, rowStart: 0),
        SquareRootButton(
          onPressed: onSquareRoot,
        ).withGridPlacement(columnStart: 2, rowStart: 0),
      ],
    );
  }
}

// InvertButton is now imported from shared_buttons.dart

// XPower2Button is now imported from shared_buttons.dart

// SquareRootButton is now imported from shared_buttons.dart
