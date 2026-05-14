import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../radix_types.dart';
import 'radix_button.dart';

/// 程序员计算器进制选择面板
///
/// 使用 flutter_layout_grid 实现 4行×1列:
/// ```
///    Col 0
///   ┌──────────────────────┐
///   │  HEX    FF            │
///   ├──────────────────────┤
///   │  DEC    255    ← 选中 │
///   ├──────────────────────┤
///   │  OCT    377           │
///   ├──────────────────────┤
///   │  BIN    11111111      │
///   └──────────────────────┘
/// ```
class CalculatorProgrammerOperators extends StatelessWidget {
  final RadixType selectedRadix;
  final String hexValue;
  final String decValue;
  final String octValue;
  final String binValue;
  final ValueChanged<RadixType>? onRadixChanged;

  const CalculatorProgrammerOperators({
    super.key,
    this.selectedRadix = RadixType.dec,
    this.hexValue = '0',
    this.decValue = '0',
    this.octValue = '0',
    this.binValue = '0',
    this.onRadixChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr],
      rowSizes: [1.fr, 1.fr, 1.fr, 1.fr],
      columnGap: 0,
      rowGap: 0,
      children: [
        RadixButton(
          radix: RadixType.hex,
          isSelected: selectedRadix == RadixType.hex,
          value: hexValue,
          onPressed: () => onRadixChanged?.call(RadixType.hex),
        ).withGridPlacement(columnStart: 0, rowStart: 0),
        RadixButton(
          radix: RadixType.dec,
          isSelected: selectedRadix == RadixType.dec,
          value: decValue,
          onPressed: () => onRadixChanged?.call(RadixType.dec),
        ).withGridPlacement(columnStart: 0, rowStart: 1),
        RadixButton(
          radix: RadixType.oct,
          isSelected: selectedRadix == RadixType.oct,
          value: octValue,
          onPressed: () => onRadixChanged?.call(RadixType.oct),
        ).withGridPlacement(columnStart: 0, rowStart: 2),
        RadixButton(
          radix: RadixType.bin,
          isSelected: selectedRadix == RadixType.bin,
          value: binValue,
          onPressed: () => onRadixChanged?.call(RadixType.bin),
        ).withGridPlacement(columnStart: 0, rowStart: 3),
      ],
    );
  }
}
