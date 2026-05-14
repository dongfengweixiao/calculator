import 'package:flutter/material.dart';

import 'memory_controls.dart';

/// 内存控件行
///
/// 包装 MemoryControls 组件，用于标准计算器页面布局。
class RowMemoryControls extends StatelessWidget {
  final VoidCallback? onMemoryClear;
  final VoidCallback? onMemoryRecall;
  final VoidCallback? onMemoryAdd;
  final VoidCallback? onMemorySubtract;
  final VoidCallback? onMemoryStore;
  final VoidCallback? onMemory;

  const RowMemoryControls({
    super.key,
    this.onMemoryClear,
    this.onMemoryRecall,
    this.onMemoryAdd,
    this.onMemorySubtract,
    this.onMemoryStore,
    this.onMemory,
  });

  @override
  Widget build(BuildContext context) {
    return MemoryControls(
      onMemoryClear: onMemoryClear,
      onMemoryRecall: onMemoryRecall,
      onMemoryAdd: onMemoryAdd,
      onMemorySubtract: onMemorySubtract,
      onMemoryStore: onMemoryStore,
      onMemory: onMemory,
    );
  }
}
