import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';

/// 表达式显示组件
///
/// 左右两侧为 TextButton 样式按钮，中间为右对齐的表达式文本:
/// ```
/// ┌─────────────────────────────────────────────────┐
/// │  [leftArrow]    ExpressionText文本  [rightArrow] │
/// └─────────────────────────────────────────────────┘
/// ```
class CalculationExpression extends StatelessWidget {
  final VoidCallback? onLeftButton;
  final VoidCallback? onRightButton;

  /// 表达式文本内容
  final String expression;

  const CalculationExpression({
    super.key,
    this.onLeftButton,
    this.onRightButton,
    this.expression = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: onLeftButton,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Icon(CalculatorIcons.leftArrow, size: 16),
        ),
        Expanded(child: ExpressionText(value: expression)),
        TextButton(
          onPressed: onRightButton,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Icon(CalculatorIcons.rightArrow, size: 16),
        ),
      ],
    );
  }
}

/// 表达式文本组件
///
/// 右对齐，溢出使用 TextOverflow.visible。
class ExpressionText extends StatelessWidget {
  final String value;

  const ExpressionText({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: TextAlign.right,
      overflow: TextOverflow.visible,
      maxLines: 1,
      style: const TextStyle(fontSize: 14),
    );
  }
}
