import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../../core/theme/app_icons.dart';
import 'shared_buttons.dart';

/// 函数弹出面板
///
/// 使用 flutter_layout_grid 实现 2行×3列:
/// ```
///    Col 0      Col 1      Col 2
///   ┌─────────┬─────────┬─────────┐
///   │   |x|   │  floor  │  ceil   │
///   ├─────────┼─────────┼─────────┤
///   │  rand   │  dms    │ degrees │
///   └─────────┴─────────┴─────────┘
/// ```
class FuncFlyout extends StatelessWidget {
  final VoidCallback? onAbs;
  final VoidCallback? onFloor;
  final VoidCallback? onCeil;
  final VoidCallback? onRand;
  final VoidCallback? onDms;
  final VoidCallback? onDegrees;

  const FuncFlyout({
    super.key,
    this.onAbs,
    this.onFloor,
    this.onCeil,
    this.onRand,
    this.onDms,
    this.onDegrees,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 196,
      height: 96,
      child: LayoutGrid(
        columnSizes: [1.fr, 1.fr, 1.fr],
        rowSizes: [1.fr, 1.fr],
        columnGap: 4,
        rowGap: 4,
        children: [
          AbsFlyoutButton(
            onPressed: onAbs,
          ).withGridPlacement(columnStart: 0, rowStart: 0),
          FloorButton(
            onPressed: onFloor,
          ).withGridPlacement(columnStart: 1, rowStart: 0),
          CeilButton(
            onPressed: onCeil,
          ).withGridPlacement(columnStart: 2, rowStart: 0),
          RandButton(
            onPressed: onRand,
          ).withGridPlacement(columnStart: 0, rowStart: 1),
          DmsButton(
            onPressed: onDms,
          ).withGridPlacement(columnStart: 1, rowStart: 1),
          DegreesButton(
            onPressed: onDegrees,
          ).withGridPlacement(columnStart: 2, rowStart: 1),
        ],
      ),
    );
  }
}

/// |x| 绝对值按钮
class AbsFlyoutButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AbsFlyoutButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: const Icon(CalculatorIcons.absoluteValue, size: 20),
    );
  }
}

/// Floor 取整按钮
class FloorButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FloorButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: const Icon(CalculatorIcons.floor, size: 20),
    );
  }
}

/// Ceil 取整按钮
class CeilButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CeilButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: const Icon(CalculatorIcons.ceiling, size: 20),
    );
  }
}

/// Rand 随机数按钮
class RandButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const RandButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: const Text('Rand', style: TextStyle(fontSize: 14)),
    );
  }
}

/// DMS 度分秒按钮
class DmsButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DmsButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: const Icon(CalculatorIcons.dms, size: 20),
    );
  }
}

/// Degrees 角度按钮
class DegreesButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DegreesButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalcButton(
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerLow,
      child: const Icon(CalculatorIcons.degrees, size: 20),
    );
  }
}
