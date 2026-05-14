import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../angle_mode_types.dart';

/// 科学计算器显示控件行
///
/// 使用 flutter_layout_grid 实现 1行×6列:
/// ```
///    Col 0        Col 1     Col 2     Col 3     Col 4     Col 5
///   ┌────────────┬─────────┬─────────┬─────────┬─────────┬─────────┐
///   │ AngleBtns  │  F-E    │         │         │         │         │
///   └────────────┴─────────┴─────────┴─────────┴─────────┴─────────┘
/// ```
class ScientificDisplayControls extends StatelessWidget {
  final VoidCallback? onDegree;
  final VoidCallback? onRadian;
  final VoidCallback? onGrads;
  final VoidCallback? onFtoE;
  final AngleMode angleMode;
  final bool isFtoEActive;

  const ScientificDisplayControls({
    super.key,
    this.onDegree,
    this.onRadian,
    this.onGrads,
    this.onFtoE,
    this.angleMode = AngleMode.degree,
    this.isFtoEActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr],
      columnGap: 4,
      rowGap: 0,
      children: [
        CalculatorScientificAngleButtons(
          angleMode: angleMode,
          onDegree: onDegree,
          onRadian: onRadian,
          onGrads: onGrads,
        ).withGridPlacement(columnStart: 0, rowStart: 0),
        FtoEButton(
          onPressed: onFtoE,
          isActive: isFtoEActive,
        ).withGridPlacement(columnStart: 1, rowStart: 0),
        // Col 2-5 空
      ],
    );
  }
}

// AngleMode is now imported from angle_mode_types.dart

/// 角度模式切换按钮组
///
/// 循环切换: Degree → Radian → Grads → Degree → ...
/// 每次只显示当前模式对应的按钮。
class CalculatorScientificAngleButtons extends StatelessWidget {
  final AngleMode angleMode;
  final VoidCallback? onDegree;
  final VoidCallback? onRadian;
  final VoidCallback? onGrads;

  const CalculatorScientificAngleButtons({
    super.key,
    this.angleMode = AngleMode.degree,
    this.onDegree,
    this.onRadian,
    this.onGrads,
  });

  @override
  Widget build(BuildContext context) {
    return switch (angleMode) {
      AngleMode.degree => DegreeButton(onPressed: onRadian),
      AngleMode.radian => RadianButton(onPressed: onGrads),
      AngleMode.grads => GradsButton(onPressed: onDegree),
    };
  }
}

/// DEG 度按钮
class DegreeButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DegreeButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          'DEG',
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

/// RAD 弧度按钮
class RadianButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const RadianButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          'RAD',
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

/// GRAD 梯度按钮
class GradsButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GradsButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          'GRAD',
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

/// F-E 科学记数法切换按钮
class FtoEButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isActive;

  const FtoEButton({super.key, this.onPressed, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'F-E',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Container(
              height: 3,
              width: 16,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: isActive ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
