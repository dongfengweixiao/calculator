import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../../core/theme/app_icons.dart';

/// 标准计算器运算符按钮列
///
/// 使用 flutter_layout_grid 实现 5行×1列:
/// ```
///   ┌─────────┐
///   │    ÷     │
///   ├─────────┤
///   │    ×     │
///   ├─────────┤
///   │    −     │
///   ├─────────┤
///   │    +     │
///   ├─────────┤
///   │    =     │
///   └─────────┘
/// ```
class StandardOperators extends StatelessWidget {
  final VoidCallback? onDivide;
  final VoidCallback? onMultiply;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;
  final VoidCallback? onEquals;

  const StandardOperators({
    super.key,
    this.onDivide,
    this.onMultiply,
    this.onSubtract,
    this.onAdd,
    this.onEquals,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr],
      rowSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      rowGap: 4,
      children: [
        DivideButton(
          onPressed: onDivide,
        ).withGridPlacement(columnStart: 0, rowStart: 0),
        MultiplyButton(
          onPressed: onMultiply,
        ).withGridPlacement(columnStart: 0, rowStart: 1),
        MinusButton(
          onPressed: onSubtract,
        ).withGridPlacement(columnStart: 0, rowStart: 2),
        PlusButton(
          onPressed: onAdd,
        ).withGridPlacement(columnStart: 0, rowStart: 3),
        EqualButton(
          onPressed: onEquals,
        ).withGridPlacement(columnStart: 0, rowStart: 4),
      ],
    );
  }
}

/// ÷ 除法按钮
class DivideButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DivideButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(CalculatorIcons.divide, size: 20),
      ),
    );
  }
}

/// × 乘法按钮
class MultiplyButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const MultiplyButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(CalculatorIcons.multiply, size: 20),
      ),
    );
  }
}

/// − 减法按钮
class MinusButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const MinusButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(CalculatorIcons.minus, size: 20),
      ),
    );
  }
}

/// + 加法按钮
class PlusButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const PlusButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(CalculatorIcons.plus, size: 20),
      ),
    );
  }
}

/// = 等于按钮
class EqualButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const EqualButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        child: const Icon(CalculatorIcons.equals, size: 20),
      ),
    );
  }
}
