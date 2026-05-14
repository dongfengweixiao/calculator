import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../core/services/calculator_service.dart';
import '../../common/view/header_bar.dart';
import 'calculator_model.dart';
import 'widgets/row_expression.dart';
import 'widgets/row_result.dart';
import 'widgets/programmer_memory_controls.dart';
import 'widgets/calculator_programmer_operators.dart';
import 'widgets/calculator_programmer_radix_operators.dart';
import 'radix_types.dart';
import 'widgets/calculator_programmer_bit_flip_panel.dart';

/// 程序员计算器页面
///
/// 使用 flutter_layout_grid 实现1列5行布局:
/// - RowExpression: 表达式行 (22.fr)
/// - RowResult: 结果行 (72.fr)
/// - CalculatorProgrammerOperators: 进制选择行 (96.fr)
/// - ProgrammerMemoryControls: 内存控件行 (32.fr)
/// - CalculatorProgrammerRadixOperators / BitFlipPanel: 键盘行 (268.fr)
class ProgrammerCalculatorPage extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ProgrammerCalculatorPage({super.key});

  @override
  State<ProgrammerCalculatorPage> createState() =>
      _ProgrammerCalculatorPageState();
}

class _ProgrammerCalculatorPageState extends State<ProgrammerCalculatorPage> {
  CalculatorModel get _model => di<CalculatorModel>();

  KeypadMode _keypadMode = KeypadMode.fullKeypad;

  @override
  void initState() {
    super.initState();
    // 进入程序员计算器页面时切换引擎模式
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model.setMode(CalculatorMode.programmer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final display = watchPropertyValue((CalculatorModel m) => m.display);
    final expression = watchPropertyValue((CalculatorModel m) => m.expression);
    final selectedRadix = watchPropertyValue(
      (CalculatorModel m) => m.selectedRadix,
    );
    final hexValue = watchPropertyValue((CalculatorModel m) => m.hexValue);
    final decValue = watchPropertyValue((CalculatorModel m) => m.decValue);
    final octValue = watchPropertyValue((CalculatorModel m) => m.octValue);
    final binValue = watchPropertyValue((CalculatorModel m) => m.binValue);
    final parenCount = watchPropertyValue((CalculatorModel m) => m.parenCount);
    final wordSize = watchPropertyValue((CalculatorModel m) => m.wordSize);
    final value = watchPropertyValue((CalculatorModel m) => m.value);

    return Scaffold(
      appBar: HeaderBar(adaptive: true, title: const Text('程序员')),
      body: LayoutGrid(
        columnSizes: [1.fr],
        rowSizes: [
          22.fr, // RowExpression
          72.fr, // RowResult
          96.fr, // CalculatorProgrammerOperators
          32.fr, // ProgrammerMemoryControls
          268.fr, // RadixOperators / BitFlipPanel
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
          CalculatorProgrammerOperators(
            selectedRadix: selectedRadix,
            hexValue: hexValue,
            decValue: decValue,
            octValue: octValue,
            binValue: binValue,
            onRadixChanged: _model.setRadix,
          ).withGridPlacement(columnStart: 0, rowStart: 2),
          ProgrammerMemoryControls(
            onModeChanged: (mode) {
              setState(() => _keypadMode = mode);
            },
            onWordSizeChanged: _model.setWordSize,
            onMemoryStore: _model.memoryStore,
          ).withGridPlacement(columnStart: 0, rowStart: 3),
          (_keypadMode == KeypadMode.fullKeypad
                  ? CalculatorProgrammerRadixOperators(
                      onHex: (hex) => _model.inputHex(hex),
                      isHexEnabled: selectedRadix == RadixType.hex,
                      onDigit: (digit) => _model.inputDigit(digit),
                      maxDigit: selectedRadix == RadixType.oct
                          ? 7
                          : selectedRadix == RadixType.bin
                          ? 1
                          : 9,
                      onAnd: _model.and,
                      onOr: _model.or,
                      onNot: _model.not,
                      onNand: _model.nand,
                      onNor: _model.nor,
                      onXor: _model.xor,
                      onOpenParen: _model.openParen,
                      openParenCount: _model.parenCount,
                      onCloseParen: _model.closeParen,
                      onClear: _model.clear,
                      onClearEntry: _model.clearEntry,
                      onBackspace: _model.backspace,
                      result: display,
                      onPercent: _model.mod,
                      onNegate: _model.inputNegate,
                      onDivide: _model.divide,
                      onMultiply: _model.multiply,
                      onSubtract: _model.subtract,
                      onAdd: _model.add,
                      onEquals: _model.equals,
                      onRol: _model.rol,
                      onRor: _model.ror,
                      onLsh: _model.lsh,
                      onRsh: _model.rsh,
                      onRshL: _model.rshl,
                      onRolc: _model.rolc,
                      onRorc: _model.rorc,
                    )
                  : CalculatorProgrammerBitFlipPanel(
                      wordSize: wordSize,
                      binValue: binValue,
                      onBitToggled: _model.toggleBit,
                    ))
              .withGridPlacement(columnStart: 0, rowStart: 4),
        ],
      ),
    );
  }
}
