import 'package:flutter/material.dart';

/// 占位Widget: 显示控件行
///
/// 用于显示控件按钮（如科学/程序员计算器的控件）。
/// 在标准计算器中此行高度为0（隐藏）。
class RowDisplayControls extends StatelessWidget {
  const RowDisplayControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF81C784), // 绿色
      alignment: Alignment.center,
      child: const Text(
        'RowDisplayControls',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
