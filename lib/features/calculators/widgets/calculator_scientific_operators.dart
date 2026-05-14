import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../../core/theme/app_icons.dart';
import '../trig_types.dart';
import 'number_pad.dart';
import 'operator_panel_row.dart';
import 'clear_backspace_row.dart';
import 'scientific_functions.dart';
import 'shared_buttons.dart';
import 'standard_operators.dart';

/// 科学计算器完整键盘
///
/// 使用 flutter_layout_grid 实现 8行×5列:
/// ```
///      Col 0       Col 1    Col 2    Col 3    Col 4
///     ┌──────────────────────────────────────────────┐
/// R0  │       OperatorPanelRow (spans 5 cols)        │
///     ├──────────┬────────┬────────┬────────┬────────┤
/// R1  │ Shift   │  π     │  e     │        │       │
///     ├──────────┼────────┼────────┼────────┼────────┤
/// R2  │ SciFunc │ 1/x   │  |x|   │  Exp   │  Mod  │
/// R3  │ SciFunc │  (     │  )     │  n!    │  ÷    │
///     ├──────────┼────────┼────────┼────────┼────────┤
/// R4  │ SciFunc │       NumberPad          │  ×    │
/// R5  │ SciFunc │       (4行×3列)          │  −    │
/// R6  │ SciFunc │                         │  +    │
/// R7  │ SciFunc │                         │  =    │
///     └──────────┴────────┴────────┴────────┴────────┘
/// ```
class CalculatorScientificOperators extends StatefulWidget {
  // OperatorPanelRow
  final void Function(TrigFunction)? onTrigFunctionSelected;
  final VoidCallback? onAbs;
  final VoidCallback? onFloor;
  final VoidCallback? onCeil;
  final VoidCallback? onRand;
  final VoidCallback? onDms;
  final VoidCallback? onDegrees;

  // Shift
  final VoidCallback? onShift;

  // 常量
  final VoidCallback? onPi;
  final VoidCallback? onEuler;

  // 括号
  final VoidCallback? onOpenParenthesis;
  final VoidCallback? onCloseParenthesis;
  final int openParenCount;

  // ScientificFunctions
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

  // 其他功能
  final VoidCallback? onFactorial;
  final VoidCallback? onInvert;
  final VoidCallback? onExp;
  final VoidCallback? onMod;

  // 清除/退格
  final VoidCallback? onClear;
  final VoidCallback? onClearEntry;
  final VoidCallback? onBackspace;
  final String result;

  // NumberPad
  final void Function(int digit)? onDigit;
  final VoidCallback? onDecimal;
  final VoidCallback? onNegate;

  // StandardOperators
  final VoidCallback? onDivide;
  final VoidCallback? onMultiply;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;
  final VoidCallback? onEquals;

  const CalculatorScientificOperators({
    super.key,
    this.onTrigFunctionSelected,
    this.onAbs,
    this.onFloor,
    this.onCeil,
    this.onRand,
    this.onDms,
    this.onDegrees,
    this.onShift,
    this.onPi,
    this.onEuler,
    this.onOpenParenthesis,
    this.onCloseParenthesis,
    this.openParenCount = 0,
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
    this.onFactorial,
    this.onInvert,
    this.onExp,
    this.onMod,
    this.onClear,
    this.onClearEntry,
    this.onBackspace,
    this.result = '0',
    this.onDigit,
    this.onDecimal,
    this.onNegate,
    this.onDivide,
    this.onMultiply,
    this.onSubtract,
    this.onAdd,
    this.onEquals,
  });

  @override
  State<CalculatorScientificOperators> createState() =>
      _CalculatorScientificOperatorsState();
}

