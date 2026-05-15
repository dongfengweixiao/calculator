import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../../core/theme/app_icons.dart';

/// 科学函数按钮列
///
/// 使用 flutter_layout_grid 实现 6行×1列:
/// ```
///   ┌─────────┐
///   │  x²    │
///   ├─────────┤
///   │  √x    │
///   ├─────────┤
///   │  xʸ    │
///   ├─────────┤
///   │ 10ˣ    │
///   ├─────────┤
///   │  log   │
///   ├─────────┤
///   │  ln    │
///   └─────────┘
/// ```
///
/// 当 [isShift] 为 true 时显示 Shift 模式按钮组:
/// ```
///   ┌─────────┐
///   │  x³    │
///   ├─────────┤
///   │  ∛x    │
///   ├─────────┤
///   │  ʸ√x   │
///   ├─────────┤
///   │  2ˣ    │
///   ├─────────┤
///   │  logᵧ  │
///   ├─────────┤
///   │  eˣ    │
///   └─────────┘
/// ```
class ScientificFunctions extends StatelessWidget {
  final bool isShift;

  final VoidCallback? onSquare;
  final VoidCallback? onSquareRoot;
  final VoidCallback? onPower;
  final VoidCallback? onPowerOf10;
  final VoidCallback? onLogBase10;
  final VoidCallback? onLogBaseE;

  final VoidCallback? onCube;
  final VoidCallback? onCubeRoot;
  final VoidCallback? onYRoot;
  final VoidCallback? onPowerOf2;
  final VoidCallback? onLogBaseY;
  final VoidCallback? onPowerOfE;

  const ScientificFunctions({
    super.key,
    this.isShift = false,
    this.onSquare,
    this.onSquareRoot,
    this.onPower,
    this.onPowerOf10,
    this.onLogBase10,
    this.onLogBaseE,
    this.onCube,
    this.onCubeRoot,
    this.onYRoot,
    this.onPowerOf2,
    this.onLogBaseY,
    this.onPowerOfE,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr],
      rowSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      columnGap: 4,
      rowGap: 4,
      children: [
        if (isShift)
          CubeButton(
            onPressed: onCube,
          ).withGridPlacement(columnStart: 0, rowStart: 0)
        else
          XPower2Button(
            onPressed: onSquare,
          ).withGridPlacement(columnStart: 0, rowStart: 0),
        if (isShift)
          CubeRootButton(
            onPressed: onCubeRoot,
          ).withGridPlacement(columnStart: 0, rowStart: 1)
        else
          SquareRootButton(
            onPressed: onSquareRoot,
          ).withGridPlacement(columnStart: 0, rowStart: 1),
        if (isShift)
          YSquareRootButton(
            onPressed: onYRoot,
          ).withGridPlacement(columnStart: 0, rowStart: 2)
        else
          PowerButton(
            onPressed: onPower,
          ).withGridPlacement(columnStart: 0, rowStart: 2),
        if (isShift)
          TwoPowerXButton(
            onPressed: onPowerOf2,
          ).withGridPlacement(columnStart: 0, rowStart: 3)
        else
          PowerOf10Button(
            onPressed: onPowerOf10,
          ).withGridPlacement(columnStart: 0, rowStart: 3),
        if (isShift)
          LogBaseYButton(
            onPressed: onLogBaseY,
          ).withGridPlacement(columnStart: 0, rowStart: 4)
        else
          LogBase10Button(
            onPressed: onLogBase10,
          ).withGridPlacement(columnStart: 0, rowStart: 4),
        if (isShift)
          PowerOfEButton(
            onPressed: onPowerOfE,
          ).withGridPlacement(columnStart: 0, rowStart: 5)
        else
          LogBaseEButton(
            onPressed: onLogBaseE,
          ).withGridPlacement(columnStart: 0, rowStart: 5),
      ],
    );
  }
}

/// x² 平方按钮
class XPower2Button extends StatelessWidget {
  final VoidCallback? onPressed;

  const XPower2Button({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.square, size: 20),
      ),
    );
  }
}

/// √x 平方根按钮
class SquareRootButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const SquareRootButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.squareRoot, size: 20),
      ),
    );
  }
}

/// xʸ 幂按钮
class PowerButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const PowerButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.power, size: 20),
      ),
    );
  }
}

/// 10ˣ 10的幂按钮
class PowerOf10Button extends StatelessWidget {
  final VoidCallback? onPressed;

  const PowerOf10Button({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.powerOf10, size: 20),
      ),
    );
  }
}

/// log 以10为底对数按钮
class LogBase10Button extends StatelessWidget {
  final VoidCallback? onPressed;

  const LogBase10Button({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Text('log', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

/// ln 以e为底对数按钮
class LogBaseEButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LogBaseEButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Text('ln', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

/// x³ 笂按钮
class CubeButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CubeButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.cube, size: 20),
      ),
    );
  }
}

/// ∛x 笱根按钮
class CubeRootButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CubeRootButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.cubeRoot, size: 20),
      ),
    );
  }
}

/// ʸ√x y次方根按钮
class YSquareRootButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const YSquareRootButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.yRoot, size: 20),
      ),
    );
  }
}

/// 2ˣ 2的幂按钮
class TwoPowerXButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const TwoPowerXButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.powerOf2, size: 20),
      ),
    );
  }
}

/// logᵧx 以y为底对数按钮
class LogBaseYButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LogBaseYButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.logBaseY, size: 20),
      ),
    );
  }
}

/// eˣ e的幂按钮
class PowerOfEButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const PowerOfEButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(CalculatorIcons.powerOfE, size: 20),
      ),
    );
  }
}
