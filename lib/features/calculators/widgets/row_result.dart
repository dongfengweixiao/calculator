import 'package:flutter/material.dart';

import 'calculation_result.dart';

/// 结果显示行
///
/// 包装 CalculationResult 组件，用于计算器页面布局。
class RowResult extends StatelessWidget {
  final VoidCallback? onLeftButton;
  final VoidCallback? onRightButton;
  final String result;

  const RowResult({
    super.key,
    this.onLeftButton,
    this.onRightButton,
    this.result = '0',
  });

  @override
  Widget build(BuildContext context) {
    return CalculationResult(
      onLeftButton: onLeftButton,
      onRightButton: onRightButton,
      result: result,
    );
  }
}