class _CalculatorScientificOperatorsState
    extends State<CalculatorScientificOperators> {
  bool _isShift = false;

  void _toggleShift() {
    setState(() => _isShift = !_isShift);
    widget.onShift?.call();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      columnGap: 4,
      rowGap: 4,
      children: [
        // R0: OperatorPanelRow (spans 5 columns)
        OperatorPanelRow(
          onTrigFunctionSelected: widget.onTrigFunctionSelected,
          onAbs: widget.onAbs,
          onFloor: widget.onFloor,
          onCeil: widget.onCeil,
          onRand: widget.onRand,
          onDms: widget.onDms,
          onDegrees: widget.onDegrees,
        ).withGridPlacement(
          columnStart: 0,
          columnSpan: 5,
          rowStart: 0,
          rowSpan: 1,
        ),

        // R1, C0: Shift
        ScientificShiftButton(
          isSelected: _isShift,
          onPressed: _toggleShift,
        ).withGridPlacement(columnStart: 0, rowStart: 1),
        // R1, C1: Pi
        PiButton(
          onPressed: widget.onPi,
        ).withGridPlacement(columnStart: 1, rowStart: 1),
        // R1, C2: Euler
        EulerButton(
          onPressed: widget.onEuler,
        ).withGridPlacement(columnStart: 2, rowStart: 1),
        // R1, C3-C4: Clear/Backspace row
        ClearBackspaceRow(
          hasEntry: widget.result != '0',
          onClear: widget.onClear,
          onClearEntry: widget.onClearEntry,
          onBackspace: widget.onBackspace,
        ).withGridPlacement(columnStart: 3, columnSpan: 2, rowStart: 1),

        // R2-R7, C0: ScientificFunctions
        ScientificFunctions(
          isShift: _isShift,
          onSquare: widget.onSquare,
          onSquareRoot: widget.onSquareRoot,
          onPower: widget.onPower,
          onPowerOf10: widget.onPowerOf10,
          onLogBase10: widget.onLogBase10,
          onLogBaseE: widget.onLogBaseE,
          onCube: widget.onCube,
          onCubeRoot: widget.onCubeRoot,
          onYRoot: widget.onYRoot,
          onPowerOf2: widget.onPowerOf2,
          onLogBaseY: widget.onLogBaseY,
          onPowerOfE: widget.onPowerOfE,
        ).withGridPlacement(columnStart: 0, rowStart: 2, rowSpan: 6),

        // R2, C1: Invert (1/x)
        InvertButton(
          onPressed: widget.onInvert,
        ).withGridPlacement(columnStart: 1, rowStart: 2),
        // R2, C2: Abs (|x|)
        AbsButton(
          onPressed: widget.onAbs,
        ).withGridPlacement(columnStart: 2, rowStart: 2),
        // R2, C3: Exp
        ExpButton(
          onPressed: widget.onExp,
        ).withGridPlacement(columnStart: 3, rowStart: 2),
        // R2, C4: Mod
        ModButton(
          onPressed: widget.onMod,
        ).withGridPlacement(columnStart: 4, rowStart: 2),

        // R3, C1: OpenParenthesis
        OpenParenthesisButton(
          onPressed: widget.onOpenParenthesis,
          count: widget.openParenCount,
        ).withGridPlacement(columnStart: 1, rowStart: 3),
        // R3, C2: CloseParenthesis
        CloseParenthesisButton(
          onPressed: widget.onCloseParenthesis,
        ).withGridPlacement(columnStart: 2, rowStart: 3),
        // R3, C3: Factorial
        FactorialButton(
          onPressed: widget.onFactorial,
        ).withGridPlacement(columnStart: 3, rowStart: 3),

        // R4-R7, C1-C3: NumberPad
        NumberPad(
          onDigit: widget.onDigit,
          onDecimal: widget.onDecimal,
          onNegate: widget.onNegate,
        ).withGridPlacement(
          columnStart: 1,
          columnSpan: 3,
          rowStart: 4,
          rowSpan: 4,
        ),

        // R3-R7, C4: StandardOperators
        StandardOperators(
          onDivide: widget.onDivide,
          onMultiply: widget.onMultiply,
          onSubtract: widget.onSubtract,
          onAdd: widget.onAdd,
          onEquals: widget.onEquals,
        ).withGridPlacement(columnStart: 4, rowStart: 3, rowSpan: 5),
      ],
    );
  }
}

/// Shift 可切换按钮
class ScientificShiftButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onPressed;

  const ScientificShiftButton({
    super.key,
    this.isSelected = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
          backgroundColor: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          foregroundColor: isSelected
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
        ),
        child: const Icon(CalculatorIcons.shift, size: 20),
      ),
    );
  }
}

/// π 圆周率按钮
class PiButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const PiButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(CalculatorIcons.pi, size: 20),
      ),
    );
  }
}

/// e 欧拉数按钮
class EulerButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const EulerButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Text('e', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

// OpenParenthesisButton is now imported from shared_buttons.dart

// CloseParenthesisButton is now imported from shared_buttons.dart

/// n! 阶乘按钮
class FactorialButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FactorialButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(CalculatorIcons.factorial, size: 20),
      ),
    );
  }
}

// InvertButton is now imported from shared_buttons.dart

/// |x| 绝对值按钮
class AbsButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AbsButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(CalculatorIcons.absoluteValue, size: 20),
      ),
    );
  }
}

/// Exp 指数表示按钮
class ExpButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ExpButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Text('exp', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

/// Mod 取模按钮
class ModButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ModButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: const Text('mod', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
