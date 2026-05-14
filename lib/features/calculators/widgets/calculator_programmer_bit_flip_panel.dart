import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../word_size_types.dart';
import 'shared_buttons.dart';

/// 位翻转面板
///
/// 使用 flutter_layout_grid 实现 8行×19列:
/// 第1/3/5/7行（0-indexed 0/2/4/6）为 BitFlipButton，其余为间距行。
///
/// ```
///   [63][62][61][60]   [59][58][57][56]   [55][54][53][52]   [51][50][49][48]  R0
///   [47][46][45][44]   [43][42][41][40]   [39][38][37][36]   [35][34][33][32]  R2
///   [31][30][29][28]   [27][26][25][24]   [23][22][21][20]   [19][18][17][16]  R4
///   [15][14][13][12]   [11][10][ 9][ 8]   [ 7][ 6][ 5][ 4]   [ 3][ 2][ 1][ 0]  R6
/// ```
class CalculatorProgrammerBitFlipPanel extends StatelessWidget {
  final WordSize wordSize;
  final String binValue;
  final ValueChanged<int>? onBitToggled;

  const CalculatorProgrammerBitFlipPanel({
    super.key,
    this.wordSize = WordSize.qword,
    this.binValue = '0',
    this.onBitToggled,
  });

  static int _enabledBitCount(WordSize size) => switch (size) {
    WordSize.qword => 64,
    WordSize.dword => 32,
    WordSize.word => 16,
    WordSize.byte => 8,
  };

  static const _separatorCols = {4, 9, 14};

  int _positionInRow(int col) {
    var pos = col;
    switch (col) {
      case > 14:
        pos -= 3;
      case > 9:
        pos -= 2;
      case > 4:
        pos -= 1;
    }
    return pos;
  }

  @override
  Widget build(BuildContext context) {
    final enabledBits = _enabledBitCount(wordSize);

    return LayoutGrid(
      columnSizes: [
        1.fr,
        1.fr,
        1.fr,
        1.fr,
        0.8.fr,
        1.fr,
        1.fr,
        1.fr,
        1.fr,
        0.8.fr,
        1.fr,
        1.fr,
        1.fr,
        1.fr,
        0.8.fr,
        1.fr,
        1.fr,
        1.fr,
        1.fr,
      ],
      rowSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      columnGap: 1,
      rowGap: 1,
      children: [
        // 第1行：BitFlipButton
        for (int col = 0; col < 19; col++)
          if (!_separatorCols.contains(col))
            _buildBitButton(
              0,
              col,
              enabledBits,
            ).withGridPlacement(columnStart: col, rowStart: 0),
        // 第2行：文本标签
        _buildTextLabel('60').withGridPlacement(columnStart: 3, rowStart: 1),
        _buildTextLabel('56').withGridPlacement(columnStart: 8, rowStart: 1),
        _buildTextLabel('52').withGridPlacement(columnStart: 13, rowStart: 1),
        _buildTextLabel('48').withGridPlacement(columnStart: 18, rowStart: 1),
        // 第3行：BitFlipButton
        for (int col = 0; col < 19; col++)
          if (!_separatorCols.contains(col))
            _buildBitButton(
              1,
              col,
              enabledBits,
            ).withGridPlacement(columnStart: col, rowStart: 2),
        // 第4行：文本标签
        _buildTextLabel('44').withGridPlacement(columnStart: 3, rowStart: 3),
        _buildTextLabel('40').withGridPlacement(columnStart: 8, rowStart: 3),
        _buildTextLabel('36').withGridPlacement(columnStart: 13, rowStart: 3),
        _buildTextLabel('32').withGridPlacement(columnStart: 18, rowStart: 3),
        // 第5行：BitFlipButton
        for (int col = 0; col < 19; col++)
          if (!_separatorCols.contains(col))
            _buildBitButton(
              2,
              col,
              enabledBits,
            ).withGridPlacement(columnStart: col, rowStart: 4),
        // 第6行：文本标签
        _buildTextLabel('28').withGridPlacement(columnStart: 3, rowStart: 5),
        _buildTextLabel('24').withGridPlacement(columnStart: 8, rowStart: 5),
        _buildTextLabel('20').withGridPlacement(columnStart: 13, rowStart: 5),
        _buildTextLabel('16').withGridPlacement(columnStart: 18, rowStart: 5),
        // 第7行：BitFlipButton
        for (int col = 0; col < 19; col++)
          if (!_separatorCols.contains(col))
            _buildBitButton(
              3,
              col,
              enabledBits,
            ).withGridPlacement(columnStart: col, rowStart: 6),
        // 第8行：文本标签
        _buildTextLabel('12').withGridPlacement(columnStart: 3, rowStart: 7),
        _buildTextLabel('8').withGridPlacement(columnStart: 8, rowStart: 7),
        _buildTextLabel('4').withGridPlacement(columnStart: 13, rowStart: 7),
        _buildTextLabel('0').withGridPlacement(columnStart: 18, rowStart: 7),
      ],
    );
  }

  Widget _buildTextLabel(String text) {
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.topCenter, // 顶部居中对齐
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center, // 文本居中对齐
        ),
      ),
    );
  }

  Widget _buildBitButton(int bitRow, int col, int enabledBits) {
    final pos = _positionInRow(col);
    final bitNum = 63 - bitRow * 16 - pos;
    final isChecked = _isBitSet(bitNum);
    final isEnabled = bitNum < enabledBits;

    return BitFlipButton(
      bitNumber: bitNum,
      isChecked: isChecked,
      isEnabled: isEnabled,
      onPressed: () => onBitToggled?.call(bitNum),
    );
  }

  bool _isBitSet(int bitNum) {
    // 移除空格，然后反转字符串以便从最低位开始索引
    final binaryStr = binValue.replaceAll(' ', '').split('').reversed.join('');
    // 检查索引是否有效，然后检查该位是否为 '1'
    return bitNum < binaryStr.length && binaryStr[bitNum] == '1';
  }
}

// BitFlipButton is now imported from shared_buttons.dart
