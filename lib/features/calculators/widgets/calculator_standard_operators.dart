import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'number_pad.dart';
import 'standard_display_controls.dart';
import 'standard_functions.dart';
import 'standard_operators.dart';

/// 标准计算器完整键盘
///
/// 使用 flutter_layout_grid 实现 6行×4列，组合所有子组件:
/// ```
///     Col 0      Col 1      Col 2      Col 3
///    ┌─────────┬─────────┬─────────┬─────────┐
/// R0 │       StandardDisplayControls         │
///    ├─────────┼─────────┼─────────┼─────────┤
/// R1 │      StandardFunctions     │    ÷     │
///    ├─────────┼─────────┼─────────┼─────────┤
/// R2 │                              │    ×     │
/// R3 │          NumberPad           │    −     │
/// R4 │                              │    +     │
/// R5 │                              │    =     │
///    └─────────┴─────────┴─────────┴─────────┘
/// ```
class CalculatorStandardOperators extends StatelessWidget {
  // StandardDisplayControls
  final VoidCallback? onPercent;
  final VoidCallback? onClearEntry;
  final VoidCallback? onClear;
  final VoidCallback? onBackspace;

  // StandardFunctions
  final VoidCallback? onReciprocal;
  final VoidCallback? onSquare;
  final VoidCallback? onSquareRoot;

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

  const CalculatorStandardOperators({
    super.key,
    this.onPercent,
    this.onClearEntry,
    this.onClear,
    this.onBackspace,
    this.onReciprocal,
    this.onSquare,
    this.onSquareRoot,
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
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      columnGap: 4,
      rowGap: 4,
      children: [
        // Row 0: StandardDisplayControls (spans 4 columns)
        StandardDisplayControls(
          onPercent: onPercent,
          onClearEntry: onClearEntry,
          onClear: onClear,
          onBackspace: onBackspace,
        ).withGridPlacement(
          columnStart: 0,
          columnSpan: 4,
          rowStart: 0,
          rowSpan: 1,
        ),
        // Row 1, Col 0-2: StandardFunctions
        StandardFunctions(
          onReciprocal: onReciprocal,
          onSquare: onSquare,
          onSquareRoot: onSquareRoot,
        ).withGridPlacement(
          columnStart: 0,
          columnSpan: 3,
          rowStart: 1,
          rowSpan: 1,
        ),
        // Row 2-5, Col 0-2: NumberPad
        NumberPad(
          onDigit: onDigit,
          onDecimal: onDecimal,
          onNegate: onNegate,
        ).withGridPlacement(
          columnStart: 0,
          columnSpan: 3,
          rowStart: 2,
          rowSpan: 4,
        ),
        // Row 1-5, Col 3: StandardOperators
        StandardOperators(
          onDivide: onDivide,
          onMultiply: onMultiply,
          onSubtract: onSubtract,
          onAdd: onAdd,
          onEquals: onEquals,
        ).withGridPlacement(
          columnStart: 3,
          columnSpan: 1,
          rowStart: 1,
          rowSpan: 5,
        ),
      ],
    );
  }
}
