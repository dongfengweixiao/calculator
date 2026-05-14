import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../core/services/calculator_service.dart';
import '../../common/view/header_bar.dart';
import 'calculator_model.dart';
import 'widgets/calculator_standard_operators.dart';
import 'widgets/row_expression.dart';
import 'widgets/row_result.dart';
import 'widgets/row_display_controls.dart';
import 'widgets/row_memory_controls.dart';

/// 标准计算器页面
///
/// 使用 flutter_layout_grid 实现1列5行布局:
/// - RowExpression: 表达式行 (22.fr)
/// - RowResult: 结果行 (72.fr)
/// - RowDisplayControls: 显示控件行 (0.px, 隐藏)
/// - RowMemoryControls: 内存控件行 (32.fr)
/// - CalculatorStandardOperators: 数字键盘行 (308.fr)
class StandardCalculatorPage extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const StandardCalculatorPage({super.key});

  @override
  State<StandardCalculatorPage> createState() => _StandardCalculatorPageState();
}

class _StandardCalculatorPageState extends State<StandardCalculatorPage> {
  CalculatorModel get _model => di<CalculatorModel>();

  @override
  void initState() {
    super.initState();
    // 确保进入标准计算器时引擎处于标准模式
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model.setMode(CalculatorMode.standard);
    });
  }

  @override
  Widget build(BuildContext context) {
    final display = watchPropertyValue((CalculatorModel m) => m.display);
    final expression = watchPropertyValue((CalculatorModel m) => m.expression);

    return Scaffold(
      appBar: HeaderBar(adaptive: true, title: const Text('标准')),
      body: LayoutGrid(
        columnSizes: [1.fr],
        rowSizes: [
          22.fr, // RowExpression
          72.fr, // RowResult
          0.px, // RowDisplayControls (标准模式隐藏)
          32.fr, // RowMemoryControls
          308.fr, // CalculatorStandardOperators
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
          // RowDisplayControls: 标准模式不显示，高度为0
          const RowDisplayControls().withGridPlacement(
            columnStart: 0,
            rowStart: 2,
          ),
          RowMemoryControls(
            onMemoryClear: _model.memoryClear,
            onMemoryRecall: _model.memoryRecall,
            onMemoryAdd: _model.memoryAdd,
            onMemorySubtract: _model.memorySubtract,
            onMemoryStore: _model.memoryStore,
          ).withGridPlacement(columnStart: 0, rowStart: 3),
          CalculatorStandardOperators(
            onPercent: _model.percent,
            onClearEntry: _model.clearEntry,
            onClear: _model.clear,
            onBackspace: _model.backspace,
            onReciprocal: _model.reciprocal,
            onSquare: _model.square,
            onSquareRoot: _model.squareRoot,
            onDigit: (digit) => _model.inputDigit(digit),
            onDecimal: _model.inputDecimal,
            onNegate: _model.inputNegate,
            onDivide: _model.divide,
            onMultiply: _model.multiply,
            onSubtract: _model.subtract,
            onAdd: _model.add,
            onEquals: _model.equals,
          ).withGridPlacement(columnStart: 0, rowStart: 4),
        ],
      ),
    );
  }
}
