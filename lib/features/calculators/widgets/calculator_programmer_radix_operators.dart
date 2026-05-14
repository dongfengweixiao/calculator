import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../../core/theme/app_icons.dart';
import 'shared_buttons.dart';
import 'hex_digit_pad.dart';
import 'number_pad.dart';
import 'programmer_operator_panel_row.dart';
import 'clear_backspace_row.dart';
import 'standard_operators.dart';
import 'bit_shift_flyout.dart';

/// 程序员计算器基数键盘面板
///
/// 使用 flutter_layout_grid 实现 7行×5列:
/// ```
///    Col 0      Col 1      Col 2      Col 3      Col 4
///   ┌─────────────────────────────────────────────────┐
///   │        ProgrammerOperatorPanelRow (占5列)         │ Row 0
///   ├──────────┼──────────┼──────────┼──────────┼─────┤
///   │          │   Rol    │   Ror    │   Rlc    │     │ Row 1
///   ├──────────┼──────────┼──────────┼──────────┼─────┤
///   │          │    (     │    )     │    %     │  ÷  │ Row 2
///   ├──────────┼──────────┴──────────┴──────────┼─────┤
///   │          │                                │  ×  │ Row 3
///   ├──────────┤       NumberPad (4行×3列)       ├─────┤ Row 4
///   │          │                                │  −  │ Row 5
///   ├──────────┼──────────┬──────────┬──────────┼─────┤ Row 6
///   │          │          │          │          │  =  │
///   └──────────┴──────────┴──────────┴──────────┴─────┘
/// ```
class CalculatorProgrammerRadixOperators extends StatefulWidget {
  final VoidCallback? onAnd;
  final VoidCallback? onOr;
  final VoidCallback? onNot;
  final VoidCallback? onNand;
  final VoidCallback? onNor;
  final VoidCallback? onXor;
  final VoidCallback? onBitShift;

  final VoidCallback? onRol;
  final VoidCallback? onRor;
  final VoidCallback? onClear;
  final VoidCallback? onClearEntry;
  final VoidCallback? onBackspace;
  final VoidCallback? onRlc;
  final String result;
  final VoidCallback? onOpenParen;
  final VoidCallback? onCloseParen;
  final VoidCallback? onPercent;
  final int openParenCount;

  final void Function(String hex)? onHex;

  final void Function(int digit)? onDigit;
  final VoidCallback? onDecimal;
  final VoidCallback? onNegate;

  final VoidCallback? onDivide;
  final VoidCallback? onMultiply;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;
  final VoidCallback? onEquals;

  final VoidCallback? onLsh;
  final VoidCallback? onRsh;
  final VoidCallback? onRshL;
  final VoidCallback? onRolc;
  final VoidCallback? onRorc;

  /// 十六进制按钮是否可用
  final bool isHexEnabled;

  /// 最大可用数字，超过此值的数字按钮将被禁用
  final int maxDigit;

  const CalculatorProgrammerRadixOperators({
    super.key,
    this.onAnd,
    this.onOr,
    this.onNot,
    this.onNand,
    this.onNor,
    this.onXor,
    this.onBitShift,
    this.onRol,
    this.onRor,
    this.onClear,
    this.onClearEntry,
    this.onBackspace,
    this.onRlc,
    this.result = '0',
    this.onOpenParen,
    this.onCloseParen,
    this.openParenCount = 0,
    this.onPercent,
    this.onHex,
    this.onDigit,
    this.onDecimal,
    this.onNegate,
    this.onDivide,
    this.onMultiply,
    this.onSubtract,
    this.onAdd,
    this.onEquals,
    this.onLsh,
    this.onRsh,
    this.onRshL,
    this.onRolc,
    this.onRorc,
    this.isHexEnabled = true,
    this.maxDigit = 9,
  });

  @override
  State<CalculatorProgrammerRadixOperators> createState() =>
      _CalculatorProgrammerRadixOperatorsState();
}

