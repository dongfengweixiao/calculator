import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../core/services/calculator_service.dart';
import '../../common/view/header_bar.dart';
import 'calculator_model.dart';
import 'widgets/row_expression.dart';
import 'widgets/row_result.dart';
import 'widgets/scientific_display_controls.dart';
import 'widgets/row_memory_controls.dart';
import 'widgets/calculator_scientific_operators.dart';

/// 科学计算器页面
///
/// 使用 flutter_layout_grid 实现1列5行布局:
/// - RowExpression: 表达式行 (22.fr)
/// - RowResult: 结果行 (72.fr)
/// - ScientificDisplayControls: 显示控件行 (32.fr)
/// - RowMemoryControls: 内存控件行 (32.fr)
/// - CalculatorScientificOperators: 数字键盘行 (276.fr)
class ScientificCalculatorPage extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ScientificCalculatorPage({super.key});

  @override
  State<ScientificCalculatorPage> createState() =>
      _ScientificCalculatorPageState();
}

class _ScientificCalculatorPageState extends State<ScientificCalculatorPage> {
  CalculatorModel get _model => di<CalculatorModel>();

  @override
  void initState() {
    super.initState();
    // 进入科学计算器页面时切换引擎模式
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model.setMode(CalculatorMode.scientific);
    });
  }

  @override
  Widget build(BuildContext context) {
    final display = watchPropertyValue((CalculatorModel m) => m.display);
    final expression = watchPropertyValue((CalculatorModel m) => m.expression);
    final angleMode = watchPropertyValue((CalculatorModel m) => m.angleMode);
    final isFtoEActive = watchPropertyValue(
      (CalculatorModel m) => m.isFtoEActive,
    );

    return Scaffold(
      appBar: HeaderBar(adaptive: true, title: const Text('科学')),
      body: LayoutGrid(
        columnSizes: [1.fr],
        rowSizes: [
          22.fr, // RowExpression
          72.fr, // RowResult
          32.fr, // ScientificDisplayControls
          32.fr, // RowMemoryControls
          276.fr, // CalculatorScientificOperators
        ],
        columnGap: 0,
        rowGap: 0,
        children: [
          RowExpression(
            expression: expression,
          ).withGridPlacement(columnStart: 0, rowStart: 0),
          RowResult(
            result: display,
          ).withGridPlacement(columnStart: 0, rowStart: 1),
          ScientificDisplayControls(
            angleMode: angleMode,
            onDegree: _model.degrees,
            onRadian: _model.radian,
            onGrads: _model.grads,
            onFtoE: _model.ftoE,
            isFtoEActive: isFtoEActive,
          ).withGridPlacement(columnStart: 0, rowStart: 2),
          RowMemoryControls(
            onMemoryClear: _model.memoryClear,
            onMemoryRecall: _model.memoryRecall,
            onMemoryAdd: _model.memoryAdd,
            onMemorySubtract: _model.memorySubtract,
            onMemoryStore: _model.memoryStore,
          ).withGridPlacement(columnStart: 0, rowStart: 3),
          CalculatorScientificOperators(
            onTrigFunctionSelected: _model.sendTrigFunction,
            onAbs: _model.abs,
            onFloor: _model.floor,
            onCeil: _model.ceil,
            onRand: _model.rand,
            onDms: _model.dms,
            onDegrees: _model.degrees,
            onShift: () => print('Shift'),
            onPi: _model.pi,
            onEuler: _model.euler,
            onOpenParenthesis: _model.openParen,
            openParenCount: _model.parenCount,
            onCloseParenthesis: _model.closeParen,
            onFactorial: _model.factorial,
            onInvert: _model.invert,
            onExp: _model.exp,
            onMod: _model.mod,
            onClear: _model.clear,
            onClearEntry: _model.clearEntry,
            onBackspace: _model.backspace,
            result: display,
            onDigit: (digit) => _model.inputDigit(digit),
            onDecimal: _model.inputDecimal,
            onNegate: _model.inputNegate,
            onDivide: _model.divide,
            onMultiply: _model.multiply,
            onSubtract: _model.subtract,
            onAdd: _model.add,
            onEquals: _model.equals,
            onSquare: _model.square,
            onSquareRoot: _model.squareRoot,
            onPower: _model.power,
            onPowerOf10: _model.pow10,
            onLogBase10: _model.log,
            onLogBaseE: _model.ln,
            onCube: _model.cube,
            onCubeRoot: _model.cubeRoot,
            onYRoot: _model.yRoot,
            onPowerOf2: _model.pow2,
            onLogBaseY: _model.logBaseY,
            onPowerOfE: _model.powE,
          ).withGridPlacement(columnStart: 0, rowStart: 4),
        ],
      ),
    );
  }
}
