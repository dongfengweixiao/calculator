import 'package:flutter/material.dart';

/// 换算值展示组件
///
/// 用于单位换算页面中展示源值或结果值，文本左对齐并自动缩放以撑满可用空间。
class ConverterDisplay extends StatelessWidget {
  /// 显示的文本内容
  final String value;

  /// 是否选中
  final bool isSelected;

  /// 点击回调
  final VoidCallback? onTap;

  const ConverterDisplay({
    super.key,
    required this.value,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 800,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