class _CalculatorProgrammerRadixOperatorsState
    extends State<CalculatorProgrammerRadixOperators> {
  // 位移类型
  ShiftType _shiftType = ShiftType.arithmetic;

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      columnGap: 4,
      rowGap: 4,
      children: [
        // Row 0: ProgrammerOperatorPanelRow (占5列)
        ProgrammerOperatorPanelRow(
          onAnd: widget.onAnd,
          onOr: widget.onOr,
          onNot: widget.onNot,
          onNand: widget.onNand,
          onNor: widget.onNor,
          onXor: widget.onXor,
          onArithmeticShift: () {
            setState(() => _shiftType = ShiftType.arithmetic);
          },
          onLogicalShift: () {
            setState(() => _shiftType = ShiftType.logical);
          },
          onRotateCircular: () {
            setState(() => _shiftType = ShiftType.rotate);
          },
          onRotateCarryShift: () {
            setState(() => _shiftType = ShiftType.rotateCarry);
          },
          selectedShiftType: _shiftType,
        ).withGridPlacement(columnStart: 0, rowStart: 0, columnSpan: 5),
        // Row 1
        _buildLeftShiftButton().withGridPlacement(columnStart: 1, rowStart: 1),
        _buildRightShiftButton().withGridPlacement(columnStart: 2, rowStart: 1),
        ClearBackspaceRow(
          hasEntry: widget.result != '0',
          onClear: widget.onClear,
          onClearEntry: widget.onClearEntry,
          onBackspace: widget.onBackspace,
        ).withGridPlacement(columnStart: 3, columnSpan: 2, rowStart: 1),
        // Row 2
        OpenParenthesisButton(
          onPressed: widget.onOpenParen,
          count: widget.openParenCount,
        ).withGridPlacement(columnStart: 1, rowStart: 2),
        CloseParenthesisButton(
          onPressed: widget.onCloseParen,
        ).withGridPlacement(columnStart: 2, rowStart: 2),
        PercentButton(
          onPressed: widget.onPercent,
        ).withGridPlacement(columnStart: 3, rowStart: 2),
        // Row 2~6, Col 4: StandardOperators
        StandardOperators(
          onDivide: widget.onDivide,
          onMultiply: widget.onMultiply,
          onSubtract: widget.onSubtract,
          onAdd: widget.onAdd,
          onEquals: widget.onEquals,
        ).withGridPlacement(columnStart: 4, rowStart: 2, rowSpan: 5),
        // Row 1~6, Col 0: HexDigitPad
        HexDigitPad(
          onHex: widget.onHex,
          isEnabled: widget.isHexEnabled,
        ).withGridPlacement(columnStart: 0, rowStart: 1, rowSpan: 6),
        // Row 3~6, Col 1~3: NumberPad
        NumberPad(
          onDigit: widget.onDigit,
          onDecimal: widget.onDecimal,
          onNegate: widget.onNegate,
          maxDigit: widget.maxDigit,
        ).withGridPlacement(
          columnStart: 1,
          rowStart: 3,
          columnSpan: 3,
          rowSpan: 4,
        ),
      ],
    );
  }

  // 根据位移类型构建左移按钮
  Widget _buildLeftShiftButton() {
    switch (_shiftType) {
      case ShiftType.arithmetic:
        return LshButton(onPressed: widget.onLsh);
      case ShiftType.logical:
        return LshLogicalButton(onPressed: widget.onLsh);
      case ShiftType.rotate:
        return RolButton(onPressed: widget.onRol);
      case ShiftType.rotateCarry:
        return RolCarryButton(onPressed: widget.onRolc);
    }
  }

  // 根据位移类型构建右移按钮
  Widget _buildRightShiftButton() {
    switch (_shiftType) {
      case ShiftType.arithmetic:
        return RshButton(onPressed: widget.onRsh);
      case ShiftType.logical:
        return RshLogicalButton(onPressed: widget.onRshL);
      case ShiftType.rotate:
        return RorButton(onPressed: widget.onRor);
      case ShiftType.rotateCarry:
        return RorCarryButton(onPressed: widget.onRorc);
    }
  }
}

/// Rol 旋转左移按钮
class RolButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const RolButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: Icon(CalculatorIcons.rol, size: 20),
      ),
    );
  }
}

/// Ror 旋转右移按钮
class RorButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const RorButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero,
        ),
        child: Icon(CalculatorIcons.ror, size: 20),
      ),
    );
  }
}
