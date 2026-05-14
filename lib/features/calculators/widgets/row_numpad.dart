import 'package:flutter/material.dart';

/// 占位Widget: 数字键盘行
///
/// 用于显示数字和运算符按钮。
class RowNumPad extends StatelessWidget {
  const RowNumPad({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFCE93D8), // 紫色
      alignment: Alignment.center,
      child: const Text(
        'RowNumPad',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
