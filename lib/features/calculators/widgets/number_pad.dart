import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../../core/theme/app_icons.dart';

/// 数字键盘组件
///
/// 使用 flutter_layout_grid 实现 4行×3列 的数字按钮布局:
/// ```
///     Col 0    Col 1    Col 2
///    ┌────────┬────────┬────────┐
/// R0 │   7    │   8    │   9    │
///    ├────────┼────────┼────────┤
/// R1 │   4    │   5    │   6    │
///    ├────────┼────────┼────────┤
/// R2 │   1    │   2    │   3    │
///    ├────────┼────────┼────────┤
/// R3 │   ±    │   0    │   .    │
///    └────────┴────────┴────────┘
/// ```
class NumberPad extends StatelessWidget {
  /// 数字按钮回调
  final void Function(int digit)? onDigit;

  /// 小数点按钮回调
  final VoidCallback? onDecimal;

  /// 正负号按钮回调
  final VoidCallback? onNegate;

  /// 最大可用数字 (0~maxDigit)，超过此值的数字按钮将被禁用
  ///
  /// - HEX/DEC 模式: 9 (全部启用)
  /// - OCT 模式: 7 (禁用 8、9)
  /// - BIN 模式: 1 (禁用 2~9)
  final int maxDigit;

  /// 是否显示正负号按钮
  final bool showNegate;

  const NumberPad({
    super.key,
    this.onDigit,
    this.onDecimal,
    this.onNegate,
    this.maxDigit = 9,
    this.showNegate = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr, 1.fr, 1.fr, 1.fr],
      columnGap: 4,
      rowGap: 4,
      children: [
        // Row 0
        NumXButton(
          digit: 7,
          onPressed: 7 <= maxDigit ? onDigit : null,
        ).withGridPlacement(columnStart: 0, rowStart: 0),
        NumXButton(
          digit: 8,
          onPressed: 8 <= maxDigit ? onDigit : null,
        ).withGridPlacement(columnStart: 1, rowStart: 0),
        NumXButton(
          digit: 9,
          onPressed: 9 <= maxDigit ? onDigit : null,
        ).withGridPlacement(columnStart: 2, rowStart: 0),
        // Row 1
        NumXButton(
          digit: 4,
          onPressed: 4 <= maxDigit ? onDigit : null,
        ).withGridPlacement(columnStart: 0, rowStart: 1),
        NumXButton(
          digit: 5,
          onPressed: 5 <= maxDigit ? onDigit : null,
        ).withGridPlacement(columnStart: 1, rowStart: 1),
        NumXButton(
          digit: 6,
          onPressed: 6 <= maxDigit ? onDigit : null,
        ).withGridPlacement(columnStart: 2, rowStart: 1),
        // Row 2
        NumXButton(
          digit: 1,
          onPressed: 1 <= maxDigit ? onDigit : null,
        ).withGridPlacement(columnStart: 0, rowStart: 2),
        NumXButton(
          digit: 2,
          onPressed: 2 <= maxDigit ? onDigit : null,
        ).withGridPlacement(columnStart: 1, rowStart: 2),
        NumXButton(
          digit: 3,
          onPressed: 3 <= maxDigit ? onDigit : null,
        ).withGridPlacement(columnStart: 2, rowStart: 2),
        // Row 3
        if (showNegate)
          NegateButton(
            onPressed: onNegate,
          ).withGridPlacement(columnStart: 0, rowStart: 3),
        NumXButton(
          digit: 0,
          onPressed: onDigit,
        ).withGridPlacement(columnStart: 1, rowStart: 3),
        DecimalSeparatorButton(
          onPressed: onDecimal,
        ).withGridPlacement(columnStart: 2, rowStart: 3),
      ],
    );
  }
}

/// 数字按钮 (0-9)
class NumXButton extends StatelessWidget {
  final int digit;
  final void Function(int digit)? onPressed;

  const NumXButton({super.key, required this.digit, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed != null ? () => onPressed!(digit) : null,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.onSurface,
        ),
        child: Text('$digit', style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}

/// 小数点按钮
class DecimalSeparatorButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DecimalSeparatorButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.dot, size: 20),
      ),
    );
  }
}

/// 正负号切换按钮
class NegateButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NegateButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.negate, size: 20),
      ),
    );
  }
}
