import 'package:flutter/material.dart';

import 'calculation_expression.dart';

/// 表达式显示行
///
/// 包装 CalculationExpression 组件，用于计算器页面布局。
class RowExpression extends StatelessWidget {
  final VoidCallback? onLeftButton;
  final VoidCallback? onRightButton;
  final String expression;

  const RowExpression({
    super.key,
    this.onLeftButton,
    this.onRightButton,
    this.expression = '',
  });

  @override
  Widget build(BuildContext context) {
    return CalculationExpression(
      onLeftButton: onLeftButton,
      onRightButton: onRightButton,
      expression: expression,
    );
  }
}
