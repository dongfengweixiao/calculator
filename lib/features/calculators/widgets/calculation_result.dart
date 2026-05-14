import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';

/// 计算结果显示组件
///
/// 左右两侧为 TextButton 样式按钮，中间为右对齐的结果文本:
/// ```
/// ┌─────────────────────────────────────────────────┐
/// │  [leftArrow]        Results文本  [rightArrow]   │
/// └─────────────────────────────────────────────────┘
/// ```
class CalculationResult extends StatelessWidget {
  final VoidCallback? onLeftButton;
  final VoidCallback? onRightButton;

  /// 结果文本内容
  final String result;

  const CalculationResult({
    super.key,
    this.onLeftButton,
    this.onRightButton,
    this.result = '0',
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
        Expanded(child: Results(value: result)),
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

/// 结果文本组件
///
/// 右对齐，溢出使用 TextOverflow.visible。
class Results extends StatelessWidget {
  final String value;

  const Results({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: TextAlign.right,
      overflow: TextOverflow.visible,
      maxLines: 1,
      style: const TextStyle(fontSize: 46),
    );
  }
}
